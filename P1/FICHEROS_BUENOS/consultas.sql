--
-- Común a varias consultas
--

-- En esta view se almacenarán las temporadas
-- que representen tanto la primera como la segunda división
-- de algún año, descartándose los ascensos y los descensos
CREATE VIEW TEMP_1_2_DIV AS
  SELECT id
  FROM temporada
  WHERE (division = '1' OR division = '2') AND finalizada = '1';

--
-- Primera consulta
--

-- Esta view almacena una fila por cada empate que haya tenido un equipo
CREATE VIEW empates AS
  -- Obtengo los empates que han sufrido los equipos jugando como locales
  (SELECT
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
  );

-- En esta view se almacena el total de empates que ha tenido cada equipo en cada temporada
-- y esta, representada con su identificador
CREATE VIEW TOTAL_EMPATES AS
  SELECT
    count(*) AS EMP,
    IDTEMP,
    EQUI
  FROM empates
  GROUP BY IDTEMP, EQUI;

-- Esta view almacena el mayor número de empates que se han obtenido en cada temporada
-- y esta, representada con su identificador
CREATE VIEW MAX_EMPATES_TEMPORADA AS
  SELECT
    max(EMP) AS EMPATES_TOTALES,
    IDTEMP
  FROM TOTAL_EMPATES
  GROUP BY IDTEMP;

-- Esta view almacena el mayor número de empates que se han obtenido en cada temporada
-- y esta, representada con su identificador y el equipo que lo ha logrado
CREATE VIEW EQUIPO_MAX_EMPATES_TEMPORADA AS
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

-- Esta view almacena los equipos que han conseguido más de 3 goles en una temporada, y la temporada en la
-- que lo hizo representada esta como su identificador
CREATE VIEW mas_de_3_goles_temporada AS
  SELECT
    temporada_,
    equipo_
  FROM equipos_goles_partido
  GROUP BY (temporada_, equipo_)
  HAVING avg(goles) >= 3;

-- Esta view almacena los equipos que han conseguido más de 3 goles en una temporada, y la temporada en la
-- que lo hizo (Consulta 2)
SELECT
  TEMPORADA.ANYO,
  TEMPORADA.DIVISION,
  equipo_
FROM mas_de_3_goles_temporada
  INNER JOIN TEMPORADA ON temporada_ = TEMPORADA.ID;

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

--
-- Primera consulta nuestra
--
-- Descripción: Obtiene de cada temporada el equipo con mayor diferencia de goles y la diferencia de goles

-- Almacena la diferencia total de goles de cada equipo en cada temporada
-- de manera separada los partidos jugados fuera de casa y los jugados en casa
CREATE VIEW diferencia_de_goles_parcial AS
  SELECT
    sum(GOLES_LOCAL - GOLES_VISITANTE) AS goles,
    IDTEMP,
    EQUIPO_LOCAL                       AS EQUI
  FROM PARTIDO
  GROUP BY IDTEMP, EQUIPO_LOCAL
  HAVING EXISTS(SELECT *
                FROM TEMP_1_2_DIV
                WHERE idTEMP = id)
  UNION ALL

  SELECT
    sum(GOLES_VISITANTE - GOLES_LOCAL) AS goles,
    IDTEMP,
    EQUIPO_VISITANTE                   AS EQUI
  FROM PARTIDO
  GROUP BY IDTEMP, EQUIPO_VISITANTE
  HAVING EXISTS(SELECT *
                FROM TEMP_1_2_DIV
                WHERE idTEMP = id);

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

---
--- Segunda consulta nuestra
---
-- Descripción: Devuelve los años en los que se ha marcado más goles en primera división que en segunda
-- y el número de goles de diferencia

--Almacena el número de goles marcados en cada partido
CREATE VIEW GOLES_POR_PARTIDO AS
  SELECT
    IDTEMP,
    (GOLES_VISITANTE + PARTIDO.GOLES_LOCAL) AS GOLES
  FROM PARTIDO
  WHERE EXISTS(SELECT *
               FROM TEMP_1_2_DIV
               WHERE idTEMP = id);

CREATE VIEW CORRESPONDENCIA_1_2 AS
  SELECT
    T1.ID AS ID_1,
    T2.ID AS ID_2
  FROM TEMPORADA T1
    INNER JOIN TEMPORADA T2 ON T1.ANYO = T2.ANYO AND
                               T1.DIVISION = '1' AND
                               T2.DIVISION = '2';

-- Cada fila corresponde a un año y en cada una se almacena el identificador de
-- la primera temporada correspondiente a ese año y el de la segunda
CREATE VIEW GOLES_POR_TEMPORADA AS
  SELECT
    IDTEMP,
    sum(GOLES) AS GOLES
  FROM GOLES_POR_PARTIDO
  GROUP BY (IDTEMP);

-- Devuelve los años en los que se ha marcado más goles en primera división que en segunda
-- y el número de goles de diferencia
SELECT
  TEMPORADA.ANYO        AS ANYO,
  (T1.GOLES - T2.GOLES) AS DIFERENCIA_GOLES
FROM GOLES_POR_TEMPORADA T1
  INNER JOIN GOLES_POR_TEMPORADA T2 ON T1.GOLES > T2.GOLES
  INNER JOIN CORRESPONDENCIA_1_2 C1 ON T1.IDTEMP = C1.ID_1 AND
                                       T2.IDTEMP = C1.ID_2
  INNER JOIN TEMPORADA ON T1.IDTEMP = TEMPORADA.ID;

---
--- Tercera consulta nuestra
---
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
