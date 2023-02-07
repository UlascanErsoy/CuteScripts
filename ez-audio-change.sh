#!/usr/bin/env bash 

sinks=$(/usr/bin/pacmd list-sinks | grep -E 'index|device.description')


input_indexes=()
choices=""

while IFS= read -r line; do 
    if [[ $line =~  (index:[[:space:]])([0-9]+) ]]; then
        choices+="${BASH_REMATCH[2]}-" 
    elif [[ $line =~ (=[[:space:]])(.*) ]]; then
        choices+=${BASH_REMATCH[2]}
        choices+="\n"
    fi
done <<< "$sinks"

choice=$(echo -e $(echo $choices | tr '"' ' ') | fzf)

if [[ $choice =~ ([0-9]+)([-]) ]]; then
    choice=${BASH_REMATCH[1]}
fi

/usr/bin/pacmd set-default-sink $choice

#if there are active audio sources switch them
#manually
inputs=$(/usr/bin/pacmd list-sink-inputs | grep 'index')

if ! [[ -z inputs ]]; then
    while IFS= read -r line; do 
        if [[ $line =~  (index:[[:space:]])([0-9]+) ]]; then
            /usr/bin/pacmd move-sink-input $choice ${BASH_REMATCH[2]}
        fi 
            done <<< "$inputs" 
fi 
