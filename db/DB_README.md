Version de postgresql instalado en WSL: `psql --version`

Encender servicio: `sudo service postgresql start`

Apagar servicio: `sudo service postgresql stop`

Entrar: `sudo -u postgres psql`

IP conexión
``SHOW listen_addresses;
SHOW port;``

# Initial data
psql -U usuario -d gym_casa -f gym_data.sql
psql -h localhost -U username -d database_name -f db/gym_init_data.sql