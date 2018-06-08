$(document).on('turbolinks:load', ->
  answersList = $('.answers')

  questionId = $('.question').data('questionId')

  App.cable.subscriptions.create({ channel: 'AnswersChannel', question_id: questionId }, {
    connected: ->
      @perform 'follow'
    ,

    received: (data) ->
      $(".answers").append(JST["templates/answer"](data));
      if (gon.current_user.id != data.answer.user_id)
        $('.rate .up-down').bind 'ajax:success', (e) ->
          [data, status, xhr] = e.detail;
          voteContainerClass = '.' + data.klass + '-' + data.id
          $(voteContainerClass + ' .rating').html(data.rating)
          $(voteContainerClass + ' .revoke-link').removeClass('revoke-link-hider')

        $('.rate .revoke-link').bind 'ajax:success', (e) ->
          [data, status, xhr] = e.detail;
          voteContainerClass = '.' + data.klass + '-' + data.id
          $(voteContainerClass + ' .rating').html(data.rating)
          $(voteContainerClass + ' .revoke-link').addClass('revoke-link-hider')
  })
)
