function start_outbound_delivery_creation() {
  $('#process_status').attr('checked', true);
  $('#odf_0').submit();
}

function stop_outbound_delivery_creation() {
  $('#process_status').attr('checked', false);
}


$(function($){ 

 $(".odf")
    .bind('ajax:beforeSend', function(data, status, xhr) {$(this).find('.errors').html('<span>Sending</span>');})
    .bind('ajax:success', function(data, status, xhr) {;})
    .bind('ajax:error', function(xhr, status, error) {$(this).find('.errors').html('<span>Error</span>');})
    .bind('ajax:complete', function() {
      if ($('#process_status').is(':checked')) {
        var selector = '#' + $(this).attr('id').split('_')[0] + '_' + (parseInt($(this).attr('id').split('_')[1]) + 1);
        if ($(selector).length) {
          $(selector).submit();
        }
      }        
    });
      
});
