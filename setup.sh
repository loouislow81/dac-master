#!/bin/bash
#
# @@script: setup.sh
# @@description: dac-master installer
# @@version:
# @@author: Loouis Low <loouis@gmail.com>
# @@copyright:
#

binary=$(basename $0)

# ansi
blue='\e[94m'
bold=$(tput bold)
normal=$(tput sgr0)
nc='\033[0m'
title="${blue}[dac-master]${nc}"

# crons
croncmd1="sudo dac-master --install && dac-master"
cronjob1="@reboot $croncmd1"

function runas_root() {
  # check if sudo
  if [ "$(whoami &2> /dev/null)" != "root" ] &&
     [ "$(id -un &2> /dev/null)" != "root" ]
    then
      echo -e "$title permission denied"
      exit 1
  fi
}

function prerequisites () {
  if ! [ -x "$(command -v sox)" ];
  then
    echo -e "$title installing sox, udev..." >&2
    apt install -y sox udev
  fi
}

function install_script() {
  runas_root
  echo -e "$title installing dac-master..."
  sudo cp $PWD/dac-master.sh /usr/local/bin/
  sudo mv /usr/local/bin/dac-master.sh /usr/local/bin/dac-master
}

function remove_script() {
  echo -e "$title removing dac-master..."
  sudo rm -rf /usr/local/bin/dac-master
}

function add_to_cron() {
  echo -e "$title adding to cronjob..."
  ( crontab -l | grep -v -F "$croncmd1" ; echo "$cronjob1" ) | crontab -
}

function remove_from_cron() {
  echo -e "$title removing from cronjob..."
  ( crontab -l | grep -v -F "$croncmd1" ) | crontab -
}

echo -e "$title usage: $binary [--help|--install|--remove]"

while test "$#" -gt 0;
  do
    case "$1" in

      -h|--help)
      shift
        echo
        echo -e "${bold}Usage:${normal}"
        echo
        echo "-h, --help            Display this information"
        echo "-i, --install         Install script"
        echo
        exit 1
      shift;;

      -i|--install)
      shift
        prerequisites
        add_to_cron
        install_script
        echo -e "$title reboot required."
        echo -e "$title !! now you can plug and unplug the headphone jack to see the volume has automatic change the master level."
      shift;;

      -r|--remove)
      shift
        remove_from_cron
        remove_script
      shift;;

  esac
done
