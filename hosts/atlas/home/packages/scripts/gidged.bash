#!/usr/bin/env bash
set -T # inherit DEBUG and RETURN trap for functions
set -C # prevent file overwrite by > &> <>
set -E # inherit -e
set -e # exit immediately on errors
set -u # exit on not assigned variables
set -o pipefail # exit on pipe failure


PROJECTS_ROOT=${XDG_PROJECTS_DIR:-$HOME/Projects}
WORKTREE_ROOT=${WORKTREE_ROOT:-${PROJECTS_ROOT}/worktrees}
INSTANCE_WIKI=${INSTANCE_WIKI:-kb/gitea}
REMOTE_NAME=${REMOTE_NAME:-origin}
REMOTE_URL=$(git remote get-url "$REMOTE_NAME")
REMOTE_WIKI=${REMOTE_URL//.git/.wiki.git}
REMOTE_BRANCH=${GIT_MAIN:-$(git symbolic-ref --short "refs/remotes/${REMOTE_NAME}/HEAD" 2>/dev/null || echo origin/main)}
WORKDIR=${WORKDIR:-/tmp/gidget}


# Repository identifier: <org-name>/<repo-name>.
repoID() {
    [[ $REMOTE_URL =~ :([^/]+/[^/]+?)\.git?$ ]] && echo "${BASH_REMATCH[1]}"
}

# Where worktree directory reside.
worktreeDirectory() {
    [ -z "$1" ] && { echo "branch argument missing" >&2; exit 1; }
    echo "${WORKTREE_ROOT}/$(repoID)/${1}"
}

# Path to a wiki file.
wikiPath() {
    echo "${WORKDIR}/wiki/$(repoID)/ALL.md"
}

# Clone a URL into a directory or update existing.
# Returns directory path.
gitClone() {
    [ -z "$1" ] || [ -z "$2" ] && { echo "usage: gitClone <url> <directory>" >&2; exit 1; }
    local gitroot
    gitroot="$WORKDIR/sources/$2"
    mkdir -p "$gitroot"
    pushd "$gitroot" >/dev/null
        if [ -d "$gitroot/.git" ]; then
            git pull --rebase >/dev/null
        else
            git clone "$1" . >/dev/null
        fi
    popd >/dev/null
    echo "$gitroot"
}

# Prints a formatted topic entry.
topic() {
    local COL=15
    if (( ${#} > 2 )); then
        printf ' %-*s %s (%s)\n' "$COL" "$@"
    else
        printf ' %-*s %s\n' "$COL" "$@"
    fi
}

# Help command, prints both the main help page
# and help for subcommands if subcommand name is given.
# Usage:
#   helpCmd [subcommand] [exit code]
# Note: subcommand help function should be prefixed with "Help."
helpCmd() {
    if (( ${#} > 1 )); then
        "${1}Help"
        shift
    else
        echo "$(basename "$0"): git wrappers for the agent workflow"
        echo
        echo 'Topics:'
        topic 'help [topic]' 'show help menu'
        topic 'wiki' 'save wiki pages'
        topic 'identity' 'show agent identity'
        topic 'worktree' 'setup git worktree'
        topic 'scrap' 'remove worktree'
        echo
        echo 'Settings (environment variables):'
        topic 'PROJECTS_ROOT' 'projects root directory' "$PROJECTS_ROOT"
        topic 'WORKTREE_ROOT' 'worktrees root directory' "$WORKTREE_ROOT"
        topic 'GIT_MAIN' 'the main branch to checkout' "$REMOTE_BRANCH"
  fi
  exit $(( ${1:-0} % 256 ))
}


wikiHelp() {
    printf 'Save wiki pages to a single file %s\n' "$(wikiPath)"
    echo "Run: $(basename "$0") wiki"
}

# Concatenate the .md files in a directory, each headed by its page name and
# a line naming the source wiki, its short revision and its short date.
dumpPages() {
    local dir source file rev date
    dir=$1
    source=$2
    rev=$(git -C "$dir" rev-parse --short HEAD 2>/dev/null || true)
    date=$(git -C "$dir" log -1 --format=%cs 2>/dev/null || true)
    for file in "$dir"/*.md; do
        [ -e "$file" ] || continue
        printf '\n# %s\n' "$(basename "$file" .md)"
        printf 'source: %s %s %s\n\n' "$source" "$rev" "$date"
        cat "$file"
        printf '\n'
    done
}

wikiCmd() {
    local p1 r2 p2 dst
    dst=$(wikiPath)

    p1=$(gitClone "$REMOTE_WIKI" "$(repoID)")

    r2=${REMOTE_URL//$(repoID).git/${INSTANCE_WIKI}.wiki.git}
    p2=$(gitClone "$r2" "$INSTANCE_WIKI")

    mkdir -p "$(dirname "$dst")"
    rm "$dst" >/dev/null 2>&1 || true
    {
        printf '# Wiki dump\n'
        dumpPages "$p2" "${INSTANCE_WIKI}.wiki"
        dumpPages "$p1" "$(repoID).wiki"
    } > "$dst"
    printf "wiki: %s\n" "$dst"
}


identityHelp() {
    echo 'Print identity information'
}

identityCmd() {
    topic 'Username' "$(git config --get user.name)"
    topic 'Email' "$(git config --get user.email)"
    topic 'Hostname' "$(hostname)"
    topic 'Remote' "$REMOTE_URL"
    topic 'Wiki' "$(wikiPath)"
    topic 'Project' "$PROJECTS_ROOT/$(repoID)"
    topic 'Worktrees' "$WORKTREE_ROOT/$(repoID)"
    topic 'Wiki URL' "$REMOTE_WIKI"
    topic 'Wiki URL ' "${REMOTE_URL//$(repoID).git/${INSTANCE_WIKI}.wiki.git}"
}


worktreeHelp() {
    echo 'Setup git worktree'
    printf 'Run: %s worktree <branch>\n' "$(basename "$0")"
}

worktreeCmd() {
    if (( ${#} != 1 )); then
        helpCmd "worktree" 2;
    fi
    local path
    path="$(worktreeDirectory "$1")"
    git worktree add "$path" -b "${1}" "$REMOTE_BRANCH" 1>/dev/null
    pushd "$path" 1>/dev/null
        if [ -f devenv.nix ]; then
            devenv shell -- printf '' 2>/dev/null
        fi
    popd 1>/dev/null
    printf 'worktree: %s\n' "$path"
}


scrapHelp() {
    echo "Removes a worktree for given branch name"
    echo "Examples:"
    printf ' %s scrap <branch>\n' "$(basename "$0")"
}

scrapCmd() {
    if (( ${#} != 1 )); then
        helpCmd "scrap" 2;
    fi
    git worktree remove "$(worktreeDirectory "$1")"
    git branch -D "$1"
}


main() {
    git status 1>/dev/null
    if [[ $PWD/ == "$WORKTREE_ROOT"/* ]]; then
        echo "must not run inside $WORKTREE_ROOT" >&2
        exit 1
    fi
    if [[ $REMOTE_URL != git@* ]]; then
        echo "$(basename "$0"): remote must be ssh (git@host:org/repo.git), got: $REMOTE_URL" >&2
        exit 1
    fi
    if (( ${#} == 0 )); then
        helpCmd 0;
    fi
    case ${1} in
        help)
            helpCmd "${@:2}" 0
        ;;
        wiki|identity|worktree|scrap)
            "${1}Cmd" "${@:2}"
        ;;
        *)
            echo "unknown command: $1"
            helpCmd 2
        ;;
    esac
}

main "$@";
