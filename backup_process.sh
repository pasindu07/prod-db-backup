#!/bin/bash

# Function to perform the backup process
backup_process() {
    # Remove old backups
    if [[ -d "$OLD_BACKUP_DIR" ]]; then
        echo "Removing old backup directory: $OLD_BACKUP_DIR" | tee -a "$LOG_FILE"
        rm -rf "$OLD_BACKUP_DIR"
    fi

    # Create new backup directory
    mkdir -p "$NEW_BACKUP_DIR"
    echo "Created new backup directory: $NEW_BACKUP_DIR" | tee -a "$LOG_FILE"

    # Get list of databases starting with 'prod_' and include 'mysql'
    DBS=$(mysql -h "$HOST" -P "$PORT" -u "$USER" -p"$PASSWORD" -e "SHOW DATABASES;" | grep -E '^prod_')

    if [[ -z "$DBS" ]]; then
        echo "No databases found with prefix 'prod_' or 'mysql'." | tee -a "$LOG_FILE"
        abort_backup "No relevant databases found for backup."
    fi

    # Backup each database
    for DB in $DBS; do
        echo "Backing up database: $DB" | tee -a "$LOG_FILE"
        mysqldump -h "$HOST" -P "$PORT" -u "$USER" -p"$PASSWORD" "$DB" | gzip > "$NEW_BACKUP_DIR/${DB}.sql.gz"
        if [[ $? -ne 0 ]]; then
            echo "Error backing up database: $DB" | tee -a "$LOG_FILE"
            abort_backup "Error occurred while backing up database: $DB."
        fi
    done

    # Backup mysql database 
    echo "Backing up database: $DB" | tee -a "$LOG_FILE"
    mysqldump -h "$HOST" -P "$PORT" -u "$USER" -p"$PASSWORD" "$DB" | gzip > "$NEW_BACKUP_DIR/mysql.sql.gz"
    if [[ $? -ne 0 ]]; then
        echo "Error backing up database: $DB" | tee -a "$LOG_FILE"
        abort_backup "Error occurred while backing up database: $DB."
    fi

    echo "Backup completed successfully for all databases." | tee -a "$LOG_FILE"
    # echo -e "Subject: Backup Process Completed\n\nMariaDB backup completed successfully. Backup directory: $NEW_BACKUP_DIR." | sendmail "$EMAIL_RECIPIENT"
}
