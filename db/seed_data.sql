-- =====================================================================
-- Base de datos: Ejercicios Gym de Casa
-- Fuente: "Ejercicios GYM Casa 1.pdf"
-- Motor: PostgreSQL 13+
--
-- Solo datos. Las tablas las crea Django: `python manage.py migrate`.
-- Correr este script BORRA y vuelve a cargar el catálogo de ejercicios.
-- Usar solo en local; nunca en dev o prod.
-- =====================================================================

BEGIN;

-- Vacía las tablas del catálogo y reinicia los ids en 1.
-- No toca las tablas propias de Django (usuarios, sesiones, migraciones).
TRUNCATE exercise_video, exercise_equipment, exercise_musclegroup,
         exercise, equipment, muscle_group
RESTART IDENTITY;

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
    ('Barra', 'Barra recta para cargar discos'),
    ('Discos', 'Discos de peso para barra'),
    ('Mancuernas', 'Par de mancuernas'),
    ('Banco plano', 'Banco horizontal'),
    ('Banco ajustable', 'Banco con respaldo inclinable'),
    ('Banco predicador', 'Banco con soporte para apoyar el brazo (curl predicador)'),
    ('Barra de dominadas', 'Barra fija para colgarse'),
    ('Rack', 'Soporte para barra (sentadilla, press de banca, remo invertido)'),
    ('Polea', 'Máquina de poleas o cable'),
    ('Liga', 'Banda elástica de resistencia'),
    ('Peso corporal', 'Sin equipo adicional');

-- ---------------------------------------------------------------------
-- Ejercicios (cada uno una sola vez, aunque aparezca en varios grupos)
-- ---------------------------------------------------------------------

INSERT INTO exercise (name, description) VALUES
    ('Patada en polea', NULL),
    ('Abducción de cadera con polea', NULL),
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
    ('Peso muerto rumano con polea baja', 'Puede sentirse más en el glúteo, pero es más inestable que un peso muerto normal'),
    ('Jalones con polea baja (Pull through)', NULL),
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
    ('Curl con polea', NULL),
    ('Curl bayesiano', NULL),
    ('Elevaciones laterales', NULL),
    ('Elevaciones laterales inclinándose hacia adentro', NULL),
    ('Elevación lateral inclinada alejándose del cuerpo', NULL),
    ('Elevaciones laterales con polea', NULL),
    ('Elevaciones laterales con rango completo de movimiento', NULL),
    ('Press militar con barra', NULL),
    ('Press militar con mancuernas', NULL),
    ('Elevaciones laterales acostado estilo Arnold', NULL),
    ('Elevaciones frontales', NULL),
    ('Elevaciones frontales con polea', NULL),
    ('Pájaros con mancuernas inclinado hacia adelante', NULL),
    ('Remo vertical con polea', NULL),
    ('Jalón a la cara (Facepull)', 'Ayuda a mejorar la postura'),
    ('Cruce de polea hombro', NULL),
    ('Sentadilla con barra', NULL),
    ('Curl nórdico invertido', 'Se puede hacer con o sin peso; si no puedes bajar, puedes ayudarte de una liga para subir'),
    ('Sentadilla frontal con barra', NULL),
    ('Sentadilla con mancuerna', NULL),
    ('Extensión de tríceps con mancuerna sentado (por encima de la cabeza)', NULL),
    ('Extensión de tríceps con mancuerna a una mano', NULL),
    ('Press francés con barra', NULL),
    ('Press francés con mancuernas', NULL),
    ('JM press', NULL),
    ('Patada de mula con mancuerna', NULL),
    ('Fondos en banco para tríceps', NULL),
    ('Press de banca con agarre cerrado', NULL),
    ('Tríceps con polea alta', 'Se pueden usar otros agarres'),
    ('Extensión de tríceps con cable sobre la cabeza', 'Se puede usar el agarre de cuerda'),
    ('Extensión de tríceps katana', 'Se trabaja cada brazo individualmente, aunque se pueden hacer ambos al mismo tiempo'),
    ('Patada de mula para tríceps con polea alta', 'Se puede hacer inclinado o parado'),
    ('Pullover con mancuerna', NULL),
    ('Press de banca', NULL),
    ('Press de banca inclinado', NULL),
    ('Press plano con mancuernas', NULL),
    ('Press de banca inclinado con mancuernas', NULL),
    ('Press guillotina con mancuerna', 'A diferencia del press con mancuerna normal, al bajar las mancuernas van a la altura de la garganta'),
    ('Aperturas con mancuerna en banco plano', NULL),
    ('Press de banca en piso', NULL),
    ('Lagartijas (flexiones)', NULL),
    ('Cruce de poleas', NULL),
    ('Cruce de poleas sentado', 'Es más estable que su variación de pie'),
    ('Press around', 'Trabaja el pectoral más contraído, por lo que puede ser interesante hacerlo de vez en cuando'),
    ('Dominadas con agarre prono', NULL),
    ('Remo con barra (espalda a 45°)', NULL),
    ('Remo Yates (espalda a ~30°)', NULL),
    ('Remo Pendlay (espalda paralela al suelo)', NULL),
    ('Remo Pendlay con déficit', 'Igual que el remo Pendlay, pero se añade un disco o un banco para ganar altura antes de iniciar el ejercicio'),
    ('Remo invertido', NULL),
    ('Remo con mancuerna a una mano', NULL),
    ('Remo con mancuernas con soporte en pecho', NULL),
    ('Jalón unilateral con polea', 'Permite trabajar un lado a la vez y da estabilidad para un mejor progreso'),
    ('Jalón unilateral con polea cruzada', 'Se hace a 90 grados de la máquina y permite mayor estiramiento'),
    ('Pullover con polea', 'Es mejor con altas repeticiones; se requiere práctica para enfocar la espalda');

