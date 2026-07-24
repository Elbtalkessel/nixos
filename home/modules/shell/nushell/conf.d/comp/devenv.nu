def "nu-complete devenv topics" [] {
  {
    options: {
      sort: false,
      completion_algorithm: substring,
      case_sensitive: false,
    },
    completions: [
      {value: "init", description: "Scaffold devenv.yaml, devenv.nix, and .gitignore."}
      {value: "generate", description: "Generate devenv.yaml and devenv.nix using AI"}
      {value: "shell", description: "Activate  the  developer  environment. https://devenv.sh/ba‐"}
      {value: "update", description: "Update  devenv.lock  from  devenv.yaml  inputs.   http://de‐"}
      {value: "search", description: "Search  for  packages  and  options  in nixpkgs. https://de‐"}
      {value: "info", description: "Print information about this developer environment."}
      {value: "up", description: "Start   processes    in    the    foreground.    https://de‐"}
      {value: "processes", description: "Start or stop processes. https://devenv.sh/processes/"}
      {value: "tasks", description: "Run tasks. https://devenv.sh/tasks/"}
      {value: "test", description: "Run tests. http://devenv.sh/tests/"}
      {value: "container", description: "Build,  copy, or run a container. https://devenv.sh/contain‐"}
      {value: "inputs", description: "Add an input to devenv.yaml. https://devenv.sh/inputs/"}
      {value: "changelogs", description: "Show relevant changelogs."}
      {value: "repl", description: "Launch an interactive environment for inspecting the  devenv"}
      {value: "gc", description: "Delete   previous   shell   generations.   See   https://de‐"}
      {value: "build", description: "Build any attribute in devenv.nix."}
      {value: "eval", description: "Evaluate any attribute in devenv.nix and return JSON."}
      {value: "direnvrc", description: "Print a direnvrc that adds devenv  support  to  direnv.  See"}
      {value: "version", description: "Print the version of devenv."}
      {value: "mcp", description: "Launch Model Context Protocol server for AI assistants"}
      {value: "lsp", description: "Start the nixd language server for devenv.nix."}
      {value: "hook", description: "Print shell hook for auto-activation on directory change."}
      {value: "allow", description: "Allow auto-activation for the current directory."}
    ],
  }
}

# https://devenv.sh 2.1.2 (x86_64-linux): Fast,  Declarative,  Repro‐
# ducible, and Composable Developer Environments
export extern "devenv" [
  topic: string@"nu-complete devenv topics"
 --from # Source for devenv.nix.
 --override-input (-o) # Source for devenv.nix.
 --max-jobs (-j) # Maximum number of Nix builds to run concurrently.
 --cores (-u) # Maximum number of Nix builds to run concurrently.
 --system (-s) # Maximum number of Nix builds to run concurrently.
 --impure (-i) # Maximum number of Nix builds to run concurrently.
 --no-impure # Maximum number of Nix builds to run concurrently.
 --offline # Maximum number of Nix builds to run concurrently.
 --nix-option # Maximum number of Nix builds to run concurrently.
 --clean (-c) # Ignore existing  environment  variables  when  entering  the
 --profile (-P) # Ignore existing  environment  variables  when  entering  the
 --reload # Ignore existing  environment  variables  when  entering  the
 --no-reload # Ignore existing  environment  variables  when  entering  the
 --eval-cache # Enable caching of Nix evaluation results (default).
 --no-eval-cache # Enable caching of Nix evaluation results (default).
 --refresh-eval-cache # Enable caching of Nix evaluation results (default).
 --secretspec-provider # Override the secretspec provider
 --verbose (-v) # Enable additional debug logs.
 --quiet (-q) # Enable additional debug logs.
 --tui # Enable additional debug logs.
 --no-tui # Enable additional debug logs.
]
def "nu-complete devenv-processes topics" [] {
  {
    options: {
      sort: false,
      completion_algorithm: substring,
      case_sensitive: false,
    },
    completions: [
      {value: "up", description: "Start processes in the foreground."}
      {value: "down", description: "Stop processes running in the background."}
      {value: "wait", description: "Wait for all processes to be ready."}
      {value: "list", description: "List all managed processes and their status."}
      {value: "status", description: "Get the status of a process."}
      {value: "logs", description: "Get logs for a process."}
      {value: "restart", description: "Restart a process."}
      {value: "start", description: "Start a process (or all processes if no name given)."}
    ],
  }
}

