Version de postgresql instalado en WSL: `psql --version`

Encender servicio: `sudo service postgresql start`

Apagar servicio: `sudo service postgresql stop`

Entrar: `sudo -u postgres psql`

IP conexión
``SHOW listen_addresses;
SHOW port;``

# Initial data
Primero crear las tablas con `python manage.py migrate` y luego cargar el catálogo:

psql -h localhost -U username -d database_name -f db/seed_data.sql