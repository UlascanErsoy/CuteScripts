
pid=$(pgrep picom)

if [ -z $pid ]; then
    picom & 
else
    kill $pid
fi
