#!/bin/bash

aqua="\033[1;36m"
violet="\033[0;35m"
fmt="\033[0m"

declare -i totGroups=0
declare -i nbUsers=0
declare -i nbGroup=0
declare -i nbUserSys=0
declare -i nbUserNormal=0

getGroups() {
  declare -a ugroups=( $(groups $1) )
  nbGroup=$((${#ugroups[@]} - 2))
  echo -e "$violet""User$fmt$aqua $1$fmt$violet is currently in $fmt$aqua$nbGroup$fmt$violet groups.$fmt"
}

while read line
do
  user=$(echo "$line"|awk -F ':' '{print $1}')
  userId=$(echo "$line"|awk -F ':' '{print $3}')
  # echo $userId
  if [[ $userId -lt '1000' ]]
  then
    ((nbUserSys++))
  else
    ((nbUserNormal++))
  fi
  getGroups $user
  ((nbUsers++))
  ((totGroups+=$nbGroup))
done < /etc/passwd

echo -e "$violet""There are $aqua$nbUsers$violet users in $aqua$HOSTNAME$violet, $aqua$nbUserSys$violet are system users, $aqua$nbUserNormal$violet are normal users.$fmt"
echo -e "$violet""The average number of groups per user is: $aqua$(awk "BEGIN { printf \"%.2f\", $totGroups / $nbUsers }")$violet.$fmt"
