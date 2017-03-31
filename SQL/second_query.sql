CREATE VIEW temporadas_permitidas AS
  SELECT id
  FROM temporada;

CREATE VIEW equipos_goles_temporada AS
  (SELECT goles_local AS goles, idTemp AS temporada_,equipo_local AS equipo_
    FROM partido
    WHERE EXISTS(SELECT *
                 FROM temporadas_permitidas
                 WHERE idTEMP = id
    ))

  UNION

  (SELECT goles_visitante AS goles, idTemp AS temporada_,equipo_visitante AS equipo_
    FROM partido
    WHERE EXISTS(SELECT *
                 FROM temporadas_permitidas
                 WHERE idTEMP = id
    ));

CREATE VIEW equipos_mediaGoles_temporada AS
  SELECT avg(goles) AS media_goles,temporada_,equipo_
  FROM equipos_goles_temporada
  GROUP BY (temporada_,equipo_);

SELECT temporada_,equipo_
FROM equipos_mediaGoles_temporada
WHERE media_goles > 3 ;

