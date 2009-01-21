TODOs
------------------
* **--DONE--** Notificador de excepciones
* Títulos de páginas ( http://railscasts.com/episodes/30-pretty-page-title )
* Observer en create de LoggedException y que envíe un mail a administradores
* Comunicación PayPal cifrada
* Posible modelo ShoppingCart
* Ajax en comentario
* Ajax en voy/no voy
* Ajax en puntuación
* **--DONE--** Seguridad de acceso de sólo administradores
* **--DONE--** Seguridad en http://localhost:3000/logged_exceptions
* **--DONE--** Seguridad de acceso sólo usuarios registrados
* **--DONE--** Seguridad de acceso sólo speakers pueden modificar paper
* **--DONE--** Seguridad de acceso a listado de charlas sólo deben aparecer las aprobadas/confirmadas sino es administrador
* Pantalla últimos comentarios
* Pantalla últimos pagos
* Cambios de estilo en listados de Papers para diferenciar: familias y estados
* **--DONE--** Capturar finds no encontrados y mandar a 404
* Diseño: Pantalla 404
* Diseño: Pantalla 500
* **--DONE--** Urls amigables
* **--DONE--** Namescope para Paper.visible 
* Speakers salen duplicados.. creo que el join no está bien igual mola más un :include.. o meter un distinct.. 
* **--DONE--** Avatares de gravatar
* Control de textos: escapar html, linkar links, ...
* Tabla de vista de calendario
* Speakers sólo son speakers si alguna de sus charlas está aceptada o confirmada.. vamos si es paper.visible?
* En perfil de usuarios sólo mostrar las charlas en las que participa si la charla es .visible?
* Modificar contraseña sólo si se introduce la actual correctamente
* Una charla en estado UNDER REVIEW no puede se modificada más que por un admin
* ¿Qué pasa si un user tiene el perfil no-público y además es un speaker?
* Un usuario puede crear una charla y empezar a asignar speakers sin consentimiento :?
* gem dependencies (http://railscasts.com/episodes/110-gem-dependencies) (mocha, faker, will-paginate )
* buscadores avanzados de usuarios y charlas( railscasts 111 y 112 )
* **--DONE--** YOURSITE en notificaciones de registro => modificar intentar que sea dinámico
* **--DONE--** El speaker no puede ver su propia charla
* **--DONE--** Al crear charla si no es Admin no debe ver los campos de room, fechas y demás.. 
* Al modificar charla proteger campos room, fechas y demás.. sólo a administradores
* Al añadir ponente a charla no deben aparecer los que ya están
* Al añadir ponente a charla el listado de salir ordenado alfabéticamente
* **--DONE--** Al añadir recurso a charla la url del link no es correcta
* Al añadir ponente a charla hay que filtrar por públicos
* Notificaciones por email: charla presentada