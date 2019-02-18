-- Aereopuertos y ciudades
select *
from airports a
where not exists(
  select *
  from airports b
  where a.city=b.city AND a.state=b.state AND a.iata!=b.iata
);

select *
from airports a
where exists(
  select *
  from airports b
  where a.city=b.city AND a.state=b.state AND a.iata!=b.iata
)
ORDER BY city ASC ;