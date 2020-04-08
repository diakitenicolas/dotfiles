
#!/usr/bin/env sh

CURRENT_DIR="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_title(){
  local line='-----------------------------------------------------'
  printf "%s%s%s\n" "+-" "${line:0:${#1} }" "-+"
  printf "%s%s%s\n" "| " "${1}" " |"
  printf "%s%s%s\n" "+-" "${line:0:${#1}}" "-+"
}


print_sub_title(){
  printf "\n%s%s\n" "--> " "${1}"
}

man() {
    printf "Usage of %s\n" "${0}"


    printf "all\n"
    printf "\t Launch Symlink , Clean and install \n"

    printf "symlinks\n"
    printf "\t Create symlink of dotfiles into \${HOME} \n"
    
    printf "clean\n"
    printf "\t Clean installation and temporary files\n"
    

    printf "install\n"
    printf "\t Install required softwares\n"

   
    printf "[blank]\n"
    printf "\t Run all stages\n"
    
    printf "man\n"
    printf "\t Print this man\n"


    printf "During processing the file  PROCESS_DATA is used to determinate which tools must be process for action. The values are \n"
  printf "\t  - DISABLE_TOOLS_INSTALL : Example DISABLE_TOOLS_INSTALL=DOCKER means docker will not process for any action \n"    
}


create_symlinks(){

  for file in ${CURRENT_DIR}/symlinks/* ; do
    BASENAME_FILE=$(basename "${file}")
    echo "${HOME}/.${BASENAME_FILE}"
    [ -r "$file" ] && [ -f "$file" ] &&  [ -e "$file" ]  && rm -f "${HOME}/.${BASENAME_FILE}" && ln -s "${file}" "${HOME}/".${BASENAME_FILE}; 
  done
}

process_tools() {

    local LC_ALL="C"
    local LANG="C"
    local PROCESS_DATA_FILE_PATH="${CURRENT_DIR}/PROCESS_DATA"
    local DISABLE_TOOLS_INSTALLATION=$( grep ^DISABLE_TOOLS ${PROCESS_DATA_FILE_PATH} | cut -d '=' -f2) 


    if [[ "$DISABLE_TOOLS_INSTALLATION" == "ALL" ]]; then
      printf "ALL TOOLS ARE DEACTIVATE FOR PROCESSING - SEE PROCESS_DATA file \n"
      return ;
  fi

  for file in "${CURRENT_DIR}/tools"/*; do
    local BASENAME_FILE
      BASENAME_FILE="$(basename "${file%.*}")"

      local UPPERCASE_FILENAME
      UPPERCASE_FILENAME="$(echo "${BASENAME_FILE}" | tr "[:lower:]" "[:upper:]")"


      if [[ "$DISABLE_TOOLS_INSTALLATION" == *"$UPPERCASE_FILENAME"* ]]; then
        #echo  $UPPERCASE_FILENAME "is DEACTIVATE FOR PROCESSING - SEE PROCESS_DATA file"
        continue ;
    fi


      if [[ -r ${file} ]]; then
          for action in "${@}"; do
            unset -f "${action}"
        done

          source "${file}"

          for action in "${@}"; do

            if [[ $(type -t "${action}") = "function" ]]; then
              print_sub_title "${action} - ${BASENAME_FILE}"
               "${action}"
            fi
          done
      fi
    done
}

clean_brew() {
  if command -v brew > /dev/null 2>&1; then
      brew cleanup
    fi
}

main(){

  local ARGS="${*}"
    
  if [[ "${ARGS}" =~ man ]]; then
      man
      return 0
  fi

  if [[ "${ARGS}" == "all" ]] || [[ "${ARGS}" =~ symlinks ]]; then
  print_title "Creation Symlinks"
  create_symlinks
  fi

  set +u
  set +e
  print_title "Launch bashrc"
  PS1="$" source "${HOME}/.bashrc"
  set -e
  set -u

  if [[ "${ARGS}" =~ all ]] || [[ "${ARGS}" =~ clean ]]; then
    print_title "Cleaning"
    process_tools clean
    clean_brew
  fi
  
  if [[ "${ARGS}" =~ all ]] || [[ "${ARGS}" =~ install ]]; then
    print_title "Installation"
    process_tools install
  clean_brew
  fi

}

main "${@:-}"
