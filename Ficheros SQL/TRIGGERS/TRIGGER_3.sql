DROP TABLE act_directores;
DROP TRIGGER act_actores_directores;
DROP TRIGGER dir_actores_directores;

CREATE TABLE act_directores (
		actor_director INTEGER REFERENCES Persona(ID) ON DELETE CASCADE ,
		pelicula INTEGER REFERENCES PELICULA(ID),
    PRIMARY KEY (actor_director,pelicula)
);

CREATE TRIGGER act_actores_directores
	AFTER INSERT
	ON actor_pelicula
	FOR EACH ROW
	DECLARE
	director INTEGER;
	peli INTEGER;
BEGIN
	SELECT persona INTO director FROM director_pelicula WHERE director_pelicula.persona  = :NEW.persona;
	SELECT pelicula INTO peli FROM pelicula WHERE pelicula.id  = :NEW.pelicula;
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
	actor INTEGER;
	pel INTEGER;
BEGIN
    	SELECT persona INTO actor FROM ACTOR_PELICULA WHERE ACTOR_PELICULA.persona  = :NEW.persona;
    	SELECT pelicula INTO pel FROM pelicula WHERE pelicula.id  = :NEW.pelicula;
   	IF actor = :NEW.PERSONA THEN
      		INSERT INTO act_directores (actor_director, pelicula) VALUES (:NEW.persona, :NEW.PELICULA);
    	END IF;
END;
/