# Postgres-backup-tool

This Docker container is created to facilitate the process of backing up and restoring a PostgreSQL database.
It automatically connects to your PostgreSQL database, dumps the entire database, and uploads it to an S3 bucket.

### Prerequisities

In order to run this container you'll need docker installed.

- [Windows](https://docs.docker.com/windows/started)
- [OS X](https://docs.docker.com/mac/started/)
- [Linux](https://docs.docker.com/linux/started/)

### Usage

#### Container Parameters

List the different parameters available to your container
you need to set the env var's before runnging any command

```shell
docker run ahmad7899/postgres-backup-restore-tool:latest help
```

Example of backup proccess

```shell
docker run --env.... ahmad7899/postgres-backup-restore-tool:latest backup
```

Example of restore proccess

```shell
docker run --env.... ahmad7899/postgres-backup-restore-tool:latest restore
```

Example of getting shell

```shell
docker run --env.... ahmad7899/postgres-backup-restore-tool:latest sh
```

#### Environment Variables

## Backup database env
- `AWS_ACCESS_KEY` - Access key for AWS s3 bucket.
- `AWS_SECRET_KEY` - Secret key paired with the access key.
- `AWS_BUCKET_NAME` - Name of the S3 bucket for storing backups
- `POSTGRES_HOST` - Hostname or IP address of the PostgreSQL server(it can be local or remote host).
- `POSTGRES_PORT` - Port number for PostgreSQL connections. default is 5432
- `POSTGRES_USER_NAME` - Username for PostgreSQL authentication.
- `POSTGRES_DB_NAME` - Name of the PostgreSQL database you want to backup.
- `POSTGRES_DB_PASSWORD` - Password for PostgreSQL authentication
- `BACKUP_FILE_NAME` - Name for the generated backup file

## Example
```shell
docker run --rm  \
###################################################################################
#optional
--network="example" \ # if you want to append it to existing network
#optional
--add-host=host.docker.internal:host-gateway \ # if you want to access host network 
###################################################################################
--env AWS_ACCESS_KEY=access-Key \
--env AWS_SECRET_KEY=secret-key \
--env AWS_BUCKET_NAME=bucket-name \
--env POSTGRES_HOST=postgres host \
--env POSTGRES_PORT=postgres port \
--env POSTGRES_USER_NAME=postgres user \
--env POSTGRES_DB_NAME=postgres database \
--env POSTGRES_DB_PASSWORD=postgres passwrod \
--env BACKUP_FILE_NAME=file name to dump database to \
ahmad7899/postgres-backup-restore-tool:latest backup
```

## Restore database env
- `AWS_ACCESS_KEY` - Access key for AWS s3 bucket.
- `AWS_SECRET_KEY` - Secret key paired with the access key.
- `AWS_BUCKET_NAME` - Name of the S3 bucket for restoring backups
- `POSTGRES_HOST` - Hostname or IP address of the PostgreSQL server(it can be local or remote host).
- `POSTGRES_PORT` - Port number for PostgreSQL connections. default is 5432
- `POSTGRES_USER_NAME` - Username for PostgreSQL authentication.
- `POSTGRES_DB_NAME` - Name of the PostgreSQL database you want to restore the database to, preferd to create new database.
- `POSTGRES_DB_PASSWORD` - Password for PostgreSQL authentication
- `DB_RESTORE_NAME` - Name for DB backup file in s3 bucket

## Example
```shell
docker run --rm \
###################################################################################
#optional
--network="example" \ # if you want to append it to existing network
#optional
--add-host=host.docker.internal:host-gateway \ # if you want to access host network 
###################################################################################
--env AWS_ACCESS_KEY=access-Key \
--env AWS_SECRET_KEY=secret-key \
--env AWS_BUCKET_NAME=bucket-name \
--env POSTGRES_HOST=postgres host \
--env POSTGRES_PORT=postgres port \
--env POSTGRES_USER_NAME=postgres user \
--env POSTGRES_DB_NAME=postgres database \
--env POSTGRES_DB_PASSWORD=postgres passwrod \
--env DB_RESTORE_NAME=backup file name in s3 bucket \
ahmad7899/postgres-backup-restore-tool:latest restore
```
