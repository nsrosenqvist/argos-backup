#!/usr/bin/env bash

EXT_HD="/media/$(whoami)/My Passport"

# Determine if the hard drive is mounted or not
mountpoint "$EXT_HD" &> /dev/null
is_mounted=$?

if [ $is_mounted -eq 0 ]; then
  notify-send --icon=system-run "Running backup..."
  backup_location="$EXT_HD/.backup/$(hostname)"

  mkdir -p "$backup_location"
  rdiff-backup --exclude '**/.cache/' /home "$backup_location"
  result=$?

  if [ $result -eq 0 ]; then
    date "+%Y-%m-%d %H:%M:%S" > "$EXT_HD/.last-backup"
    notify-send --icon=dialog-information "Backup successful!"
    exit 0
  fi
fi

notify-send --icon=dialog-error "Backup failed! Call Niklas!"
exit 1
