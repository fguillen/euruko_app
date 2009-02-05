TODOs
------------------

## fguillen:
* Comunicación PayPal cifrada
* Un usuario con carritos pagados no se debería poder eliminar
* Tests exhaustivos de cart y carts controller
* No se están ejecutando los tests de foreignkeys

## xuanxu:
* Pantalla últimos comentarios

## marze:
* Cambios de estilo en listados de Papers para diferenciar: familias y estados
* Diseño: Pantalla 404
* Diseño: Pantalla 500
* Tabla de vista de calendario
* Mejorar un poco pantalla de carrito (Pay!), la new, la confirm y la complete
* Mejorar listados, Papers, Users, ...


## anybody:
* Control de textos: linkar links, ...
* gem dependencies (http://railscasts.com/episodes/110-gem-dependencies) (mocha, faker, will-paginate )
* buscadores avanzados de usuarios y charlas( railscasts 111 y 112 )
* Una charla se puede quedar sin speakers.. :?


WISHLIST
------------------
* Si estamos usando sqlite no se deberían ejecutar los test de foreign-keys
* Un usuario puede crear una charla y empezar a asignar speakers sin consentimiento :?
* Autocomplete en añadir speaker
* Añadir ponentes al crear charla via js
* Notificaciones a twitter de nuevos registros y nueva paper presentada
* Paginar listados de usuarios
* Optimizar cargas de javascript.
* Solo posible cambiar password si se introduce actual, problemas:
** El admin debe poder hacerlo sin la actual
** El reset password debe poder hacerlo sin la actual
** La creación debe poder hacerlo, sin la actual


DONE
------------------
* En perfil de usuarios sólo mostrar las charlas en las que participa si la charla es .visible?
* Una charla en estado UNDER REVIEW no puede se modificada más que por un admin
* Al modificar charla proteger campos room, fechas y demás.. sólo a administradores
* Paperclip sube la photo a la carpeta public/system ??
* Reset Password no lanza alert. Mensajes de error feos.
* Títulos de páginas ( http://railscasts.com/episodes/30-pretty-page-title )
* Tests photo
* Vigilar traduciones: "Participa en las siguientes charlas" => "Presenting"
* Listado de últimos pagos, con mini buscador
* Ajax en añadir/eliminar ponente a Paper
* Añadir Foto (una y sólo una) a Paper
* Cuando Admin accede al show de un Cart tiene que llevarle a una página especial.. o llamar a la accion de crear carrito new o edit o algo así
* Control de textos: escapar html
* Guardar el usuario que creó la charla para saber a quién preguntar en caso de dudas
* Autologin en activación de cuenta
* Recuperar password, revisar el rest-authetication que lo tiene, sólo habrá que activarlo
* Al cambiar de nombre todo.md a TODO.md e install.md a INSTALL.md en el repositorio se han quedado duplicados :?
* Sino seleccionas ningún evento en el carrito dá error 404 al confirmar
* Posible modelo ShoppingCart
* Ajax en comentario
* Ajax en voy/no voy
* Ajax en puntuación
* Al añadir ponente a charla no deben aparecer los que ya están
* Al añadir ponente a charla hay que filtrar por públicos
* Al añadir ponente a charla el listado de salir ordenado alfabéticamente
* Speakers sólo son speakers si alguna de sus charlas está aceptada o confirmada.. vamos si es paper.visible?
* Speakers salen duplicados.. creo que el join no está bien igual mola más un :include.. o meter un distinct.. 
* ¿Qué pasa si un user tiene el perfil no-público y además es un speaker? -> no puede
* Notificaciones por email: charla presentada
* Al añadir recurso a charla la url del link no es correcta
* YOURSITE en notificaciones de registro => modificar intentar que sea dinámico
* El speaker no puede ver su propia charla
* Al crear charla si no es Admin no debe ver los campos de room, fechas y demás.. 
* Avatares de gravatar
* Urls amigables
* Namescope para Paper.visible 
* Capturar finds no encontrados y mandar a 404
* Seguridad de acceso de sólo administradores
* Seguridad en http://localhost:3000/logged_exceptions
* Seguridad de acceso sólo usuarios registrados
* Seguridad de acceso sólo speakers pueden modificar paper
* Seguridad de acceso a listado de charlas sólo deben aparecer las aprobadas/confirmadas sino es administrador
* Notificador de excepciones
* Observer en create de LoggedException y que envíe un mail a administradores