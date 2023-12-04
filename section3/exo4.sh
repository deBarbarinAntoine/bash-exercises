#!/bin/bash

aqua="\033[1;36m"
violet="\033[35m"
red="\033[1;31m"
fmt="\033[0m"

if [[ $# != 1 ]]
then
  echo -e "$red""This program takes a username in parameter!$fmt"
  exit 1
fi

if [ $(getent passwd $1) ]
then
  declare -a ugroups=( $(groups $1) )
  declare -i nbGroup=$((${#ugroups[@]} - 2))
  echo -e "$violet""User$fmt$aqua $1$fmt$violet is currently in $fmt$aqua$nbGroup$fmt$violet groups.$fmt"
else
  echo -e "$red""Error: User$violet $1$red doesn't exist!$fmt"
fi