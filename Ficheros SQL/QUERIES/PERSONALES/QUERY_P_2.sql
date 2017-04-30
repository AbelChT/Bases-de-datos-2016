CREATE VIEW seriesCaps AS
  SELECT COUNT(*) caps, serie FROM capitulos_serie GROUP BY serie;

CREATE VIEW maxCaps AS
  SELECT MAX(caps) totalCaps FROM seriesCaps;

SELECT (s.fin_de_emision - s.fecha_de_estreno) duracion, s.titulo
FROM serie s INNER JOIN seriesCaps cap
ON s.id = cap.serie WHERE cap.caps = (SELECT totalCaps FROM maxCaps);