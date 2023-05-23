# pg-to-b2

Backup postgresql databases to blackblaze

* take a pg_dump from the database
* encript it
* upload it to blackblaze

# How to use it

    docker pull pabloscolpino/pg-to-b2

    docker run pabloscolpino/pg-to-b2 --env DATABASE_URL
