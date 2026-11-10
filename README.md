# GymScreen

GymScreen es una aplicación web para entrenar en un gimnasio en casa. Hoy ofrece un catálogo de ejercicios que se puede explorar por grupo muscular, con la imagen, la descripción y videos de ejemplo de cada ejercicio. Las secciones de Rutinas, A entrenar e Historial están reservadas en la interfaz para próximas versiones.

La aplicación está pensada para desplegarse en Azure, sobre AKS, con un entorno local (`local`) y dos entornos en la nube (`dev` y `prod`).

## Descripción técnica

### Componentes

La aplicación tiene tres capas y depende de dos servicios gestionados de Azure para su configuración.

```
 Navegador
    │  HTML/JS estático
    ▼
┌──────────────────┐   HTTP/JSON    ┌───────────────────────┐   SQL    ┌──────────────┐
│ Frontend (SPA)   │ ─────────────► │ Backend API           │ ───────► │ PostgreSQL   │
│ React + Vite     │   /api/v1/     │ Django + DRF          │          │ (única capa  │
│ sin estado       │                │ sin estado            │          │  con estado) │
└──────────────────┘                └───────────────────────┘          └──────────────┘
                                         │ al arrancar
                                         ▼
                             Azure Key Vault (secretos)
                             Azure App Configuration (parámetros)
```

| Componente | Tecnología | Responsabilidad | ¿Guarda estado? |
|---|---|---|---|
| Frontend | React 19, TypeScript, Vite 8, Tailwind CSS 4, React Router 7 | SPA que consume la API. Se compila a archivos estáticos (`npm run build` → `dist/`). | No |
| Backend API | Python 3.13, Django 5.2, Django REST Framework 3.18 | API REST de solo lectura en `/api/v1/` y panel de administración (`/admin`) para editar el catálogo. | No. Todo el estado vive en la base de datos. |
| Base de datos | PostgreSQL (14 en local) | Catálogo de ejercicios, usuarios del admin, sesiones y el historial de migraciones. | **Sí** |
| Configuración | Azure Key Vault y Azure App Configuration (en local, el archivo `backend/env.local`) | Credenciales y parámetros por entorno (`ENV` = `local`, `dev` o `prod`). | Fuera de la aplicación |

Las partes que más importan para el despliegue:

- **Configuración centralizada y fail-fast** ([backend/gymscreen/gymscreen/config.py](backend/gymscreen/gymscreen/config.py)):
  - Al arrancar, el backend carga una sola vez toda su configuración en un diccionario de solo lectura (`CONFIG`).
  - Los secretos (`DJANGO_SECRET_KEY`, `DB_USER`, `DB_PASSWORD`) vienen de Key Vault.
  - Los parámetros (`ALLOWED_HOSTS`, `DB_NAME`, `DB_HOST`, `DB_PORT`, `CORS_ALLOWED_ORIGINS`) vienen de App Configuration, filtrados por la etiqueta del entorno.
  - Si falta un valor o un servicio no responde, el proceso termina al iniciar en lugar de fallar más tarde en una petición. Así, un contenedor mal configurado no llega a quedar listo.
- **Autenticación hacia Azure sin credenciales en el código:**
  - El backend usa `DefaultAzureCredential`.
  - En AKS se espera usar Workload Identity. En local se usa la sesión de Azure CLI, si hace falta.
- **Esquema versionado:**
  - El esquema de la base lo definen los modelos de Django ([backend/gymscreen/exercises/models.py](backend/gymscreen/exercises/models.py)).
  - Se aplica con las migraciones versionadas en [backend/gymscreen/exercises/migrations/](backend/gymscreen/exercises/migrations/).
  - No se edita SQL a mano.
- **Frontend estático:**
  - La URL de la API se fija al compilar (`VITE_API_URL`).
  - El resultado es un conjunto de archivos que puede servir cualquier servidor web o CDN.

### Dependencias

Las versiones están fijadas para que el entorno se pueda reconstruir de forma idéntica:

