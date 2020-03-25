#!/usr/bin/env bash

WORKING_DIRECTORY="/home/dev/.update/"

die() {
  echo "$*" >&2
  exit 444
}

working_directory() {
  if [[ ! -s ${WORKING_DIRECTORY} ]]; then
    mkdir -p ${WORKING_DIRECTORY}
  fi
  cd ${WORKING_DIRECTORY}
}

main() {

  if [[ ! -s .git ]]; then
    git clone https://github.com/boratanrikulu/update.git .
  else
    git pull
  fi
  clear

  if [[ ! -s "/home/dev/.local/share/systemd/user/update_dev.service" ]]; then
    mkdir -p /home/dev/.local/share/systemd/user
    cp update_dev.service /home/dev/.local/share/systemd/user/update_dev.service
    chown dev:users /home/dev/.local/share/systemd/ -R
    systemctl --user enable update_dev.service
    die "Service was enabled. Reboot is needed."
  fi

  if [[ -s "go.sh" ]]; then
    chmod u+x go.sh
  else
    die "There is no go installation script."
  fi

  sudo -u dev DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus xfce4-terminal \
       --title "Update - PauSiber Dev" \
       --hide-menubar \
       --hide-toolbar \
       -e "./go.sh" \
       --hold
}

working_directory
main
