Add a DB and Create a new User

- `su - postgres`
- `psql`
- `CREATE DATABASE mydb;`
- `CREATE USER NAME WITH PASSWORD 'password';`
- `ALTER USER NAME WITH PASSWORD 'password';`
- `GRANT ALL PRIVILEGES ON DATABASE mydb TO myuser;`

Local Access

- Update `/var/lib/pgsql9/data/pg_hba.conf` with `host    all             all             127.0.0.1/32            md5`

Remote Access

- Update `/var/lib/pgsql9/data/pg_hba.conf` with `host    all             all             IP_ADDRESS/32          md5`
- Update `/var/lib/pgsql9/data/postgresql.conf` with `listen_addresses = 'IP_ADDRESS'`
