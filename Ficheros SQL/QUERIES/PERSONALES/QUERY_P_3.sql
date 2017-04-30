-- Tercera consulta personal: 	Obtiene la película con la saga mas larga (tanto anterior como posterior cuentan) 
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

CREATE VIEW PRE_SEG_CONSULTA AS
  SELECT ORIGINAL, MAX(NPELIS) AS NUMERO_PELICULAS
	  FROM NUM_PELIS_SAGA;
	  
-- Asociamos al id de la consulta anterior el nombre de la película y lo proyectamos
-- junto al número de películas que componen la saga (sumándole uno por la original)
	  
CREATE VIEW SEGUNDA_CONSULTA AS
	SELECT TITULO, PRE_SEG_CONSULTA.NUMERO_PELICULAS+1
	FROM pelicula
	INNER JOIN PRE_SEG_CONSULTA ON PRE_SEG_CONSULTA.ORIGINAL = pelicula.id;
	