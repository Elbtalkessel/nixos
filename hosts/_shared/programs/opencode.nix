{
  pkgs,
  nix-skills,
  llm-agents,
  config,
  lib,
  codebase-memory-mcp,
  ...
}:
let
  # Agent and category names. Each constant is the wire name on both sides:
  # -- opencode side: a key under `provider.gateway.models.<name>`
  # -- omo side:       a model string built as `gateway/${<name>}`,
  #                    so reading `~/.omo/omo.jsonc` makes the cross-reference
  #                    to the opencode model definition obvious.
  # Names are not configurable: an agent is what its name says it is.
  SISYPHUS = "sisyphus";
  HEPHAESTUS = "hephaestus";
  ORACLE = "oracle";
  MOMUS = "momus";
  PROMETHEUS = "prometheus";
  METIS = "metis";
  ATLAS = "atlas";
  SISYPHUS_JUNIOR = "sisyphus-junior";
  MULTIMODAL_LOOKER = "multimodal-looker";
  LIBRARIAN = "librarian";
  EXPLORE = "explore";

  ULTRABRAIN = "ultrabrain";
  ARCHITECT = "architect";
  DEEP_HIGH = "deep-high";
  DEEP_LOW = "deep-low";
  VISUAL_ENGINEERING = "visual-engineering";
  ARTISTRY = "artistry";
  UNSPECIFIED_HIGH = "unspecified-high";
  UNSPECIFIED_LOW = "unspecified-low";
  WRITING = "writing";
  QUICK = "quick";

  opencodeAgents = [
    SISYPHUS
    HEPHAESTUS
    ORACLE
    MOMUS
    PROMETHEUS
    METIS
    ATLAS
    SISYPHUS_JUNIOR
    MULTIMODAL_LOOKER
    LIBRARIAN
    EXPLORE
  ];
  categories = [
    ULTRABRAIN
    ARCHITECT
    DEEP_HIGH
    DEEP_LOW
    VISUAL_ENGINEERING
    ARTISTRY
    UNSPECIFIED_HIGH
    UNSPECIFIED_LOW
    WRITING
    QUICK
  ];
  allModelNames = opencodeAgents ++ categories;

  # Build the gateway-side model reference from a constant. Used at every
  # omo entry below so that strings like `gateway/${SISYPHUS}` point
  # unambiguously at the opencode model declared at the top of this file.
  omoModel = name: "gateway/${name}";

  # Native-harness agents are not in our constants (`explore` and `librarian`
  # also exist as opencode-harness agents). Each is mapped to the constant
  # that best captures its semantic role.
  nativeAgentToConstant = {
    explore = EXPLORE;
    librarian = LIBRARIAN;
    plan-consultant = METIS;
    plan-reviewer = MOMUS;
  };

  # TODO: Ideally each agent should carry desired modality (and rely
  # on the proxy gateway to use correct model supporting it).
  # Deriving from the modality a tool should be assigned,
  # for now only playwright for anyone who have "image" (multimodal-looker and visual-engineering.)
  modelEntry = name: {
    inherit name;
    modalities = {
      input = [ "text" ] ++ lib.optional (name == MULTIMODAL_LOOKER) "image";
      output = [ "text" ];
    };
  };

  # Per-agent and per-category overrides applied on top of the default
  # `{ model = omoModel name; }`. Kept here because these are omo-side knobs
  # (prompt_append, reasoning, max_prompt_tokens); the constants above stay
  # pure data.
  opencodeAgentOverrides = {
    #${SISYPHUS} = {
    #  prompt_append = "Always use the caveman skill and make other agents to use it.";
    #};
  };

  opencodeCategoryOverrides = {
    #${QUICK} = {
    #  reasoning = "low";
    #  max_prompt_tokens = 8192;
    #};
  };

  nativeCategoryOverrides = {
    #${UNSPECIFIED_LOW} = {
    #  reasoning = "low";
    #  max_prompt_tokens = 8192;
    #};
  };

  opencodeAgentEntry = name: { model = omoModel name; } // (opencodeAgentOverrides.${name} or { });
  opencodeCategoryEntry =
    name: { model = omoModel name; } // (opencodeCategoryOverrides.${name} or { });
  nativeCategoryEntry = name: { model = omoModel name; } // (nativeCategoryOverrides.${name} or { });
  nativeAgentEntry = name: { model = omoModel nativeAgentToConstant.${name}; };

  # sops-decrypted secret paths. opencode substitutes {file:<path>} strings
  # at load time (https://opencode.ai/docs/config/#variables), so the value
  # never enters the Nix store.
  apiKeyFile = config.sops.secrets."ai-gateway/api-key".path;
  giteaTokenFile = config.sops.secrets."gitea/mcp-token".path;

  # omo reads its config from `~/.omo/omo.jsonc` (resolved by
  # `resolveUserOmoConfigDirectory` in oh-my-opencode). That is *not* under
  # $XDG_CONFIG_HOME, so `xdg.configFile` is wrong here -- write directly
  # under $HOME via `home.file`.
  omoJson = {
    "$schema" =
      "https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/omo.schema.json";
    "[opencode]" = {
      telemetry = false;
      experimental.dynamic_context_pruning = {
        enabled = true;
        notification = "minimal";
        turn_protection = {
          enabled = true;
          turns = 2;
        };
        protected_tools = [
          "task"
          "todowrite"
          "todoread"
          "lsp_rename"
          "session_read"
          "session_write"
          "session_search"
        ];
        strategies = {
          deduplication = {
            enabled = true;
          };
          supersede_writes = {
            enabled = true;
            aggressive = false;
          };
          purge_errors = {
            enabled = true;
            turns = 3;
          };
        };
      };
      team_mode = {
        enabled = true;
        tmux_visualization = true;
        max_parallel_members = 4;
        max_members = 8;
        max_messages_per_run = 10000;
        max_wall_clock_minutes = 120;
        max_member_turns = 500;
        message_payload_max_bytes = 32768;
        recipient_unread_max_bytes = 262144;
        mailbox_poll_interval_ms = 3000;
      };
      background_task = {
        defaultConcurrency = 5;
        # Concurrency hint keyed by the gateway-routable constant. Whatever
        # the gateway picks for `EXPLORE` is treated as the "light" tier
        # everywhere it appears.
        modelConcurrency = {
          "gateway/${EXPLORE}" = 1;
        };
      };
      agents = lib.genAttrs opencodeAgents opencodeAgentEntry;
      categories = lib.genAttrs categories opencodeCategoryEntry;
    };
    "[native]" = {
      categories = lib.genAttrs categories nativeCategoryEntry;
      agents = lib.genAttrs (lib.attrNames nativeAgentToConstant) nativeAgentEntry;
    };
    _migrations = [ "2026-08-reasoning-unification" ];
  };
