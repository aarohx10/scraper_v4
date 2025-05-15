#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Set backup directory
BACKUP_DIR="/root/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="company_research_backup_$DATE"

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Backup data directory
tar -czf $BACKUP_DIR/$BACKUP_NAME.tar.gz -C $SCRIPT_DIR data/

# Keep only last 7 backups
ls -t $BACKUP_DIR/company_research_backup_* | tail -n +8 | xargs -r rm

# Log backup
echo "$(date): Backup completed: $BACKUP_NAME.tar.gz" >> $BACKUP_DIR/backup.log 