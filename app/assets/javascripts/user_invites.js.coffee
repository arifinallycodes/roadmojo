$(document).ready ->
  $('form#invite-users').bind 'ajaxSuccess', (event, data) ->
    alert "alert-success"
    $('.container-fluid').append("
      <div class='alert alert-success'> 
        <a class='close' data-dismiss='alert'>×</a>"
        + data +
        "</div>")

  $('form#invite-users').bind 'ajaxError', (event, data) ->
    alert "alert-error"
    $('.container-fluid').append("
      <div class='alert alert-error'> 
        <a class='close' data-dismiss='alert'>×</a>"
        + data +
        "</div>")