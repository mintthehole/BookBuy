function start_upload() {
  $('#process_status').attr('checked', true);
  $('#et_1').submit();
}

function stop_upload() {
  $('#process_status').attr('checked', false);
}


$(function($){ 

 $(".et")
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
