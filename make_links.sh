#!/usr/bin/env bash
DIR="$( cd "$( dirname "$0" )" && pwd )"

vimpath="${HOME}/.vim/after/ftplugin"
mkdir -p "${vimpath}"
for file in "${DIR}"/*.vim
do
	filename=$(basename "${file}")
	rm -f "${vimpath}/${filename}"
	ln -s $file "${vimpath}/"
done

vimsyntax="${HOME}/.vim/after/syntax"
mkdir -p "${vimsyntax}"
for file in "${DIR}"/after/syntax/*.vim
do
	filename=$(basename "${file}")
	rm -f "${vimsyntax}/${filename}"
	ln -s $file "${vimsyntax}/"
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
