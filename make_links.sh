#!/bin/bash
DIR="$( cd "$( dirname "$0" )" && pwd )"

vimpath="${HOME}/.vim/after/ftplugin"
mkdir -p "${vimpath}"
for file in "${DIR}"/*.vim
do
	filename=$(basename "${file}")
	rm -f "${vimpath}/${filename}"
	ln -s $file "${vimpath}/"
done

ymlpath="${HOME}/.tmuxinator"
mkdir -p "${ymlpath}"
for file in "${DIR}"/*.yml
do
	filename=$(basename "${file}")
	rm -f "${ymlpath}/${filename}"
	ln -s $file "${ymlpath}/"
done

declare -A map_files
map_files[".bashrc"]=".bash_aliases"
declare -A ignore_files=([".viminfo"]=1 [".vrapperrc"]=1)

for file in "${DIR}"/.*
do
	if [ ! -f "$file" ]; then
		continue
	fi

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
	ln -s "${link}" "${target}"
done
