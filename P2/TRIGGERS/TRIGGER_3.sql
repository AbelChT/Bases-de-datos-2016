DROP TABLE act_directores;
DROP TRIGGER act_actores_directores_ins;
DROP TRIGGER dir_actores_directores_ins;
DROP TRIGGER act_actores_directores_del;
DROP TRIGGER dir_actores_directores_del;
DROP TRIGGER act_actores_directores_upd;
DROP TRIGGER dir_actores_directores_upd;

CREATE TABLE act_directores (
		actor_director INTEGER,
		pelicula INTEGER,
    PRIMARY KEY (actor_director,pelicula)
);

CREATE TRIGGER act_actores_directores_ins
	AFTER INSERT
	ON actor_pelicula
	FOR EACH ROW
	DECLARE
	numero INTEGER;
BEGIN
	SELECT COUNT(*) INTO numero FROM director_pelicula WHERE director_pelicula.persona  = :NEW.persona AND director_pelicula.pelicula= :NEW.pelicula;
	IF numero > 0
	THEN
		INSERT INTO act_directores (actor_director, pelicula) VALUES (:NEW.persona, :NEW.pelicula);
	END IF;
END;
/

CREATE TRIGGER dir_actores_directores_ins
	AFTER INSERT
	ON director_pelicula
	FOR EACH ROW
	DECLARE
	numero INTEGER;
BEGIN
	SELECT COUNT(*) INTO numero FROM ACTOR_PELICULA WHERE ACTOR_PELICULA.persona  = :NEW.persona AND ACTOR_PELICULA.pelicula = :NEW.pelicula;
	IF numero > 0
	THEN
      		INSERT INTO act_directores (actor_director, pelicula) VALUES (:NEW.persona, :NEW.PELICULA);
    	END IF;
END;
/

CREATE TRIGGER act_actores_directores_del
	AFTER DELETE
	ON actor_pelicula
	FOR EACH ROW
BEGIN
	DELETE FROM act_directores WHERE actor_director = :OLD.persona AND pelicula = :OLD.pelicula;
END;
/

CREATE TRIGGER dir_actores_directores_del
	AFTER DELETE
	ON director_pelicula
	FOR EACH ROW
BEGIN
	DELETE FROM act_directores WHERE actor_director = :OLD.persona AND pelicula = :OLD.pelicula;
END;
/

CREATE TRIGGER act_actores_directores_upd
	AFTER UPDATE
	ON actor_pelicula
	FOR EACH ROW
	DECLARE
	numero INTEGER;
BEGIN
	SELECT COUNT(*) INTO numero FROM director_pelicula WHERE persona = :NEW.persona AND pelicula = :NEW.pelicula;
	IF numero > 0
	THEN
		UPDATE act_directores SET actor_director = :NEW.persona , pelicula = :NEW.pelicula WHERE actor_director = :OLD.persona AND pelicula = :OLD.pelicula;
	ELSE
		DELETE FROM act_directores WHERE actor_director= :OLD.persona AND pelicula = :OLD.pelicula;
	END IF;
END;
/

CREATE TRIGGER dir_actores_directores_upd
	AFTER UPDATE
	ON director_pelicula
	FOR EACH ROW
	DECLARE
	numero INTEGER;
BEGIN
	SELECT COUNT(*) INTO numero FROM actor_pelicula WHERE persona = :NEW.persona AND pelicula = :NEW.pelicula;
	IF numero > 0
	THEN
		UPDATE act_directores SET actor_director = :NEW.persona, pelicula= :NEW.pelicula WHERE actor_director= :OLD.persona AND pelicula = :OLD.pelicula;
	ELSE
		DELETE FROM act_directores WHERE actor_director= :OLD.persona AND pelicula = :OLD.pelicula;
	END IF;
END;
/
