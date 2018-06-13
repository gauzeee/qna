$(document).on('turbolinks:load', ->
  questionId = $('.question').data('questionId')

  App.cable.subscriptions.create({ channel: 'CommentsChannel', question_id: questionId }, {
    connected: ->
      @perform 'follow'
    ,

    received: (data) ->
        resourseContainer = '.' + data.klass.toLowerCase() + '-' + data.id
        $(resourseContainer + ' .comments').append(JST["templates/comment"](data))
  })
)
