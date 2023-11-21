#!/usr/bin/env bash 

default_sink=$(/usr/bin/pactl get-default-sink)

cur_sink=0
name=""
mute=0
volume=""

while IFS= read -r line; do 
    if [[ $line == *"Name: ${default_sink}"* ]]; then
        cur_sink=1
    fi

    if [ $cur_sink -gt 0 ]; then
        if [[ $line =~ Description:[[:space:]](.*) ]]; then
            name=${BASH_REMATCH[1]}
        fi

        if [[ $line == *"Mute: yes"* ]]; then
            mute=1
        fi

        if [[ $line =~ Volume:[[:space:]]front-left:[[:space:]][0-9]*[[:space:]]/[[:space:]]*([0-9]*) ]]; then
            volume=${BASH_REMATCH[1]};
        fi
    fi
done <<< "$(/usr/bin/pactl list sinks)"

if [ "$cur_sink" -eq "0" ]; then
    echo "No Sink";
    exit;
fi

if [ "$mute" -eq "1" ]; then
    echo " ";
    echo
    echo "yellow";
    exit;
fi

echo "${volume}% "
