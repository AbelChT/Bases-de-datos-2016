CREATE OR REPLACE VIEW TEMP_1_2_DIV AS
  SELECT id
  FROM temporada
  WHERE (division = '1' OR division = '2') AND finalizada = '1';

--
-- Tercera consulta
--

-- En esta view se almacenan las temporadas que corresponden a la primera división
CREATE VIEW TEMP_1_DIV AS
  SELECT id
  FROM temporada
  WHERE division = '1' AND finalizada = '1';

-- En esta view se almacenan todos los partidos ganados en primera división, su ganador y la temporada
CREATE VIEW PARTIDOS_GANADOS_1_DIV AS
  SELECT
    IDTEMP,
    EQUIPO_LOCAL AS EQUI
  FROM PARTIDO
  WHERE EXISTS(SELECT *
               FROM TEMP_1_DIV
               WHERE IDTEMP = ID) AND GOLES_LOCAL > GOLES_VISITANTE
  UNION ALL
  SELECT
    IDTEMP,
    EQUIPO_VISITANTE AS EQUI
  FROM PARTIDO
  WHERE EXISTS(SELECT *
               FROM TEMP_1_DIV
               WHERE IDTEMP = ID) AND GOLES_LOCAL < GOLES_VISITANTE;

-- En esta view se almacenan todos los partidos empatados en primera división, su ganador y la temporada
CREATE VIEW PARTIDOS_EMPATADOS_1_DIV AS
  SELECT
    IDTEMP,
    EQUIPO_LOCAL AS EQUI
  FROM PARTIDO
  WHERE EXISTS(SELECT *
               FROM TEMP_1_DIV
               WHERE IDTEMP = ID) AND GOLES_LOCAL = GOLES_VISITANTE
  UNION ALL
  SELECT
    IDTEMP,
    EQUIPO_VISITANTE AS EQUI
  FROM PARTIDO
  WHERE EXISTS(SELECT *
               FROM TEMP_1_DIV
               WHERE IDTEMP = ID) AND GOLES_LOCAL = GOLES_VISITANTE;

-- En esta view se almacenan los puntos que ha conseguido cada equipo tanto en empates como en victorias durante
-- una temporada, pero en un registro las victorias y en otro los empates
CREATE VIEW PUNTOS_EMPATES_VICT_1_DIV AS
  SELECT
    count(*) AS PUNTOS,
    IDTEMP,
    EQUI
  FROM PARTIDOS_EMPATADOS_1_DIV
  GROUP BY (idtemp, equi)
  UNION ALL
  SELECT
    3 * count(*) AS PUNTOS,
    IDTEMP,
    EQUI
  FROM PARTIDOS_GANADOS_1_DIV
  GROUP BY (idtemp, equi);

-- En esta view se almacena el total de puntos de cada equipo durante una temporada
CREATE VIEW PUNTOS_TEMPORADA AS
  SELECT
    sum(PUNTOS) AS PUNTOS,
    IDTEMP,
    EQUI
  FROM PUNTOS_EMPATES_VICT_1_DIV
  GROUP BY (IDTEMP, EQUI);

-- En esta view se almacena el máximo número de puntos conseguido por algán equipo durante cada
-- temporada
CREATE VIEW MAX_PUNTOS_TEMPORADA AS
  SELECT
    max(PUNTOS) AS PUNTOS,
    IDTEMP
  FROM PUNTOS_TEMPORADA
  GROUP BY (IDTEMP);

-- En esta view se almacenan los ganadores de cada temporada
CREATE VIEW GANADORES_TEMPORADAS AS
  SELECT
    EQUI,
    MAX_PUNTOS_TEMPORADA.IDTEMP AS temp,
    MAX_PUNTOS_TEMPORADA.PUNTOS AS PUNTOS
  FROM PUNTOS_TEMPORADA, MAX_PUNTOS_TEMPORADA
  WHERE PUNTOS_TEMPORADA.IDTEMP = MAX_PUNTOS_TEMPORADA.IDTEMP
        AND PUNTOS_TEMPORADA.PUNTOS = MAX_PUNTOS_TEMPORADA.PUNTOS;

-- En esta view se almacenan los equipos que han ganado alguna liga y el número de veces que lo
-- han hecho
CREATE VIEW PALMARES AS
  SELECT
    count(EQUI) AS TITULOS,
    EQUI
  FROM GANADORES_TEMPORADAS
  GROUP BY (EQUI)
  ORDER BY (TITULOS) DESC;

-- Devuelve los 3 equipos que más ligas han ganado y el número de estas que han ganado
SELECT *
FROM PALMARES
WHERE ROWNUM <= 3;