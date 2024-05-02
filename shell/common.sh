justHelp() {
  if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo $2
    exit 0
  fi
}

asRoot() {
  if [[ $(id -u) -ne 0 ]]; then
    echo "Not running as root"
    exit 1
  fi
}

# Utility functions
# EXAMPLE:
#   [ "$(ask "Close?" = "y" ] && exit 0
ask() {
  printf >&2 "%s (y/n): " "$1"
  while true; do
    read -r ANSWER
    if [ "$ANSWER" = "y" ]; then
      echo "y"
      break
    elif [ "$ANSWER" = "n" ]; then
      echo "n"
      break
    fi
  done
}

# EXAMPLE:
#   Compulsory prompt
#     COOKIES=$(prompt "Cookies?")
#   Optional prompt, second argument is default value
#     COOKIES=$(prompt "Cookies?" "YES")
prompt() {
  QUESTION=$1
  DEFAULT_VALUE=$2
  while true; do
    printf >&2 "%s (%s) " "$QUESTION" "${DEFAULT_VALUE:-required}"
    read -r ANSWER
    ANSWER=${ANSWER:-$DEFAULT_VALUE}
    if [ "$ANSWER" != "" ]; then
      echo >&2 ""
      echo "$ANSWER"
      break
    fi
  done
}
