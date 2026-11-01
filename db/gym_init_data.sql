-- =====================================================================
-- Base de datos: Ejercicios Gym de Casa
-- Fuente: "Ejercicios GYM Casa 1.pdf"
-- Motor: PostgreSQL 13+
-- =====================================================================

BEGIN;

DROP TABLE IF EXISTS exercise_video;
DROP TABLE IF EXISTS exercise_equipment;
DROP TABLE IF EXISTS exercise_musclegroup;
DROP TABLE IF EXISTS exercise;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS muscle_group;

-- ---------------------------------------------------------------------
-- Esquema
-- ---------------------------------------------------------------------

CREATE TABLE muscle_group (
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE equipment (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    image      TEXT          -- ruta o URL de la imagen (ej: 'img/equipment/mancuernas.jpg')
);

CREATE TABLE exercise (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    image      TEXT          -- ruta o URL de la imagen
);

-- Un ejercicio puede tener varios videos (relación 1 a N)
CREATE TABLE exercise_video (
    id          SERIAL PRIMARY KEY,
    exercise_id INT  NOT NULL REFERENCES exercise(id) ON DELETE CASCADE,
    url         TEXT NOT NULL,
    UNIQUE (exercise_id, url)
);

-- Relación muchos a muchos ejercicio <-> grupo muscular
CREATE TABLE exercise_musclegroup (
    id              SERIAL PRIMARY KEY,
    exercise_id     INT NOT NULL REFERENCES exercise(id) ON DELETE CASCADE,
    muscle_group_id INT NOT NULL REFERENCES muscle_group(id) ON DELETE CASCADE,
    UNIQUE (exercise_id, muscle_group_id)
);

-- Relación muchos a muchos ejercicio <-> equipo
CREATE TABLE exercise_equipment (
    id           SERIAL PRIMARY KEY,
    exercise_id  INT NOT NULL REFERENCES exercise(id) ON DELETE CASCADE,
    equipment_id INT NOT NULL REFERENCES equipment(id) ON DELETE CASCADE,
    UNIQUE (exercise_id, equipment_id)
);

CREATE INDEX idx_emg_muscle_group ON exercise_musclegroup(muscle_group_id);
CREATE INDEX idx_ee_equipment     ON exercise_equipment(equipment_id);
CREATE INDEX idx_ev_exercise      ON exercise_video(exercise_id);

-- ---------------------------------------------------------------------
-- Grupos musculares (Abdomen, Isquiotibiales y Gemelos aún sin ejercicios)
-- ---------------------------------------------------------------------

INSERT INTO muscle_group (name) VALUES
    ('Glúteos'),
    ('Bíceps'),
    ('Hombros'),
    ('Cuadríceps'),
    ('Tríceps'),
    ('Pectorales'),
    ('Espalda'),
    ('Abdomen'),
    ('Isquiotibiales'),
    ('Gemelos');

-- ---------------------------------------------------------------------
-- Equipo (inferido de las imágenes del documento)
-- ---------------------------------------------------------------------

INSERT INTO equipment (name, description) VALUES
    ('Barra',              'Barra recta para cargar discos'),
    ('Discos',             'Discos de peso para barra'),
    ('Mancuernas',         'Par de mancuernas'),
    ('Banco plano',        'Banco horizontal'),
    ('Banco ajustable',    'Banco con respaldo inclinable'),
    ('Banco predicador',   'Banco con soporte para apoyar el brazo (curl predicador)'),
    ('Barra de dominadas', 'Barra fija para colgarse'),
    ('Rack',               'Soporte para barra (sentadilla, press de banca, remo invertido)'),
    ('Peso corporal',      'Sin equipo adicional');

-- ---------------------------------------------------------------------
-- Ejercicios (cada uno una sola vez, aunque aparezca en varios grupos)
-- ---------------------------------------------------------------------

INSERT INTO exercise (name, description) VALUES
    -- Glúteos
    ('Hip Thrust', NULL),
    ('Hip Thrust a una pierna con mancuerna', NULL),
    ('Glute Bridge (Puente de glúteo)', NULL),
    ('Frog Pumps (Bombas de rana)', NULL),
    ('Sentadilla profunda', NULL),
    ('Sentadilla búlgara', NULL),
    ('Step up (subida a un banco)', NULL),
    ('Zancada con peso', NULL),
    ('Zancadas cruzadas', NULL),
    ('Peso muerto convencional', NULL),
    ('Peso muerto sumo', NULL),
    ('Peso muerto rumano', NULL),
    -- Bíceps
    ('Curl con barra (agarre supino)', NULL),
    ('Curl con mancuernas', 'Dependiendo del agarre se activan más distintas partes, aunque en todas se activa todo el bíceps'),
    ('Curl predicador con mancuerna', NULL),
    ('Curl inclinado', NULL),
    ('Curl mancuerna acostado', NULL),
    ('Curl en banco plano', NULL),
    ('Dominadas con agarre supino', NULL),
    ('21s', '7 repeticiones de media subida desde abajo, 7 completas y 7 de media subida desde arriba'),
    ('Curl martillo (agarre neutro)', NULL),
    ('Curl Zottman', NULL),
    -- Hombros
    ('Elevaciones laterales', NULL),
    ('Elevaciones laterales inclinándose hacia adentro', NULL),
    ('Elevación lateral inclinada alejándose del cuerpo', NULL),
    ('Elevaciones laterales con rango completo de movimiento', NULL),
    ('Press militar con barra', NULL),
    ('Press militar con mancuernas', NULL),
    ('Elevaciones laterales acostado estilo Arnold', NULL),
    ('Elevaciones frontales', NULL),
    ('Pájaros con mancuernas inclinado hacia adelante', NULL),
    -- Cuadríceps
    ('Sentadilla con barra', NULL),
    ('Sentadilla frontal con barra', NULL),
    ('Sentadilla con mancuerna', NULL),
    -- Tríceps
    ('Extensión de tríceps con mancuerna sentado (por encima de la cabeza)', NULL),
    ('Extensión de tríceps con mancuerna a una mano', NULL),
    ('Press francés con barra', NULL),
    ('Press francés con mancuernas', NULL),
    ('JM press', NULL),
    ('Patada de mula con mancuerna', NULL),
    ('Fondos en banco para tríceps', NULL),
    ('Press de banca con agarre cerrado', NULL),
    -- Pectorales
    ('Pullover con mancuerna', NULL),
    ('Press de banca', NULL),
    ('Press de banca inclinado', NULL),
    ('Press plano con mancuernas', NULL),
    ('Press de banca inclinado con mancuernas', NULL),
    ('Press guillotina con mancuerna', 'A diferencia del press con mancuerna normal, al bajar las mancuernas van a la altura de la garganta'),
    ('Aperturas con mancuerna en banco plano', NULL),
    ('Press de banca en piso', NULL),
    ('Lagartijas (flexiones)', NULL),
    -- Espalda
    ('Dominadas con agarre prono', NULL),
    ('Remo con barra (espalda a 45°)', NULL),
    ('Remo Yates (espalda a ~30°)', NULL),
    ('Remo Pendlay (espalda paralela al suelo)', NULL),
    ('Remo Pendlay con déficit', 'Igual que el remo Pendlay, pero se añade un disco o un banco para ganar altura antes de iniciar el ejercicio'),
    ('Remo invertido', NULL),
    ('Remo con mancuerna a una mano', NULL),
    ('Remo con mancuernas con soporte en pecho', NULL);

-- ---------------------------------------------------------------------
-- Ejercicio <-> grupo muscular
-- ---------------------------------------------------------------------

INSERT INTO exercise_musclegroup (exercise_id, muscle_group_id)
SELECT e.id, m.id
FROM (VALUES
    ('Hip Thrust', 'Glúteos'),
    ('Hip Thrust a una pierna con mancuerna', 'Glúteos'),
    ('Glute Bridge (Puente de glúteo)', 'Glúteos'),
    ('Frog Pumps (Bombas de rana)', 'Glúteos'),
    ('Sentadilla profunda', 'Glúteos'),
    ('Sentadilla búlgara', 'Glúteos'),
    ('Step up (subida a un banco)', 'Glúteos'),
    ('Zancada con peso', 'Glúteos'),
    ('Zancadas cruzadas', 'Glúteos'),
    ('Peso muerto convencional', 'Glúteos'),
    ('Peso muerto sumo', 'Glúteos'),
    ('Peso muerto rumano', 'Glúteos'),
    ('Curl con barra (agarre supino)', 'Bíceps'),
    ('Curl con mancuernas', 'Bíceps'),
    ('Curl predicador con mancuerna', 'Bíceps'),
    ('Curl inclinado', 'Bíceps'),
    ('Curl mancuerna acostado', 'Bíceps'),
    ('Curl en banco plano', 'Bíceps'),
    ('Dominadas con agarre supino', 'Bíceps'),
    ('21s', 'Bíceps'),
    ('Curl martillo (agarre neutro)', 'Bíceps'),
    ('Curl Zottman', 'Bíceps'),
    ('Elevaciones laterales', 'Hombros'),
    ('Elevaciones laterales inclinándose hacia adentro', 'Hombros'),
    ('Elevación lateral inclinada alejándose del cuerpo', 'Hombros'),
    ('Elevaciones laterales con rango completo de movimiento', 'Hombros'),
    ('Press militar con barra', 'Hombros'),
    ('Press militar con mancuernas', 'Hombros'),
    ('Elevaciones laterales acostado estilo Arnold', 'Hombros'),
    ('Elevaciones frontales', 'Hombros'),
    ('Pájaros con mancuernas inclinado hacia adelante', 'Hombros'),
    ('Sentadilla con barra', 'Cuadríceps'),
    ('Sentadilla frontal con barra', 'Cuadríceps'),
    ('Zancada con peso', 'Cuadríceps'),
    ('Sentadilla con mancuerna', 'Cuadríceps'),
    ('Sentadilla búlgara', 'Cuadríceps'),
    ('Peso muerto convencional', 'Cuadríceps'),
    ('Peso muerto sumo', 'Cuadríceps'),
    ('Step up (subida a un banco)', 'Cuadríceps'),
    ('Extensión de tríceps con mancuerna sentado (por encima de la cabeza)', 'Tríceps'),
    ('Extensión de tríceps con mancuerna a una mano', 'Tríceps'),
    ('Press francés con barra', 'Tríceps'),
    ('Press francés con mancuernas', 'Tríceps'),
    ('JM press', 'Tríceps'),
    ('Patada de mula con mancuerna', 'Tríceps'),
    ('Fondos en banco para tríceps', 'Tríceps'),
    ('Press de banca con agarre cerrado', 'Tríceps'),
    ('Pullover con mancuerna', 'Pectorales'),
    ('Press de banca', 'Pectorales'),
    ('Press de banca inclinado', 'Pectorales'),
    ('Press plano con mancuernas', 'Pectorales'),
    ('Press de banca inclinado con mancuernas', 'Pectorales'),
    ('Press guillotina con mancuerna', 'Pectorales'),
    ('Aperturas con mancuerna en banco plano', 'Pectorales'),
    ('Press de banca en piso', 'Pectorales'),
    ('Lagartijas (flexiones)', 'Pectorales'),
    ('Dominadas con agarre prono', 'Espalda'),
    ('Dominadas con agarre supino', 'Espalda'),
    ('Remo con barra (espalda a 45°)', 'Espalda'),
    ('Remo Yates (espalda a ~30°)', 'Espalda'),
    ('Remo Pendlay (espalda paralela al suelo)', 'Espalda'),
    ('Remo Pendlay con déficit', 'Espalda'),
    ('Remo invertido', 'Espalda'),
    ('Remo con mancuerna a una mano', 'Espalda'),
    ('Remo con mancuernas con soporte en pecho', 'Espalda'),
    ('Pullover con mancuerna', 'Espalda')
) AS v(exercise, muscle_group)
JOIN exercise     e ON e.name = v.exercise
JOIN muscle_group m ON m.name = v.muscle_group;

-- ---------------------------------------------------------------------
-- Videos (un ejercicio puede tener varios)
-- ---------------------------------------------------------------------

INSERT INTO exercise_video (exercise_id, url)
SELECT e.id, v.url
FROM (VALUES
    ('Hip Thrust', 'https://www.youtube.com/shorts/eecT-JzxxVE'),
    ('Hip Thrust a una pierna con mancuerna', 'https://www.youtube.com/watch?v=DFIVNdnVrEk'),
    ('Glute Bridge (Puente de glúteo)', 'https://www.youtube.com/shorts/Cxp6D7LEqjM'),
    ('Frog Pumps (Bombas de rana)', 'https://www.youtube.com/watch?v=9NscenzL0vk'),
    ('Sentadilla profunda', 'https://www.youtube.com/watch?v=I0qy4Sat4kw'),
    ('Sentadilla búlgara', 'https://www.youtube.com/shorts/5gRn1lr8vYk'),
    ('Step up (subida a un banco)', 'https://www.youtube.com/shorts/fQbLxZB6y2U'),
    ('Zancada con peso', 'https://www.youtube.com/shorts/a4_Vw2P-3qQ'),
    ('Zancadas cruzadas', 'https://www.youtube.com/shorts/OxUzbavy7oA'),
    ('Peso muerto convencional', 'https://www.youtube.com/shorts/3EhkrUEEPOg'),
    ('Peso muerto sumo', 'https://www.youtube.com/shorts/YE7rtn57tP4'),
    ('Peso muerto rumano', 'https://www.youtube.com/shorts/BSLuRD7fZwc'),
    ('Curl con barra (agarre supino)', 'https://www.youtube.com/shorts/iNXa8JIzUSo'),
    ('Curl con mancuernas', 'https://www.youtube.com/shorts/LQcQNJiVY24'),
    ('Curl predicador con mancuerna', 'https://www.youtube.com/shorts/3MxHAEW18-c'),
    ('Curl inclinado', 'https://www.youtube.com/shorts/PIOttZxDUpw'),
    ('Curl mancuerna acostado', 'https://www.youtube.com/shorts/EoZEByj_8wk'),
    ('Curl en banco plano', 'https://vt.tiktok.com/ZShnvCJU1/'),
    ('Dominadas con agarre supino', 'https://www.youtube.com/shorts/ZYuK-R-y5iA'),
    ('21s', 'https://www.youtube.com/shorts/7MBlGMKsNeU'),
    ('Curl martillo (agarre neutro)', 'https://www.youtube.com/shorts/1pTUHKXGaSs'),
    ('Curl Zottman', 'https://www.youtube.com/shorts/CEEU1Fau228'),
    ('Elevaciones laterales', 'https://www.youtube.com/shorts/zBqZqAjCnR4'),
    ('Elevaciones laterales inclinándose hacia adentro', 'https://www.youtube.com/shorts/nxT4Jj6M0fI'),
    ('Elevación lateral inclinada alejándose del cuerpo', 'https://www.youtube.com/shorts/OF9g4TRUPGw'),
    ('Elevaciones laterales con rango completo de movimiento', 'https://www.youtube.com/shorts/aikdxby_D3A'),
    ('Press militar con barra', 'https://www.youtube.com/shorts/jpi8pC95ubY'),
    ('Press militar con mancuernas', 'https://www.youtube.com/shorts/CpvyRFjbgow'),
    ('Elevaciones laterales acostado estilo Arnold', 'https://www.youtube.com/shorts/APZj2RYTqeQ'),
    ('Elevaciones frontales', 'https://www.youtube.com/shorts/jk7YrK79ciA'),
    ('Pájaros con mancuernas inclinado hacia adelante', 'https://www.youtube.com/shorts/nO-JNf2b3s8'),
    ('Sentadilla con barra', 'https://www.youtube.com/shorts/Ur-zj6AiO44'),
    ('Sentadilla frontal con barra', 'https://www.youtube.com/shorts/nOilmCM2TPI'),
    ('Sentadilla con mancuerna', 'https://www.youtube.com/shorts/d_8xKB8qYVg'),
    ('Step up (subida a un banco)', 'https://www.youtube.com/shorts/zQ1Iw9EuKYs'),
    ('Extensión de tríceps con mancuerna sentado (por encima de la cabeza)', 'https://www.youtube.com/shorts/z4dTmGzJVG0'),
    ('Extensión de tríceps con mancuerna a una mano', 'https://www.youtube.com/shorts/eGI2k3DasHI'),
    ('Press francés con barra', 'https://www.youtube.com/shorts/emnTk9VixDA'),
    ('Press francés con mancuernas', 'https://www.youtube.com/shorts/DFFD1LU_iXw'),
    ('JM press', 'https://www.youtube.com/shorts/jYlviyc6-vw'),
    ('Patada de mula con mancuerna', 'https://www.youtube.com/shorts/sYk-67UhxJk'),
    ('Fondos en banco para tríceps', 'https://www.youtube.com/shorts/hVwojhhQhj4'),
    ('Press de banca con agarre cerrado', 'https://www.youtube.com/shorts/kCuB4PfbMPg'),
    ('Pullover con mancuerna', 'https://www.youtube.com/shorts/X0qV-Gs69MM'),
    ('Press de banca', 'https://www.youtube.com/shorts/nZXbeBS-Zm0'),
    ('Press de banca inclinado', 'https://www.youtube.com/shorts/SqT0lZDPm-Y'),
    ('Press plano con mancuernas', 'https://www.youtube.com/shorts/48L0oQApm_0'),
    ('Press de banca inclinado con mancuernas', 'https://www.youtube.com/shorts/SUDic00idNo'),
    ('Press guillotina con mancuerna', 'https://www.youtube.com/shorts/LVr6CDJNSCo'),
    ('Aperturas con mancuerna en banco plano', 'https://www.youtube.com/shorts/OWsPTRX7GK0'),
    ('Press de banca en piso', 'https://www.youtube.com/shorts/HqOwEHFlrO0'),
    ('Lagartijas (flexiones)', 'https://www.youtube.com/shorts/SKX9JimnGpg'),
    ('Dominadas con agarre prono', 'https://www.youtube.com/shorts/6E3tt4ajzSs'),
    ('Dominadas con agarre supino', 'https://www.youtube.com/shorts/DbGmb272M8A'),
    ('Remo con barra (espalda a 45°)', 'https://www.youtube.com/shorts/sr_U0jBE89A'),
    ('Remo Yates (espalda a ~30°)', 'https://www.youtube.com/shorts/eeZ59A0qmtk'),
    ('Remo Pendlay (espalda paralela al suelo)', 'https://www.youtube.com/shorts/lnpCptq2k1I'),
    ('Remo Pendlay con déficit', 'https://www.youtube.com/shorts/lnpCptq2k1I'),
    ('Remo invertido', 'https://www.youtube.com/shorts/TMCAdemQICk'),
    ('Remo con mancuerna a una mano', 'https://www.youtube.com/shorts/N_KrUuUsg9k'),
    ('Remo con mancuernas con soporte en pecho', 'https://www.youtube.com/shorts/wbk4CmTb7lY'),
    ('Pullover con mancuerna', 'https://www.youtube.com/shorts/w1h4Fu_DRAg')
) AS v(exercise, url)
JOIN exercise e ON e.name = v.exercise;

-- ---------------------------------------------------------------------
-- Ejercicio <-> equipo (inferido de las imágenes)
-- ---------------------------------------------------------------------

INSERT INTO exercise_equipment (exercise_id, equipment_id)
SELECT e.id, q.id
FROM (VALUES
    ('Hip Thrust', ARRAY['Barra','Discos','Banco plano']),
    ('Hip Thrust a una pierna con mancuerna', ARRAY['Mancuernas','Banco plano']),
    ('Glute Bridge (Puente de glúteo)', ARRAY['Barra','Discos']),
    ('Frog Pumps (Bombas de rana)', ARRAY['Mancuernas']),
    ('Sentadilla profunda', ARRAY['Barra','Discos','Rack']),
    ('Sentadilla búlgara', ARRAY['Mancuernas','Banco plano']),
    ('Step up (subida a un banco)', ARRAY['Mancuernas','Banco plano']),
    ('Zancada con peso', ARRAY['Mancuernas']),
    ('Zancadas cruzadas', ARRAY['Peso corporal']),
    ('Peso muerto convencional', ARRAY['Barra','Discos']),
    ('Peso muerto sumo', ARRAY['Barra','Discos']),
    ('Peso muerto rumano', ARRAY['Barra','Discos']),
    ('Curl con barra (agarre supino)', ARRAY['Barra','Discos']),
    ('Curl con mancuernas', ARRAY['Mancuernas']),
    ('Curl predicador con mancuerna', ARRAY['Mancuernas','Banco predicador']),
    ('Curl inclinado', ARRAY['Mancuernas','Banco ajustable']),
    ('Curl mancuerna acostado', ARRAY['Mancuernas','Banco plano']),
    ('Curl en banco plano', ARRAY['Mancuernas','Banco plano']),
    ('Dominadas con agarre supino', ARRAY['Barra de dominadas']),
    ('21s', ARRAY['Barra','Discos']),
    ('Curl martillo (agarre neutro)', ARRAY['Mancuernas']),
    ('Curl Zottman', ARRAY['Mancuernas']),
    ('Elevaciones laterales', ARRAY['Mancuernas']),
    ('Elevaciones laterales inclinándose hacia adentro', ARRAY['Mancuernas']),
    ('Elevación lateral inclinada alejándose del cuerpo', ARRAY['Mancuernas']),
    ('Elevaciones laterales con rango completo de movimiento', ARRAY['Mancuernas']),
    ('Press militar con barra', ARRAY['Barra','Discos']),
    ('Press militar con mancuernas', ARRAY['Mancuernas','Banco ajustable']),
    ('Elevaciones laterales acostado estilo Arnold', ARRAY['Mancuernas','Banco ajustable']),
    ('Elevaciones frontales', ARRAY['Mancuernas']),
    ('Pájaros con mancuernas inclinado hacia adelante', ARRAY['Mancuernas']),
    ('Sentadilla con barra', ARRAY['Barra','Discos','Rack']),
    ('Sentadilla frontal con barra', ARRAY['Barra','Discos','Rack']),
    ('Sentadilla con mancuerna', ARRAY['Mancuernas']),
    ('Extensión de tríceps con mancuerna sentado (por encima de la cabeza)', ARRAY['Mancuernas','Banco plano']),
    ('Extensión de tríceps con mancuerna a una mano', ARRAY['Mancuernas','Banco plano']),
    ('Press francés con barra', ARRAY['Barra','Discos','Banco plano']),
    ('Press francés con mancuernas', ARRAY['Mancuernas','Banco plano']),
    ('JM press', ARRAY['Barra','Discos','Banco plano','Rack']),
    ('Patada de mula con mancuerna', ARRAY['Mancuernas','Banco plano']),
    ('Fondos en banco para tríceps', ARRAY['Banco plano']),
    ('Press de banca con agarre cerrado', ARRAY['Barra','Discos','Banco plano','Rack']),
    ('Pullover con mancuerna', ARRAY['Mancuernas','Banco plano']),
    ('Press de banca', ARRAY['Barra','Discos','Banco plano','Rack']),
    ('Press de banca inclinado', ARRAY['Barra','Discos','Banco ajustable','Rack']),
    ('Press plano con mancuernas', ARRAY['Mancuernas','Banco plano']),
    ('Press de banca inclinado con mancuernas', ARRAY['Mancuernas','Banco ajustable']),
    ('Press guillotina con mancuerna', ARRAY['Mancuernas','Banco plano']),
    ('Aperturas con mancuerna en banco plano', ARRAY['Mancuernas','Banco plano']),
    ('Press de banca en piso', ARRAY['Barra','Discos','Rack']),
    ('Lagartijas (flexiones)', ARRAY['Peso corporal']),
    ('Dominadas con agarre prono', ARRAY['Barra de dominadas']),
    ('Remo con barra (espalda a 45°)', ARRAY['Barra','Discos']),
    ('Remo Yates (espalda a ~30°)', ARRAY['Barra','Discos']),
    ('Remo Pendlay (espalda paralela al suelo)', ARRAY['Barra','Discos']),
    ('Remo Pendlay con déficit', ARRAY['Barra','Discos']),
    ('Remo invertido', ARRAY['Barra','Rack']),
    ('Remo con mancuerna a una mano', ARRAY['Mancuernas','Banco plano']),
    ('Remo con mancuernas con soporte en pecho', ARRAY['Mancuernas','Banco ajustable'])
) AS v(exercise, equip_list)
JOIN exercise  e ON e.name = v.exercise
CROSS JOIN LATERAL unnest(v.equip_list) AS eq(name)
JOIN equipment q ON q.name = eq.name;

COMMIT;

-- ---------------------------------------------------------------------
-- Consultas de ejemplo
-- ---------------------------------------------------------------------

-- Ejercicios de un grupo con sus videos
-- SELECT e.name, string_agg(v.url, ' , ') AS videos
-- FROM exercise_musclegroup emg
-- JOIN exercise e        ON e.id = emg.exercise_id
-- JOIN muscle_group m    ON m.id = emg.muscle_group_id
-- LEFT JOIN exercise_video v ON v.exercise_id = e.id
-- WHERE m.name = 'Glúteos'
-- GROUP BY e.name;

-- Ejercicios que trabajan más de un grupo
-- SELECT e.name, string_agg(m.name, ', ') AS grupos
-- FROM exercise_musclegroup emg
-- JOIN exercise e     ON e.id = emg.exercise_id
-- JOIN muscle_group m ON m.id = emg.muscle_group_id
-- GROUP BY e.name
-- HAVING count(*) > 1;

-- Qué puedo hacer solo con mancuernas y banco plano
-- SELECT e.name
-- FROM exercise e
-- JOIN exercise_equipment ee ON ee.exercise_id = e.id
-- JOIN equipment q           ON q.id = ee.equipment_id
-- GROUP BY e.name
-- HAVING bool_and(q.name IN ('Mancuernas', 'Banco plano'));
