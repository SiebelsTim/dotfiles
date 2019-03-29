#!/bin/sh
ID=$(xdpyinfo | grep focus | cut -f4 -d " ")
# CWD depends on fish's title
# split by # and then by $
CWD=$(xprop -id $ID | grep -m 1 WM_NAME | cut -f2 -d "#" | cut -f1 -d "\$" | tr -d '[:space:]')

gnome-terminal --working-directory="$CWD"
