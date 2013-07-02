#!/bin/bash

ps aux | grep c.sh | grep bash | grep -v grep | awk '{print $2}' | xargs kill -10

