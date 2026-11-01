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


### Mejoras futuras
- Implementar una fecha de creacion y última actualización en las tablas de equipo y ejercicios
- Hacer que los ejercicios tengan su nombre en inglés y en españo dentro de la base de datos
