# pg-to-b2

Backup postgresql databases to blackblaze

* take a pg_dump from the database
* encript it
* upload it to blackblaze

# How to use it

    docker pull pabloscolpino/pg-to-b2

    docker run pabloscolpino/pg-to-b2 \
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
