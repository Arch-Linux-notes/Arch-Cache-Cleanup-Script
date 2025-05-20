#!/bin/bash

# Clear screen and show title
clear
echo '
░█▀▀░█▀█░█▀▀░█░█░█▀▀░░░█▀▀░█░░░█▀▀░█▀█░█▀█░█░█░█▀█
░█░░░█▀█░█░░░█▀█░█▀▀░░░█░░░█░░░█▀▀░█▀█░█░█░█░█░█▀▀
░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀░░░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░░
'

# Avoid some implicit errors
set -euo pipefail

# 1. Clean package cache
echo '
--------------------------------------------------
'
echo "==> Cleaning pacman cache..."
sudo pacman -Sc
sudo pacman -Scc

# 2. Find orphan packages and remove them
echo '
--------------------------------------------------
'
pkglist=$(pacman -Qdtq 2>/dev/null || echo "")
orphans=$(echo "$pkglist" | tr '\n' ' ' | xargs)
if [[ -n "$orphans" ]]; then
	echo "Orphan packages detected:"
	echo "$orphans"
	echo "==> Cleaning orphan packages..."
	sudo pacman -Rns $orphans
else
	echo "No orphan packages found."
fi

# 3. Clean cache folder
echo '
--------------------------------------------------
'
CACHE_DIR="$HOME/.cache"
echo "Cache size before cleanup:"
du -sh "$CACHE_DIR"
echo "==> Removing all files in $CACHE_DIR..."
rm -rf "$CACHE_DIR"/*
echo "Cache size after cleanup:"
du -sh "$CACHE_DIR"

# Script completed
echo '
--------------------------------------------------
'
echo "Cleanup complete!"
