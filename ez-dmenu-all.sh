#!/usr/bin/env bash 
#Script to add flatpak to the 
#dmenu

flatpak_apps=$(flatpak list)
choices=""

while IFS= read -r line; do 
    if [[ $line =~ ^([^[[:space:]]*)[[:space:]]*([^[[:space:]]*) ]]; then
       choices+="${BASH_REMATCH[1]}\n" 
    fi

done <<< "$flatpak_apps"

choice=$(echo -e "$(dmenu_path)\n$choices" | i3-dmenu-desktop)

if [[ "$choices" =~ $choice ]]; then
    while IFS= read -r line; do 
        if [[ $line =~ ^$choice[[:space:]]*([^[[:space:]]*) ]]; then
            flatpak run ${BASH_REMATCH[1]} &
            exit 0
        fi
    done <<< "$flatpak_apps"
else
    echo $choice | ( ${SHELL:-"/bin/sh"} & ) 
fi 


