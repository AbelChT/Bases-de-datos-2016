--Se cuenta el número total de películas
CREATE VIEW count_total_peliculas AS
SELECT count(*) AS total_peliculas
FROM PELICULA;

--Se cuenta el número total de películas con entre 5 y 10 actores
CREATE VIEW count_peliculas_5_10_actores AS
SELECT count(*) AS peliculas_5_10_actores
FROM NUM_ACTORES_PELICULA
WHERE NUM_ACTORES>=5 AND NUM_ACTORES<=10;

-- Se realiza la operación
-- ((películas con entre 5 y 10 actores)/ (total de películas)) * 100
SELECT (peliculas_5_10_actores/total_peliculas)*100 AS porcentaje
FROM count_total_peliculas,count_peliculas_5_10_actores;