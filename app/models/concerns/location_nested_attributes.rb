module LocationNestedAttributes
  module InstanceMethods
    def location_attributes=(new_location)
      existing_location = Location.find_by(city: new_location[:city])
      if existing_location && existing_location.state == new_location[:state]
        self.location = existing_location
      else
        self.location = Location.create(city: new_location[:city], state: new_location[:state])
      end
    end
  end 
end
