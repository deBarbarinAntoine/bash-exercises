#!/bin/bash

declare -a quotes

fetchquotes() {
  while read line
  do quotes+=("$line")
  done < "$(pwd)/quotes.txt"
}

displayquote() {
  local i=($RANDOM%${#quotes[@]})
  local color="\033[$((RANDOM % 2));3$(((RANDOM % 9) + 1))m"
  echo -e "$color""${quotes[i]}\033[0m"
}

run() {
  fetchquotes
  if [ $1 ]
  then
    local regex='^[0-9]+$'
    if [[ $1 =~ $regex ]]
    then
      echo "regex ok"
      echo
      local j=0
      while [ $j -lt $1 ]; do
        displayquote
        ((j++))
      done
      echo
    else
      echo -e "\033[1;31m""Error: This program only takes one unsigned integer number!\033[0m"
    fi
  else
    echo
    displayquote
    echo
  fi
}

run "$@"