#!/bin/bash


function write_chat()
{

    # variable

    local path_chat_usr=~/whitehacks/mac_user.csv
    local path_chat_log=~/whitehacks/chat.log

    #  input:
    # output: ip address

    local ip=`who am i | cut -d ' ' -f 9 | sed -e 's/[()]//g'`
    if [ -z $ip ]
    then
        local ip=`/sbin/ifconfig | grep broadcast | awk '{print $2}'`
    fi

    #  input: ip address
    # output: mac address
echo $ip
    local mac=`arp -a | grep $ip | awk '{print $4}'`

    #  input: mac address
    # output: user name
    echo $mac
    local user=`grep "$mac" $path_chat_usr | cut -d ',' -f 2`
    echo $user
    # organize username length
    # write <args> to log file

    if [ `echo $user | wc -m`>10 ]
    then
        echo "`echo $user | cut -c 1-10`: $1" >> $path_chat_log
    else
        echo "`printf %10s $user`: $1" >> $path_chat_log
    fi

}

write_chat $1
