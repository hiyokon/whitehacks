#!/bin/bash

LOG_BASE=/tmp/
DEFAULT_LOG=chat.log
LOG=$LOG_BASE$DEFAULT_LOG
LINENUM=$(stty size|cut -d ' ' -f 1)
if [[ "$CHAT_NAME" = "" ]]; then
  CHAT_NAME=$USER
fi
if [[ "$CHAT_ICON" = "" ]]; then
  NOTIFY_COM="notify-send"
else
  NOTIFY_COM="notify-send -i $CHAT_ICON"
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
    echo -n "[$(date '+%H:%M:%S')] $(printf '%10s' $CHAT_NAME): " >> $LOG_BASE$DEFAULT_LOG
    echo "$1" >> $LOG_BASE$DEFAULT_LOG
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
    if [[ "$(echo $NBODY|cut -d ' ' -f 1)" = "@${CHAT_NAME}" ]]; then
      NTITLE="Reply from $NTITLE"
      dbus-launch $NOTIFY_COM -u critical "$NTITLE" "$NBODY" &
    else
      dbus-launch $NOTIFY_COM "$NTITLE" "$NBODY" &
    fi
  fi
}


if [[ "$1" != "" ]]; then
  LOG=$LOG_BASE$1.log
  if [[ ! -f $LOG ]]; then
    touch $LOG
    chmod a+rw $LOG
    t_d "== チャットルーム '$1' を作成しました =="
  fi
fi

l
while ((1))
do
  while read -e line
  do
    case "$line" in
    "q") quit;clear;exit 0 ;;
    "exit") quit;clear;echo Bye!;exit 0 ;;
    "l") quit;less -R +G $LOG;l;continue ;;
    esac

    t "$line"
    l
  done
done

