# Proyecto: aasa-vmware-storage-reports

## Descripcion
Este proyecto se encarga de la generacion de reportes de capacidades de Storage y VMs VMware del cliente Aceros Arequipa. Consiste en diversos playbooks, los cuales se ejecutan como Job Templates en AWX, pero todos integrados con un unico Job de Workflow.
El reporte genera 2 archivos Excel, los mismos que se envian por correo al equipo de Infraestructura el ultimo dia de cada mes. Dicha programacion se hace via AWX.

