-- 2) Directores que han dirigido 3 o más películas el mismo año ordenados de más a menos películas dirigidas en total y el año en cuestión


--
-- La view selecciona el id de los directores, qué año y el número de películas que ha estrenado en ese año, si ese número es mayor a 3.
--
CREATE VIEW peliculasPorAnyo AS
SELECT d.persona dirID, p.fecha_de_estreno estreno, COUNT(*) peliculas FROM director_pelicula d INNER JOIN pelicula p
ON d.pelicula = p.id GROUP BY p.fecha_de_estreno, d.persona HAVING COUNT(*) >= 3 ORDER BY peliculas DESC;


--
-- Muestra el nombre del director, qué año y el número de películas que ha estrenado ese año, si ese número es mayor a 3.
--
SELECT director.nombre, estreno, peliculas FROM peliculasPorAnyo pelic INNER JOIN persona director ON director.id = pelic.dirID;