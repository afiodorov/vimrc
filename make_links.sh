#!/bin/bash
DIR="$( cd "$( dirname "$0" )" && pwd )"

vimpath="${HOME}/.vim/after/ftplugin"
for file in "${DIR}"/*.vim
do
	filename=$(basename "${file}")
	rm -f "${vimpath}/${filename}"
	ln -s $file "${vimpath}/"
done

declare -A map_files=( [".bashrc"]=".aliases.bash" )
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
	rm -f "${HOME}/$linkname"
	ln -s "${link}" "${HOME}/${linkname}"
done
