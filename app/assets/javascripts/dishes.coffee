$ ->
  new PureFormHandler '#dishform'

  $(document).on 'click', '.delete', (e) ->
    e.preventDefault()
    successurl = $(@).data('successurl')
    tocallurl = $(@).data('tocallurl')
    $.ajax
      url: tocallurl
      type: 'DELETE'
      contentType: 'application/json'
      dataType: 'text'
      success: (result) ->
        window.location = successurl

class PureFormHandler
  constructor: (selector) ->
    $(document).on 'ajax:success', "#{selector} form", @redirect_to_object
    $(document).on 'ajax:error',   "#{selector} form", @displayErrors

  redirect_to_object: (e, response) ->
    e.preventDefault()
    id = response['dish']['id']
    url = response['dish']['url']
    window.location = url

  displayErrors: (e, response) ->
    e.preventDefault()
    data = $.parseJSON(response.responseText)
    error_messages = []
    Object.keys(data).forEach (key) ->
      value = data[key]
      Object.keys(value).forEach (key2) ->
        error_message = key2 + ' ' + value[key2]
        error_messages.push(error_message)
    $(@).displayErrors error_messages
