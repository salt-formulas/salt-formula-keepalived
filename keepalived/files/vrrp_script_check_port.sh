#!/bin/sh
# $1 PORT
# $2 [TCP|UDP]
# $3 inet family [4|6]
lsof -i${3}${2}:${1} | grep -Fq LISTEN
