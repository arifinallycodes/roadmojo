class TripDecorator < Draper::Decorator
  delegate_all

  def name_item
    definition_entry(:name, model.name)
  end

  def place_items
    items = model.places.each.with_index(1).with_object("") do |(place, index), result|
      result << definition_entry("Location #{index}", place.name) 
    end
    h.raw items
  end

  def library_items
    items = model.items.each.with_object("") do |item, result|
      result << definition_entry(item["name"], "#{item["item_type"]} in #{item["place"]}")
    end
    h.raw items
  end

  def description_item
    definition_entry(:description, model.description)
  end

  def transport_item
    definition_entry(:transport, model.transport)
  end

  def trip_date_item
    definition_entry(:trip_date, model.trip_date)
  end

  private

  def definition_entry(item, description)
    item = model.class.human_attribute_name(item) if item.is_a? Symbol

    if description.present?
      dt = h.content_tag :dt do
        h.content_tag :strong, item
      end
      dt << h.content_tag(:dd, description)
    end
  end

  # Accessing Helpers
  #   You can access any helper via a proxy
  #
  #   Normal Usage: helpers.number_to_currency(2)
  #   Abbreviated : h.number_to_currency(2)
  #
  #   Or, optionally enable "lazy helpers" by including this module:
  #     include Draper::LazyHelpers
  #   Then use the helpers with no proxy:
  #     number_to_currency(2)

  # Defining an Interface
  #   Control access to the wrapped subject's methods using one of the following:
  #
  #   To allow only the listed methods (whitelist):
  #     allows :method1, :method2
  #
  #   To allow everything except the listed methods (blacklist):
  #     denies :method1, :method2

  # Presentation Methods
  #   Define your own instance methods, even overriding accessors
  #   generated by ActiveRecord:
  #
  #   def created_at
  #     h.content_tag :span, attributes["created_at"].strftime("%a %m/%d/%y"),
  #                   :class => 'timestamp'
  #   end
end
