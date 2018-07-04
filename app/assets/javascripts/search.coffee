# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
searchListener = ->
  search = (e) ->
    e.preventDefault();
    $(this).hide();
    $('.search-form').show()

  $('.search-link').click search

  closeSearch = (e) ->
    $('.search-form').hide()
    $('.search-link').show()

  $('.closer').click closeSearch

$(document).ready(searchListener)
$(document).on('turbolinks:load', searchListener)
