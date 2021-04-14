# Introducción
Este proyecto contiene el desarrollo al ITOps Engineer Challenge, propuesto a mi persona

## Tecnologias usadas
A continuación, el detalle de las herramientas tecnológicas usadas:

- *vagrant* : Tool de creación de VMs, usando VirtualBox como provider por defecto
- *ansible* : Herramienta de aprovisionamiento y gestión de configuraciones
- *ansible-galaxy* : Herramienta usada para descargar el rol arengifoc.elk, necesario para este proyecto


## Estructura de archivos
Este proyecto contiene los siguientes archivos, con sus propositos descritos a la derecha de cada uno:

- *Vagrantfile* : Contiene la definicion de las 4 VMs a crear, sus características e integraciones de aprovisionamiento
- *site.yml* : Playbook principal de aprovisionamiento, el cual es invocado para todas las VMs de vagrant
- *roles/requirements* : Definición de roles a importar antes de correr el playbook principal (site.yml)
- *.gitignore* : Ficheros a excluir del repo Git
- *README.md* : Este archivo de documentación

## Modo de uso
1. Instalar VirtualBox y vagrant
2. Clonar este repositorio
3. Colocarse dentro del directorio local donde se clonó el repositorio
4. Ejecutar `vagrant up`
5. Esperar que termine de iniciar y configurar todas las VMs: elasticsearch, logstash, kibana y maven
6. Si se requiere conectarse a una de ellas, ejecutar `vagrant ssh NombreVM`

## Pendiente
- En el rol arengifoc.elk, falta configurar handlers para el reinicio condicionado de Elasticsearch, solo cuando detecte cambios en su configuracion
- Probar configuracion de Logstash en integracion con Elasticsearch
- Descarga, compilacion y test del proyecto Java con Maven para probar el funcionamiento integrado con ELK
