#!/usr/bin/env bash
#
#Created by Antoine de Barbarin, December, 5th 2023
#This script takes a service as parameter and checks if it exists, if it does, it checks if it is running, and if not, it turns it down.

usage() {
	echo "The command $0 accepts service name and can toggle it."
	echo "Add -h or --help parameters to view this help."
}

activate() {
  echo "Activating service $1..."
  if [ "$(whoami)" != "root" ]
  then
  sudo systemctl start "$1"
  else
    systemctl start "$1"
  fi
  echo "Service $1 activated successfully!"
  exit 0
}

deactivate() {
  echo "Deactivating service $1..."
  if [ "$(whoami)" != "root" ]
  then
  sudo systemctl stop "$1"
  else
    systemctl stop "$1"
  fi
  echo "Service $1 deactivated successfully!"
  exit 0
}

if [[ " $* " =~ " -h " ]] || [[ " $* " =~ " --help " ]] ; then
	usage
	exit 0
fi

if [[ $# != 1 ]]
then
    usage
    exit 1
elif  systemctl list-unit-files --type service | grep -q "$1"
then
    if [[ $(systemctl is-active "$1") ]]
    then
        while [[ ! $answer =~ ^[YyNn]$ ]]
        do
            read -p "Service $1 is active, do you want to deactivate it? [Y/n] " answer
        done
        case $answer in
          [Yy] ) deactivate "$@";;
          [Nn] ) echo "Nothing was done"; exit 0;;
        esac
    else
        while [[ ! $answer =~ ^[YyNn]$ ]]
        do
            read -p "Service $1 is inactive, do you want to activate it? [Y/n] " answer
        done
        case $answer in
          [Yy] ) activate "$@";;
          [Nn] ) echo "Nothing was done"; exit 0;;
        esac
    fi
else
    echo "Service $1 hasn't been found!"
    exit 1
fi


