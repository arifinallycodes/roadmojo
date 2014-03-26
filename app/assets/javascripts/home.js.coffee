# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->

  $('.scoll-down-to-home-level').click ->
    $("body,html").animate
      scrollTop: $("body").height()
    , 1000
# TODO Clean up this whole file and write a proper class and methods
  $('body').click ->
    dropdown = $('ul.dropdown-header-menu')
    if !dropdown.hasClass( 'hide' )
      dropdown.addClass( 'hide' )

  $('.question').click ->
    _this  = $(this)
    faq_icon = _this.find '.faq-icon'
    open_image_src  = location.origin + '/assets/faq-icon-open.png'
    close_image_src = location.origin + '/assets/faq-icon-close.png'
    answer = _this.parent().find '.answer'
    if answer.hasClass 'hide'
      faq_icon.attr('src', open_image_src )
      answer.slideDown "100"
      answer.removeClass 'hide'
    else
      faq_icon.attr('src', close_image_src )
      answer.slideUp "100"
      answer.addClass 'hide'


  $('#dropdown-header-toggle').click (e)->
    e.stopPropagation()
    hide = 'hide'
    dropdown = $('ul.dropdown-header-menu')

    if dropdown.hasClass( hide )
      dropdown.removeClass( hide )
    else
      dropdown.addClass( hide )
    

  # $('#header-nav li').click ->
  #   alert "clicked"
  #   _this = $(this)
  #   active_header = '.active-header'
  #   active_header_li = '.active-header-li'

  #   current_active_header_li = _this.siblings( active_header_li )
  #   current_active_header = current_active_header_li.find active_header

  #   current_active_header_li.removeClass active_header_li
  #   current_active_header.removeClass active_header

  #   _this.addClass active_header_li
  #   _this.childred().addClass active_header