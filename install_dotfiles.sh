#!/usr/bin/env bash


readonly SCRIPTS_DIR="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo $SCRIPTS_DIR

printTitle(){
	local line='_---------_---------_---------_---------_---------'
	printf "%s%s%s\n" "+-" "${line:0:${#1}}" "-+"
	printf "%s%s%s\n" "|"  "${1}}" "-+"
	printf "%s%s%s\n" "+-" "${line:0:${#1}}" "-+"
}


createSymlinks(){
	for file in ${SCRIPTS_DIR}/symlinks/* ; do
		basenameFile=$(basename "${file}")
		[ -r "$file" ] && [ -f "$file" ] &&  [ -e "$file" ]  && rm -f "${HOME}/.${basenameFile}" && ln -s "${file}" "${HOME}/".${basenameFile};	
	done
}


main(){
	
	printTitle "Creation Symlinks"
	createSymlinks

 	set +u
  	set +e
  	printTitle "Launch all sh in system directory aliases,bash_completion,bash_prompt,exports,functions,jdk,paths"
  	source "${HOME}/.bashrc"
  	set -e
  	set -u
}

main