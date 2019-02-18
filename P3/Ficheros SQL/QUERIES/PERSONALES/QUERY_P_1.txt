CREATE OR REPLACE FUNCTION diffSeconds(h0 IN INTEGER, m0 IN INTEGER, h1 IN INTEGER, m1 IN INTEGER)
  RETURN INTEGER AS
    h12 INTEGER;
    secs INTEGER;
  BEGIN
    IF (h0 > h1) THEN
      h12 := h1 + 24;
    ELSE
      h12 := h1;
    END IF;
    secs :=  3600 * (h12 - h0) + 60 * (m1 - m0);
    IF secs < 0 THEN
      secs := 86400 + secs;
    END IF;
    RETURN secs;
  END;
/

CREATE OR REPLACE FUNCTION velocity(t0 IN INTEGER, t1 IN INTEGER, d IN FLOAT)
  RETURN FLOAT AS
    secs INTEGER;
  BEGIN
    secs := diffSeconds(TRUNC(t0 / 100), MOD(t0, 100), TRUNC(t1 / 100), MOD(t1, 100));
    IF secs = 0 THEN
      RETURN 0;
    END IF;
    return 5760 * d / secs;
  END;
/

SELECT MAX(vel) v, tipo_motor FROM (
	SELECT velocity(v.hora_despegue, v.hora_aterrizaje, v.distancia) vel, v.tipo_motor
	FROM vuelo v
	INNER JOIN avion a ON a.id = v.avion
	INNER JOIN modelo_avion m ON m.id = a.modelo
) GROUP BY tipo_motor ORDER BY v DESC
