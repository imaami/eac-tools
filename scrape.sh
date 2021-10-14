#!/usr/bin/env bash

unset -n __download_sh &&
unset    __download_sh &&
readonly __download_sh="${0%/*}/download.sh"

__fetch() {
	local os
	for os in "$@"; do
		"$__download_sh" --os-type="$os" --from-id=1 --to-id=1000
	done
}

__report() {
	local os file
	local -i real null
	for os in "$@"; do
		file="eac-games-0001-to-1000-$os.log"
		real=$(grep '\.bin$' "$file" | wc -l)
		null=$(grep -E '[[:blank:]]0[[:blank:]]' "$file" | wc -l)
		echo -e "\n$os"
		printf '  %-10s: %3d\n' 'real blobs' "$real" \
		                        'null blobs' "$null" \
		                        'total' "$((real+$null))"
	done
}

__scrape() {
	__fetch "$@"
	__report "$@"
}

__scrape {linux,win{,e}}{32,64} wow64
