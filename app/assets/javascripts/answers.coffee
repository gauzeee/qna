$(document).bind 'ajax:error', (e) ->
    [data, status, xhr] = e.detail;
    document.location = '/users/sign_in' if xhr.status == 401
    alert 'Sign in before'


editAnswerListener = ->
  bestAnswer = (e) ->
    e.preventDefault();
    answer_id = $(this).data('answerId')
  editAnswer = (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  $('.answers').on 'click', '.edit-answer-link', editAnswer
  $('.best-answer').on 'click', '.edit-answer-link', editAnswer
  $('.answers').on 'click', '.set-best-answer', bestAnswer

$(document).ready(editAnswerListener)
$(document).on('turbolinks:load', editAnswerListener)




