# AGENTS.md

Bootstrap for coding agents working on **nixos**, the flake that declares every
host in this lab (`omen`, `atlas`).

Knowledge is split by scope into two Gitea wikis. Read the relevant pages before
planning or changing anything; the repository carries only `README.md`
(operator-facing) and this file.

- **Instance-wide** — `gitea.x.home.arpa/kb/gitea/wiki`: who you act as on Gitea,
  the task lifecycle and review rules, dependencies. True in every repo here.
- **This project** — `gitea.x.home.arpa/nix/nixos/wiki`: gates, layout, host
  facts, this repo's own decisions.

## Read first — project

| Page | Covers |
| --- | --- |
| `Home` | Wiki entrypoint listing every page and when to read it |

## Read first — instance-wide

| Page | Covers |
| --- | --- |
| `Home` | Wiki entrypoint listing every page and when to read it |

Fetch one page:

```
gitea_wiki_read(method="get", owner="nix", repo="nixos", pageName="Home")
gitea_wiki_read(method="get", owner="kb", repo="gitea", pageName="Home")
```

Or clone the lots:

```
git clone git@gitea.x.home.arpa:nix/nixos.wiki.git /tmp/nixos-wiki
git clone git@gitea.x.home.arpa:kb/gitea.wiki.git /tmp/gitea-wiki
```
