#!/bin/bash

. "$(dirname "$0")/libexec/args.sh"

# Command-line argument list
options=(
  'os-type'
#  'id-list'
  'id'
  'from-id'
  'to-id'
  'uuid'
)

# Program name
argv0="$(basename "$0")"

# Parse command-line arguments
parse_args "$argv0" "$@"

# Copy arguments to less fugly variables
os_type="${opts_value['os-type']}"
#id_list="${opts_value['id-list']}"
id="${opts_value['id']}"
from_id="${opts_value['from-id']}"
to_id="${opts_value['to-id']}"
uuid="${opts_value['uuid']}"

# Check arguments' sanity somewhat
if [[ "$id" ]]; then
  [[ -z "$from_id$to_id" ]] || {
    echo "Mixing '--id' with '--from-id' and/or '--to-id' is forbidden" >&2
    usage "$argv0" 1
  }
  from_id="$id"
  to_id="$id"
else
  [[ "$from_id" && "$to_id" ]] || {
    echo "Not enough arguments: need a game ID or range of IDs" >&2
    usage "$argv0" 1
  }
fi

# Fill in default arguments where applicable
[[ "$os_type" ]] || {
  os_type=wine64
  echo "No '--os-type' argument, defaulting to $os_type" >&2
}

#[[ "$id_list" ]] || id_list="$(dirname "$0")/game_ids.list"

# Shim for missing uuidgen
command -v uuidgen >/dev/null || uuidgen() {
  hexdump -vn 16 -e '4/1 "%02x" "-" 2/1 "%02x" "-" 2/1 "%02x" "-" 2/1 "%02x" "-" 6/1 "%02x" "\n"' /dev/urandom 2>/dev/null
}

urlhead='https://download.eac-cdn.com/api/v1/games'
urltail="client/$os_type/download/?uuid="

# printf format specifier for zero-padding game id
id_fmt0="%0${#to_id}d"

if [[ "$id" ]]; then
  logfile=$(printf "eac-game-$id_fmt0-$os_type.log" "$id")
else
  logfile=$(printf "eac-games-$id_fmt0-to-$id_fmt0-$os_type.log" "$from_id" "$to_id")
fi

tmpfile="/dev/shm/eac-$os_type.bin"

rm -f "$tmpfile"

{
  echo -e ' game id\t dl size\tlast modified (UTC)\tdownload saved as'
  echo -e ' -------\t -------\t-------------------\t-----------------'

  for ((i = from_id; i <= to_id; i++)); do
    url="$urlhead/$i/$urltail$uuid"
    [[ "$uuid" ]] || url="$url$(uuidgen)"

    if wget -O "$tmpfile" "$url" 2>/dev/null &&
       st=$(stat -c '%s %Y' "$tmpfile"); then

      len="${st%% *}"
      st=$(date -ud@"${st##* }" '+%Y-%m-%d %H:%M:%S')

      if (( len > 0 )); then
        [[ "$(head -c5 "$tmpfile")" == '<?xml' ]] \
        && grep -i -q 'Access Denied' "$tmpfile"  \
        && {
          rm -f "$tmpfile"
          continue
        }

        dst=$(printf "eac-game-$id_fmt0-$os_type.bin" "$i")
        mv "$tmpfile" "$dst"
        dst=$'\t'"$dst"

      else
        dst=''
      fi

      printf "%8d\t%8d\t$st$dst\n" "$i" "$len"
    fi

    rm -f "$tmpfile"

  done;
} | tee "$logfile"
