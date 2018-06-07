rateListener = ->
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

$(document).on('turbolinks:load', rateListener)

