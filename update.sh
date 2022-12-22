#!/bin/sh

# This script is cloning git repository and restarts shiny server to make edits come to life.
# If there are any problems with permissions try to run:
#
# > chmod u+x ./update-server.sh
#
# see: https://www.shells.com/l/en-US/tutorial/How-to-Fix-Shell-Script-Permission-Denied-Error-in-Linux

# To automate task edit crontab, i.e.
#
# > crontab -e
#
# see: https://stackoverflow.com/a/23147406/9300556

echo "Updating Shiny-Server…"
git -C  /srv/shiny-server pull
sudo systemctl restart shiny-server