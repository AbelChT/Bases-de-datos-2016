CREATE VIEW peliculasPorAnyo AS
SELECT d.persona dirID, p.fecha_de_estreno estreno, COUNT(*) peliculas FROM director_pelicula d INNER JOIN pelicula p
ON d.pelicula = p.id GROUP BY p.fecha_de_estreno, d.persona HAVING COUNT(*) >= 3 ORDER BY peliculas DESC;

SELECT director.nombre, estreno, peliculas FROM peliculasPorAnyo pelic INNER JOIN persona director ON director.id = pelic.dirID;