-- ---------------------------------------------------------------------
-- Ejercicio <-> grupo muscular
-- ---------------------------------------------------------------------

INSERT INTO exercise_musclegroup (exercise_id, muscle_group_id)
SELECT e.id, m.id
FROM (VALUES
    ('Patada en polea', 'Glúteos'),
    ('Abducción de cadera con polea', 'Glúteos'),
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
    ('Peso muerto rumano con polea baja', 'Glúteos'),
    ('Jalones con polea baja (Pull through)', 'Glúteos'),
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
    ('Curl con polea', 'Bíceps'),
    ('Curl bayesiano', 'Bíceps'),
    ('Elevaciones laterales', 'Hombros'),
    ('Elevaciones laterales inclinándose hacia adentro', 'Hombros'),
    ('Elevación lateral inclinada alejándose del cuerpo', 'Hombros'),
    ('Elevaciones laterales con polea', 'Hombros'),
    ('Elevaciones laterales con rango completo de movimiento', 'Hombros'),
    ('Press militar con barra', 'Hombros'),
    ('Press militar con mancuernas', 'Hombros'),
    ('Elevaciones laterales acostado estilo Arnold', 'Hombros'),
    ('Elevaciones frontales', 'Hombros'),
    ('Elevaciones frontales con polea', 'Hombros'),
    ('Pájaros con mancuernas inclinado hacia adelante', 'Hombros'),
    ('Remo vertical con polea', 'Hombros'),
    ('Jalón a la cara (Facepull)', 'Hombros'),
    ('Cruce de polea hombro', 'Hombros'),
    ('Sentadilla búlgara', 'Cuadríceps'),
    ('Step up (subida a un banco)', 'Cuadríceps'),
    ('Zancada con peso', 'Cuadríceps'),
    ('Peso muerto convencional', 'Cuadríceps'),
    ('Peso muerto sumo', 'Cuadríceps'),
    ('Sentadilla con barra', 'Cuadríceps'),
    ('Curl nórdico invertido', 'Cuadríceps'),
    ('Sentadilla frontal con barra', 'Cuadríceps'),
    ('Sentadilla con mancuerna', 'Cuadríceps'),
    ('Extensión de tríceps con mancuerna sentado (por encima de la cabeza)', 'Tríceps'),
    ('Extensión de tríceps con mancuerna a una mano', 'Tríceps'),
    ('Press francés con barra', 'Tríceps'),
    ('Press francés con mancuernas', 'Tríceps'),
    ('JM press', 'Tríceps'),
    ('Patada de mula con mancuerna', 'Tríceps'),
    ('Fondos en banco para tríceps', 'Tríceps'),
    ('Press de banca con agarre cerrado', 'Tríceps'),
    ('Tríceps con polea alta', 'Tríceps'),
    ('Extensión de tríceps con cable sobre la cabeza', 'Tríceps'),
    ('Extensión de tríceps katana', 'Tríceps'),
    ('Patada de mula para tríceps con polea alta', 'Tríceps'),
    ('Pullover con mancuerna', 'Pectorales'),
    ('Press de banca', 'Pectorales'),
    ('Press de banca inclinado', 'Pectorales'),
    ('Press plano con mancuernas', 'Pectorales'),
    ('Press de banca inclinado con mancuernas', 'Pectorales'),
    ('Press guillotina con mancuerna', 'Pectorales'),
    ('Aperturas con mancuerna en banco plano', 'Pectorales'),
    ('Press de banca en piso', 'Pectorales'),
    ('Lagartijas (flexiones)', 'Pectorales'),
    ('Cruce de poleas', 'Pectorales'),
    ('Cruce de poleas sentado', 'Pectorales'),
    ('Press around', 'Pectorales'),
    ('Dominadas con agarre supino', 'Espalda'),
    ('Jalón a la cara (Facepull)', 'Espalda'),
    ('Pullover con mancuerna', 'Espalda'),
    ('Dominadas con agarre prono', 'Espalda'),
    ('Remo con barra (espalda a 45°)', 'Espalda'),
    ('Remo Yates (espalda a ~30°)', 'Espalda'),
    ('Remo Pendlay (espalda paralela al suelo)', 'Espalda'),
    ('Remo Pendlay con déficit', 'Espalda'),
    ('Remo invertido', 'Espalda'),
    ('Remo con mancuerna a una mano', 'Espalda'),
    ('Remo con mancuernas con soporte en pecho', 'Espalda'),
    ('Jalón unilateral con polea', 'Espalda'),
    ('Jalón unilateral con polea cruzada', 'Espalda'),
    ('Pullover con polea', 'Espalda')
) AS v(exercise, muscle_group)
JOIN exercise     e ON e.name = v.exercise
JOIN muscle_group m ON m.name = v.muscle_group;

