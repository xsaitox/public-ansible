# Introducción
Este proyecto contiene el rol que despliega los componentes Elasticsearch, Logstash, Kibana y Maven, cada uno en sus respectivas VMs

## Tecnologias usadas
A continuación, el detalle de las herramientas tecnológicas usadas:

- *ansible* : Herramienta de aprovisionamiento y gestión de configuraciones

## Estructura de archivos
Este proyecto contiene los siguientes archivos, con sus propositos descritos a la derecha de cada uno:

- *defaults/main.yml* : Valores por defecto de variables usadas en el rol
- *tasks/main.yml* : Fichero principal de tareas que invoca a otras, según el rol detectado de cada VM basado en el nombre de grupo de host (variable *inventory_hostname*)
- *tasks/elasticsearch-tasks.yml* : Contiene las tareas de despliegue de Elasticsearch
- *tasks/logstash-tasks.yml* : Contiene las tareas de despliegue de LogStash
- *tasks/kibana-tasks.yml* : Contiene las tareas de despliegue de Kibana
- *tasks/maven-tasks.yml* : Contiene las tareas de despliegue de Maven
- *tasks/requisite-tasks.yml* : Tareas previas comunes a cada VM
- *tasks/docker-tasks.yml* : Tareas previas de despliegue de Docker, comunes a cada VM donde corresponde (logstash y kibana)
- *templates/limits.conf.j2* : Plantilla de fichero de configuracion de límites de SO para Elasticsearch
- *templates/systemd.override.conf* : Plantilla de fichero de configuracion de Systemd para cambiar parámetros de Elasticsearch
- *templates/kibana.yml* : Plantilla de fichero de configuracion de Kibana
- *templates/logstash.yml* : Plantilla de fichero de configuracion de Logstash
- *README.md* : Este archivo de documentación