# Start or stop processes. https://devenv.sh/processes/
export extern "devenv processes" [
  topic: string@"nu-complete devenv-processes topics"
]

# Start processes in the foreground.
export extern "devenv processes up" [
 --from # Source for devenv.nix.
 --override-input (-o) # Source for devenv.nix.
 --max-jobs (-j) # Maximum number of Nix builds to run concurrently.
 --cores (-u) # Maximum number of Nix builds to run concurrently.
 --system (-s) # Maximum number of Nix builds to run concurrently.
 --impure (-i) # Maximum number of Nix builds to run concurrently.
 --no-impure # Maximum number of Nix builds to run concurrently.
 --offline # Maximum number of Nix builds to run concurrently.
 --nix-option # Maximum number of Nix builds to run concurrently.
 --clean (-c) # Ignore existing  environment  variables  when  entering  the
 --profile (-P) # Ignore existing  environment  variables  when  entering  the
 --reload # Ignore existing  environment  variables  when  entering  the
 --no-reload # Ignore existing  environment  variables  when  entering  the
 --eval-cache # Enable caching of Nix evaluation results (default).
 --no-eval-cache # Enable caching of Nix evaluation results (default).
 --refresh-eval-cache # Enable caching of Nix evaluation results (default).
 --secretspec-provider # Override the secretspec provider
 --verbose (-v) # Enable additional debug logs.
 --quiet (-q) # Enable additional debug logs.
 --tui # Enable additional debug logs.
 --no-tui # Enable additional debug logs.
]

# Stop processes running in the background.
export extern "devenv processes down" [
 --from # Source for devenv.nix.
 --override-input (-o) # Source for devenv.nix.
 --max-jobs (-j) # Maximum number of Nix builds to run concurrently.
 --cores (-u) # Maximum number of Nix builds to run concurrently.
 --system (-s) # Maximum number of Nix builds to run concurrently.
 --impure (-i) # Maximum number of Nix builds to run concurrently.
 --no-impure # Maximum number of Nix builds to run concurrently.
 --offline # Maximum number of Nix builds to run concurrently.
 --nix-option # Maximum number of Nix builds to run concurrently.
 --clean (-c) # Ignore existing  environment  variables  when  entering  the
 --profile (-P) # Ignore existing  environment  variables  when  entering  the
 --reload # Ignore existing  environment  variables  when  entering  the
 --no-reload # Ignore existing  environment  variables  when  entering  the
 --eval-cache # Enable caching of Nix evaluation results (default).
 --no-eval-cache # Enable caching of Nix evaluation results (default).
 --refresh-eval-cache # Enable caching of Nix evaluation results (default).
 --secretspec-provider # Override the secretspec provider
 --verbose (-v) # Enable additional debug logs.
 --quiet (-q) # Enable additional debug logs.
 --tui # Enable additional debug logs.
 --no-tui # Enable additional debug logs.
]

# Wait for all processes to be ready.
export extern "devenv processes wait" [
 --from # Source for devenv.nix.
 --override-input (-o) # Source for devenv.nix.
 --max-jobs (-j) # Maximum number of Nix builds to run concurrently.
 --cores (-u) # Maximum number of Nix builds to run concurrently.
 --system (-s) # Maximum number of Nix builds to run concurrently.
 --impure (-i) # Maximum number of Nix builds to run concurrently.
 --no-impure # Maximum number of Nix builds to run concurrently.
 --offline # Maximum number of Nix builds to run concurrently.
 --nix-option # Maximum number of Nix builds to run concurrently.
 --clean (-c) # Ignore  existing  environment  variables  when  entering the
 --profile (-P) # Ignore  existing  environment  variables  when  entering the
 --reload # Ignore  existing  environment  variables  when  entering the
 --no-reload # Ignore  existing  environment  variables  when  entering the
 --eval-cache # Enable caching of Nix evaluation results (default).
 --no-eval-cache # Enable caching of Nix evaluation results (default).
 --refresh-eval-cache # Enable caching of Nix evaluation results (default).
 --secretspec-provider # Override the secretspec provider
 --verbose (-v) # Enable additional debug logs.
 --quiet (-q) # Enable additional debug logs.
 --tui # Enable additional debug logs.
 --no-tui # Enable additional debug logs.
]

