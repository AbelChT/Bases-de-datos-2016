CREATE TABLE vuelos_estado
(
    estado VARCHAR(50) PRIMARY KEY,
    vuelos INTEGER DEFAULT 0
);

CREATE OR REPLACE FUNCTION getState(airportIATA IN VARCHAR(4))
	RETURN VARCHAR(4) AS
	state VARCHAR(50);
	BEGIN
		SELECT c1.estado INTO state FROM aeropuerto a1
			INNER JOIN ciudad c1 ON a1.ciudad = c1.id
		WHERE a1.IATA = airportIATA;

		return state;
	END;
/

CREATE OR REPLACE PROCEDURE addState(state IN VARCHAR(50)) AS
		amount INTEGER;
	BEGIN
		SELECT COUNT(*) INTO amount FROM vuelos_estado WHERE estado = state;

		if amount = 0 THEN
			INSERT INTO vuelos_estado(estado, vuelos) VALUES (state, 1);
		ELSE
			UPDATE vuelos_estado SET vuelos = vuelos + 1 WHERE estado = state;
		END IF;
	END;
/

CREATE OR REPLACE PROCEDURE removeState(state IN VARCHAR(50)) AS
	BEGIN
		UPDATE vuelos_estado SET vuelos = vuelos - 1 WHERE estado = state;
	END;
/

CREATE TRIGGER vuelosEstadoIns
AFTER INSERT ON vuelos_retrasados
	FOR EACH ROW
	DECLARE
		iataOrig VARCHAR(4);
		iataDest VARCHAR(4);
	BEGIN
		SELECT v.origen, v.destino INTO iataOrig, iataDest FROM vuelo v WHERE v.id = :NEW.vuelo;
		addState(getState(iataOrig));
		addState(getState(iataDest));
	END;
/

CREATE TRIGGER vuelosEstadoDel
AFTER DELETE ON vuelos_retrasados
	FOR EACH ROW
	DECLARE
		iataOrig VARCHAR(4);
		iataDest VARCHAR(4);
	BEGIN
		SELECT v.origen, v.destino INTO iataOrig, iataDest FROM vuelo v WHERE v.id = :NEW.vuelo;
		removeState(getState(iataOrig));
		removeState(getState(iataDest));
	END;
/


CREATE TRIGGER vuelosEstadoUpt
AFTER UPDATE ON vuelos_retrasados
	FOR EACH ROW
	DECLARE
		iataOrigOld VARCHAR(4);
		iataDestOld VARCHAR(4);
		iataOrigNew VARCHAR(4);
		iataDestNew VARCHAR(4);
	BEGIN
		IF :OLD.VUELO != :NEW.VUELO THEN
			SELECT v.origen, v.destino INTO iataOrigOld, iataDestOld FROM vuelo v WHERE v.id = :NEW.vuelo;
			removeState(getState(iataOrigOld));
			removeState(getState(iataDestOld));

			SELECT v.origen, v.destino INTO iataOrigNew, iataDestNew FROM vuelo v WHERE v.id = :NEW.vuelo;
			addState(getState(iataOrigNew));
			addState(getState(iataDestNew));
		END IF;
	END;
/


CREATE TRIGGER vuelosEstadoIATA
	AFTER UPDATE ON vuelo
	FOR EACH ROW
	BEGIN
		IF :NEW.ORIGEN != :OLD.ORIGEN THEN
			removeState(getState(:OLD.ORIGEN));
			addState(getState(:NEW.ORIGEN));
		END IF;

		IF :NEW.DESTINO != :OLD.DESTINO THEN
			removeState(getState(:OLD.DESTINO));
			addState(getState(:NEW.DESTINO));
		END IF;
	END;
