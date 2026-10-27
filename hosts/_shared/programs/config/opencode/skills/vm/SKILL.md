---
name: vm
description: Work inside the atlas virtual machine — cloning from and pushing to gitea.x.home.arpa, laying out projects under ~/Projects, activating devenv or nix develop environments, and diagnosing missing-tool, permission, or disk-space failures on this machine.
---

# atlas VM

## Machine facts

- Project dependencies declared in a `flake.nix` or `devenv.nix` at a project level.
- System dependencies declared by machine operator. Ask to install anything.

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

- The guest **root filesystem is a tmpfs**. `/`, `/etc`, `/var`, `/run`,
  `/nix/var` and `/tmp` are rebuilt on every boot. Anything outside
  `/home/kimberlee`, `/var/lib/ssh` and `/etc/sops-nix` is lost on restart.
- Keep work under `~/Projects`.
- Parallel worktrees live (`~/Projects/worktrees/<repo>/<branch>`).
- Refer to files by absolute path (`/home/kimberlee/Projects/...`) across tool calls.

## Git and gitea

- Clone URL form: `git@gitea.x.home.arpa:<owner>/<repo>.git`.
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

## Disk and the Nix store

- **Never run `nix-collect-garbage` or `nix store gc`.** A full disk is a
  rebuild problem, not a GC problem. Report a full disk to the operator instead.
- **Never build the NixOS system here.** `nixos-rebuild switch` needs root you
  do not have. The operator builds and deploys on `omen`.
- Cheap checks are fine: `nix eval .#nixosConfigurations.<host>.config.<opt>`,
  a single small derivation, `shellcheck` on an extracted unit script.
  Serialize Nix commands — two at once contend on the eval-cache SQLite
  database and look like a hang.

## Asking the operator

State requests in the conversation, concretely: what you need, why, and
which repository or workflow it blocks. System packages, VM resources,
gitea permissions, and config changes are operator-side.
