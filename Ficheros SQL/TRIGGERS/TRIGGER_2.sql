DROP TABLE peliculas_director_num;
DROP TRIGGER peliculasPorDirectorInsert;
DROP TRIGGER peliculasPorDirectorUpdate;
DROP TRIGGER peliculasPorDirectorDelete;

--
-- Tabla para almacenar los resultados de los 3 triggers.
--
CREATE TABLE peliculas_director_num (
  anyo INTEGER,
  director INTEGER REFERENCES persona(id) ON DELETE CASCADE,
  peliculas INTEGER,
  PRIMARY KEY (anyo, director)
);

CREATE INDEX peliculasNum ON peliculas_director_num(peliculas DESC);

--
-- Actualiza la tabla anterior con el número de películas que ha estrenado un director en un año concreto.
--
CREATE TRIGGER peliculasPorDirectorInsert
  AFTER INSERT
  ON director_pelicula
  FOR EACH ROW
  DECLARE
  countPeliculas INTEGER;
  estreno INTEGER;
BEGIN
  SELECT fecha_de_estreno INTO estreno FROM pelicula WHERE id = :NEW.pelicula;
  SELECT COUNT(*) INTO countPeliculas FROM peliculas_director_num WHERE director = :NEW.persona AND anyo = estreno;

  IF countPeliculas = 0 THEN
    INSERT INTO peliculas_director_num (director, anyo, peliculas) VALUES (:NEW.persona, estreno, 1);
  ELSE
    UPDATE peliculas_director_num SET peliculas = peliculas + 1 WHERE director = :NEW.persona AND anyo = estreno;
  END IF;
END;
/

CREATE TRIGGER peliculasPorDirectorUpdate
  AFTER UPDATE
  ON director_pelicula
  FOR EACH ROW
  DECLARE
  countPeliculas INTEGER;
  estreno INTEGER;
  estrenoAnterior INTEGER;
BEGIN
  SELECT fecha_de_estreno INTO estreno FROM pelicula WHERE id = :NEW.pelicula;
    SELECT fecha_de_estreno INTO estreno FROM pelicula WHERE id = :OLD.pelicula;
  SELECT COUNT(*) INTO countPeliculas FROM peliculas_director_num WHERE director = :NEW.persona AND anyo = estreno;

  IF countPeliculas = 0 THEN
    INSERT INTO peliculas_director_num (director, anyo, peliculas) VALUES (:NEW.persona, estreno, 1);
  ELSE
    UPDATE peliculas_director_num SET peliculas = peliculas + 1 WHERE director = :NEW.persona AND anyo = estreno;
    UPDATE peliculas_director_num SET peliculas = peliculas - 1 WHERE director = :OLD.persona AND anyo = estrenoAnterior;
  END IF;
END;
/

CREATE TRIGGER peliculasPorDirectorDelete
  AFTER DELETE
  ON director_pelicula
  FOR EACH ROW
  DECLARE
  estreno INTEGER;
BEGIN
  SELECT fecha_de_estreno INTO estreno FROM pelicula WHERE id = :OLD.pelicula;

  UPDATE peliculas_director_num SET peliculas = peliculas - 1 WHERE director = :OLD.persona AND anyo = estreno;

END;
/
