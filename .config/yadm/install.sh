#!/bin/bash

# curl https://raw.githubusercontent.com/elstevi/dotfiles/refs/heads/master/.config/yadm/install.sh | bash
# Install yadm, clearing old installs out
rm -r ${HOME}/.local/share/yadm ${HOME}/.config/yadm
yadm clone -f --bootstrap https://github.com/elstevi/dotfiles
yadm reset --hard origin/master
