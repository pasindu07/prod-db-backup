#!/bin/bash

# Configuration
BACKUP_DIR="<PATH>"   
HOST="<HOST>"                
USER="<DB_USER>"            
PASSWORD="<DB_PASSWORD>"     
PORT=3306                       
EMAIL_RECIPIENT="techops@orangehrm.com"  
DATE=$(date +"%d%m%Y")          
YESTERDAY=$(date -d "yesterday" +"%d%m%Y")
NEW_BACKUP_DIR="$BACKUP_DIR/backup_$DATE"
OLD_BACKUP_DIR=$(find $BACKUP_DIR -type d -name 'backup_*')
LOG_FILE="$BACKUP_DIR/log/backup_$DATE.log"

# Source external scripts
source ./abort_backup.sh
source ./backup_process.sh

# Check if backup directory exists
if [[ ! -d "$BACKUP_DIR" ]]; then
    echo "Error: Backup directory $BACKUP_DIR does not exist." | tee -a "$LOG_FILE"
    abort_backup "Backup directory $BACKUP_DIR does not exist."
    exit 1
fi

backup_process