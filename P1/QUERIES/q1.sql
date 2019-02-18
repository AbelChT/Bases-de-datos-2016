-- En esta view se almacenarán las temporadas
-- que representen tanto la primera como la segunda división
-- de algún año, descartándose los ascensos y los descensos
CREATE OR REPLACE VIEW TEMP_1_2_DIV AS
  SELECT id
  FROM temporada
  WHERE (division = '1' OR division = '2') AND finalizada = '1';

--
-- Primera consulta
--

-- Esta view almacena una fila por cada empate que haya tenido un equipo
CREATE OR REPLACE VIEW empates_v AS
  -- Obtengo los empates que han sufrido los equipos jugando como locales
  ((SELECT
     IDTEMP,
     EQUIPO_LOCAL AS EQUI
   FROM PARTIDO
   WHERE GOLES_LOCAL = GOLES_VISITANTE AND
         EXISTS(SELECT *
                FROM TEMP_1_2_DIV
                WHERE idTEMP = id)
  )
  UNION ALL
  (SELECT
     IDTEMP,
     EQUIPO_VISITANTE AS EQUI
   FROM PARTIDO
   WHERE GOLES_LOCAL = GOLES_VISITANTE AND
         EXISTS(SELECT *
                FROM TEMP_1_2_DIV
                WHERE idTEMP = id)
  ));

-- En esta view se almacena el total de empates que ha tenido cada equipo en cada temporada
-- y esta, representada con su identificador
CREATE OR REPLACE VIEW TOTAL_EMPATES AS
  SELECT
    count(*) AS EMP,
    IDTEMP,
    EQUI
  FROM empates_v
  GROUP BY IDTEMP, EQUI;

-- Esta view almacena el mayor número de empates que se han obtenido en cada temporada
-- y esta, representada con su identificador
CREATE OR REPLACE VIEW MAX_EMPATES_TEMPORADA AS
  SELECT
    max(EMP) AS EMPATES_TOTALES,
    IDTEMP
  FROM TOTAL_EMPATES
  GROUP BY IDTEMP;

-- Esta view almacena el mayor número de empates que se han obtenido en cada temporada
-- y esta, representada con su identificador y el equipo que lo ha logrado
CREATE OR REPLACE VIEW EQUIPO_MAX_EMPATES_TEMPORADA AS
  SELECT
    EQUI,
    TOTAL_EMPATES.IDTEMP                  AS temp,
    MAX_EMPATES_TEMPORADA.EMPATES_TOTALES AS num_empates
  FROM TOTAL_EMPATES, MAX_EMPATES_TEMPORADA
  WHERE
    MAX_EMPATES_TEMPORADA.IDTEMP = TOTAL_EMPATES.IDTEMP AND MAX_EMPATES_TEMPORADA.EMPATES_TOTALES = TOTAL_EMPATES.EMP;

-- Esta view almacena el mayor número de empates que se han obtenido en cada temporada y esta,
-- y el equipo que lo ha logrado ( Primera consulta ) ( Resultados comprobados )
SELECT
  TEMPORADA.ANYO,
  TEMPORADA.DIVISION,
  EQUI,
  num_empates
FROM EQUIPO_MAX_EMPATES_TEMPORADA
  INNER JOIN TEMPORADA ON temp = TEMPORADA.ID;