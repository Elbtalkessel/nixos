---
name: vm
description: Work inside the atlas virtual machine — cloning from and pushing to gitea.x.home.arpa, laying out projects under ~/Projects, activating devenv or nix develop environments, and diagnosing missing-tool, permission, or disk-space failures on this machine.
---

# atlas VM

## Machine facts

- You run as unprivileged user `atlas` on a NixOS microvm (hostname `atlas`.)
- There is no sudo and no root. You cannot install system packages or change
  system configuration; the VM operator rebuilds the VM from the nixos repo
  for that.
  Project dependencies declared in a `flake.nix` or `devenv.nix` at a project level.

## Persistence — the one rule

- All work — clones, environments, artifacts you care about — lives under
  `~/Projects`. Refer to files by absolute path (`/home/atlas/Projects/...`)
  across tool calls.
- `/var/lib/ssh` is persistent but reserved for machine identity keys.
  Do not read or modify it beyond using git through the preconfigured SSH.

## Git and gitea

- Clone URL form: `git@gitea.x.home.arpa:<owner>/<repo>.git`. SSH is
  preconfigured (`~/.ssh/config` pins the key for this host); pull and push
  work with no setup for repositories the VM key may write.
- `permission denied (publickey)` on push means the VM key is not registered
  on gitea or lacks rights. Report it to the operator; you cannot fix it.

## Project layout

Inspect the repository root (gitea MCP file listing, or a throwaway
`git clone --depth 1` under `/tmp`) before choosing the layout:

| Repository root contains     | Clone destination            | Environment             |
| ---------------------------- | ---------------------------- | ----------------------- |
| `devenv.nix`                 | `~/Projects/<repo>`          | `devenv shell`          |
| `flake.nix` (no devenv.nix)  | `~/Projects/<repo>`          | `nix develop`           |
| neither                      | `~/Projects/<repo>/<repo>`   | `devenv shell` at the wrapper level |

For the third case, create the environment at `~/Projects/<repo>/` (one level
above the checkout) with `devenv init` plus the language modules the code
actually needs. Rationale: environment artifacts (`.devenv/`, `.direnv/`,
`node_modules/`, ...) stay outside the git tree, and the wrapper directory
can later hold sibling checkouts (`~/Projects/<repo>/<other>`) sharing the
same environment.

## Environments

- devenv: follow the `devenv-project` skill for writing `devenv.nix`; do not
  improvise its schema. Activate explicitly per command:

  ```sh
  cd ~/Projects/foo && devenv shell -- <command>
  ```

  The first activation builds the environment and can take minutes.
- flake with a devShell: `cd ~/Projects/foo && nix develop --command <command>`.
- Do not enable direnv auto-activation and do not run `devenv allow` or
  `direnv allow` on a fresh clone: those execute repository-provided hooks.
  Explicit activation only.
- Long-running services belong in a foreground devenv shell or a detached
  tmux session. Losing them on VM restart is expected; do not build
  workarounds that write outside `~/Projects`.

## Installing things

- You never install: no `sudo`, no `nix profile install`, no
  `npm install -g`, no `pip install --user`, no `cargo install`.
- Project dependencies are yours: add them to the project's `devenv.nix` and
  let `devenv shell` build them.
- A tool missing from the VM itself (not project-specific) is the operator's
  problem: ask in the conversation, naming the tool and why you need it.
  Wait; do not improvise a user-level install.

## Tools present

- Prefer `fd` over `find` and `rg` over `grep`; both skip `.gitignore`d
  paths by default.
- Also available: `git`, `tmux`, `devenv`, `nix`, `node`, `gh`, (GitHub only), `podman`
  and language servers (gopls, pyright, nil, nixd, bash/lua/yaml servers).
- All other programs and services are declared in ~/Projects/nixos/hosts/atlas/home (cloned
  from git@gitea.x.home.arpa:nix/nixos.git)
- Report to the operator for any missing tools.

## Secrets

- `~/.config/sops-nix/secrets/` holds service credentials. Never read,
  print, log, or embed them in code, commits, or tool output.
- Never write tokens or keys into a repository.

## Disk

- New store paths from environment builds land in a writable overlay
  (`df -h /nix`). If a build fails with a full-disk error, report it to the
  operator; do not delete store paths by hand.

## Asking the operator

State requests in the conversation, concretely: what you need, why, and
which repository or workflow it blocks. System packages, VM resources,
gitea permissions, and config changes are operator-side.
