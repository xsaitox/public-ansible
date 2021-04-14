#!/bin/bash
# Con este script se guarda historial de comandos en directorios por cada dia de los ultimos 30 dias.
# Tambien, se comprime los directorios antiguos de mas de 1 mes de antiguedad. Luego, se borra los
# antiguos directorios comprimidos que representen fechas de mas de 6 meses de antiguedad.
HISTDIR=/var/log/history
cd $HISTDIR

# Borrar antiguos archivos comprimidos de historial, pero quedarnos con los ultimos 150
find . -maxdepth 1 -type f -name "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].tar.gz" | sort -n | head -n -150 | xargs rm -f

# Comprimir y borrar antiguos directorios de historial de comandos, excepto los ultimos 30
find . -maxdepth 1 -type d -name "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]" | sort -n | head -n -30 |
while read dir
do
  dir=$(basename $dir)
  tar czf ${dir}.tar.gz $dir
  rm -rf $dir
done
