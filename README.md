# pg-to-b2

Backup postgresql databases to blackblaze

* run pg_dump targetting the given database
* encript the dump
* upload the encrypted dump to blackblaze

# How to use it

    docker pull pabloscolpino/pg-to-b2:13-latest

    docker run pabloscolpino/pg-to-b2:13-latest \
        --env DATABASE_URL \
        --env B2_APPLICATION_KEY \
        --env B2_APPLICATION_KEY_ID \
        --env B2_BUCKET_NAME \
        --env ENCRYPTION_KEY

# Configuration
The configuration is done thrugh environment variables

* `DATABASE_URL`: Database url to reach the database to be backed up

* `B2_APPLICATION_KEY`: Blackblaze application key (_this is the secret one that is only shown once on the UI_)

* `B2_APPLICATION_KEY_ID`: Blackblaze's application key id

* `B2_BUCKET_NAME`: Blackblaze's bucket name

* `ENCRYPTION_KEY`: The simetric password to encrypt the dump with

# Development & Testing

    # Configure credentials and target PG version
    cp .env.sample .env
    vi .env

    docker compose build
    docker compose down --remove-orphans -v
    docker compose up -d db
    sleep 1
    docker compose run --rm backup