| Ámbito | Archivo | Contenido |
|---|---|---|
| Python | [backend/.python-version](backend/.python-version) | 3.13.12 |
| Paquetes Python | [backend/requirements.txt](backend/requirements.txt) | Versiones exactas (`==`) |
| Node.js | [frontend/gymscreen/.nvmrc](frontend/gymscreen/.nvmrc) | v24.21.0 |
| Paquetes npm | [frontend/gymscreen/package-lock.json](frontend/gymscreen/package-lock.json) | Árbol completo resuelto (`npm ci`) |
| Esquema de BD | `exercises/migrations/` | Historial de migraciones |
| Datos del catálogo | [db/seed_data.sql](db/seed_data.sql) | Carga de datos de referencia |

Dependencias del backend:

| Paquete | Uso |
|---|---|
| `Django` | Framework web, ORM, migraciones y admin |
| `djangorestframework` | API REST |
| `psycopg` | Driver de PostgreSQL |
| `django-cors-headers` | Permite que el frontend, en otro origen, llame a la API |
| `python-dotenv` | Lee `env.local` en el entorno local |
| `azure-identity` | Autenticación con Azure (Workload Identity / CLI) |
| `azure-keyvault-secrets` | Lectura de secretos |
| `azure-appconfiguration` | Lectura de parámetros |

Servicios externos de los que depende la aplicación en ejecución:

- Azure Key Vault y Azure App Configuration, solo en `dev` y `prod`.
- YouTube y TikTok, para reproducir los videos de ejemplo. El navegador los incrusta directamente.
- Los servidores donde estén alojadas las imágenes de los ejercicios. La base guarda URLs completas.

### Recursos necesarios

| Recurso | Local | Nube (`dev` / `prod`) |
|---|---|---|
| Cómputo backend | Proceso `manage.py runserver` | Contenedor en AKS |
| Frontend | Servidor de desarrollo de Vite (puerto 5173) | Archivos estáticos servidos por un contenedor o un servicio de hosting estático |
| Base de datos | PostgreSQL en WSL | PostgreSQL gestionado (p. ej. Azure Database for PostgreSQL) |
| Secretos | `backend/env.local` (no se sube al repositorio) | Azure Key Vault |
| Parámetros | `backend/env.local` | Azure App Configuration, con una etiqueta por entorno |
| Identidad | — | Identidad gestionada con acceso de lectura a Key Vault y App Configuration |
| Red | `localhost` | Acceso del backend a PostgreSQL y a los servicios de Azure; entrada HTTP hacia frontend y API |

La carga es ligera. El backend no guarda archivos en disco ni sesiones en memoria, así que puede escalar horizontalmente o reemplazarse sin perder información.

### Capa de datos: qué persiste

PostgreSQL es el **único componente con estado**. Todo lo demás se puede destruir y volver a crear a partir del repositorio y de la configuración en Azure.

Esta es la base, con los volúmenes actuales del entorno local:

| Tabla | Filas | Tipo de dato | Contenido |
|---|---|---|---|
| `muscle_group` | 10 | Referencia | Grupos musculares |
| `equipment` | 11 | Referencia | Aparatos y material (nombre, descripción, URL de imagen) |
| `exercise` | 79 | Referencia | Ejercicios (nombre, descripción, URL de imagen) |
| `exercise_video` | 86 | Referencia | URLs de videos de ejemplo por ejercicio |
| `exercise_musclegroup` | 87 | Referencia | Relación N:M ejercicio ↔ grupo muscular |
| `exercise_equipment` | 134 | Referencia | Relación N:M ejercicio ↔ equipo |
| `auth_user`, `auth_group`, `auth_permission` y sus tablas de relación | — | Operacional | Usuarios y permisos del panel de administración (contraseñas con hash) |
| `django_session` | — | Operacional | Sesiones abiertas en el admin |
| `django_admin_log` | — | Operacional | Bitácora de cambios hechos desde el admin |
| `django_content_type` | — | Sistema | Catálogo interno de modelos de Django |
| `django_migrations` | — | Sistema | Migraciones aplicadas; indica en qué versión está el esquema |

La integridad la garantiza la propia base:

- Claves foráneas con borrado en cascada desde `exercise` hacia sus videos y relaciones.
- Restricciones de unicidad en los nombres y en cada par de las tablas de relación.

Los datos son de dos tipos, y cada uno se recupera de forma distinta:

