$.fn.displayErrors = (errors) ->
  if errors.length > 1
    div_content = $("<ul>")
    for error in errors
      div_content.append $("<li>").html(error)
  else if errors.length == 1
    div_content = errors[0]
  $(@).find('.alert.alert-danger').removeClass('hidden').html(div_content).show()
