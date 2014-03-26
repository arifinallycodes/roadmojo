class MetaRoad

  ZERO = 0

  # increments column value for any model instance
  # 
  # Usage : MetaRoad.increment_count( trip, 'no_of_likes' )
  def self.increment_count( model_instance, column_name )
    count = model_instance.send(column_name)
    model_instance.update_column( column_name, count + 1 )
  end

  # decrements column value for any model instance
  # 
  # Usage : MetaRoad.decrement_count( trip, 'no_of_likes' )
  def self.decrement_count( model_instance, column_name )
    count = model_instance.send(column_name)
    model_instance.update_column( column_name, count - 1 ) unless count <= ZERO
  end
end