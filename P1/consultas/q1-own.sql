CREATE OR REPLACE VIEW TEMP_1_2_DIV AS
  SELECT id
  FROM temporada
  WHERE (division = '1' OR division = '2') AND finalizada = '1';

--
-- Primera consulta nuestra
--
-- Descripción: Obtiene de cada temporada el equipo con mayor diferencia de goles y la diferencia de goles

-- Almacena la diferencia total de goles de cada equipo en cada temporada
-- de manera separada los partidos jugados fuera de casa y los jugados en casa
CREATE VIEW diferencia_de_goles_parcial AS
  (SELECT
    sum(GOLES_LOCAL - GOLES_VISITANTE) AS goles,
    IDTEMP,
    EQUIPO_LOCAL                       AS EQUI
  FROM PARTIDO
  GROUP BY IDTEMP, EQUIPO_LOCAL
  HAVING EXISTS(SELECT *
                FROM TEMP_1_2_DIV
                WHERE idTEMP = id))
  UNION ALL
  (SELECT
    sum(GOLES_VISITANTE - GOLES_LOCAL) AS goles,
    IDTEMP,
    EQUIPO_VISITANTE                   AS EQUI
  FROM PARTIDO
  GROUP BY IDTEMP, EQUIPO_VISITANTE
  HAVING EXISTS(SELECT *
                FROM TEMP_1_2_DIV
                WHERE idTEMP = id)
  );

-- Almacena la diferencia total de goles de cada equipo en cada temporada
CREATE VIEW diferencia_de_goles AS
  SELECT
    sum(goles) AS goles,
    IDTEMP,
    EQUI
  FROM diferencia_de_goles_parcial
  GROUP BY IDTEMP, EQUI;

-- Almacena la mayor diferencia de goles de algún equipo en cada temporada
CREATE VIEW max_diferencia_de_goles AS
  SELECT
    max(goles) AS max_diferencia,
    IDTEMP
  FROM diferencia_de_goles
  GROUP BY IDTEMP;

-- Almacena la mayor diferencia de goles de algún equipo en cada temporada, siendo expresada esta como un identificador
-- y el equipo que la produjo
CREATE VIEW equi_max_dif_de_goles_temp AS
  SELECT
    EQUI,
    max_diferencia_de_goles.max_diferencia AS diferencia,
    max_diferencia_de_goles.IDTEMP         AS temp
  FROM max_diferencia_de_goles, diferencia_de_goles
  WHERE max_diferencia_de_goles.IDTEMP = diferencia_de_goles.IDTEMP AND
        max_diferencia_de_goles.max_diferencia = diferencia_de_goles.goles;

-- Obtiene de cada temporada el equipo con mayor diferencia de goles y la diferencia de goles
SELECT
  TEMPORADA.ANYO,
  TEMPORADA.DIVISION,
  EQUI,
  diferencia
FROM equi_max_dif_de_goles_temp
  INNER JOIN TEMPORADA ON temp = TEMPORADA.ID;