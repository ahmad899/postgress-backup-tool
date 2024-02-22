#!/bin/sh
set -eu
Help() {
   # Display Help
   echo "This Continer is made for backup | restore postgresql database to s3 bucket."
   echo
   echo "Syntax: backup"
   echo "Syntax: resore"
   echo
}

#declare needed paths and variables
USER_COMMAND="$1"
mkdir -p /home/$(whoami)/DB_BACKUP
mkdir -p /home/$(whoami)/DB_RESTORE
S3CMD_CONFIG=/home/$(whoami)/.s3cfg
DATABASE_BACKUP_FOLDER=/home/$(whoami)/DB_BACKUP
DATABASE_RESTORE_FOLDER=/home/$(whoami)/DB_RESTORE
DATABASE_BACKUP_FILE=`date +"%Y%m%d%H%M"_vulcan.pgsql`

#check if env vars is set 
if [[ -n "$AWS_ACCESS_KEY" && \
      -n "$AWS_SECRET_KEY" && \
      -n "$AWS_BUCKET_NAME" && \
      -n "$POSTGRES_HOST" && \
      -n "$POSTGRES_PORT" && \
      -n "$POSTGRES_USER_NAME" && \
      -n "$POSTGRES_DB_NAME" && \
      -n "$POSTGRES_DB_PASSWORD" ]]; then
    echo "All env are set and ready to be used"
else
    echo "You need to set AWS env variables and postgres env variables
    make sure the follwoing env is set:
        AWS_ACCESS_KEY
        AWS_SECRET_KEY
        AWS_BUCKET_NAME
        POSTGRES_HOST
        POSTGRES_PORT
        POSTGRES_USER_NAME
        POSTGRES_DB_NAME
        POSTGRES_DB_PASSWORD"
    exit 1
fi

#check the connection with the database
if pg_isready -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER_NAME" -d "$POSTGRES_DB_NAME" > /dev/null 2>&1; then
    echo "Connection to PostgreSQL host is successful."
else
    echo "Failed to connect to PostgreSQL host."
    exit 1
fi

echo "" >> "$S3CMD_CONFIG"
echo "access_key=${AWS_ACCESS_KEY}" >> "$S3CMD_CONFIG"
echo "secret_key=${AWS_SECRET_KEY}" >> "$S3CMD_CONFIG"


function backupDBtoS3() {
    echo "dumping database into file ..........."
    PGPASSWORD="$POSTGRES_DB_PASSWORD" pg_dump -U "${POSTGRES_USER_NAME}" -h "${POSTGRES_HOST}" -p "${POSTGRES_PORT}" "${POSTGRES_DB_NAME}" -O > $DATABASE_BACKUP_FOLDER/$DATABASE_DESTINATION_FILE
    echo "upload database file to s3 bucket"
    s3cmd put $DATABASE_BACKUP_FOLDER/$DATABASE_DESTINATION_FILE s3://$AWS_BUCKET_NAME
    echo "Database backuped successfully"
}

function restoreDBFromS3() {
    echo "start restoring database"
    echo "download database from s3 ......."
    s3cmd get s3://$AWS_BUCKET_NAME/$DB_RESTORE_NAME $DATABASE_RESTORE_FOLDER
    echo "Database downloaded"
    echo "Restoring database $POSTGRES_DB_NAME from $DATABASE_RESTORE_FOLDER"
    PGPASSWORD="$POSTGRES_DB_PASSWORD" psql -U "${POSTGRES_USER_NAME}" -h "${POSTGRES_HOST}" -p "${POSTGRES_PORT}" -d "${POSTGRES_DB_NAME}" < $DATABASE_RESTORE_FOLDER/$DB_RESTORE_NAME
    echo "Database restored successfully"
}

# Get the first argument passed to the script
case "$USER_COMMAND" in
    help)
        Help
        ;;
    backup)
        echo "Start backup process..."
        backupDBtoS3
        ;;
    restore)
        echo "Start restore process..."
        restoreDBFromS3
        ;;
    *)
        exec $1
        ;;
esac
exit 0