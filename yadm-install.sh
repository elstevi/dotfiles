#!/bin/bash

# Install yadm, clearing old installs out
rm -r ${home}/.local/share/yadm ${home}/.config/yadm
yadm clone -f --bootstrap https://github.com/elstevi/dotfiles
yadm reset --hard origin/master