- **Datos de referencia (catálogo):**
  - Se pueden regenerar desde el repositorio: migraciones más `seed_data.sql`.
  - En `dev` y `prod` el catálogo se edita desde `/admin`. A partir de ese momento la fuente de verdad es la base de datos y no el script, por lo que también necesitan respaldo.
- **Datos operacionales:**
  - Hoy son los usuarios del admin, las sesiones y la bitácora.
  - No se pueden regenerar; solo se recuperan desde un respaldo.
  - Las secciones previstas (Rutinas, A entrenar, Historial) añadirán datos generados por los usuarios, como rutinas y entrenamientos realizados, que también son de este tipo. Con ellas crecerán el volumen y la importancia de la recuperación.

**Qué no está en la base de datos:**

| Elemento | Dónde está | Implicación para la recuperación |
|---|---|---|
| Secretos y parámetros | Key Vault y App Configuration | Al restaurar la base, las credenciales de Key Vault deben coincidir con las del servidor restaurado. |
| Imágenes de ejercicios y videos | Servicios externos; la base solo guarda la URL | No forman parte del respaldo. Si un enlace externo deja de existir, la interfaz muestra un placeholder o el botón "Ver video". |
| Imágenes de grupos musculares, logo y placeholder | Repositorio (`frontend/gymscreen/src/assets/`), incluidas en la compilación | Se recuperan al volver a compilar el frontend. |
| Código, esquema y datos iniciales | Repositorio Git | Se recuperan clonando el repositorio. |

### Reproducibilidad y recuperación

- **Arquitectura de tres capas en contenedores:** frontend estático, API sin estado y base relacional, más servicios gestionados de configuración. Tiene dependencias reales entre componentes (orden de arranque, conectividad, identidad, secretos) y, a la vez, es lo bastante acotada para desplegarla, destruirla y volver a crearla con facilidad.
- **El estado está concentrado en un solo punto.** Recuperar la aplicación se reduce a dos pasos:
  1. volver a desplegar los componentes sin estado desde el repositorio;
  2. restaurar PostgreSQL.

  El tiempo de reconstrucción de la infraestructura y el de restauración de datos se pueden medir por separado; juntos dan el tiempo total de recuperación (RTO). La pérdida de datos máxima (RPO) depende solo de la frecuencia de respaldo de PostgreSQL.
- **Todo lo necesario para reconstruir está versionado:** versiones del lenguaje, dependencias exactas, esquema como migraciones y datos iniciales como script. Dos despliegues desde el mismo commit deberían producir el mismo resultado.
- **Los errores de configuración se detectan al arrancar.** La carga fail-fast hace visible un despliegue incompleto (un secreto que falta, un servicio inaccesible) en el momento del arranque, y la plataforma puede reflejarlo como un contenedor que no queda listo.
- **La recuperación se puede verificar con criterios objetivos tras restaurar:**
  - las migraciones aplicadas en `django_migrations` coinciden con las del repositorio;
  - el número de filas por tabla coincide con el respaldo;
  - los endpoints responden con los mismos datos (por ejemplo, `exercise_count` de cada grupo muscular).
- **Hay dos estrategias de recuperación posibles,** porque conviven datos regenerables con datos que solo existen en la base:
  - volver a cargar el catálogo desde el script;
  - restaurar desde un respaldo, que es la única opción para los datos operacionales.

### Estado actual y pendientes para el despliegue en la nube

Implementado:

- API de solo lectura del catálogo.
- Panel de administración.
- Carga de configuración por entorno con Key Vault y App Configuration.
- CORS.
- Frontend con la sección de Ejercicios completa: grupos, lista por grupo y detalle con videos.

Pendiente para llevarla a AKS:

- Dockerfiles del backend y del frontend.
- Servidor de aplicación de producción para Django (p. ej. Gunicorn). `runserver` es solo para desarrollo.
- Servir los archivos estáticos del admin (`STATIC_ROOT` + `collectstatic`, o WhiteNoise).
- Endpoint de salud para las sondas de Kubernetes.
- Definir cómo se carga el catálogo inicial en `dev` y `prod`. `seed_data.sql` vacía las tablas antes de insertar, así que no debe ejecutarse sobre una base con datos.
- Estrategia de respaldo y restauración de PostgreSQL.
- Inyectar `VITE_API_URL` por entorno. Hoy se fija al compilar, lo que implica una compilación del frontend por entorno.

