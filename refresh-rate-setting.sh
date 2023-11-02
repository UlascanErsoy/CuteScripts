#!/usr/bin/env bash 

monitors=""
index=0

chooser="fzf"
if ! [[ -z $1 ]];then
    chooser=$1
fi

while IFS= read -r line; do
    if [[ $line =~ [0-9][[:space:]](.*)[0-9][[:space:]]*(.+) ]]; then
        monitors+="${line##* }\n"
        index+=1
    fi
done <<< $(xrandr --listmonitors)     

if [ $index -gt 1 ]; then
    monitor=$(echo -e $monitors | ${chooser})
else
    monitor="${BASH_REMATCH[2]}"
fi

cm_flag=0
mode_line=""

while IFS= read -r line; do
    if [[ "$line" == *"${monitor} connected"* ]]; then
        cm_flag=1 
    fi
    if [[ "$line" == *"disconnected"* ]]; then
        cm_flag=0
    fi
    
    if [[ $cm_flag -eq 1 ]]; then
        if [[ $line == *"*"* ]]; then
            mode_line=$line
        fi
    fi
done <<< $(xrandr)

res=""
fps=""

for mode in $mode_line
do
    if [[ $res == "" ]]; then
        res=$mode
    elif [[ $mode != *"+"* ]]; then
        if [[ $mode != *"*"* ]]; then
            if [[ $fps != *"${mode}"* ]]; then
               fps+="${mode}\n" 
            fi
        fi
    fi
done

fps_choice=$(echo -e $fps | ${chooser})


xrandr --output $monitor --mode $res --rate $fps_choice 


