CREATE OR REPLACE VIEW TEMP_1_2_DIV AS
  SELECT id
  FROM temporada
  WHERE (division = '1' OR division = '2') AND finalizada = '1';
--
-- Segunda consulta
--

-- Esta view almacena los goles que ha marcado cada equipo en cada partido
CREATE VIEW equipos_goles_partido AS
  (SELECT
     goles_local  AS goles,
     idTemp       AS temporada_,
     equipo_local AS equipo_
   FROM partido
   WHERE EXISTS(SELECT *
                FROM TEMP_1_2_DIV
                WHERE idTEMP = id
   ))
  UNION ALL
  (SELECT
     goles_visitante  AS goles,
     idTemp           AS temporada_,
     equipo_visitante AS equipo_
   FROM partido
   WHERE EXISTS(SELECT *
                FROM TEMP_1_2_DIV
                WHERE idTEMP = id
   ));

-- Esta view almacena los equipos que han conseguido m�s de 3 goles en una temporada, y la temporada en la
-- que lo hizo representada esta como su identificador
CREATE VIEW mas_de_3_goles_temporada AS
  SELECT
    temporada_,
    equipo_
  FROM equipos_goles_partido
  GROUP BY (temporada_, equipo_)
  HAVING avg(goles) >= 3;

-- Esta view almacena los equipos que han conseguido m�s de 3 goles en una temporada, y la temporada en la
-- que lo hizo (Consulta 2)
SELECT
  TEMPORADA.ANYO,
  TEMPORADA.DIVISION,
  equipo_
FROM mas_de_3_goles_temporada
  INNER JOIN TEMPORADA ON temporada_ = TEMPORADA.ID;