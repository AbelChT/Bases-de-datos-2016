-- Nombre: Consulta personal nº1
-- Descripción: Obtiene los actores y actrices que han participado en al menos la mitad de las películas
-- de la saga a la que pertenece la película "La maldición de la bestia"

CREATE VIEW peliculas_saga AS -- El union garantiza resultados no repetidos
( -- Obtengo las precuelas de la pelicula
  SELECT PRECUELA AS PELICULAS_SAGA
  FROM ES_PRECUELA
  INNER JOIN PELICULA ON ES_PRECUELA.ORIGINAL = PELICULA.ID AND PELICULA.TITULO = 'La maldición de la bestia'
)
UNION (  -- Obtengo las secuelas de la pelicula
  SELECT SECUELA AS PELICULAS_SAGA
  FROM ES_SECUELA
  INNER JOIN PELICULA ON ES_SECUELA.ORIGINAL = PELICULA.ID AND PELICULA.TITULO = 'La maldición de la bestia'
)
UNION ( -- Obtengo el id de la pelicula
  SELECT ID AS PELICULAS_SAGA
  FROM PELICULA
  WHERE TITULO = 'La maldición de la bestia'
)
;

CREATE VIEW actores_saga AS
SELECT PERSONA
FROM ACTOR_PELICULA
WHERE PELICULA IN( SELECT *
                   FROM peliculas_saga);

CREATE VIEW act_al_menos_mitad_pel AS
SELECT PERSONA
FROM actores_saga
GROUP BY PERSONA
HAVING count(*) >= ((SELECT count(*)
                  FROM peliculas_saga) / 2);

SELECT NOMBRE
FROM act_al_menos_mitad_pel
INNER JOIN PERSONA ON PERSONA.ID=act_al_menos_mitad_pel.PERSONA;