# List all managed processes and their status.
export extern "devenv processes list" [
 --from # Source for devenv.nix.
 --override-input (-o) # Source for devenv.nix.
 --max-jobs (-j) # Maximum number of Nix builds to run concurrently.
 --cores (-u) # Maximum number of Nix builds to run concurrently.
 --system (-s) # Maximum number of Nix builds to run concurrently.
 --impure (-i) # Maximum number of Nix builds to run concurrently.
 --no-impure # Maximum number of Nix builds to run concurrently.
 --offline # Maximum number of Nix builds to run concurrently.
 --nix-option # Maximum number of Nix builds to run concurrently.
 --clean (-c) # Ignore  existing  environment  variables  when  entering the
 --profile (-P) # Ignore  existing  environment  variables  when  entering the
 --reload # Ignore  existing  environment  variables  when  entering the
 --no-reload # Ignore  existing  environment  variables  when  entering the
 --eval-cache # Enable caching of Nix evaluation results (default).
 --no-eval-cache # Enable caching of Nix evaluation results (default).
 --refresh-eval-cache # Enable caching of Nix evaluation results (default).
 --secretspec-provider # Override the secretspec provider
 --verbose (-v) # Enable additional debug logs.
 --quiet (-q) # Enable additional debug logs.
 --tui # Enable additional debug logs.
 --no-tui # Enable additional debug logs.
]

# Get the status of a process.
export extern "devenv processes status" [
 --from # Source for devenv.nix.
 --override-input (-o) # Source for devenv.nix.
 --max-jobs (-j) # Maximum number of Nix builds to run concurrently.
 --cores (-u) # Maximum number of Nix builds to run concurrently.
 --system (-s) # Maximum number of Nix builds to run concurrently.
 --impure (-i) # Maximum number of Nix builds to run concurrently.
 --no-impure # Maximum number of Nix builds to run concurrently.
 --offline # Maximum number of Nix builds to run concurrently.
 --nix-option # Maximum number of Nix builds to run concurrently.
 --clean (-c) # Ignore  existing  environment  variables  when  entering the
 --profile (-P) # Ignore  existing  environment  variables  when  entering the
 --reload # Ignore  existing  environment  variables  when  entering the
 --no-reload # Ignore  existing  environment  variables  when  entering the
 --eval-cache # Enable caching of Nix evaluation results (default).
 --no-eval-cache # Enable caching of Nix evaluation results (default).
 --refresh-eval-cache # Enable caching of Nix evaluation results (default).
 --secretspec-provider # Override the secretspec provider
 --verbose (-v) # Enable additional debug logs.
 --quiet (-q) # Enable additional debug logs.
 --tui # Enable additional debug logs.
 --no-tui # Enable additional debug logs.
]

# Get logs for a process.
export extern "devenv processes logs" [
 --from # Source for devenv.nix.
 --override-input (-o) # Source for devenv.nix.
 --max-jobs (-j) # Maximum number of Nix builds to run concurrently.
 --cores (-u) # Maximum number of Nix builds to run concurrently.
 --system (-s) # Maximum number of Nix builds to run concurrently.
 --impure (-i) # Maximum number of Nix builds to run concurrently.
 --no-impure # Maximum number of Nix builds to run concurrently.
 --offline # Maximum number of Nix builds to run concurrently.
 --nix-option # Maximum number of Nix builds to run concurrently.
 --clean (-c) # Ignore  existing  environment  variables  when  entering the
 --profile (-P) # Ignore  existing  environment  variables  when  entering the
 --reload # Ignore  existing  environment  variables  when  entering the
 --no-reload # Ignore  existing  environment  variables  when  entering the
 --eval-cache # Enable caching of Nix evaluation results (default).
 --no-eval-cache # Enable caching of Nix evaluation results (default).
 --refresh-eval-cache # Enable caching of Nix evaluation results (default).
 --secretspec-provider # Override the secretspec provider
 --verbose (-v) # Enable additional debug logs.
 --quiet (-q) # Enable additional debug logs.
 --tui # Enable additional debug logs.
 --no-tui # Enable additional debug logs.
]

