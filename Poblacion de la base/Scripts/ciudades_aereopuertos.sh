#!/bin/bash
# Primer parámetro es el fichero de ciudades, en el fichero resultado han de estar
# los aereopuertos en las que se quiere sustituir la ciudad por el id correspondiente

old_ifs=$IFS
IFS=','
cat "$1" | while read numero buscar
do
  sed "s/$buscar/$numero/g" "resultado" > /dev/null > resultado2
  mv resultado2 resultado
done
IFS=$old_ifs
