--
-- Optimizada (trigger, index)
--
SELECT director.nombre, anyo, peliculas FROM peliculas_director_num pelic INNER JOIN persona director ON director.id = pelic.director WHERE peliculas >= 3 ORDER BY peliculas;