# Crear una VM por **IAC**
## Descripción:
<p>El siguiente manual detalla el procedimiento para construir una maquina virtual en las diferentes infraestructuras desplegadas en canvia</p>

## Instalación 
<p>Se debe contar con las siguientes herramientas para el trabajo diario, estas deben estar instaladas en tu equipo local</p>

1. xubuntu
1. ansible
1. git
1. git-flow
1. visual studio code 
1. grip

## Requisitos previos

<p>Configurar los repositorios almacenados en bitbucket para ellos debes contar con una cuenta de canvia(Ejemplo: eflores@canvia) solicitarlo previamente a Miguel Quispe ( Responsable de Code Arquitectura y Genesis), una vez se cuenta con los accesos descargar 
los proyectos necesarios para desplegarla el equipo como se muestra a continuación</p>

>Generar las llaves ssh con el comando ssh-keygen: 

```bash 
ssh-keygent -t rsa -b 2048 -f bitbucket 
-rw-r--r-- 1 eflores eflores  397 Dec 23 10:33 efloresbitbucket.pub
-rw------- 1 eflores eflores 1.7K Dec 23 10:33 efloresbitbucket
```

>Posteriormente, crear un archivo con el nombre config en el directorio **.ssh** para tener multiples cuentas de respositorios y direccionar a la llave correcta como se indica a continuación

```bash
Host bitbucket.org
 IdentityFile ~/.ssh/efloresbitbucket
```

* ansible-role-os-antivirus
* ansible-role-os-baseline
* ansible-role-os-basevars
* ansible-role-os-customization
* ansible-role-os-hardening
* ansible-role-os-monitoring
* ansible-role-os-register
* ansible-role-os-update
* ansible-role-os-users

_vmware-templates_, repositorio que contiene el codigo para desplegar la vm desde awx.

#### Observaciones
Actualmente se trabaja con la rama sid la cual se le realizara el merge a la rama master, para descargar la rama master de vmware-template se realiza de la siguiente forma: 

```bash
git clone git@bitbucket.org:automatizacioncanvia/vmware-templates.git 
```

<p>Esto nos descargara la rama master, para descargar la rama sid se debe usar el siguiente comando.</p>

```bash
git checkout sid 
git pull origin sid 
```

# Creación de un Maquina vmware template 

<p>Para dicho proceso debemos considerar en:</p>

## Etapa I 

<p>Creación de una vm línea base, la cual debe tener el sistema operativo instalado sin updates, sin suscripción en el caso de Linux se debe validar el paquete open-vm-tools que venga instalado el cual es la herramienta opensource a vmware-tools.

Para ello ingresamos a cada vcenter para este ejemplo: https://172.23.8.39/vsphere-client/ y validamos que existen el nombre template y sino lo creamos </p>

![](img/Picture1.png)

## Observaciones: 

* Se debe crear con el nombre windows-[[numeral]]-base o [[name_linux]]-base para que a la hora de buscar el nombre del archivo este le permita crear el primer template. 

<p>Para pasar a la etapa 2 se clona una maquina base la cual será nuestro template sobre la cual instalaremos los roles y updates, bugs fixes como otros(vmware_template_base_A).</p>

## Etapa II 

Dirigirse al dominio con url https://awx.canvia.com para crear la vmware template la cual trabajara con la línea base para este caso se buscara con el nombre “**crear**” “**plantilla**” “**vmware**” en el buscador.

![](img/Picture2.png)

![](img/Picture3.png)

![](img/Picture4.png)

* **Inventory**: Se ejecuta localmente en el equipo localhost donde esta instalado el ansible.
* **Project**: nombre del proyecto que va a englobar al template.
* **Playbook**: template creado que se va a ejecutar.

Nos va a salir un _survey_ ( aviso ) el cual tenemos que seleccionar para ello el vcenter donde va instalarse o crear la vm ( template )

![](img/Picture5.png)

Seleccionamos credencial, que significa, en que vcenter esta la vm sobre la cual vamos a trabajar) y que va a ser nuestro template global,

![](img/Picture6.png)

En **_Survey_** que son parametros ingresados se debe rellenar la direccion IP, la clave del usuario admin y el nombre de la vm ( en este caso es el nombre de la vm clonada ) cuando ejecutamos el playbook declarado en ansible tower este llama a un archivo con el nombre

> Create.yml 

Dicho archivo define 3 estructuras la primera aplica al entorno local 

![](img/Picture7.png)

Define una variable:

* De entorno llamado **TZ**: America/Lima 
* **ANSIBLE_HOST_KEY_CHECKING**: false no permite el intercambio de llaves a nivel de ssh 
* **Roles**: aplica el role canvia.os-basevars descarga dicho rol usando el archivo requirements.yml
* **Tasks**: define la tarea create-prerequisites.yml la cual va a cargar ...

En el archivo create-prerequisites.yml se declara a continuación partes del codigo más importantes

![](img/Picture8.png)

Dichas variables son declaradas en credential types > vCenter Parameters, el cual se crea manualmente al inicio del poryecto, queremos definir un tipo de credencial

![](img/Picture9.png)

![](img/Picture10.png)

En dicha etiqueta creamos las variables las cuales que van a definir a nuestro recuadro credentials que son los parametros a rellenar dentro del mismo.

![](img/Picture11.png)

![](img/Picture12.png)

![](img/Picture13.png)

Detalle_variable_field 

Donde: 
Host es el equipo al que se va hacer referencia para ejecutar el playbook este esta representando por un ID
Type: es el tipo o valor que se va a ingresar en el formulario ( el cual puede ser tipo texto, entero o booleano
Label: es la etiqueta que aparece en la ventana como identificador 

fields:
  - id: host
    type: string
    label: Host
  - id: username
    type: string
    label: Username
  - id: password
    type: string
    label: Password
    secret: true
  - id: datacenter
    type: string
    label: Default Data Center
  - id: datastore
    type: string
    label: Default datastore
  - id: vm_folder
    type: string
    label: Default folder for VMs
  - id: template_folder
    type: string
    label: Default folder for templates
  - id: linux_cluster
    type: string
    label: Default cluster for Linux guests
  - id: windows_cluster
    type: string
    label: Default cluster for Windows guests
  - id: resourcepool
    type: string
label: Default resource pool

# Required, hace referencia a los valores que se van a utilizar y declarar en la interfaz gráfica, en resumen las que estarán habilitadas.

required:
  - host
  - datacenter
  - datastore
  - vm_folder
  - template_folder
  - linux_cluster
  - windows_cluster
  - resourcepool
  - username
  - password

Estos datos se declaran en survey para la plantilla crear-vmware-template y hacen referencia al ip del equipo clonado, password del usuario admin y nombre de la vm creada que se tomara