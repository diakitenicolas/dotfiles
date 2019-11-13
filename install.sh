#!/usr/bin/env bash


readonly CURRENT_DIR="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

printTitle(){
	local line='-----------------------------------------------------'
	printf "%s%s%s\n" "+-" "${line:0:${#1} }" "-+"
	printf "%s%s%s\n" "| " "${1}" " |"
	printf "%s%s%s\n" "+-" "${line:0:${#1}}" "-+"
}


printSubTitle(){
	printf "\n%s%s\n" "--> " "${1}"
}

man() {
    printf "Usage of %s\n" "${0}"
    printf "symlinks\n"
    printf "\t Create symlink of dotfiles into \${HOME}\n"
    
    printf "install\n"
    printf "\t Install required softwares\n"
    
    printf "[blank]\n"
    printf "\t Run all stages\n"
    printf "man\n"
    printf "\t Print this man\n"
}


createSymlinks(){
	for file in ${CURRENT_DIR}/symlinks/* ; do
		basenameFile=$(basename "${file}")
		[ -r "$file" ] && [ -f "$file" ] &&  [ -e "$file" ]  && rm -f  && ln -sf "${file}" "${HOME}/".${basenameFile};	
	done
}


installTools() {
  local installing="Installing"
  for file in "${CURRENT_DIR}/tools"/*; do
    local basenameFile=$(basename ${file%.*}) 
    local upperCaseFilename=$(echo "${basenameFile}" | tr '[:lower:]' '[:upper:]')
    local disableVariableName="DOTFILES_NO_${upperCaseFilename}"

    if [[ "${!disableVariableName:-}" == "true" ]]; then
      continue
    fi

    printSubTitle "${installing} ${basenameFile}"
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
  done
}

main(){
	
  local ARGS="${*}"

   if [[ "${ARGS}" =~ man ]]; then
    usage
    return 1
  fi

  if [[ -z "${ARGS}" ]] || [[ "${ARGS}" =~ symlinks ]]; then
    printTitle "Creation Symlinks"
    createSymlinks
  fi

	set +u
  set +e
	printTitle "Launch bashrc"
	PS1="$" source "${HOME}/.bashrc"
	set -e
	set -u

  if [[ -z "${ARGS}" ]] || [[ "${ARGS}" =~ install ]]; then
    printTitle "Installation"
    installTools
  fi

}

main "${@:-}"
