#!/bin/bash -u
USER=$1
PASS=$2
PORT=$3

TTYD_PID=$(ps aux | grep "ttyd -p" | grep -v grep | awk '{print $2}')
if [[ "$TTYD_PID" =~ ^[0-9]+$ ]] ; then
    kill $TTYD_PID
fi
TMUX_PID=$(ps aux | grep "tmux new -A -s ttyd-persist" | grep -v grep | awk '{print $2}')
if [[ "$TMUX_PID" =~ ^[0-9]+$ ]] ; then
    kill $TMUX_PID
fi
sleep 1

ttyd -p $PORT -c $USER:$PASS tmux new -A -s ttyd-persist bash &
