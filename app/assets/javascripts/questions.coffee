editQuestionListener = ->
  editQuestion = (e) ->
    e.preventDefault();
    $(this).hide();
    $('.edit-question-form').show()

  $('.edit-question-link').click editQuestion

hideAttachField = ->
  hideAttach = (e) ->
  removeField = $('.remove_fields')
  removeField.click()

$(document).ready(editQuestionListener)
$(document).on('turbolinks:load', editQuestionListener)
$(document).on('turbolinks:load', hideAttachField)


$ ->
  questionsList = $('.question-list-inside')
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
      ,

    received: (data) ->
      questionsList.append data
  })
