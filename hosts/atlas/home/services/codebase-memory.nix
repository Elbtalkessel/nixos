# Run the codebase-memory-mcp coordination daemon as a persistent user
# service.
#
# codebase-memory is wired into opencode as an MCP server
# (hosts/_shared/programs/opencode.nix), but indexing is otherwise manual: an
# agent calls `index_repository` per repo and the index goes stale on the next
# merge. The tool ships the automation -- a coordination daemon that owns a
# watcher poll thread and shared indexing jobs -- but runs it only
# session-managed, so the daemon exits when the last MCP session closes.
#
# This unit runs that daemon permanently under systemd. The one thing the
# issue left open is answered by the upstream source: `codebase-memory-mcp
# daemon start` does NOT stay in the foreground -- it double-forks
# (fork + setsid + fork) a detached daemon and exits, so neither Type=simple
# nor Type=forking can track it. Instead this unit launches the daemon role
# directly with its byte-exact internal argv. That is exactly the process
# `daemon start` spawns, minus the detach wrapper, so systemd owns the real
# PID, SIGTERM shuts it down cleanly, and Restart=on-failure works.
#
# Both this unit and the opencode MCP server resolve to the same
# `codebase-memory-mcp` flake input, so a rebuild without `nix flake update`
# keeps them on the same binary build -- the daemon's admission barrier.
#
# auto_index (index a fresh repo on the first agent connection) is runtime
# config in ~/.cache/codebase-memory-mcp/_config.db, not nix. Enable it once:
#   codebase-memory-mcp config set auto_index true
{ pkgs, codebase-memory-mcp, ... }:
let
  cbm = codebase-memory-mcp.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  systemd.user.services.codebase-memory-mcp = {
    Unit = {
      Description = "codebase-memory-mcp coordination daemon (watcher + indexing)";
    };
    Service = {
      ExecStart = "${cbm}/bin/codebase-memory-mcp --cbm-daemon-internal --cbm-daemon-permanent";
      Restart = "on-failure";
      RestartSec = "5s";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
