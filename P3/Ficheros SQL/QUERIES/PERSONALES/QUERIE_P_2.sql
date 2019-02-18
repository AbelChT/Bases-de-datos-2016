-- Consulta personal nº2
-- Descripción: Devuelve el modelo de avión que más distancia ha recorrido así como esta distancia

CREATE OR REPLACE VIEW distancia_modelo AS
SELECT -- distancia recorrida por cada modelo de avión
   modelo,
   SUM(distancia) AS distancia
FROM ( -- Sumas parciales distancia recorrida en emergencia y en vuelo normal
        (SELECT
             AVION,
             SUM(distancia) AS distancia
           FROM vuelo
           GROUP BY avion
         )
          UNION ALL
          (SELECT
             avion,
             SUM(distancia_adiccional) AS distancia
           FROM escalas_emergencias
           GROUP BY avion)
    )
INNER JOIN avion ON avion = avion.id
GROUP BY modelo
HAVING modelo IS NOT NULL;

SELECT
  modelo_de_avion.nombre,
  modelo_de_avion.fabricante,
  distancia
FROM distancia_modelo
INNER JOIN (SELECT MAX(distancia) AS maxima_distancia -- se obtiene la mayor deistancia recorrida por un modelo
            FROM distancia_modelo) ON distancia_modelo.distancia = maxima_distancia -- se obtiene el modelo asociado
INNER JOIN modelo_de_avion ON modelo = id;-- se obtiene el nombre y fabricante del modelo

DROP VIEW distancia_modelo;
