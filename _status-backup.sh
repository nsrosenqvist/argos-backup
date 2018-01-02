#!/usr/bin/env bash

EXT_HD="/media/$(whoami)/My Passport"
BACKUP_SCRIPT="/home/$(whoami)/.config/argos/_backup.sh"
CLEAN_SCRIPT="/home/$(whoami)/.config/argos/_clean-backup.sh"

# Determine if the hard drive is mounted or not
mountpoint "$EXT_HD" &> /dev/null
is_mounted=$?

if [ $is_mounted -eq 0 ]; then
  # First check if a backup is running
  backup_pid="$(pgrep -fl "$BACKUP_SCRIPT")"

  if [ -n "$backup_pid" ]; then
    notify-send --icon=system-run "Backup is still running (${backup_pid%% *})..."
    exit 0
  fi

  # Then check if a cleanup is running
  clean_pid="$(pgrep -fl "$CLEAN_SCRIPT")"

  if [ -n "$clean_pid" ]; then
    notify-send --icon=system-run "Cleaning is still running (${backup_pid%% *})..."
    exit 0
  fi

  # All done!
  notify-send --icon=dialog-information "Operation has finished!"
  exit 0
else
  # Can't find hard drive!
  notify-send --icon=dialog-error "Hard drive is no longer connected!"
  exit 1
fi
