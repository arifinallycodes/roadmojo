# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

LIKE_BUTTON = '.like-async'

class LikeTrip

  constructor: ->
    @_likeATrip()

  _likeATrip: ->
    $( LIKE_BUTTON ).click =>
      if @_isLiked()
        # Post unlike url
        $.ajax(
          url: @_unLikeURL(),
          type: "POST",
          success: =>
            $( LIKE_BUTTON ).data 'like', 'unliked'
            $( LIKE_BUTTON ).html 'Like'
        )
      else
        # Post Like url
        $.ajax(
          url: @_likeURL(),
          type: "POST",
          success: =>
            $( LIKE_BUTTON ).data 'like', 'liked'
            $( LIKE_BUTTON ).html 'Unlike'
        )

  _isLiked: ->
    liked_data = $( LIKE_BUTTON ).data 'like'
    if liked_data == 'liked'
      return true
    else
      return false
    

  _unLikeURL: ->
    return @_stripURL() + '/unlike.json'
  _likeURL: ->
    return @_stripURL() + '/like.json'

  _stripURL: ->
    thisUrl = location.href
    myRegExp = new RegExp("([^(?#)]*)")
    thisUrl = myRegExp.exec(thisUrl)
    return thisUrl[0]

$ ->
  new LikeTrip()