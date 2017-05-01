DROP TABLE act_directores;
DROP TRIGGER act_actores_directores;
DROP TRIGGER dir_actores_directores;

CREATE TABLE act_directores (
		actor_director INTEGER,
		pelicula INTEGER REFERENCES,
    PRIMARY KEY (actor_director,pelicula)
);

CREATE TRIGGER act_actores_directores
	AFTER INSERT
	ON actor_pelicula
	FOR EACH ROW
	DECLARE
	PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	IF EXISTS(SELECT * FROM director_pelicula WHERE director_pelicula.persona  = :NEW.persona AND director_pelicula.pelicula= :NEW.pelicula;)
	THEN
	INSERT INTO act_directores (actor_director, pelicula) VALUES (:NEW.persona, :NEW.PELICULA);
	END IF;
END;
/

CREATE TRIGGER dir_actores_directores
	AFTER INSERT
	ON director_pelicula
	FOR EACH ROW
	DECLARE
	PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	IF EXISTS (SELECT * FROM ACTOR_PELICULA WHERE ACTOR_PELICULA.persona  = :NEW.persona AND director_pelicula.pelicula = :NEW.pelicula;)
      		INSERT INTO act_directores (actor_director, pelicula) VALUES (:NEW.persona, :NEW.PELICULA);
    	END IF;
END;
/
