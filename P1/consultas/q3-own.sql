CREATE OR REPLACE VIEW TEMP_1_2_DIV AS
  SELECT id
  FROM temporada
  WHERE (division = '1' OR division = '2') AND finalizada = '1';

--
-- Tercera consulta nuestra
--
-- Obtiene los equipos que protagonizaron el mayor empate a puntos en primera división, así
-- como los puntos y la temporada donde ocurrió

-- Obtiene el número de equipos que tienen una misma puntuacion final en cada temporada
CREATE VIEW MISMA_PUNT_FINAL AS
  SELECT
    count(*) AS EQUIPOS_EMPATADOS,
    IDTEMP,
    PUNTOS
  FROM PUNTOS_TEMPORADA
  GROUP BY (IDTEMP, PUNTOS);

-- Obtiene el máximo numero de equipos que hayan empatado en alguna temporada
CREATE VIEW NUM_MAX_EQUIPOS_EMPATADOS AS
  SELECT max(EQUIPOS_EMPATADOS) AS NUM_EQUI
  FROM MISMA_PUNT_FINAL;

-- Obtiene la temporada y los puntos en los que se consiguó el máximo empate
CREATE VIEW MAX_EQUIPOS_TEMP_PUNT_EMP AS
  SELECT
    IDTEMP,
    PUNTOS
  FROM MISMA_PUNT_FINAL, NUM_MAX_EQUIPOS_EMPATADOS
  WHERE NUM_MAX_EQUIPOS_EMPATADOS.NUM_EQUI = EQUIPOS_EMPATADOS;

-- Obtiene los equipos la temporada, como un identificador y los puntos en los que se consiguó el máximo empate
CREATE VIEW EQUIPOSEMP_IDTEMP_PUNTOS AS
  SELECT
    PUNTOS_TEMPORADA.EQUI   AS EQUI,
    PUNTOS_TEMPORADA.IDTEMP AS IDTEMP,
    PUNTOS_TEMPORADA.PUNTOS AS PUNTOS
  FROM PUNTOS_TEMPORADA, MAX_EQUIPOS_TEMP_PUNT_EMP
  WHERE PUNTOS_TEMPORADA.IDTEMP = MAX_EQUIPOS_TEMP_PUNT_EMP.IDTEMP AND
        PUNTOS_TEMPORADA.PUNTOS = MAX_EQUIPOS_TEMP_PUNT_EMP.PUNTOS;

-- Obtiene los equipos la temporada y los puntos en los que se consiguó el máximo empate
SELECT
  TEMPORADA.ANYO,
  EQUI,
  PUNTOS
FROM EQUIPOSEMP_IDTEMP_PUNTOS
  INNER JOIN TEMPORADA ON EQUIPOSEMP_IDTEMP_PUNTOS.IDTEMP = TEMPORADA.ID;