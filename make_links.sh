#!/usr/bin/env bash
set -e
DIR="$( cd "$( dirname "$0" )" && pwd )"

declare -A map_files
map_files["init.lua"]=".config/nvim/init.lua"
map_files["bat_config"]=".config/bat/config"
map_files["coc-settings.json"]=".config/nvim/coc-settings.json"
map_files["python.lua"]=".config/nvim/after/ftplugin/python.lua"
map_files["exa_config"]=".config/exa/config"
map_files["plugins"]=".config/nvim/lua/plugins"
declare -A ignore_files=([".viminfo"]=1 [".vrapperrc"]=1 ["README.md"]=1 ["make_links.sh"]=1 ["tags"]=1 [".git"]=1)

for file in "${DIR}"/.*  "${DIR}"/*
do
	filename=$(basename "${file}")
	if [[ ! -z ${ignore_files["$filename"]} ]]; then
		continue
	fi

	linkname=${map_files["$filename"]}
	[[ -z "$linkname" ]] && linkname="${filename}"

	link="${DIR}/${filename}"
	target="${HOME}/$linkname"
	mkdir -p $(dirname "${target}")
	rm -f "${target}"
	echo ln -s "${link}" "${target}"
	ln -s "${link}" "${target}"
done
