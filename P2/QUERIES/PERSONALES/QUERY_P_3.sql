-- Tercera consulta personal: 	Obtiene la película con la saga mas larga , el nombre de las películas de la saga
--									y el número de películas que la componen

-- Esta view obtiene todas las precuelas y secuelas de cada película original

CREATE VIEW PELICULAS_SAGA AS
(
  SELECT PRECUELA AS PELICULAS_SAGA,ORIGINAL
  FROM ES_PRECUELA
)
UNION (
  SELECT SECUELA AS PELICULAS_SAGA,ORIGINAL
  FROM ES_SECUELA
);

-- Esta view obtiene la cuenta de precuelas y secuelas de cada película

CREATE VIEW NUM_PELIS_SAGA AS
	SELECT ORIGINAL, COUNT(PELICULAS_SAGA) AS NPELIS
	FROM peliculas_saga
	GROUP BY ORIGINAL;

-- Esta view obtiene la pelicula que mas precuelas/secuelas tiene así como su número

CREATE VIEW MAX_PELIS_SAGA AS
  SELECT MAX(NPELIS) AS NUMERO_PELICULAS
	FROM NUM_PELIS_SAGA;

CREATE VIEW PELI_MAX_SAGA AS
  SELECT original, NUMERO_PELICULAS
  FROM NUM_PELIS_SAGA
  INNER JOIN MAX_PELIS_SAGA ON NUM_PELIS_SAGA.NPELIS = MAX_PELIS_SAGA.NUMERO_PELICULAS;
	
-- Esta view añade a la película sus secuelas

CREATE VIEW SAGA_TOTAL AS
	SELECT PELI_MAX_SAGA.original, NUMERO_PELICULAS, PELICULAS_SAGA
	FROM PELI_MAX_SAGA
	INNER JOIN peliculas_saga ON PELI_MAX_SAGA.original = peliculas_saga.ORIGINAL;
	
-- Proyectamos el nombre de cada película y dejamos el número de películas de la saga
	
SELECT original, titulo, NUMERO_PELICULAS
	FROM SAGA_TOTAL
	INNER JOIN pelicula ON pelicula.id = PELICULAS_SAGA
