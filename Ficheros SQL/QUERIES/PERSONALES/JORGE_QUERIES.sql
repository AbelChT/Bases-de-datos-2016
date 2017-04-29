-- Tercera consulta obligatoria: 	Directores para los cuales la última obra en la que han participado ha sido como
-- 									actor/actriz

-- Esta view obtiene todas las películas de cada director así como su fecha de estreno necesario para 
-- posteriormente saber cual es su última película

CREATE VIEW PELICULAS_DIRECTOR AS
    SELECT persona as director, id, fecha_de_estreno
    FROM director_pelicula
    INNER JOIN pelicula ON director_pelicula.pelicula = pelicula.id;
	
-- Esta view obtiene la fecha de estreno de la última película de cada director a partir de la view anterior

CREATE VIEW DIR_ULTIMAS_PELICULAS AS
	SELECT PELICULAS_DIRECTOR.director, MAX(fecha_de_estreno) AS ultima_pelicula
	FROM PELICULAS_DIRECTOR
	GROUP BY PELICULAS_DIRECTOR.director;
	
-- Esta view asocia a cada director la última película que dirigió (la que coincide con la fecha de la view anterior=)

CREATE VIEW DIRECTOR_Y_PELICULA AS
	SELECT id, DIR_ULTIMAS_PELICULAS.director
	FROM DIR_ULTIMAS_PELICULAS
	INNER JOIN  PELICULAS_DIRECTOR ON 	DIR_ULTIMAS_PELICULAS.ultima_pelicula = PELICULAS_DIRECTOR.FECHA_DE_ESTRENO AND
										DIR_ULTIMAS_PELICULAS.director = PELICULAS_DIRECTOR.director;

-- Esta view obtiene los actores que coinciden con las últimas películas de cada director y que participan como directores

CREATE VIEW ACTORES_DIRECTORES AS
	SELECT DISTINCT ACTOR_PELICULA.persona AS actor,pelicula
	FROM actor_pelicula
	INNER JOIN  DIRECTOR_Y_PELICULA ON actor_pelicula.pelicula = DIRECTOR_Y_PELICULA.id AND
																			DIRECTOR_Y_PELICULA.director = ACTOR_PELICULA.PERSONA;
																			
-- Como resultado se muestra en esta view el nombre del actor/director																			


CREATE VIEW NOMBRE_DIRECTORES AS
	SELECT NOMBRE
	FROM PERSONA
	INNER JOIN ACTORES_DIRECTORES ON PERSONA.ID = ACTORES_DIRECTORES.actor;

											
-- Tercera consulta obligatoria: 	Obtiene la película con la saga mas larga (tanto anterior como posterior cuentan) 
--									y el número de películas que la sigen / preceden

-- Esta view obtiene todas las precuelas y secuelas de cada película original

CREATE VIEW peliculas_saga AS
(
  SELECT PRECUELA AS PELICULAS_SAGA,ORIGINAL
  FROM ES_PRECUELA
)
UNION (
  SELECT SECUELA AS PELICULAS_SAGA,ORIGINAL
  FROM ES_SECUELA
);

-- Esta view obtiene la cuenta de precuelas y secuelas

CREATE VIEW NUM_PELIS_SAGA AS
	SELECT ORIGINAL, COUNT(PELICULAS_SAGA) AS NPELIS
	  FROM peliculas_saga
	  GROUP BY ORIGINAL;

-- Como resultado obtenemos la pelicula que mas precuelas/secuelas tiene así como su número

CREATE VIEW SEG_CONSULTA AS
  SELECT ORIGINAL, MAX(NPELIS) AS NUMERO_PELICULAS
	  FROM NUM_PELIS_SAGA;
	

	
