# AGENTS.md

Bootstrap for coding agents working on **nixos**, the flake that declares every
host in this lab (`omen`, `atlas`).

Knowledge is split by scope into two Gitea wikis. Read the pages you need before
planning or changing anything; the repository carries only `README.md`
(operator-facing) and this file.

- **Instance-wide** — `gitea.x.home.arpa/kb/gitea/wiki`: who you act as on Gitea,
  the task lifecycle and review rules, dependencies. True in every repo here.
- **This project** — `gitea.x.home.arpa/nix/nixos/wiki`: gates, layout, host
  facts, this repo's own decisions.

## Read first — project

| Page | Covers |
| --- | --- |
| `Workflow` | issue → worktree/branch → gates → PR → review → merge |
| `MicroVM` | what the `atlas` guest can and cannot do |
| `Conventions` | nixfmt/statix/deadnix, layout, commit style |
| `Architecture` | flake → hosts → modules → options |
| `Decisions` | settled decisions — check before proposing an approach |

## Read first — instance-wide

| Page | Covers |
| --- | --- |
| `AgentIdentity` | which account, key and token you act as, and how to verify it |
| `Workflow` | the lifecycle, and the review/merge rules in detail |
| `Dependencies` | recording blocked-by relations on issues and PRs |
| `Decisions` | settled instance-wide rules (G-rules) |

Fetch one page:

```
gitea_wiki_read(method="get", owner="kb", repo="gitea", pageName="AgentIdentity")
gitea_wiki_read(method="get", owner="nix", repo="nixos", pageName="MicroVM")
```

Or clone the lots:

```
git clone git@gitea.x.home.arpa:kb/gitea.wiki.git /tmp/gitea-wiki
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
   knowledge in the wikis (`kb/gitea` `Decisions` G003).
5. **Never merge your own PR** without an explicit go-ahead from the maintainer
   (`risus`).
6. **Never paper over an evaluation error** with `lib.mkForce` / `lib.mkOverride`
   or by deleting the failing check. Fix the cause.
7. **If an issue or PR has a dependency, record it as a Gitea dependency** —
   `blocked_by` / `blocking` on the issue itself, not in prose. Same-repo only;
   cross-repo dependencies go in the body with a link. Details: `kb/gitea`
   `Dependencies`.
8. **Commit as `nastya <pieceof@duck.com>`.** The VM default identity is not on
   that account, so pass it explicitly and check
   `git log -1 --format='%an <%ae>'`. Details: `kb/gitea` `AgentIdentity`.
