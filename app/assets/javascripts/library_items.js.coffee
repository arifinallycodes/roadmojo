LOCATION_LINK = '.location-link'
class LibraryItems
  @form: -> $("#items-form")
  location: -> $("#item-place")
  items: -> $("#items")
  descriptionDiv: -> $("#inb-description")
  descriptionText: -> $("#description")
  descriptionUpdate: -> $("#update")
  # saveButton: -> $("#save")
  saveButton: -> $(".save-library-item")
  itemType: -> $("#item-type")
  itemText: -> $(".item-text")
  itemName: -> $("#item-name")
  itemDesc: -> $("#item-desc")
  newItem: -> $("#new")
  # locationLink: -> $(".location-link")
  # newItem: -> $(".new-item")

  ITEM = ".library_item"
  DELETE_ITEM = ".delete-item"

  constructor: ->
    @registerHandlers()
    @getItemsForLocation()
    @toggleDescription()
    $('.location-link:first').trigger('click') # sadly done !

  registerHandlers: ->
    @itemText().keyup( => 
      len = @itemName().val().length * @itemDesc().val().length
      if len > 0 then @enableSave() else @disableSave()
    )
    @_locationSelectBinding()
    @_loadingLibraryItemsOnClick()
    @_inbetweenDescriptionBinding()
    @_saveButtonBinding()
    @_itemBinding()
    @_newItemBinding()

  # enableSave: -> @saveButton().attr("disabled", false)
  enableSave: -> $(".save-library-item").attr("disabled", false)
  disableSave: -> $(".save-library-item").attr("disabled", "disabled")

  editMode: (id) ->
    # @saveButton().html("Update")
    $(".save-library-item").html("Update")
    # @saveButton().data("id", id)
    $(".save-library-item").data("id", id)

  newMode: ->
    # @saveButton().html("Add an item")
    $(".save-library-item").html("Add an item")
    # @saveButton().removeData("id")
    $(".save-library-item").removeData("id")

  clearForm: ->
    @itemType()[0].selectedIndex = 0
    @itemText().val("")
    @newMode()

  getItemsForLocation: (val, inbetween_place, type_of_page)->
    $.ajax(
      url: "/library_items",
      # data: @_getSelectedLocation()
      data: @_getSelectedLocationForLibraryItem(val, inbetween_place, type_of_page)
      success: (data) => @items().html(data),
      dataType: "html"
    )

  _getSelectedLocationForLibraryItem: (val, inbetween_place, type_of_page)->
    if inbetween_place
      { inbetween_id: val , type_of_page: type_of_page }
    else
      { trip_place_id: val , type_of_page: type_of_page }
    
  toggleDescription: ->
    if @_inbetweenSelected()
      @descriptionDiv().show()
    else
      @descriptionDiv().hide()

  getDescription: ->
    $.getJSON("/inbetween", 
      place_id: @_locationId()
      (data) => @descriptionText().val(data.description)
    )

  _inbetweenSelected: ->
    @location().prop("selectedIndex") % 2 isnt 0

  _locationId: ->
    parseInt(@location().val(), 10)

  _getSelectedLocation: =>
    selectedValue = @_locationId()
    if @_inbetweenSelected()
      { inbetween_id: selectedValue }
    else
      { trip_place_id: selectedValue }

  _locationSelectBinding: ->
    @location().change(=> 
      @_loadingLibraryItems()
    )

  _loadingLibraryItemsOnClick: ->
    # $(".location-link").click ->
    _this = this
    # @locationLink().click ->
    # $('.location-link').click(=>
    $(LOCATION_LINK).click (e)->
      type_of_page = $('#type-of-page').val()
        
      e.preventDefault()
      $('.active-link').removeClass "active-link"
      $(this).addClass "active-link"
      val = $(this).data "val"
      inbetween_place = $(this).data("inbetween-place")
      # if $(this).data("inbetween-place")
      _this._loadingLibraryItems(val, inbetween_place, type_of_page) # anti-pattern
        # @_loadingLibraryItems() 
    # )

  _loadingLibraryItems: (val, inbetween_place, type_of_page)->
    @getItemsForLocation(val, inbetween_place, type_of_page)
    # @clearForm() if @saveButton().data("id")
    @clearForm() if $(".save-library-item").data("id")
    @toggleDescription()
    @getDescription()

  _inbetweenDescriptionBinding: ->
    @descriptionUpdate().click( =>
      data = 
        description: @descriptionText().val(),
        place_id: @_locationId()
      $.ajax(
        url: "/inbetween",
        type: "PUT",
        data: data,
        success: (data) =>
      )
    )

  _saveButtonBinding: ->
    # @saveButton().click( =>
    $(".save-library-item").click( =>
      location = @_getSelectedLocation()
      location.item =
        name: @itemName().val()
        item_type: @itemType().val()
        description: @itemDesc().val()

      # Post for new items, put for existing ones
      # itemId = @saveButton().data("id")
      itemId = $(".save-library-item").data("id")
      if itemId
        location.item.id = itemId
        $.ajax(
          url: "/library_item",
          type: "PUT",
          data: location,
          success: (data) => 
            @getItemsForLocation()
            @clearForm()
        )
      else
        $.post("/library_items", location, => (
          @getItemsForLocation()
          @clearForm()
        ))
    )

  _editItem: (itemData) ->
    @itemType().val(itemData.item_type)
    @itemName().val(itemData.name)
    @itemDesc().val(itemData.description)
    @enableSave()
    @editMode(itemData.id)

  _itemBinding: ->
    @items().on("click", ITEM, (e) =>
      $.getJSON("/library_item", 
        item_id: e.target.parentElement.id,
        (data) => @_editItem(data)
      )
    )
    @items().on("click", DELETE_ITEM, (e) =>
      e.stopPropagation()
      if confirm "Are you sure ?"
        val = $('.items-heading').data 'id'
        inbetween_place = $('.items-heading').data 'inbetween-place'
        $.ajax(
          url: "/library_item",
          type: "DELETE",
          # data: locAttr
          data:
            item_id: $(e.target).parent().data 'id',
          success: =>
            #TODO what if editing given item?
            @getItemsForLocation(val, inbetween_place, $('#type-of-page').val())
            #@saveButton().removeData("id")
        )
    )

  _newItemBinding: ->
    @newItem().click( =>
      @clearForm()
      @disableSave()
      @newMode()
    )

$ ->
  # if LibraryItems.form().length
    new LibraryItems()
