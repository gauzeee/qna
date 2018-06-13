# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on('turbolinks:load', ->
  addComment = (e) ->
    e.preventDefault();
    $(this).hide();
    klass = $(this).data('klass')
    id = $(this).data('id')
    $('form#comment' + '-' + klass + '-' + id).show()

  $(document).on 'click', '.new-comment-link', addComment
)
