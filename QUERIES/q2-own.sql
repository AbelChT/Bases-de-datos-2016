CREATE OR REPLACE VIEW TEMP_1_2_DIV AS
  SELECT id
  FROM temporada
  WHERE (division = '1' OR division = '2') AND finalizada = '1';

--
-- Segunda consulta nuestra
--
-- Descripción: Devuelve los años en los que se ha marcado más goles en primera división que en segunda
-- y el número de goles de diferencia

-- Almacena el número de goles marcados en cada partido
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