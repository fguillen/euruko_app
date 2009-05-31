TODOs
------------------

## fguillen:
* Un usuario con carritos pagados no se debería poder eliminar
* Tests exhaustivos de cart y carts controller
* No se están ejecutando los tests de foreignkeys
* Si pago no "Completed" sacar mensaje y decir que se pongan en contacto con admin
* Una Paper no puede estar activa o confirmada si date is null, o la room is null.. o sino por lo menos hacer que calendar soporte esta casuística
* Enviar email de notificación a usuario y a admin cuando concluye un pago.. haya sido correcto o no.
* En creación de Paper no se puede iniciar el estado.
* Si adjuntos a la foto de la Paper un fichero que no es imagen peta 500
* Borrar usuario parece no funcionar, creo que tampoco te puedes dar de baja voluntariamente
* Cuando envías un comentario después de un error el error no desaparece
* En el edit del user el campo company_url hace cosas raras si está vacío
* UserSearcher
** emails de ponentes con charlas aprobadas
** emails de ponentes con charlas rechazadas
** emails de ponentes con charlas aprobadas y algún campo de descripción vacío en su ficha.
* Al resetear password no se dice el Login del usuario osea que si también se le ha olvidado estamo jodidos.
* "Meanwhile on the others tracks:"
* Exportar PDF de las charlas
* Editor static pages
* Campo serial de invoice debería tener el serial completo no sólo el entero: euruko-2009-0001

## xuanxu:
* Pantalla últimos comentarios

## marze:


## anybody:
* Control de textos: linkar links, ...
* gem dependencies (http://railscasts.com/episodes/110-gem-dependencies) (mocha, faker, will-paginate )
* buscadores avanzados de usuarios y charlas( railscasts 111 y 112 )
* Una charla se puede quedar sin speakers.. :?
* Método retrieve_speakers muy poco optimizado
* Cuando pinchas en Speakers no queda resaltado en menú People (claro porque es otra url)

WISHLIST
------------------
* Poder comprar códigos promo para pagar la entrada a otras personas. Así los admin podrán generarlos para repartir también.
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
* El carrito en sesion lo veo raro. La manera de instaciarlo tambien
  se puede revisar. Por lo general uno simplemente haria
   @current_cart ||= current_user.cart
 en un filtro sin mas complicaciones (y sin poner el cart en sesion).


DONE
------------------
* No se graba la room ni la duración ni family asignada en la creacíón de Paper por admin
* Comunicación PayPal cifrada
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