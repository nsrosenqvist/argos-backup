#!/usr/bin/env bash

EXT_HD="/media/$(whoami)/My Passport"

# Determine if the hard drive is mounted or not
mountpoint "$EXT_HD" &> /dev/null
is_mounted=$?

if [ $is_mounted -eq 0 ]; then
  notify-send --icon=system-run "Removing backups older than 1 month..."

  rdiff-backup --remove-older-than 1M "$EXT_HD/.backup/$(hostname)"
  result=$?

  if [ $result -eq 0 ]; then
    notify-send --icon=dialog-information "Cleaning successful!"
    exit 0
  fi
fi

notify-send --icon=dialog-error "Cleaning failed! Call Niklas!"
exit 1
