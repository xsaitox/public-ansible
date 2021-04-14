# update-awx-surveys
### Descripcion
Proyecto que se encarga de modificar los surveys (formularios) de Job Templates en AWX. El proposito de esto es poder actualizar, de forma dinamica, algunos campos de los formularios de Job Templates. Para ello, se sigue esta secuencia:

- Se obtiene el contenido en JSON de un formulario de Job Template deseado, usando tower-cli
- Se obtiene o genera el contenido que se desea sobreescribir a traves de algun comando o script (Ejm: list-networks.ps1)
- El valor obtenido en el punto anterior se usa para sobreescribir un objeto del documento JSON generado en el primer punto, generando un nuevo JSON
- Usando tower-cli, se actualiza el formulario del Job Template deseado, tomando como entrada el nuevo JSON generado

### Variables
- *jobtemplate_name* : Nombre de un Job Template
- *jobtemplate_filter* : Nombre de un archivo de filtro JQ (extension .jq) que se desea usar para procesar el documento JSON del formulario
- *jobtemplate_command* : Comando y parametros usados para generar una salida que se usara como contenido a sobreescribir en un objeto del documento JSON del formulario
