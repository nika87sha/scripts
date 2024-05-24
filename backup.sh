#!/bin/bash
source_dir="$HOME/Pictures"
backup_dir="$HOME/Drive"

timestamp=$(date +%Y%m%d%H%M%S)
backup_file="backup_$timestamp.tar.gz"
tar -cvzpf $backup_dir/$backup_file $source_dir
