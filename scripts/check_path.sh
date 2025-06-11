#!/bin/bash

# check that /home/$USERNAME/.local/bin is in PATH
if [[ ! "$PATH" =~ /home/$USERNAME/.local/bin ]]; then
    echo "/home/$USERNAME/.local/bin is not in PATH"
    exit 1
else
    echo "/home/$USERNAME/.local/bin is in PATH"
fi