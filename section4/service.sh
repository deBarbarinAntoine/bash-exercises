#!bin/bash
#
#Created by Antoine de Barbarin, December, 5th 2023
#This script takes a service as parameter and checks if it exists, if it does, it checks if it is running, and if not, it turns it down.

usage() {
	echo "The command $0 accepts service name and can toggle it."
	echo "Add -h or --help parameters to view this help."
}

if [[ " $@ " =~ " -h " ]] || [[ " $@ " =~ " --help " ]] ; then
	usage
	exit 0
fi

if [[ $# != 1 ]]
then
    usage
    exit 1
elif [ $(systemctl list-unit-files --type=service | grep $1 ) ]
then
    if [ $(systemctl is-active $1) ]
    then
        while [[ ! answer=~^[YyNn]$ ]]
        do
            read -p "Service $1 is active, do you want to deactivate it? [Y/n] " answer
        done
        if [[ answer=~^[Yy]$ ]]
        then
            echo "Deactivating service $1 ..."
            systemctl stop $1
            exit 0
        else
            echo "Nothing was done"
            exit 0
        fi
    else
        while [[ ! answer=~^[YyNn]$ ]]
        do
            read -p "Service $1 is inactive, do you want to activate it? [Y/n] " answer