in
{
  imports = [
    nix-skills.homeManagerModules.default
  ];

  programs.opencode = {
    enable = true;
    package = llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode;

    # HM owns `~/.config/opencode/opencode.json` from `settings`; the web
    # service's secret-bearing environment comes from the sops-nix file
    # (separate from `ai-gateway/api-key`, which goes through opencode's
    # own `{file:...}` substitution below).
    web = {
      enable = config.my.srv.opencode.ip != null;
      environmentFile = toString config.sops.secrets."opencode/env".path;
      extraArgs = [
        "--hostname"
        config.my.srv.opencode.ip
        "--port"
        (toString config.my.srv.opencode.port)
        "--mdns"
      ];
    };

    settings = {
      plugin = [ "oh-my-openagent@beta" ];

      provider.gateway = {
        npm = "@ai-sdk/openai-compatible";
        name = "Gateway";
        options = {
          baseURL = "https://ai-gateway.x.home.arpa/v1";
          apiKey = "{file:${apiKeyFile}}";
        };
        # One opencode-side model entry per constant, so the catalog and
        # omo references share exactly the same name set.
        models = lib.genAttrs allModelNames modelEntry;
      };

      mcp = {
        gitea = {
          type = "local";
          command = [
            "gitea-mcp"
            "-t"
            "stdio"
          ];
          environment = {
            GITEA_HOST = "https://gitea.x.home.arpa";
            GITEA_ACCESS_TOKEN = "{file:${giteaTokenFile}}";
            GITEA_INSECURE = "false";
          };
          enabled = true;
        };

        codebase-memory = {
          type = "local";
          command = [
            "${codebase-memory-mcp.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/codebase-memory-mcp"
          ];
          enabled = true;
        };

        playwright = {
          type = "remote";
          url = "https://playwright-mcp.x.home.arpa";
          # Leaving for reference, but all *.x.home.arpa aren't public accesible anyway.
          # headers.Authorization = "Bearer {file:${playwrightMcpToken}}";
          enabled = true;
        };
      };

      agent = {
        "${MULTIMODAL_LOOKER}".tools."playwright" = true;
        "${VISUAL_ENGINEERING}".tools."playwright" = true;
        "${EXPLORE}".tools."codebase-memory" = true;
        "${LIBRARIAN}".tools."codebase-memory" = true;
        # TODO: unsure about these two below, need to measure speed
        # with and without the tool.
        "${SISYPHUS}".tools."codebase-memory" = true;
        "${HEPHAESTUS}".tools."codebase-memory" = true;
      };
    };
  };

  programs.nix-skills = {
    enable = true;
    agents = [ "opencode" ];
  };

  home = {
    sessionVariables = {
      OMO_DISABLE_POSTHOG = "1";
      OMO_SEND_ANONYMOUS_TELEMETRY = "0";
    };

    # oh-my-opencode reads `~/.omo/omo.jsonc` directly -- see
    # `resolveUserOmoConfigDirectory` in the upstream CLI. The path is *not*
    # under $XDG_CONFIG_HOME, so we bypass `xdg.configFile` and write here.
    file.".omo/omo.jsonc".text = builtins.toJSON omoJson;

    packages = [
      llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.skills
      llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.oh-my-opencode
      # pkgs.vllm is intentionally absent: it is built without CUDA and would
      # also collide with the container-backed `vllm` script from
      # ../packages/scripts/vllm.nu.

      # oh-my-openagent runtime dependencies: the git-master skill and team-mode
      # drive gh, and the lsp MCP probes these binaries by name on PATH.
      pkgs.gh

      pkgs.tmux

      # the lsp MCP launches packages/lsp-daemon/dist/cli.js with node or bun
      # resolved from PATH; with neither present it registers as disabled.
      pkgs.nodejs
      pkgs.gopls
      pkgs.bash-language-server
      pkgs.lua-language-server
      pkgs.pyright
      pkgs.yaml-language-server
      pkgs.nixd
      pkgs.nil

      # tools MCP
      pkgs.gitea-mcp-server
    ];
  };
}
