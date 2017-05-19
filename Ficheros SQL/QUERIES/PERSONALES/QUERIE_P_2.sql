-- Modelo de avión que más distancia ha recorrido

-- Sumas parciales distancia recorrida en emergencia y en vuelo normal
CREATE VIEW DISTANCIA_AVION AS
(SELECT AVION,sum(DISTANCIA) AS DISTANCIA
FROM VUELO
GROUP BY AVION)
UNION ALL
(SELECT AVION, sum(DISTANCIA_ADICCIONAL) AS DISTANCIA
FROM ESCALAS_EMERGENCIAS
GROUP BY AVION);

-- Distancia recorrida por cada avion
CREATE VIEW DISTANCIA_AVION_SUM AS
SELECT avion,sum(distancia) AS distancia
FROM DISTANCIA_AVION
GROUP BY avion;

CREATE VIEW DISTANCIA_MODELO AS
SELECT  modelo, sum(distancia) AS distancia
FROM DISTANCIA_AVION_SUM
INNER JOIN AVION ON DISTANCIA_AVION_SUM.AVION=AVION.ID
GROUP BY modelo;

SELECT modelo
FROM DISTANCIA_MODELO
WHERE distancia IN (
  SELECT max(distancia) as maxima_distancia
  FROM DISTANCIA_MODELO
);




