#!/bin/bash
########################################################
########################################################
########################################################
# Descripcion   : Script que genera un log separado de #
#                 historial de comandos por usuario    #
# Autor         : Angel Rengifo <arengifoc@gmd.com.pe> #
# Version       : 1.0                                  #
# Fecha         : 12/02/2018                           #
# Licencia      : GPLv2                                #
########################################################
########################################################
########################################################


# Directorio de log de historiales
DIRECTORIO_HISTORIAL="/var/log/history"

# Salir del script si no existe el directorio $DIRECTORIO_HISTORIAL
# o si no se esta en una sesion tty real
if [ -d $DIRECTORIO_HISTORIAL ] && tty > /dev/null 2>&1
then
  # Definicion de variables
  FECHA=$(date "+%Y%m%d")
  HORA=$(date "+%H%M%S")
  
  # Crear directorio de historial por fecha
  DIRECTORIO_HISTORIAL=$DIRECTORIO_HISTORIAL/$FECHA
  mkdir -p $DIRECTORIO_HISTORIAL > /dev/null 2>&1
  chmod 1777 $DIRECTORIO_HISTORIAL > /dev/null 2>&1
  
  # Identificar la SESSION a partir del tty en uso
  SESION=$(who am i | awk '{ print $2 }' | tr -d /)
  
  # En caso no detecte el tty, asignar el PID como nombre de tty
  [ -z "${SESION}" ] && SESION=pid.$$
  
  # Obtener el usuario destino al cual nos convertimos
  COMO="$(whoami | awk '{ print $1 }')"
  
  # Obtener el usuario original con el cual iniciamos sesion
  DE="$(who am i | awk '{ print $1 }')"
  
  # Si no se pudo averiguar el usuario original, igualarlo con
  # el cual nos convertimos o destino
  [ -z "${DE}" ] && DE=${COMO}
  
  export HISTFILE="${DIRECTORIO_HISTORIAL}/de-${DE}-como-${COMO}-${FECHA}-${HORA}-${SESION}.log"
  export HISTTIMEFORMAT="%h/%d - %H:%M:%S "
  unset HISTCONTROL HISTIGNORE
  shopt -s histappend
  touch $HISTFILE
  chmod 0600 $HISTFILE
  
  if echo $HISTFILE | grep -q "\-root\-"
  then
    export PROMPT_COMMAND="history -a ; history -w"
  else
    VERSION_BASH=$(echo $BASH_VERSION | cut -d . -f 1)
    if [ $VERSION_BASH -ge 4 ]
    then
      export PROMPT_COMMAND="history -a ; history -c ; history -r ; ${PROMPT_COMMAND}"
    else
      export PROMPT_COMMAND="history -w ; history -c ; history -r ; ${PROMPT_COMMAND}"
    fi
  fi
  
  echo "# Inicio de historial de ${DE} ($0) como ${COMO} ($(tty)) - $FECHA $HORA - ${HISTFILE}"  >> ${HISTFILE}
fi