-- ---------------------------------------------------------------------
-- Videos (un ejercicio puede tener varios)
-- ---------------------------------------------------------------------

INSERT INTO exercise_video (exercise_id, url)
SELECT e.id, v.url
FROM (VALUES
    ('Patada en polea', 'https://www.youtube.com/shorts/B9Fqo0KqeWc'),
    ('Patada en polea', 'https://www.youtube.com/shorts/BNOfVprH6DI'),
    ('Abducción de cadera con polea', 'https://www.youtube.com/shorts/1lnTMSjC13Y'),
    ('Glute Bridge (Puente de glúteo)', 'https://www.youtube.com/shorts/Cxp6D7LEqjM'),
    ('Frog Pumps (Bombas de rana)', 'https://www.youtube.com/watch?v=9NscenzL0vk'),
    ('Sentadilla profunda', 'https://www.youtube.com/watch?v=I0qy4Sat4kw'),
    ('Sentadilla búlgara', 'https://www.youtube.com/shorts/5gRn1lr8vYk'),
    ('Step up (subida a un banco)', 'https://www.youtube.com/shorts/fQbLxZB6y2U'),
    ('Step up (subida a un banco)', 'https://www.youtube.com/shorts/zQ1Iw9EuKYs'),
    ('Zancada con peso', 'https://www.youtube.com/shorts/a4_Vw2P-3qQ'),
    ('Zancadas cruzadas', 'https://www.youtube.com/shorts/OxUzbavy7oA'),
    ('Peso muerto convencional', 'https://www.youtube.com/shorts/3EhkrUEEPOg'),
    ('Peso muerto sumo', 'https://www.youtube.com/shorts/YE7rtn57tP4'),
    ('Peso muerto rumano', 'https://www.youtube.com/shorts/BSLuRD7fZwc'),
    ('Peso muerto rumano con polea baja', 'https://www.youtube.com/shorts/xhz912iXiX0'),
    ('Jalones con polea baja (Pull through)', 'https://www.youtube.com/shorts/rsM_ZZPl2uk'),
    ('Jalones con polea baja (Pull through)', 'https://www.youtube.com/shorts/M6rEyyD8UU8'),
    ('Curl con barra (agarre supino)', 'https://www.youtube.com/shorts/iNXa8JIzUSo'),
    ('Curl con mancuernas', 'https://www.youtube.com/shorts/LQcQNJiVY24'),
    ('Curl predicador con mancuerna', 'https://www.youtube.com/shorts/3MxHAEW18-c'),
    ('Curl inclinado', 'https://www.youtube.com/shorts/PIOttZxDUpw'),
    ('Curl mancuerna acostado', 'https://www.youtube.com/shorts/EoZEByj_8wk'),
    ('Curl en banco plano', 'https://vt.tiktok.com/ZShnvCJU1/'),
    ('Dominadas con agarre supino', 'https://www.youtube.com/shorts/ZYuK-R-y5iA'),
    ('Dominadas con agarre supino', 'https://www.youtube.com/shorts/DbGmb272M8A'),
    ('21s', 'https://www.youtube.com/shorts/7MBlGMKsNeU'),
    ('Curl martillo (agarre neutro)', 'https://www.youtube.com/shorts/1pTUHKXGaSs'),
    ('Curl Zottman', 'https://www.youtube.com/shorts/CEEU1Fau228'),
    ('Curl con polea', 'https://www.youtube.com/shorts/CrbTqNOlFgE'),
    ('Curl bayesiano', 'https://www.youtube.com/shorts/J_-lkeKmHB8'),
    ('Elevaciones laterales', 'https://www.youtube.com/shorts/zBqZqAjCnR4'),
    ('Elevaciones laterales inclinándose hacia adentro', 'https://www.youtube.com/shorts/nxT4Jj6M0fI'),
    ('Elevación lateral inclinada alejándose del cuerpo', 'https://www.youtube.com/shorts/OF9g4TRUPGw'),
    ('Elevaciones laterales con polea', 'https://www.youtube.com/shorts/SBAAdAoo8NM'),
    ('Elevaciones laterales con rango completo de movimiento', 'https://www.youtube.com/shorts/aikdxby_D3A'),
    ('Press militar con barra', 'https://www.youtube.com/shorts/jpi8pC95ubY'),
    ('Press militar con mancuernas', 'https://www.youtube.com/shorts/CpvyRFjbgow'),
    ('Elevaciones laterales acostado estilo Arnold', 'https://www.youtube.com/shorts/APZj2RYTqeQ'),
    ('Elevaciones frontales', 'https://www.youtube.com/shorts/jk7YrK79ciA'),
    ('Elevaciones frontales con polea', 'https://www.youtube.com/shorts/Y6jokLRar68'),
    ('Pájaros con mancuernas inclinado hacia adelante', 'https://www.youtube.com/shorts/nO-JNf2b3s8'),
    ('Remo vertical con polea', 'https://www.youtube.com/shorts/3-t4x2mrQw8'),
    ('Jalón a la cara (Facepull)', 'https://www.youtube.com/shorts/CkIoZeOKfPw'),
    ('Jalón a la cara (Facepull)', 'https://www.youtube.com/shorts/Ue0xtLb_kvM'),
    ('Cruce de polea hombro', 'https://www.youtube.com/shorts/4g54Ial_I08'),
    ('Sentadilla con barra', 'https://www.youtube.com/shorts/Ur-zj6AiO44'),
    ('Curl nórdico invertido', 'https://www.youtube.com/shorts/zndfr6WydX0'),
    ('Sentadilla frontal con barra', 'https://www.youtube.com/shorts/nOilmCM2TPI'),
    ('Sentadilla con mancuerna', 'https://www.youtube.com/shorts/d_8xKB8qYVg'),
    ('Extensión de tríceps con mancuerna sentado (por encima de la cabeza)', 'https://www.youtube.com/shorts/z4dTmGzJVG0'),
    ('Extensión de tríceps con mancuerna a una mano', 'https://www.youtube.com/shorts/eGI2k3DasHI'),
    ('Press francés con barra', 'https://www.youtube.com/shorts/emnTk9VixDA'),
    ('Press francés con mancuernas', 'https://www.youtube.com/shorts/DFFD1LU_iXw'),
    ('JM press', 'https://www.youtube.com/shorts/jYlviyc6-vw'),
    ('Patada de mula con mancuerna', 'https://www.youtube.com/shorts/sYk-67UhxJk'),
    ('Fondos en banco para tríceps', 'https://www.youtube.com/shorts/hVwojhhQhj4'),
    ('Press de banca con agarre cerrado', 'https://www.youtube.com/shorts/kCuB4PfbMPg'),
    ('Tríceps con polea alta', 'https://www.youtube.com/shorts/4NWWB0f0vzQ'),
    ('Extensión de tríceps con cable sobre la cabeza', 'https://www.youtube.com/shorts/9Ark9S11uXw'),
    ('Extensión de tríceps katana', 'https://www.youtube.com/shorts/I7dhWD2xt3A'),
    ('Extensión de tríceps katana', 'https://www.youtube.com/shorts/Hgk2HinXMSc'),
    ('Patada de mula para tríceps con polea alta', 'https://www.youtube.com/shorts/YebyKE3Ts8o'),
    ('Pullover con mancuerna', 'https://www.youtube.com/shorts/X0qV-Gs69MM'),
    ('Pullover con mancuerna', 'https://www.youtube.com/shorts/w1h4Fu_DRAg'),
    ('Press de banca', 'https://www.youtube.com/shorts/nZXbeBS-Zm0'),
    ('Press de banca inclinado', 'https://www.youtube.com/shorts/SqT0lZDPm-Y'),
    ('Press plano con mancuernas', 'https://www.youtube.com/shorts/48L0oQApm_0'),
    ('Press de banca inclinado con mancuernas', 'https://www.youtube.com/shorts/SUDic00idNo'),
    ('Press guillotina con mancuerna', 'https://www.youtube.com/shorts/LVr6CDJNSCo'),
    ('Aperturas con mancuerna en banco plano', 'https://www.youtube.com/shorts/OWsPTRX7GK0'),
    ('Press de banca en piso', 'https://www.youtube.com/shorts/HqOwEHFlrO0'),
    ('Lagartijas (flexiones)', 'https://www.youtube.com/shorts/SKX9JimnGpg'),
    ('Cruce de poleas', 'https://www.youtube.com/shorts/QEW6RO0O-ak'),
    ('Cruce de poleas sentado', 'https://www.youtube.com/shorts/D3IJDJdfPMU'),
    ('Press around', 'https://www.youtube.com/shorts/iskGojEE0Hg'),
    ('Dominadas con agarre prono', 'https://www.youtube.com/shorts/6E3tt4ajzSs'),
    ('Remo con barra (espalda a 45°)', 'https://www.youtube.com/shorts/sr_U0jBE89A'),
    ('Remo Yates (espalda a ~30°)', 'https://www.youtube.com/shorts/eeZ59A0qmtk'),
    ('Remo Pendlay (espalda paralela al suelo)', 'https://www.youtube.com/shorts/lnpCptq2k1I'),
    ('Remo Pendlay con déficit', 'https://www.youtube.com/shorts/lnpCptq2k1I'),
    ('Remo invertido', 'https://www.youtube.com/shorts/TMCAdemQICk'),
    ('Remo con mancuerna a una mano', 'https://www.youtube.com/shorts/N_KrUuUsg9k'),
    ('Remo con mancuernas con soporte en pecho', 'https://www.youtube.com/shorts/wbk4CmTb7lY'),
    ('Jalón unilateral con polea', 'https://www.youtube.com/shorts/L3isMvyckQU'),
    ('Jalón unilateral con polea cruzada', 'https://www.youtube.com/shorts/arUvkxSNOy8'),
    ('Pullover con polea', 'https://www.youtube.com/shorts/Vce6ta2xs9Q')
) AS v(exercise, url)
JOIN exercise e ON e.name = v.exercise;

