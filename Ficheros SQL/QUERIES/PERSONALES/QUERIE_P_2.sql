
-- Sumas parciales distancia recorrida en emergencia y en vuelo normal

-- Distancia recorrida por cada avion

-- Consulta personal nº2
-- Descripción: Modelo de avión que más distancia ha recorrido

CREATE OR REPLACE VIEW DISTANCIA_MODELO AS
SELECT
   modelo,
   sum(distancia) AS distancia
FROM ( -- Sumas parciales distancia recorrida en emergencia y en vuelo normal
        (SELECT
             AVION,
             sum(DISTANCIA) AS DISTANCIA
           FROM VUELO
           GROUP BY AVION
         )
          UNION ALL
          (SELECT
             AVION,
             sum(DISTANCIA_ADICCIONAL) AS DISTANCIA
           FROM ESCALAS_EMERGENCIAS
           GROUP BY AVION)
    )
INNER JOIN AVION ON avion = AVION.ID
GROUP BY modelo
HAVING modelo IS NOT NULL;

SELECT
  MODELO_DE_AVION.NOMBRE,
  MODELO_DE_AVION.FABRICANTE,
  distancia
FROM DISTANCIA_MODELO
INNER JOIN (SELECT max(distancia) AS maxima_distancia
            FROM DISTANCIA_MODELO) ON DISTANCIA_MODELO.distancia = maxima_distancia
INNER JOIN MODELO_DE_AVION ON modelo = id;

DROP VIEW DISTANCIA_MODELO;
