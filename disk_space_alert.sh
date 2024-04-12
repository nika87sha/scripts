#!/bin/bash

threshold=50
current_usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

if [ "$current_usage" -ge "$threshold" ]; then
	echo "Disk space is running low!" | mail -s "Alert: Low disk space" admin@example.com
else
	echo "Disk space is okay"
fi
