-- Obtenemos las películas
SELECT id,title,production_year
FROM title
WHERE kind_id=1;

-- Obtenemos la tabla personas
SELECT  id,name
FROM name;

-- Obtenemos la tabla actores-película
SELECT  person_id AS Actor, cast_info.movie_id AS Pelicula
FROM cast_info
WHERE (cast_info.role_id=1 OR cast_info.role_id=2)
      AND EXISTS(SELECT *
                 FROM name
                 WHERE name.id=cast_info.person_id)
      AND EXISTS(SELECT *
                 FROM title
                 WHERE title.id=cast_info.movie_id AND title.kind_id=1);

-- Obtenemos la tabla directores-película
SELECT  person_id AS Actor, cast_info.movie_id AS Pelicula
FROM cast_info
WHERE (cast_info.role_id=8)
      AND EXISTS(SELECT *
                 FROM name
                 WHERE name.id=cast_info.person_id)
      AND EXISTS(SELECT *
                 FROM title
                 WHERE title.id=cast_info.movie_id AND title.kind_id=1);

-- Obtenemos la tabla precuela
SELECT linked_movie_id AS original, movie_id AS secuela
FROM movie_link
INNER JOIN title ON title.id=movie_id AND title.kind_id=1 AND link_type_id=1;

-- Obtenemos la tabla remake
SELECT linked_movie_id AS original, movie_id AS remake
FROM movie_link
INNER JOIN title ON title.id=movie_id AND title.kind_id=1 AND link_type_id=1;

-- Obtener la tabla series
SELECT id,title,series_years
FROM title
WHERE kind_id=2;

-- Obtiene los capítulos de cada serie
SELECT title,episode_of_id
FROM title
WHERE kind_id=7;