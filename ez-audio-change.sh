#!/usr/bin/env bash 

sinks=$(/usr/bin/pactl list sinks | grep -E 'object.serial|Description')

input_indexes=()
choices=""

chooser_cmd="fzf"

if ! [[ -z $1 ]]; then
    chooser_cmd=$1
fi
while IFS= read -r line; do 
    if [[ $line =~ (Description:[[:space:]])(.*) ]]; then
        choices+="${BASH_REMATCH[2]}-"
    elif [[ $line =~ (object.serial[[:space:]]=[[:space:]]*)(.*) ]]; then
        choices+="${BASH_REMATCH[2]}" 
        choices+="\n"
    fi
done <<< "$sinks"

choice=$(echo -e $(echo $choices | tr '"' ' ') | "$chooser_cmd")

if [[ $choice =~ ([-][[:space:]])([0-9]+) ]]; then
    choice=${BASH_REMATCH[2]}
fi

/usr/bin/pactl set-default-sink $choice

#if there are active audio sources switch them
#manually
inputs=$(/usr/bin/pactl list sink-inputs short)

if ! [[ -z inputs ]]; then
    while IFS= read -r line; do 
        if [[ $line =~  ([0-9]+)([[:space:]]) ]]; then
            echo ${BASH_REMATCH[1]}
            /usr/bin/pactl move-sink-input ${BASH_REMATCH[1]} $choice 
        fi 
            done <<< "$inputs" 
fi 
