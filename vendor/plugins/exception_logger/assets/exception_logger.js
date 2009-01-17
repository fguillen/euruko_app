ExceptionLogger = {
  filters: ['exception_names', 'controller_actions', 'date_ranges'],
  setPage: function(num) {
    $('#page').val(num);
    $('#query-form').submit();
  },
  
  setFilter: function(context, name) {
    var filterName = '#' + context + '_filter'
    $(filterName).value = ($(filterName).val() == name) ? '' : name;
    this.deselect(context, filterName);
    $('#page').value = '1';
    $('#query-form').submit();
  },

  deselect: function(context, filterName) {
    $('#' + context + ' a').each(function(a) {
      var value = $(filterName) ? $(filterName).val() : null;
      a.className = (value && (a.getAttribute('title') == value || a.innerHTML == value)) ? 'selected' : '';
    });
  },
  
  deleteAll: function() {
    return $('#query-form').serialize() + '&' + jQuery.map($('tr.exception'), function(tr) { return 'ids[]=' + tr.id.replace(/^\w+-/, '') }).join('&');
  }
}

$(document).ready(function(){
  jQuery.each(ExceptionLogger.filters, function(context) {
    $(context + '_filter').value = '';
  });
});


$("#activity")
  .ajaxStart(function(){ $(this).show(250); })
  .ajaxStop(function(){ $(this).hide(250); }); 

