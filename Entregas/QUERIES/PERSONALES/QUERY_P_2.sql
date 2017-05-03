-- 2) Título y duración de la(s) serie(s) con más capítulos.

--
-- La view seriesCaps selecciona cuantos capítulos tiene cada serie.
--
CREATE VIEW seriesCaps AS
  SELECT COUNT(*) caps, serie FROM capitulos_serie GROUP BY serie;

--
-- La view maxCaps selecciona cual ha sido el mayor número de capítulos que han tenido las series.
--
CREATE VIEW maxCaps AS
  SELECT MAX(caps) totalCaps FROM seriesCaps;

  
--
-- Esta consulta muestra la duración en años y el título de las series con más capítulos.
--
SELECT (s.fin_de_emision - s.fecha_de_estreno) duracion, s.titulo
FROM serie s INNER JOIN seriesCaps cap
ON s.id = cap.serie WHERE cap.caps = (SELECT totalCaps FROM maxCaps);