DROP TABLE actores_directores;
DROP TRIGGER act_actores_directores;
DROP TRIGGER dir_actores_directores;

CREATE TABLE act_directores (
		actor_director INTEGER REFERENCES Persona(ID) ON DELETE CASCADE ,
		pelicula INTEGER REFERENCES PELICULA(ID) ON DELETE CASCADE,
    PRIMARY KEY (actor_director,pelicula)
);

CREATE TRIGGER act_actores_directores
AFTER INSERT
	ON actor_pelicula
	FOR EACH ROW
		DECLARE
		PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	  SELECT persona AS director FROM DIRECTOR_PELICULA WHERE DIRECTOR_PELICULA.pelicula  =: NEW.PELICULA;
    IF director = :NEW.PERSONA THEN
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
    SELECT persona AS actor FROM ACTOR_PELICULA WHERE ACTOR_PELICULA.pelicula  =: NEW.PELICULA;
    IF actor = :NEW.PERSONA THEN
      INSERT INTO act_directores (actor_director, pelicula) VALUES (:NEW.persona, :NEW.PELICULA);
    END IF;
END;
/