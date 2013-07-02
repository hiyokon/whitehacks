#!/bin/bash

DEFAULT_LOG=/tmp/chat.log
LOG=$DEFAULT_LOG
LINENUM=$(stty size|cut -d ' ' -f 1)
if [[ "$CHAT_NAME" = "" ]]; then
  CHAT_NAME=$USER
fi

trap 'quit;exit 0;' 2 3 9 15
trap 'notify' 10

function quit {
  if [[ "$T_PID" != "" ]]; then
    kill -9 $T_PID
  fi
}

function t {
  if [[ "$1" != "" ]]; then
    echo -n "[$(date '+%H:%M:%S')] $(printf '%10s' $CHAT_NAME): " >> $LOG
    echo "$1" >> $LOG
    sendsig
  fi
}
function t_d {
  if [[ "$1" != "" ]]; then
    echo -n "[$(date '+%H:%M:%S')] $(printf '%10s' $CHAT_NAME): " >> $DEFAULT_LOG
    echo "$1" >> $DEFAULT_LOG
    sendsig
  fi
}
function l {
  quit
  clear
  tail -f -n $LINENUM $LOG &
  T_PID=$!
}

function notify {
  local T=$(tail -1 $LOG)
  local NTITLE=$(echo $T|awk '{print $2}')
  local NBODY=$(echo $T|cut -d ' ' -f '3-')

  if [[ "$NTITLE" != "${USER}:" ]]; then
    dbus-launch notify-send $NTITLE $NBODY &
  fi
}


if [[ "$1" != "" ]]; then
  LOG=/tmp/$1.log
  if [[ ! -f $LOG ]]; then
    touch $LOG
    chmod +r+w $LOG
    t_d "== チャットルーム '$1' を作成しました =="
  fi
fi

l
while ((1))
do
  while read -e line
  do
    case "$line" in
    "q") quit; exit 0 ;;
    esac

    t "$line"
    l
  done
done

