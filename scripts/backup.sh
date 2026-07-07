#!/bin/bash

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="backup_${TIMESTAMP}.sql"

docker exec postgres pg_dump -U postgres hotel_db > $BACKUP_FILE

echo "Backup created: $BACKUP_FILE"