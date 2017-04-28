CREATE VIEW PELICULAS_DIRECTOR AS
    SELECT director, id_pelicula, fecha_de_estreno
    FROM director_pelicula
    INNER JOIN pelicula ON director_pelicula.pelicula = pelicula.id;

CREATE VIEW ULTIMAS_PELICULAS AS
	SELECT director, id_pelicula, MAX(fecha_de_estreno) AS ultima_pelicula FROM
	PELICULAS_DIRECTOR
	GROUP BY director, id_pelicula

CREATE VIEW DIRECTORES_ACTORES AS
	SELECT director AS director_actor FROM
	ULTIMAS_PELICULAS
	INNER JOIN actor_pelicula ON actor_pelicula.persona = DIRECTORES_ACTORES.director