# Restart a process.
export extern "devenv processes restart" [
 --from # Source for devenv.nix.
 --override-input (-o) # Source for devenv.nix.
 --max-jobs (-j) # Maximum number of Nix builds to run concurrently.
 --cores (-u) # Maximum number of Nix builds to run concurrently.
 --system (-s) # Maximum number of Nix builds to run concurrently.
 --impure (-i) # Maximum number of Nix builds to run concurrently.
 --no-impure # Maximum number of Nix builds to run concurrently.
 --offline # Maximum number of Nix builds to run concurrently.
 --nix-option # Maximum number of Nix builds to run concurrently.
 --clean (-c) # Ignore  existing  environment  variables  when  entering the
 --profile (-P) # Ignore  existing  environment  variables  when  entering the
 --reload # Ignore  existing  environment  variables  when  entering the
 --no-reload # Ignore  existing  environment  variables  when  entering the
 --eval-cache # Enable caching of Nix evaluation results (default).
 --no-eval-cache # Enable caching of Nix evaluation results (default).
 --refresh-eval-cache # Enable caching of Nix evaluation results (default).
 --secretspec-provider # Override the secretspec provider
 --verbose (-v) # Enable additional debug logs.
 --quiet (-q) # Enable additional debug logs.
 --tui # Enable additional debug logs.
 --no-tui # Enable additional debug logs.
]

# Start a process (or all processes if no name given).
export extern "devenv processes start" [
 --from # Source for devenv.nix.
 --override-input (-o) # Source for devenv.nix.
 --max-jobs (-j) # Maximum number of Nix builds to run concurrently.
 --cores (-u) # Maximum number of Nix builds to run concurrently.
 --system (-s) # Maximum number of Nix builds to run concurrently.
 --impure (-i) # Maximum number of Nix builds to run concurrently.
 --no-impure # Maximum number of Nix builds to run concurrently.
 --offline # Maximum number of Nix builds to run concurrently.
 --nix-option # Maximum number of Nix builds to run concurrently.
 --clean (-c) # Ignore existing  environment  variables  when  entering  the
 --profile (-P) # Ignore existing  environment  variables  when  entering  the
 --reload # Ignore existing  environment  variables  when  entering  the
 --no-reload # Ignore existing  environment  variables  when  entering  the
 --eval-cache # Enable caching of Nix evaluation results (default).
 --no-eval-cache # Enable caching of Nix evaluation results (default).
 --refresh-eval-cache # Enable caching of Nix evaluation results (default).
 --secretspec-provider # Override the secretspec provider
 --verbose (-v) # Enable additional debug logs.
 --quiet (-q) # Enable additional debug logs.
 --tui # Enable additional debug logs.
 --no-tui # Enable additional debug logs.
]
def "nu-complete devenv-tasks topics" [] {
  {
    options: {
      sort: false,
      completion_algorithm: substring,
      case_sensitive: false,
    },
    completions: [
      {value: "run", description: "Run tasks."}
    ],
  }
}

# Run tasks. https://devenv.sh/tasks/
export extern "devenv tasks" [
  topic: string@"nu-complete devenv-tasks topics"
]

