I18n.backend.store_translations :'es-ES', {
  # date and time formats
  :date => {
    :formats => {
      :default      => "%d-%m-%Y",
      :short        => "%e %b",
      :long         => "%B %e, %Y",
      :long_ordinal => lambda { |date| "%B #{date.day}ish, %Y" },
      :only_day     => lambda { |date| "#{date.day}ish"}
    },
    :day_names => %w(lunes martes miércoles jueves viernes sábado domingo),
    :abbr_day_names => %w(lun mar mié jue vie sáb dom),
    :month_names => [nil] + %w(enero febrero marzo abril mayo junio julio agosto septiembre octubre noviembre diciembre),
    :abbr_month_names => [nil] + %w(ene feb mar abr may jun jul ago sep oct nov dic),
    :order => [:day, :month, :year]
  },
  :time => {
    :formats => {
      :default      => "%a %b %d %H:%M:%S %Z %Y",
      :time         => "%H:%M",
      :short        => "%d %b %H:%M",
      :long         => "%B %d, %Y %H:%M",
      :long_ordinal => lambda { |time| "%B #{time.day}ish, %Y %H:%M" },
      :only_second  => "%S (ish)"
    },
    :am => '',
    :pm => ''
  },

  # date helper distance in words
  :datetime => {
    :distance_in_words => {
      :half_a_minute       => 'medio minuto',
      :less_than_x_seconds => ['menos de 1 segundo', '{{count}} segundos'],
      :x_seconds           => ['1 segundo', '{{count}} segundos'],
      :less_than_x_minutes => ['menos de 1 minuto', '{{count}} minutos'],
      :x_minutes           => ['1 minuto', '{{count}} minutos'],
      :about_x_hours       => ['casi 1 hora', 'casi {{count}} horas'],
      :x_days              => ['1 día', '{{count}} días'],
      :about_x_months      => ['casi 1 mes', 'casi {{count}} meses'],
      :x_months            => ['1 mes', '{{count}} meses'],
      :about_x_years       => ['casi 1 año', '{{count}} años'],
      :over_x_years        => ['más de 1 año', '{{count}} años']
    }
  },

  # numbers
  :number => {
    :format => {
      :precision => 3,
      :separator => ',',
      :delimiter => '.'
    },
    :currency => {
      :format => {
        :unit => '€',
        :precision => 2,
        :format => '%n %u'
      }
    }
  },

  # Active Record
  :active_record => {
    :error => {
      :header_message => ["No se puede guardar {{object_name}}: 1 error.", "No se puede guardar {{object_name}}: {{count}} errores."],
      :message => "Por favor, comprueba lo siguiente:"
    }
  },
  :active_record => {
    :error_messages => {
      :inclusion => "no está incluído en la lista",
      :exclusion => "no está disponible",
      :invalid => "no es válidos",
      :confirmation => "no concuerda con su confirmación",
      :accepted  => "tiene que ser aceptado",
      :empty => "no puede estar vacío",
      :blank => "no puede estar vacío",
      :too_long => "es demasiado largo (no puede mayor de {{count}} caracteres)",
      :too_short => "es demasiado corto (no puede menor de {{count}} caracteres)",
      :wrong_length => "no tiene la longitud correcta (tiene que ser de {{count}} caracteres)",
      :taken => "no está disponible",
      :not_a_number => "no es un número",
      :greater_than => "tiene que ser mayor que {{count}}",
      :greater_than_or_equal_to => "tiene que ser mayor o igual a {{count}}",
      :equal_to => "tiene que ser igual a {{count}}",
      :less_than => "tiene que ser menor que {{count}}",
      :less_than_or_equal_to => "tiene que ser menor o igual a {{count}}",
      :odd => "tiene que ser par",
      :even => "tiene que ser impar"
    }
  }
}