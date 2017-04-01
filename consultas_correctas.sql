--
-- Común a varias consultas
--

-- En esta view se almacenarán las temporadas
-- que representen tanto la primera como la segunda división
-- de algún año, descartándose los ascensos y los descensos
CREATE VIEW TEMP_1_2_DIV AS
  SELECT id
  FROM temporada
  WHERE division = '1' OR division = '2';

--
-- Primera consulta
--

-- Esta view almacena una fila por cada empate que haya tenido un equipo
CREATE VIEW empates AS
  -- Obtengo los empates que han sufrido los equipos jugando como locales
  (SELECT IDTEMP,EQUIPO_LOCAL AS EQUI
  FROM PARTIDO
  WHERE GOLES_LOCAL = GOLES_VISITANTE AND
        EXISTS(SELECT *
               FROM TEMP_1_2_DIV
               WHERE idTEMP = id)
  )

  UNION ALL

  (SELECT IDTEMP,EQUIPO_VISITANTE AS EQUI
  FROM PARTIDO
  WHERE GOLES_LOCAL = GOLES_VISITANTE AND
        EXISTS(SELECT *
               FROM TEMP_1_2_DIV
               WHERE idTEMP = id)
  );

-- En esta view se almacena el total de empates que ha tenido cada equipo en cada temporada
-- y esta, representada con su identificador
CREATE VIEW TOTAL_EMPATES AS
  SELECT count(*) AS EMP ,IDTEMP,EQUI
  FROM empates
  GROUP BY IDTEMP,EQUI;

-- Esta view almacena el mayor número de empates que se han obtenido en cada temporada
-- y esta, representada con su identificador
CREATE VIEW MAX_EMPATES_TEMPORADA AS
  SELECT max(EMP) AS EMPATES_TOTALES,IDTEMP
  FROM TOTAL_EMPATES
  GROUP BY IDTEMP;

-- Esta view almacena el mayor número de empates que se han obtenido en cada temporada
-- y esta, representada con su identificador y el equipo que lo ha logrado
CREATE VIEW EQUIPO_MAX_EMPATES_TEMPORADA AS
  SELECT EQUI , TOTAL_EMPATES.IDTEMP AS temp , MAX_EMPATES_TEMPORADA.EMPATES_TOTALES AS num_empates
  FROM TOTAL_EMPATES,MAX_EMPATES_TEMPORADA
  WHERE MAX_EMPATES_TEMPORADA.IDTEMP=TOTAL_EMPATES.IDTEMP AND MAX_EMPATES_TEMPORADA.EMPATES_TOTALES=TOTAL_EMPATES.EMP;

-- Esta view almacena el mayor número de empates que se han obtenido en cada temporada y esta,
-- y el equipo que lo ha logrado ( Primera consulta ) ( Resultados comprobados )
SELECT TEMPORADA.ANYO, TEMPORADA.DIVISION , EQUI,num_empates
FROM  EQUIPO_MAX_EMPATES_TEMPORADA
INNER JOIN TEMPORADA ON temp=TEMPORADA.ID;

--
-- Segunda consulta
--

-- Esta view almacena los goles que ha marcado cada equipo en cada partido
CREATE VIEW equipos_goles_partido AS
  (SELECT goles_local AS goles, idTemp AS temporada_,equipo_local AS equipo_
    FROM partido
    WHERE EXISTS(SELECT *
                 FROM TEMP_1_2_DIV
                 WHERE idTEMP = id
    ))

  UNION ALL

  (SELECT goles_visitante AS goles, idTemp AS temporada_,equipo_visitante AS equipo_
    FROM partido
    WHERE EXISTS(SELECT *
                 FROM TEMP_1_2_DIV
                 WHERE idTEMP = id
    ));

-- Esta view almacena los equipos que han conseguido más de 3 goles en una temporada, y la temporada en la
-- que lo hizo representada esta como su identificador
CREATE VIEW mas_de_3_goles_temporada AS
  SELECT temporada_,equipo_
  FROM equipos_goles_partido
  GROUP BY (temporada_,equipo_)
  HAVING avg(goles) > 3;

-- Esta view almacena los equipos que han conseguido más de 3 goles en una temporada, y la temporada en la
-- que lo hizo (Consulta 2)
SELECT TEMPORADA.ANYO, TEMPORADA.DIVISION , equipo_
FROM  mas_de_3_goles_temporada
INNER JOIN TEMPORADA ON temporada_=TEMPORADA.ID;


--
-- Primera consulta nuestra
--
-- Obtiene de cada temporada el equipo con mayor diferencia de goles y la diferencia de goles

-- Almacena la diferencia total de goles de cada equipo en cada temporada
-- de manera separada los partidos jugados fuera de casa y los jugados en casa
CREATE VIEW diferencia_de_goles_parcial AS
  SELECT sum(GOLES_LOCAL-GOLES_VISITANTE) AS goles, IDTEMP, EQUIPO_LOCAL AS EQUI
  FROM PARTIDO
  GROUP BY IDTEMP, EQUIPO_LOCAL
  HAVING EXISTS(SELECT *
                 FROM TEMP_1_2_DIV
                 WHERE idTEMP = id)
  UNION ALL

  SELECT sum(GOLES_VISITANTE-GOLES_LOCAL) AS goles, IDTEMP, EQUIPO_VISITANTE AS EQUI
  FROM PARTIDO
  GROUP BY IDTEMP, EQUIPO_VISITANTE
  HAVING EXISTS(SELECT *
                 FROM TEMP_1_2_DIV
                 WHERE idTEMP = id)
;

-- Almacena la diferencia total de goles de cada equipo en cada temporada
CREATE VIEW diferencia_de_goles AS
  SELECT sum(goles) AS goles, IDTEMP , EQUI
  FROM diferencia_de_goles_parcial
  GROUP BY IDTEMP, EQUI;

-- Almacena la mayor diferencia de goles de algún equipo en cada temporada
CREATE VIEW max_diferencia_de_goles AS
  SELECT max(goles) AS max_diferencia, IDTEMP
  FROM diferencia_de_goles
  GROUP BY IDTEMP;

-- Almacena la mayor diferencia de goles de algún equipo en cada temporada, siendo expresada esta como un identificador
-- y el equipo que la produjo
CREATE VIEW equi_max_dif_de_goles_temp AS
SELECT EQUI, max_diferencia_de_goles.max_diferencia AS diferencia , max_diferencia_de_goles.IDTEMP AS temp
FROM max_diferencia_de_goles,diferencia_de_goles
WHERE max_diferencia_de_goles.IDTEMP=diferencia_de_goles.IDTEMP AND
      max_diferencia_de_goles.max_diferencia=diferencia_de_goles.goles
;

-- Obtiene de cada temporada el equipo con mayor diferencia de goles y la diferencia de goles
SELECT TEMPORADA.ANYO, TEMPORADA.DIVISION , EQUI,diferencia
FROM  equi_max_dif_de_goles_temp
INNER JOIN TEMPORADA ON temp=TEMPORADA.ID;