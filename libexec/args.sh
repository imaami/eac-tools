#!/bin/bash

unset opts_value
declare -A opts_value
export opts_value

#
# Show valid command-line options and exit. First argument must be program name.
#
usage()
{
  local argv0="$1" retval=$(($2)) i n
  echo -n "Usage: $argv0 [ -h | --help ]" >&2
  for ((i = 0, n=${#options[@]}; i < n; i++)); do
    echo -n " [ --${options[i]}=VALUE ]" >&2
  done
  echo >&2
  exit $retval
}

#
# Parse command-line arguments. First argument must be program name.
#
parse_args()
{
  local argv0="$1" opts_regex arg opt

  opts_regex="${options[@]}"
  opts_regex="${opts_regex// /|}"

  while (( $# > 1 )); do
    shift

    if [[ "$1" =~ ^--($opts_regex)(=(.*))?$ ]]; then
      opt="${BASH_REMATCH[1]}"

      if [[ "${BASH_REMATCH[-2]}" ]]; then
        arg="${BASH_REMATCH[-1]}"
      else
        shift
        arg="$1"
      fi

      opts_value[$opt]="$arg"

    elif [[ "$1" =~ ^-(h|-help)$ ]]; then
      usage "$argv0" 0

    else
      usage "$argv0" 1
    fi
  done
}