-- ---------------------------------------------------------------------
-- Ejercicio <-> equipo (inferido de las imágenes)
-- ---------------------------------------------------------------------

INSERT INTO exercise_equipment (exercise_id, equipment_id)
SELECT e.id, q.id
FROM (VALUES
    ('Patada en polea', ARRAY['Polea']),
    ('Abducción de cadera con polea', ARRAY['Polea']),
    ('Glute Bridge (Puente de glúteo)', ARRAY['Barra', 'Discos']),
    ('Frog Pumps (Bombas de rana)', ARRAY['Mancuernas']),
    ('Sentadilla profunda', ARRAY['Barra', 'Discos', 'Rack']),
    ('Sentadilla búlgara', ARRAY['Mancuernas', 'Banco plano']),
    ('Step up (subida a un banco)', ARRAY['Mancuernas', 'Banco plano']),
    ('Zancada con peso', ARRAY['Mancuernas']),
    ('Zancadas cruzadas', ARRAY['Peso corporal']),
    ('Peso muerto convencional', ARRAY['Barra', 'Discos']),
    ('Peso muerto sumo', ARRAY['Barra', 'Discos']),
    ('Peso muerto rumano', ARRAY['Barra', 'Discos']),
    ('Peso muerto rumano con polea baja', ARRAY['Polea']),
    ('Jalones con polea baja (Pull through)', ARRAY['Polea']),
    ('Curl con barra (agarre supino)', ARRAY['Barra', 'Discos']),
    ('Curl con mancuernas', ARRAY['Mancuernas']),
    ('Curl predicador con mancuerna', ARRAY['Mancuernas', 'Banco predicador']),
    ('Curl inclinado', ARRAY['Mancuernas', 'Banco ajustable']),
    ('Curl mancuerna acostado', ARRAY['Mancuernas', 'Banco plano']),
    ('Curl en banco plano', ARRAY['Mancuernas', 'Banco plano']),
    ('Dominadas con agarre supino', ARRAY['Barra de dominadas']),
    ('21s', ARRAY['Barra', 'Discos']),
    ('Curl martillo (agarre neutro)', ARRAY['Mancuernas']),
    ('Curl Zottman', ARRAY['Mancuernas']),
    ('Curl con polea', ARRAY['Polea']),
    ('Curl bayesiano', ARRAY['Polea']),
    ('Elevaciones laterales', ARRAY['Mancuernas']),
    ('Elevaciones laterales inclinándose hacia adentro', ARRAY['Mancuernas']),
    ('Elevación lateral inclinada alejándose del cuerpo', ARRAY['Mancuernas']),
    ('Elevaciones laterales con polea', ARRAY['Polea']),
    ('Elevaciones laterales con rango completo de movimiento', ARRAY['Mancuernas']),
    ('Press militar con barra', ARRAY['Barra', 'Discos']),
    ('Press militar con mancuernas', ARRAY['Mancuernas', 'Banco ajustable']),
    ('Elevaciones laterales acostado estilo Arnold', ARRAY['Mancuernas', 'Banco ajustable']),
    ('Elevaciones frontales', ARRAY['Mancuernas']),
    ('Elevaciones frontales con polea', ARRAY['Polea']),
    ('Pájaros con mancuernas inclinado hacia adelante', ARRAY['Mancuernas']),
    ('Remo vertical con polea', ARRAY['Polea']),
    ('Jalón a la cara (Facepull)', ARRAY['Polea']),
    ('Cruce de polea hombro', ARRAY['Polea']),
    ('Sentadilla con barra', ARRAY['Barra', 'Discos', 'Rack']),
    ('Curl nórdico invertido', ARRAY['Peso corporal', 'Liga']),
    ('Sentadilla frontal con barra', ARRAY['Barra', 'Discos', 'Rack']),
    ('Sentadilla con mancuerna', ARRAY['Mancuernas']),
    ('Extensión de tríceps con mancuerna sentado (por encima de la cabeza)', ARRAY['Mancuernas', 'Banco plano']),
    ('Extensión de tríceps con mancuerna a una mano', ARRAY['Mancuernas', 'Banco plano']),
    ('Press francés con barra', ARRAY['Barra', 'Discos', 'Banco plano']),
    ('Press francés con mancuernas', ARRAY['Mancuernas', 'Banco plano']),
    ('JM press', ARRAY['Barra', 'Discos', 'Banco plano', 'Rack']),
    ('Patada de mula con mancuerna', ARRAY['Mancuernas', 'Banco plano']),
    ('Fondos en banco para tríceps', ARRAY['Banco plano']),
    ('Press de banca con agarre cerrado', ARRAY['Barra', 'Discos', 'Banco plano', 'Rack']),
    ('Tríceps con polea alta', ARRAY['Polea']),
    ('Extensión de tríceps con cable sobre la cabeza', ARRAY['Polea']),
    ('Extensión de tríceps katana', ARRAY['Polea']),
    ('Patada de mula para tríceps con polea alta', ARRAY['Polea']),
    ('Pullover con mancuerna', ARRAY['Mancuernas', 'Banco plano']),
    ('Press de banca', ARRAY['Barra', 'Discos', 'Banco plano', 'Rack']),
    ('Press de banca inclinado', ARRAY['Barra', 'Discos', 'Banco ajustable', 'Rack']),
    ('Press plano con mancuernas', ARRAY['Mancuernas', 'Banco plano']),
    ('Press de banca inclinado con mancuernas', ARRAY['Mancuernas', 'Banco ajustable']),
    ('Press guillotina con mancuerna', ARRAY['Mancuernas', 'Banco plano']),
    ('Aperturas con mancuerna en banco plano', ARRAY['Mancuernas', 'Banco plano']),
    ('Press de banca en piso', ARRAY['Barra', 'Discos', 'Rack']),
    ('Lagartijas (flexiones)', ARRAY['Peso corporal']),
    ('Cruce de poleas', ARRAY['Polea']),
    ('Cruce de poleas sentado', ARRAY['Polea', 'Banco plano']),
    ('Press around', ARRAY['Polea']),
    ('Dominadas con agarre prono', ARRAY['Barra de dominadas']),
    ('Remo con barra (espalda a 45°)', ARRAY['Barra', 'Discos']),
    ('Remo Yates (espalda a ~30°)', ARRAY['Barra', 'Discos']),
    ('Remo Pendlay (espalda paralela al suelo)', ARRAY['Barra', 'Discos']),
    ('Remo Pendlay con déficit', ARRAY['Barra', 'Discos']),
    ('Remo invertido', ARRAY['Barra', 'Rack']),
    ('Remo con mancuerna a una mano', ARRAY['Mancuernas', 'Banco plano']),
    ('Remo con mancuernas con soporte en pecho', ARRAY['Mancuernas', 'Banco ajustable']),
    ('Jalón unilateral con polea', ARRAY['Polea']),
    ('Jalón unilateral con polea cruzada', ARRAY['Polea']),
    ('Pullover con polea', ARRAY['Polea'])
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