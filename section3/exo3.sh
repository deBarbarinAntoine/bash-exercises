#!/bin/bash

declare sum=0
declare -i noteNb=0
aqua="\033[1;36m"
green="\033[1;32m"
red="\033[1;31m"
fmt="\033[0m"

checkInput() {
	regex='^[+-]?[0-9]+(\.[0-9]+)?$'
	if [[ $1 =~ $regex  ]]
	then
		if (( $(echo "$1 >= 0" | bc) )) && (( $(echo "$1 <= 20" | bc) ))
		then
     			sum=$(echo "$sum + $1" | bc)
          		((noteNb++))
		else 
      			echo -e "$red""Only numbers between 0 and 20""$fmt"
   		fi
	else
		echo -e $red"Only numbers are accepted!"$fmt
	fi
}

while [ true ]
do
	echo -e -n "$green""Type your note and when you finished, type 'end':$fmt $aqua"
	read note
	echo -e -n "$fmt"
	if [[ $note == "end" ]]
	then break
	else
		checkInput $note
	fi
done

if [[ $noteNb -eq 0 ]]
then
	echo -e $red"You didn't enter any note!"$fmt
else
	echo -e $green"Your average qualification is$fmt""$aqua $(awk "BEGIN {print $sum / $noteNb}")$fmt"
fi
