# awx-prerequisites

## Descripcion
Este repositorio contiene un sencillo playbook, el cual es ejecutado periodicamente por el AWX para que se encargue de instalar un conjunto de requisitos y otras dependencias dentro del contenedor awx_task.  Algunas de las dependencias que se instalarian son estas:

- Packer
- Terraform
- Paquetes del SO: cifs-utils, gcc, jq, powershell, etc
- Modulos de Python: awscli, enum, pywinrm, ansible-tower-cli, etc
- Modulos de PowerShell: PowerCLI


## Modo de uso
Este playbook es no interactivo. Es decir, no requiere ninguna intervencion del usuario. Sin embargo, si requiere definir algunas variables, como:

- packer_version : Version de Packer a instalar
- terraform_version : Version de Terraform a instalar

Ademas, este playbook deberia ser invocado como un Job Template de forma periodica (1 vez al dia, por ejemplo)

