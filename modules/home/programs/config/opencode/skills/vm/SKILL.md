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

## Project knowledge

`~/Projects/nixos` documents itself in a Gitea wiki: read the page you need
instead of guessing. This skill is the short version of `MicroVM`. The
instance-wide rules — who you push as, dependencies — live in the `kb/gitea`
wiki, not in this one.

| Page | Covers |
| --- | --- |
| `Workflow` | issue → worktree/branch → gates → PR → review → merge |
| `MicroVM` | what this VM can and cannot do — source of truth for this file |
| `Conventions` | nixfmt/statix/deadnix, layout, commit style |
| `Architecture` | flake → hosts → modules → options |
| `Decisions` | settled decisions — check before proposing an approach |

| `kb/gitea` page | Covers |
| --- | --- |
| `AgentIdentity` | who you push as on gitea, and how to verify it |
| `Dependencies` | recording blocked-by relations on issues and PRs |

```
gitea_wiki_read(method="get", owner="nix", repo="nixos", pageName="MicroVM")
gitea_wiki_read(method="get", owner="kb", repo="gitea", pageName="AgentIdentity")
```

Or clone the whole wiki: `git clone git@gitea.x.home.arpa:nix/nixos.wiki.git /tmp/nixos-wiki`.

## Persistence

- `/home/atlas` — the whole home directory — is a persistent 20 GiB volume and
  survives a VM restart. `/var/lib/ssh` is persistent too, reserved for machine
  identity keys; do not read or modify it beyond using git through the
  preconfigured SSH.
- The guest **root filesystem is a tmpfs**. `/`, `/etc`, `/var`, `/run`,
  `/nix/var` and `/tmp` are rebuilt on every boot. Anything outside
  `/home/atlas`, `/var/lib/ssh` and `/etc/sops-nix` is lost on restart.
- Keep work under `~/Projects` anyway — that is where the operator looks, and
  it is where parallel worktrees live (`~/Projects/worktrees/<repo>/<branch>`).
  Refer to files by absolute path (`/home/atlas/Projects/...`) across tool calls.

## Git and gitea

- Clone URL form: `git@gitea.x.home.arpa:<owner>/<repo>.git`. SSH is
  preconfigured (`~/.ssh/config` pins the key for this host); pull and push
  work with no setup for repositories the VM key may write.
- Commit authorship is configured by the host (`nix/nixos#21`). On `atlas` the
  host configuration must produce `nastya <pieceof@duck.com>`. Until that issue
  lands, pass `-c user.name=nastya -c user.email=pieceof@duck.com`, or set it
  once per clone, and confirm with `git log -1 --format='%an <%ae>'`.
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

## Disk and the Nix store

- `/nix/store` is an **overlay**: the host's store shared read-only, plus a
  writable 15 GiB upper layer (`df -h /nix/store`). New store paths from
  environment builds land in that upper layer.
- **Never run `nix-collect-garbage` or `nix store gc`.** A full disk is a
  rebuild problem, not a GC problem. The guest's Nix database lives on the
  ephemeral root while the overlay is persistent, so GC deletes paths the host
  still provides and leaves overlayfs whiteouts that hide them on every later
  boot — producing units that report `bad` / "not found" for no visible reason.
  Report a full disk to the operator instead.
- **Never build the NixOS system here.** `nixos-rebuild switch` needs root you
  do not have, and a full system closure does not fit in the 15 GiB overlay.
  The operator builds and deploys on `omen`.
- Cheap checks are fine: `nix eval .#nixosConfigurations.<host>.config.<opt>`,
  a single small derivation, `shellcheck` on an extracted unit script.
  Serialize Nix commands — two at once contend on the eval-cache SQLite
  database and look like a hang.

## Asking the operator

State requests in the conversation, concretely: what you need, why, and
which repository or workflow it blocks. System packages, VM resources,
gitea permissions, and config changes are operator-side.
