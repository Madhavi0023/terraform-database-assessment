#!/bin/bash

BACKUP_FILE=$1

cat $BACKUP_FILE | docker exec -i postgres psql -U postgres hotel_db

echo "Database restored successfully."