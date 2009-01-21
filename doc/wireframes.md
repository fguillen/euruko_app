Wireframes (mirar /doc/wireframes)
------------------

### 01 Layout Invitado

Los *Invitados* podrán acceder a parte de la aplicación.

Cuando el usuario activo no está logueado tiene siempre presente el formulario de login en el que está envevido un link para *Registrarse* si es lo que desea.

### 02 Layout Usuario

Se diferencia del *Layout de Invitado* en que no le aparece el formulario de login y en su lugar aparece un menú con opciones de *Usuario*.

### 03 Layout de Admin

Se diferencia del *Layout de Usuario* en que su menú de Usuario tiene más opciones.

### 04 Registro

### 05 Registro con Error

Hay que tener en cuenta estos ejemplos de pantalla a la hora de realizar los diseños y maquetas para hacerles un sitio a los **mensajes de error**.

### 06 Registro OK

Hay que tener en cuenta estos ejemplos de pantalla a la hora de realizar los diseños y maquetas para hacerles un sitio a los **mensajes de notificación**.

### 07 Ver Perfil

Todo *Usuario* o *Invitado* puede visualizar el *Perfil* de otro usuario, siempre y cuando esté activado como **Público**.

Un *Usuario* puede visualizar su propio perfil pudiendo acceder desde ahí a la opción de *Modificar Perfil*. Los Admin pueden acceder a la modificación de cualquier perfil incluidos los no-públicos.

En el Perfil de Usuario aparecen listadas **todas las charlas** en las que está inscrito como Ponente.

Sólo se listan las **charlas ya confirmadas**. Si el Usuario está visitando su propio Perfil, o es un Admin, entonces se listan todas las charlas en las que participa estén en el estado que estén, además aparece el **estado actual de cada charla**.

Desde esta pantalla se puede acceder a *Proponer Charla*.

En el Perfil se incluye un **Avatar** que se traerá de **Gravatar**, un nombre, un texto y un par de links: su web personal y la de su empresa si procede.

### 08 Modificar Perfil

Aquí se configura los datos del Perfil del Usuario.

El email **no se puede modificar** por lo costoso que resulta comprobar su autenticidad, si el usuario quiere modificarlo que se haga contactando con un Admin y comprobándolo a mano.

Aquí se puede modificar la **clave** si se desea.

Se puede **modificar el Rol del Usuario** de Usuario a Admin y viceversa.

### 09 Ver Charla

Se muestra información de la Charla

* Título
* Ponentes
* Fecha (si ya está programada)
* Recursos (Son links a recursos asociados con la charla)
* Valoración de los Usuarios (los Invitados no pueden valorar)
* Listado de Asistentes a la charla.
* Comentarios (los Invitados no pueden comentar)

Links a:

* Proponer nueva Charla
* Indicar la asistencia, o no, a la Charla
* Modificar la Charla, si se es uno de los Ponentes o un Admin.

### 10 Crear/Modificar Charla

Misma pantalla para la creación como para la modificación de una Charla.

El título, descripción y duracción se modifica pulsando el botón de modificar. Todos los demás elementos se modifican en tiempo real mediante Ajax.

Del listado de Ponentes se pueden eliminar uno a uno. (PELIGRO: no puedo eliminar a todos, no me puedo eliminar a mí)

Se pueden añadir más ponentes eligiéndolos de un listado desplegable entre todos los Usuarios registrados.

#### Los Estados

1. Presentada
2. En revisión
3. Aceptada/No aceptada
4. Confirmada

Una Charla nace con estado *Presentada*, de ahí sólo los Admins la pueden pasar a *En Revisión* que significa que se está revisando para Aceptarla o No. Cuando una Charla está en estado *En Revisión* **no se puede modificar** por los Ponentes.

Si se pasa a estado *Aceptada* es uno de los Ponentes quienes tienen que pasarla a estado *Confirmada*.

#### Los Tipos

Hay que indicar el tipo de Charla: Keynote, Caso de Éxito, Taller, Charla, ...

#### Los Recursos

Se pueden añadir nuevos Recursos a una Charla de dos modos excluyentes:

* Indicando una URL donde el recurso ya está accesible
* Subiendo un archivo desde el ordenador

Al final siempre se obtiene lo mismo: un link que apunta al recurso.

### 11 Pagar Eventos

El pago de la Conferencia o cualquier otro **Evento satélite** como puede ser una cena, se hace mediante este míni carrito de la compra.

Se selecciona los eventos que se quieren pagar y se paga mediante **PayPal**.

Si se accede a esta pantalla cuando ya se ha pagado alguno o todos los eventos posibles **aparecen desactivadas** las opciones de dichos eventos para evitar un doble pago y para indicarle al Usuario que esos Eventos ya los tiene pagados.

En esta pantalla se indican los **datos de facturación**, que se almacenarán en BD para futuros accesos.

### 12 Pagar Eventos ERROR

### 13 Pagar Eventos OK

### 14 Listado Charlas

Se listan todas las Charlas, paginada o no, ya veremos.

Se diferencia de alguna manera:

* El Estado de la Charla
* Si voy o no
* El Tipo de la Charla

Sólo los Admins y sus Ponentes ven las Charlas que no estén en estado Confirmadas.

### 15 Asistentes/Ponentes

### 16 Buscar Usuarios

Posibilidad de buscar usuarios por diferentes criterios para mandarles recordatorios o cualquier tipo de Email.

### 17 Resultado Búsqueda Usuarios

Una vez filtrados los Usuarios se le podrá enviar un email a todos ellos.

Se podrán usar variables con campos del Usuario: name, ...

### 18 Calendario

Listado de todas las charlas programadas diferenciando por:

* Si voy o no
* El Tipo de la Charla

### 19 Modificar Calendario

Una de las pantallas con más pretensiones.

Aparecen las salas y se define un día.

Aparecen abajo todas las Charlas aún sin programar y se podrán seleccionar y arrastrar sobre cualquier punto del Calendario.

Igualmente se podrá seleccionar cualquier Charla en el Calendario y pasarla a la zona de las Charlas no Programadas.

Ya se verá que sale de todo esto...
