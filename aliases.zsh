# clipboard
# Sets up clipboard aliases for pbcopy and pbpaste,
# if they are not already available

if ! type pbcopy >/dev/null 2>&1; then
  alias pbcopy="xclip -selection clipboard"
fi

if ! type pbpaste >/dev/null 2>&1; then
  alias pbpaste="xclip -selection clipboard -o"
fi

# rebase
# Will git rebase the current branch against the default one,
# automatically detecting if it's "main" or "master"

rebase() {
  git fetch || return
  local base
  base=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null)

  if [[ -z "$base" ]]; then
    if git show-ref --verify --quiet refs/remotes/origin/main; then
      base="origin/main"
    elif git show-ref --verify --quiet refs/remotes/origin/master; then
      base="origin/master"
    else
      echo "rebase: could not detect default branch of origin" >&2
      return 1
    fi
  fi

  git rebase "$@" "$base"
}

# retry
# Will retry the command until it succeeds,
# using exponential backoff

retry() {
    local attempt=1

    until "$@"; do
        echo "retry: attempt $attempt failed, retrying..." >&2
        sleep $((2 ** (attempt - 1)))
        (( attempt++ ))
    done
}

# run
# Creates an alias for running "make run"

alias run="make run"