# Run tasks.
export extern "devenv tasks run" [
 --from # Source for devenv.nix.
 --override-input (-o) # Source for devenv.nix.
 --max-jobs (-j) # Maximum number of Nix builds to run concurrently.
 --cores (-u) # Maximum number of Nix builds to run concurrently.
 --system (-s) # Maximum number of Nix builds to run concurrently.
 --impure (-i) # Maximum number of Nix builds to run concurrently.
 --no-impure # Maximum number of Nix builds to run concurrently.
 --offline # Maximum number of Nix builds to run concurrently.
 --nix-option # Maximum number of Nix builds to run concurrently.
 --clean (-c) # Ignore existing  environment  variables  when  entering  the
 --profile (-P) # Ignore existing  environment  variables  when  entering  the
 --reload # Ignore existing  environment  variables  when  entering  the
 --no-reload # Ignore existing  environment  variables  when  entering  the
 --eval-cache # Enable caching of Nix evaluation results (default).
 --no-eval-cache # Enable caching of Nix evaluation results (default).
 --refresh-eval-cache # Enable caching of Nix evaluation results (default).
 --secretspec-provider # Override the secretspec provider
 --verbose (-v) # Enable additional debug logs.
 --quiet (-q) # Enable additional debug logs.
 --tui # Enable additional debug logs.
 --no-tui # Enable additional debug logs.
]
def "nu-complete devenv-container topics" [] {
  {
    options: {
      sort: false,
      completion_algorithm: substring,
      case_sensitive: false,
    },
    completions: [
      {value: "build", description: "Build a container."}
      {value: "copy", description: "Copy a container to registry."}
    ],
  }
}

# Build, copy, or run a container. https://devenv.sh/containers/
export extern "devenv container" [
  topic: string@"nu-complete devenv-container topics"
]

# Build a container.
export extern "devenv container build" [
 --from # Source for devenv.nix.
 --override-input (-o) # Source for devenv.nix.
 --max-jobs (-j) # Maximum number of Nix builds to run concurrently.
 --cores (-u) # Maximum number of Nix builds to run concurrently.
 --system (-s) # Maximum number of Nix builds to run concurrently.
 --impure (-i) # Maximum number of Nix builds to run concurrently.
 --no-impure # Maximum number of Nix builds to run concurrently.
 --offline # Maximum number of Nix builds to run concurrently.
 --nix-option # Maximum number of Nix builds to run concurrently.
 --clean (-c) # Ignore  existing  environment  variables  when  entering the
 --profile (-P) # Ignore  existing  environment  variables  when  entering the
 --reload # Ignore  existing  environment  variables  when  entering the
 --no-reload # Ignore  existing  environment  variables  when  entering the
 --eval-cache # Enable caching of Nix evaluation results (default).
 --no-eval-cache # Enable caching of Nix evaluation results (default).
 --refresh-eval-cache # Enable caching of Nix evaluation results (default).
 --secretspec-provider # Override the secretspec provider
 --verbose (-v) # Enable additional debug logs.
 --quiet (-q) # Enable additional debug logs.
 --tui # Enable additional debug logs.
 --no-tui # Enable additional debug logs.
]

# Copy a container to registry.
export extern "devenv container copy" [
 --from # Source for devenv.nix.
 --override-input (-o) # Source for devenv.nix.
 --max-jobs (-j) # Maximum number of Nix builds to run concurrently.
 --cores (-u) # Maximum number of Nix builds to run concurrently.
 --system (-s) # Maximum number of Nix builds to run concurrently.
 --impure (-i) # Maximum number of Nix builds to run concurrently.
 --no-impure # Maximum number of Nix builds to run concurrently.
 --offline # Maximum number of Nix builds to run concurrently.
 --nix-option # Maximum number of Nix builds to run concurrently.
 --clean (-c) # Ignore  existing  environment  variables  when  entering the
 --profile (-P) # Ignore  existing  environment  variables  when  entering the
 --reload # Ignore  existing  environment  variables  when  entering the
 --no-reload # Ignore  existing  environment  variables  when  entering the
 --eval-cache # Enable caching of Nix evaluation results (default).
 --no-eval-cache # Enable caching of Nix evaluation results (default).
 --refresh-eval-cache # Enable caching of Nix evaluation results (default).
 --secretspec-provider # Override the secretspec provider
 --verbose (-v) # Enable additional debug logs.
 --quiet (-q) # Enable additional debug logs.
 --tui # Enable additional debug logs.
 --no-tui # Enable additional debug logs.
]
