#!/usr/bin/env bash

set -e

if [ -z "$DATABASE_URL" ]; then
  echo "DATABASE_URL is not set. Set this environment variable and try again."
  exit 1
fi

if [ -z "$B2_APPLICATION_KEY" ]; then
  echo "B2_APPLICATION_KEY is not set. Set this environment variable and try again."
  exit 1
fi

if [ -z "$B2_APPLICATION_KEY_ID" ]; then
  echo "B2_APPLICATION_KEY_ID is not set. Set this environment variable and try again."
  exit 1
fi

if [ -z "$B2_BUCKET_NAME" ]; then
  echo "B2_BUCKET_NAME is not set. Set this environment variable and try again."
  exit 1
fi

if [ -z "$ENCRYPTION_KEY" ]; then
  echo "ENCRYPTION_KEY is not set. Set this environment variable and try again."
  exit 1
fi

# Parse the DATABASE_URL for `pg_dump` command
DB_HOST=$(echo $DATABASE_URL | cut -d '@' -f 2 | cut -d '/' -f 1)
DB_PORT=5432  # default PostgreSQL port, adjust if necessary
DB_USER=$(echo $DATABASE_URL | cut -d ':' -f 2 | cut -d '/' -f 3)
DB_PASS=$(echo $DATABASE_URL | cut -d ':' -f 3 | cut -d '@' -f 1)
DB_NAME=$(echo $DATABASE_URL | cut -d '@' -f 2 | cut -d '/' -f 2)

# Create a PostgreSQL password file to avoid the password prompt of pg_dump
> ~/.pgpass
chmod 600 ~/.pgpass
echo "*:*:*:$DB_USER:$DB_PASS" > ~/.pgpass


# Dump the PostgreSQL database
BACKUP_FILE=/tmp/backup.dmp
PGPASSWORD=$DB_PASS pg_dump --host=$DB_HOST --port=$DB_PORT --username=$DB_USER --format c --blobs --verbose --file=$BACKUP_FILE $DB_NAME

# Encrypt the backup file with OpenSSL
ENCRYPTED_BACKUP_FILE=/tmp/encrypted_backup.dmp
openssl enc -aes-256-cbc -pbkdf2 -p -in $BACKUP_FILE -out $ENCRYPTED_BACKUP_FILE -pass pass:$ENCRYPTION_KEY

# Get the current date and time for the backup filename
TIMESTAMP=$(date +%Y%m%d%H%M%S)
TARGET_FILENAME="${DB_NAME}-${TIMESTAMP}.dmp.enc"

# Upload the encrypted backup file to Backblaze B2
b2 authorize-account $B2_APPLICATION_KEY_ID $B2_APPLICATION_KEY
b2 upload-file $B2_BUCKET_NAME $ENCRYPTED_BACKUP_FILE $TARGET_FILENAME
