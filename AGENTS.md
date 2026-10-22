# AGENTS.md

Bootstrap for coding agents working on **nixos**, the flake that declares every
host in this lab (`omen`, `atlas`).

Project knowledge lives in the Gitea wiki at `gitea.x.home.arpa/nix/nixos/wiki`
— not in this repository. Read the pages you need before planning or changing
anything. The only markdown here is `README.md` (operator-facing) and this file.

## Read first

| Page | Covers |
| --- | --- |
| `Workflow` | issue → worktree/branch → gates → PR → review → merge |
| `MicroVM` | what the `atlas` guest can and cannot do |
| `AgentIdentity` | who you push as on Gitea, and how to verify it |
| `Conventions` | nixfmt/statix/deadnix, layout, commit style |
| `Architecture` | flake → hosts → modules → options |
| `Decisions` | settled decisions — check before proposing an approach |

Fetch one page:

```
gitea_wiki_read(method="get", owner="nix", repo="nixos", pageName="MicroVM")
```

Or clone the lot:

```
git clone git@gitea.x.home.arpa:nix/nixos.wiki.git /tmp/nixos-wiki
```

## Hard rules

1. **Never push to `main`.** It is protected. Work on `feature/<slug>` in its
   own worktree and open a PR. Details: `Workflow`.
2. **Never build or garbage-collect inside the `atlas` guest.** No
   `nixos-rebuild build`, no `nix-collect-garbage`. Build and deploy on `omen`.
   Details: `MicroVM`.
3. **Run the gates before pushing:** `nixfmt --check`, `statix`, `deadnix`, and
   `shellcheck` on any script embedded in a systemd unit. Details: `Conventions`.
4. **Never add `.md` files to this repo** for planning or documentation. Put
   knowledge in the wiki (`Decisions` D002).
5. **Never merge your own PR** without an explicit go-ahead from the maintainer
   (`risus`).
6. **Never paper over an evaluation error** with `lib.mkForce` / `lib.mkOverride`
   or by deleting the failing check. Fix the cause.
