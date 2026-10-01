#!/usr/bin/env -S nu --stdin
# llama.cpp with CUDA, via the official container image.
#
# Why a container and not pkgs.llama-cpp: nixpkgs has no CUDA-enabled llama.cpp
# server build, so this runs the official server-cuda13 image and picks up the
# host NVIDIA driver through the container toolkit CDI spec.
#
# The container name and llama.cpp `--alias` both derive from the model file, so
# several models can be served side by side:
#
#   llamacpp Qwen3-8B-Q4_K_M.gguf            -> alias qwen3-8b-nvidia
#   llamacpp Qwen3-30B-A3B-Q4_K_M.gguf       -> alias qwen3-30b-a3b-nvidia
#   llamacpp                                  -> picks a model from --models-dir with fzf
#
# Nushell parses the flags it knows and errors on the ones it does not, so any
# llama.cpp flag not listed below has to come after a bare `--` separator:
#
#   llamacpp Qwen3-8B-Q4_K_M.gguf --ctx-size 16384 -- --jinja --flash-attn on

const IMAGE = "ghcr.io/ggml-org/llama.cpp:server-cuda13"

# llama.cpp server args that rarely change between runs.
const HOST = "0.0.0.0"
const CTX_SIZE = 8192
const PARALLEL = 1
const N_GPU_LAYERS = "all"
const PORT = 8080
const ALIAS_SUFFIX = "-nvidia"
const MODELS_DIR = "~/.local/share/models"

def fail [msg: string] {
    print -e $"error: ($msg)"
    exit 1
}

# Bind mounts must be absolute: docker does not expand a leading `~`, it treats
# it as a relative path and silently creates a directory named `~`. nushell's
# `path exists` does expand it, so an unexpanded path would pass the model check
# below and only fail once the server cannot find /models.
def expand-home [path: string] {
    $path | path expand
}

# Strips a trailing quantisation marker (IQ4_XS, Q4_K_M, Q8_0, Q3_K_L, TQ2_0,
# BF16, F16, F32) together with the separator in front of it.
def strip-quant []: string -> string {
    $in | str replace --regex '(?i)[-._](iq\d[\w]*|q\d[\w]*|tq\d_\d|bf16|f16|f32)$' ''
}

def derive-alias [model: string] {
    $model
    | path basename
    | str replace --regex '(?i)\.gguf$' ''
    | str lowercase
    | strip-quant
}

def pick-model [dir: string]: nothing -> string {
    # fzf is fed over stdin, not argv: it rejects bare filenames as arguments.
    # Names are relative to $dir because the container mounts that dir at /models.
    let models = (glob $"($dir)/*.gguf" | path basename | sort)

    if ($models | is-empty) {
        fail $"no .gguf models in ($dir). Pass --models-dir, or download one first."
    }

    let picked = ($models | str join (char newline) | ^fzf --reverse --cycle --prompt="model> " | complete)

    # fzf exits 1 when nothing matches and 130 on Esc/Ctrl-C; both mean "no model".
    if $picked.exit_code != 0 {
        print -e "no model selected."
        exit 0
    }

    # A selection is one line; keep the first so a stray extra cannot become a path.
    $picked.stdout | lines | first
}

def main [
  model?: string, # The GGUF file name inside the models dir; omit to pick one with fzf.
  ...rest: string, # Extra llama.cpp server flags; unknown --flags need a bare -- separator.
  --models-dir: string = $MODELS_DIR, # Directory containing the models.
  --cache-dir: string = "~/.cache/llama", # Directory for the llama.cpp cache.
  --image (-i): string = $IMAGE, # Container image to run.
  --port (-p): int = $PORT, # Host port the server is published on.
  --ctx-size: int = $CTX_SIZE, # Context size.
  --parallel: int = $PARALLEL, # Number of parallel sequences.
  --n-gpu-layers: string = $N_GPU_LAYERS, # Number of layers to offload to GPU.
  --detach (-d), # Run in the background, print the container name.
  --help (-h), # Show usage.
]: nothing -> nothing {
    if (which docker | is-empty) {
        fail "docker not found on PATH."
    }

    let resolved_models_dir = (expand-home $models_dir)
    let resolved_cache_dir = (expand-home $cache_dir)

    let model_file = if $model != null { $model } else { (pick-model $resolved_models_dir) }

    let model_path = $"($resolved_models_dir)/($model_file)"

    # Prevent docker from silently creating an empty directory for a missing bind source
    # which would cause llama.cpp to fail cryptically.
    if not ($model_path | path exists) {
        fail $"model file not found at ($model_path). Pass --models-dir if it is located elsewhere."
    }

    let alias = $"((derive-alias $model_file))($ALIAS_SUFFIX)"
    # Use the alias in the container name to avoid collisions when running multiple models
    let name = $"llama-($alias)"

    let args = [
        "run"
        "--rm"
        $"--name=($name)"
        "--gpus" "all"
        "--publish" $"($port):($port)"
        "-v" $"($resolved_cache_dir):/root/.cache"
        "-v" $"($resolved_models_dir):/models"
    ]
    | append (if $detach { ["--detach"] } else { [] })
    | append [
        $image
        "--model" $"/models/($model_file)"
        "--alias" $alias
        "--host" $HOST
        "--port" ($port | into string)
        "--ctx-size" ($ctx_size | into string)
        "--n-gpu-layers" $n_gpu_layers
        "--parallel" ($parallel | into string)
    ]
    | append $rest

    print -e $"image: ($image)"
    print -e $"model: ($model_path)"
    print -e $"alias: ($alias)"
    print -e $"api:   http://localhost:($port)/v1"

    docker ...$args
}
