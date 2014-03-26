module TripsHelper
  def my_trip?( trip )
    current_user && current_user.slug == trip.user.slug
  end

  def short_date( trip )
    trip.trip_date.strftime("%b %Y")
  end

  def more_than_one_location?( locations )
    val = false
    if locations.count > 1
      val = true
    end
    val
  end

  def is_location_an_inbetween_place?( location )
    if location.class.name == "InbetweenPlace"
      return true
    else
      return false
    end
  end

  # gives button info for all the steps, their name and their disabling with info
  def get_button_info( form_title )
    info = {}

    case form_title
    when 'new_trip'
      info = { 
                draft: {
                    name: "Save as draft",
                    disable_with: "Saving.."
                  },
                next_step: {
                    name: "Next >",
                    disable_with: "Saving.."
                 }
              }  
    when 'edit_trip'
      info = { 
                draft: {
                    name: "Update as draft",
                    disable_with: "Updating.."
                  },
                next_step: {
                    name: "Next >",
                    disable_with: "Updating.."
                  }
              }  
    end

    return info
  end
end
