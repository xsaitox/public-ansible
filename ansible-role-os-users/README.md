<<<<<<< HEAD
# Ansible Role: os-users

## Descripcion
Rol de ansible que se encarga de la creacion de usuarios de sistema operativo, para Linux y Windows

## Estructura de contenido
- *defaults/main.yml* : Contiene la lista de usuarios y grupos por defecto a crear
- *files/\*.pub* : Lista de llaves publicas SSH de cada usuario de Linux. El nombre del archivo debe coincidir con el nombre del usuario (sin extension .pub)
- *tasks/main.yml* : Playbook principal que llama a windows-users.yml o linux-users.yml
- *tasks/windows-users.yml* : Playbook que crea usuarios y/o grupos en Windows
- *tasks/windows-linux.yml* : Playbook que crea usuarios y/o grupos en Linux
- *templates/\** : Diversos archivos usados para configurar permisos de sudo, scripts y/o archivos de perfil para usuarios de Linux

## Modo de uso
Simplemente se invoca al rol, sin parametro ni ajuste de variable alguna

=======
# Proyecto: Rol de Ansible os-users
Crea usuarios para los administradores de Canvia

## Descripcion
Este rol crea una serie de usuarios genericos para los administradores de distintas areas (DBA, SAP, CECOM, etc) con una cuenta compartida. Tambien, crea usuarios personales para los administradores de Linux, solo en servidores Linux

## Modo de uso
>>>>>>> release/1.0.2
    - hosts:
      roles:
        - canvia.os-users

