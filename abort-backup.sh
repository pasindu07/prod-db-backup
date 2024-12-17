#!/bin/bash

# Function to send email and log abort message
abort_backup() {
    local message=$1
    echo "Backup aborted: $message" | tee -a "$LOG_FILE"
    echo -e "Subject: Backup Process Aborted\n\n$message" | sendmail "$EMAIL_RECIPIENT"
    exit 1
}
