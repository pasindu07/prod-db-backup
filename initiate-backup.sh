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
OLD_BACKUP_DIR=$(ls $BACKUP_DIR)
LOG_FILE="$BACKUP_DIR/backup_$DATE.log"

