#!/usr/bin/env bash

device_addrs=()
choices=""
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
BLUE='\033[0;35m'
idx=0
while IFS= read -r line; do 
    if [[ $line =~ ^Device[[:space:]](.{17})[[:space:]](.*) ]]; then
        choices+="$idx-${BASH_REMATCH[2]}"
        device_addrs+=("${BASH_REMATCH[1]}")
        device_info=$(bluetoothctl info "${BASH_REMATCH[1]}")
        if [[ $device_info == *"Connected: yes"* ]]; then
            choices+="${GREEN}(Connected)${NC}"
        else 
            choices+="${RED}(Disconnected)${NC}"
        fi
        choices+="\n"
    fi
    ((idx=idx+1)) 
done <<< "$(bluetoothctl devices)"

choices+="X-${BLUE}Pair New Device!${NC}"
choice=$(echo -e $choices | fzf --ansi)

if [[ -z $choice ]]; then
    exit 0
fi

#TODO: implement pairing
if [[ $choice == "X-"* ]]; then
    echo "Not Implemented Yet!"
    exit 2
fi 

[[ $choice =~ ^([0-9]*)-.*\((.*)\) ]]
mac_addr="${device_addrs[${BASH_REMATCH[1]}]}"
if [[ ${BASH_REMATCH[2]} == "Connected" ]]; then
    bluetoothctl disconnect $mac_addr 
else 
    bluetoothctl connect $mac_addr
fi
