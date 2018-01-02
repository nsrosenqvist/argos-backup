#!/usr/bin/env bash

MEDIA_DIR="/media/$(whoami)"
EXT_HD="$MEDIA_DIR/My Passport"
BACKUP_DIR="$EXT_HD/.backup/$(hostname)"
BACKUP_SCRIPT="/home/$(whoami)/.config/argos/_backup.sh"
CLEAN_SCRIPT="/home/$(whoami)/.config/argos/_clean-backup.sh"
STATUS_SCRIPT="/home/$(whoami)/.config/argos/_status-backup.sh"

# Determine if the hard drive is mounted or not
mountpoint "$EXT_HD" &> /dev/null
is_mounted=$?

if [ $is_mounted -eq 0 ]; then
  echo "Backup | iconName=document-save refresh=true"
  echo "---"

  echo "<span color='green'>HD connected</span>"
  echo "Browse HD | iconName=folder bash=\"nautilus '$EXT_HD'\" terminal=false"
  echo "---"

  # First check if a backup is running
  backup_pid="$(pgrep -fl "$BACKUP_SCRIPT")"

  if [ -n "$backup_pid" ]; then
    echo "<span color='gray'>Backup is running...</span>"
    echo "<span color='gray'>Process ID: ${backup_pid%% *}</span>"
    echo "Check If Done | iconName=view-refresh bash=\"bash '$STATUS_SCRIPT'\" refresh=true terminal=false"
    exit 0
  fi

  # Then check if a cleanup is running
  clean_pid="$(pgrep -fl "$CLEAN_SCRIPT")"

  if [ -n "$clean_pid" ]; then
    echo "<span color='gray'>Cleaning is running...</span>"
    echo "<span color='gray'>Process ID: ${clean_pid%% *}</span>"
    echo "Check If Done | iconName=view-refresh bash=\"bash '$STATUS_SCRIPT'\" refresh=true terminal=false"
    exit 0
  fi

  # Determine last time a backup was run
  last_backup="$(cat "$EXT_HD/.last-backup")"

  if [ -z "$last_backup" ]; then
    last_backup='none'
  fi

  echo "<span color='gray'>Last backup: $last_backup</span>"

  # Backup actions
  echo "Backup Now | iconName=media-playback-start bash=\"bash '$BACKUP_SCRIPT'\" terminal=false refresh=true"
  echo "Browse Backups | iconName=folder bash=\"nautilus '$BACKUP_DIR'\" terminal=false"
  echo "---"
  echo "Clean Old Backups | iconName=user-trash bash=\"bash '$CLEAN_SCRIPT'\" terminal=false refresh=true"
  echo "Reload Plugin | iconName=view-refresh refresh=true"
else
  # Don't show the backup text when it isn't plugged in
  echo " | iconName=drive-harddisk"
  echo "---"
  echo "<span color='red'>HD not connected</span>"
  echo "---"
  echo "<span color='gray'>Connect your external HD (My Passport)\nto view and run backups</span>"
  echo "Check Again | iconName=view-refresh refresh=true"
fi
