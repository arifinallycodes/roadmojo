# Trip name input
TRIP_NAME = "input#trip_name"
# Selector for geocoding input
PLACE_INPUT = "input.place-geocode"
# Sortable list
SORTABLE = "#sortable"
# Create new place button
NEW_PLACE_BUTTON = "#create-new-place"
# Select year field
SELECT_YEAR = "select#trip-date[name='trip[trip_date(1i)]']"
# Select month field
SELECT_MONTH = "select#trip-date[name='trip[trip_date(2i)]']"
# Draft version tooltip
DRAFT_VERSION_CHECKBOX = "#draftVersionTooltip"
# Maximum no of places added as of this moment
MAX_NO_OF_PLACES = 10
# Map canvas
MAP = "div#map_canvas"
# Alert message
ALERT_MESSAGE = ".alert.alert-error"
# Places
ALL_PLACES = 'ul#sortable li'
# Submit add places button
SUBMIT_ADDING_PLACES = '.add-places-submit-form'
# Places list from the sortable div
PLACES_LIST = '#sortable li'
#
ROAD_NOT_FOUND_BOX = '.road_not_found_box'

class PlacesGrid
  TRIP_PLACE_NAME = "input.trip_place_name"
  TRIP_PLACE_LAT = "input.trip_place_lat"
  TRIP_PLACE_LON = "input.trip_place_lon"
  PLACE_LI = "li.place_li"

  constructor: (@map) ->
    _checkForMoreThanTwoPlaces()
    $(SORTABLE).disableSelection()
    $(SORTABLE).sortable({
      placeholder: "ui-state-highlight"
      stop: (event, ui) =>
        _redrawRoute()
        _checkAdjacency()
    })
    _redrawRoute()
    if _tenPlaces()
      _displayNoticeAndDisableInput()


  _generateLi = (place, lat, lon) ->
    "<li class='ui-state-default place_li'> #{place} <button class='remove_place close'>&times;</button>
    <input class='trip_place_name' name='trip[places][][name]' type='hidden' value='#{place}' />
    <input class='trip_place_lat' name='trip[places][][lat]' type='hidden' value='#{lat}' />
    <input class='trip_place_lon' name='trip[places][][lon]' type='hidden' value='#{lon}' />
    </li>"

  _onlyOne = (placeName) ->
    $("#{TRIP_PLACE_NAME}[value='#{placeName}']").length == 1
    # console.log $("#{TRIP_PLACE_NAME}[value='#{placeName}']").length

  _tenPlaces = ->
    $( PLACES_LIST ).size() >= MAX_NO_OF_PLACES

  # if places are 10 then disable the input box and display an error message
  _displayNoticeAndDisableInput = ->
    $('input#place-geocode').attr 'disabled','true' #disable the text box to add any more inputs
    $('.row-fluid .add-places').prepend "<div class='alert alert-success places-error fade in'><button type='button' class='close' data-dismiss='alert'>×</button><strong>Sorry</strong>, more than 10 places are not allowed at this moment.</div>"

  # enable the input and hide the error message when the no of places are less than 10
  _removeNoticeAndEnableInput = ->
    $('input#place-geocode').removeAttr 'disabled'
    $('.row-fluid .add-places .places-error button').trigger 'click'

  _getCoords = ->
    ([lat.value, $(lat).next().val()] for lat in $(TRIP_PLACE_LAT))

  _redrawRoute = ->
    if $("#{SORTABLE} > #{PLACE_LI}").length > 1
      @map.show()
      @map.showRoute(_getCoords(), "Car")
    else
      $(MAP).hide()

  _checkForMoreThanTwoPlaces = ->
    $(SUBMIT_ADDING_PLACES).click =>
      if $( PLACES_LIST ).size() < 2
        $('.row-fluid .add-places').prepend "<div class='alert alert-error places-error fade in'><button type='button' class='close' data-dismiss='alert'>×</button><strong>Sorry</strong> you need to add at least two places to a trip</div>"
        return false
      

  _checkAdjacency = () ->
    $ ->
      showAlert = false
      parent = $(SORTABLE).parent()
      coords = _getCoords()
      return if coords.length < 2

      for coord, i in coords[0..(coords.length - 2)]
        if coord[0] == coords[i + 1][0] && coord[1] == coords[i + 1][1]
          showAlert = true
          break

      if showAlert
        parent.addClass("alert-error")
        parent.tooltip({
          title: "There is a dupliacted place adjacent to itself."
        }).tooltip("show")
      else
        parent.removeClass("alert-error")
        parent.tooltip("destroy")

  _hideErrorIfAny = ->
    if $(ALERT_MESSAGE).size() is 1 and $(ALL_PLACES).size() >= 2
      $(ALERT_MESSAGE).remove()

  addPlace: (place, lat, lon) ->
    # alert "adding place now"
    $(SORTABLE).append(_generateLi(place, lat, lon))
    _redrawRoute()
    _checkAdjacency()
    $(PLACE_INPUT).val('')
    _hideErrorIfAny()
    # alert "Done!"
    if $('#submit-follow-places').data('page') == 'follow'
      $('#submit-follow-places').trigger('click')
    if _tenPlaces() # limit the no of places added
      _displayNoticeAndDisableInput()
    

  removePlace: (jqueryPlace) ->
    placeName = jqueryPlace.find(TRIP_PLACE_NAME).val()
    placeLat = jqueryPlace.find(TRIP_PLACE_LAT).val()
    placeLon = jqueryPlace.find(TRIP_PLACE_LON).val()
    jqueryPlace.remove()
    _redrawRoute()
    _checkAdjacency()
    if !_tenPlaces()  # enable the disabled input
      _removeNoticeAndEnableInput()

  showAlert: (title, content) ->
    $(NEW_PLACE_BUTTON).data("popover", null).popover({
      title: title,
      content: content
    }).popover("show")

  clearAlert: ->
    $(NEW_PLACE_BUTTON).popover("hide")

