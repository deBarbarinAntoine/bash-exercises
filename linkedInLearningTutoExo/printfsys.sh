#!/bin/bash

# command uname parameters:
# Kernel name                       -s
# Hostname (network node hostname)  -n
# Kernel release                    -r
# Kernel version                    -v
#             #38~22.04.1-Ubuntu SMP PREEMPT_DYNAMIC Thu Nov  2 18:01:13 UTC 2
# Machine name                      -m
# Processor type                    -p
# Hardware platform                 -i
# Operating system                  -o

# GREEN	\033[32m
# YELLOW	\033[33m
# RED	\033[31m
# BLUE	\033[34m
# BOLD GREEN	\033[1;32m
# BOLD YELLOW	\033[1;33m
# BOLD RED	\033[1;31m
# BOLD BLUE	\033[1;31m
# CLEAR FORMAT \033[00m

# mySysInfo=$(uname -a)
bold="\033[1m"
# blink="\033[5m"
aqua="\033[36m"
violet="\033[35m"
grey="\033[37m"
clrFmt="\033[0m"

kernelVersion="$(uname -v)"
diskAllInfo="$(df -h / | awk 'NR==2')"
memAllInfo="$(free -h | awk 'NR==2')"

# Internal Field Separator
IFS=' '

# Convert string to array
read -ra kernelVersionArgs <<< "$kernelVersion"
read -ra diskInfo <<< "$diskAllInfo"
read -ra memInfo <<< "$memAllInfo"

echo
echo -e "$violet$bold""Hello $bold$aqua$USER$clrFmt$violet$bold, here is a little system recap:$clrFmt\n"

echo -e -n "$bold$aqua"
printf "%-16s %-16s %-22s %-22s %-16s %-18s" "Kernel name" "Hostname" "Kernel release" "Kernel version" "Processor type" "Operating system"
echo -e $clrFmt
echo -e -n $grey
printf "%-16s %-16s %-22s %-22s %-16s %-18s" "$(uname -s)" "$(uname -n)" "$(uname -r)" "${kernelVersionArgs[0]}" "$(uname -p)" "$(uname -o)"
echo -e "$clrFmt"

echo -e -n "\n$bold$aqua"
printf "%-14s\t%05s\t%05s\t%05s\t%-8s\t%-8s\t%-14s" "Volume name" "Size" "Used" "Free" "RAM size" "Free RAM" "Bash version"
echo -e $clrFmt
echo -e -n $grey
printf "%-14s\t%05s\t%05s\t%05s\t%08s\t%08s\t%-14s" "${diskInfo[0]}" "${diskInfo[1]}" "${diskInfo[2]}" "${diskInfo[3]}" "${memInfo[1]}" "${memInfo[3]}" "$BASH_VERSION"
echo -e "$clrFmt\n"