## Puesta en marcha local

Requisitos: WSL Ubuntu con PostgreSQL, pyenv (Python 3.13.12) y nvm (Node v24.21.0).

**Backend** (`backend/`):

1. Crear `backend/env.local` con `DJANGO_SECRET_KEY`, `DB_USER`, `DB_PASSWORD`, `ALLOWED_HOSTS`, `DB_NAME`, `DB_HOST`, `DB_PORT` y `CORS_ALLOWED_ORIGINS` (p. ej. `http://localhost:5173`).
2. `python -m venv venv && source venv/bin/activate && pip install -r requirements.txt`
3. `cd gymscreen && python manage.py migrate`
4. Cargar el catálogo (ver [Base de datos](#base-de-datos)).
5. `python manage.py createsuperuser` (opcional, para `/admin`)
6. `python manage.py runserver`

**Frontend** (`frontend/gymscreen/`):

1. Crear `.env.local` con `VITE_API_URL=http://localhost:8000/api/v1`.
2. `npm ci`
3. `npm run dev`. La aplicación queda en `http://localhost:5173`.

## Backend

### Base de datos

El esquema lo manejan las migraciones de Django; los datos del catálogo están en `db/seed_data.sql`.

Base nueva:
1. `python manage.py migrate`
2. `psql -h localhost -U <usuario> -d <base> -f db/seed_data.sql`

Recargar el catálogo (solo local): vuelve a correr el paso 2. Vacía y recarga las tablas de ejercicios sin tocar usuarios ni migraciones.

Cambios de esquema: edita `models.py`, luego `python manage.py makemigrations exercises` y `python manage.py migrate`. No se edita SQL a mano.

### Endpoints

Base: `/api/v1/`. Todos son de solo lectura (`GET`) y públicos.

| Método | Ruta | Descripción |
|---|---|---|
| GET | `/api/v1/equipment/` | Lista del equipo: `id`, `name`, `description`, `image`, `exercise_count` |
| GET | `/api/v1/equipment/{id}/` | Detalle de un aparato |
| GET | `/api/v1/muscle-groups/` | Lista de grupos musculares: `id`, `name`, `exercise_count` |
| GET | `/api/v1/muscle-groups/{id}/` | Detalle de un grupo muscular |
| GET | `/api/v1/exercises/` | Lista de ejercicios: `id`, `name`, `image`, `muscle_groups`, `equipment` |
| GET | `/api/v1/exercises/{id}/` | Detalle de un ejercicio; agrega `description` y `videos` |

Filtros de `/api/v1/exercises/` (combinables):

| Parámetro | Ejemplo | Descripción |
|---|---|---|
| `equipment` | `?equipment=3,5` | Ejercicios que usan cualquiera de esos aparatos |
| `muscle_group` | `?muscle_group=2,7` | Ejercicios que trabajan cualquiera de esos grupos |
| `search` | `?search=press` | Nombre contiene el texto (sin distinguir mayúsculas) |

Un id no numérico en `equipment` o `muscle_group` responde `400`.

## Frontend

| Ruta | Pantalla |
|---|---|
| `/ejercicios` | Catálogo con dos vistas: grupos musculares (`?vista=grupos`) o todos los ejercicios (`?vista=ejercicios`) |
| `/ejercicios/grupos/:id` | Ejercicios de un grupo muscular |
| `/ejercicios/:id` | Detalle del ejercicio: imagen, grupos, descripción y videos |
| `/rutinas`, `/entrenar`, `/historial` | Próximamente |

Videos: los enlaces de YouTube (`watch`, `shorts`, `youtu.be`) y los de TikTok con formato completo (`tiktok.com/@usuario/video/<id>`) se incrustan en la página. Cualquier otro enlace se muestra como un botón "Ver video" que abre una pestaña nueva.

## Mejoras futuras
- Implementar una fecha de creacion y última actualización en las tablas de equipo y ejercicios
- Hacer que los ejercicios tengan su nombre en inglés y en españo dentro de la base de datos
- Se puede plantear la idea de filtrar los ejercicios por equipo en la sección de Ejercicios