class Geocoder
  constructor: (@grid) ->
    @geocoder = new google.maps.Geocoder

  _isACity = (geocodeResult) ->
    types = geocodeResult["types"]
    types[0] isnt "country" and types[1] is "political"

  validate: (text) ->
    # alert "in validate function for geocoder, will alert text now"
    # result = @geocoder.geocode({"address": text},())
    result = @geocoder.geocode({ 'address': text }, ( (results, status) ->
      # alert "alerting status now"
      # alert status
      if status is google.maps.GeocoderStatus.OK
        # alert "status is OK"
        # alert results
        result = results[0]
        # alert result
        # console.log result
        name = result["address_components"][0]["long_name"] 
        if _isACity(result)
          # alert "its a city so we will go ahead and add a place"
          lat = result["geometry"]["location"].lat()
          lon = result["geometry"]["location"].lng()
          @grid.addPlace(name, lat, lon)
        else
          @grid.showAlert("Place is not a city", "It seems that #{text}" +
            " is not a city. Please try entering a city name.")
      else
        @grid.showAlert("Place not found", "Sorry, but we couldn't find #{text}")
    ))

class Map
  constructor: ->
    options =
      zoom: 8,
      center: new google.maps.LatLng(-34.397, 150.644),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    @map = new google.maps.Map($(MAP)[0], options)
    @directionsService = new google.maps.DirectionsService
    @directionsDisplay = new google.maps.DirectionsRenderer
    @directionsDisplay.setMap(@map)
    windowResizeHandler()

  _getTravelMode = (transport) ->
    if transport == "Bicycle" then google.maps.TravelMode.BICYCLING else google.maps.TravelMode.DRIVING

  _routeNotFound = (desc = "") ->
    # $(MAP).parent().append("<div class='alert alert-info'></div>")
    # $(".row-fluid div.alert").append("Unfortunately no route could be found. #{desc}")
    # $(MAP).parent().append("<div class='road-not-found-box'></div>")
    $('#items-box').append("<div class='road-not-found-box'></div>")
    $('.road-not-found-box').css("margin","3% 0 3% 16%")
    $('.road-not-found-box').html("<img src='/assets/road_not_found.jpg'/>")
    $(MAP).remove()
    # 3% 0 3% 16%

  show: ->
    $(MAP).show()
    $('.instruction').removeClass('hide');
    google.maps.event.trigger(@map, "resize")

  showRoute: (places, transport) ->
    [start, points..., end] = (new google.maps.LatLng(lat, lon) for [lat, lon] in places)

    unless start? and end?
      _routeNotFound("You have to specify at least two places for a route to be calculated.")
      return

    waypoints = ({ location: point } for point in points)
    directionsRequest =
      origin: start
      waypoints: waypoints
      destination: end
      travelMode: _getTravelMode(transport)
    @directionsService.route(directionsRequest, (result, status) =>
      switch status
        when google.maps.DirectionsStatus.OK then @directionsDisplay.setDirections(result)
        when google.maps.DirectionsStatus.ZERO_RESULTS 
          if transport == "Bicycle" then @showRoute(places, "Car") else _routeNotFound()
        else _routeNotFound()
    )

  windowResizeHandler = ->
    $(window).resize( ->
      $(MAP).css("height", "300px")
    ).resize()

setMonths = ->
  currentDate = new Date
  if $(SELECT_YEAR)[0].value is currentDate.getFullYear().toString()
    currentMonth = currentDate.getMonth()
    $(SELECT_MONTH + " option:gt(#{currentMonth})").hide()
    # Reset month to last possible when selected month is in the future
    $(SELECT_MONTH).val(currentMonth) if $(SELECT_MONTH)[0].value > currentMonth + 1
  else
    $(SELECT_MONTH + " option").show()

jQuery =>
  # Show map
  if $(MAP).length > 0
    @map = new Map
  
  paths = location.pathname.split('/')

  # if paths[2] == 'trips' and paths[3] == 'new'
    # window.onbeforeunload = ->
    #   "You have not completed saving the trip[choose an appropriate message here !]"

  # Edit trip
  if $(PLACE_INPUT).length > 0
    @grid = new PlacesGrid(@map)
    @geocoder = new Geocoder(@grid)

    $(PLACE_INPUT).geocomplete()

    $(document).on("click", "button.remove_place", (e) =>
      e.preventDefault()
      @grid.removePlace($(e.target).parent())
    )

    $(NEW_PLACE_BUTTON).click =>
      # alert @geocoder
      # alert "inside NEW_PLACE_BUTTON click"
      @geocoder.validate($(PLACE_INPUT).val()) if $(PLACE_INPUT).val()

    $(PLACE_INPUT).click =>
      @grid.clearAlert()

    setMonths()
    $(SELECT_YEAR).change (e) ->
      setMonths()

    if $(TRIP_NAME).val()
      $(TRIP_NAME).data("tooltip", null).tooltip({
        title: "Changing the trip name will change its public URL.",
        trigger: "focus"
      })

    $(DRAFT_VERSION_CHECKBOX).data("tooltip", null).tooltip({
      title: "Draft trips will only be visible to you",
      placement: "right"
    })
