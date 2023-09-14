#!/usr/bin/env bash 


monitors=""
index=0

chooser="fzf"
if ! [[ -z $1 ]];then
    chooser=$1
fi

echo $chooser

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

choices="0.05\n0.1\n0.15\n0.2\n0.25\n0.3\n0.35\n0.4\n0.45\n0.5\n0.55\n0.6\n0.65\n0.7\n0.75\n0.8\n0.85\n0.9\n0.95\n1"

choice=$(echo -e $choices | ${chooser})

/usr/bin/xrandr --output $monitor --brightness $choice
