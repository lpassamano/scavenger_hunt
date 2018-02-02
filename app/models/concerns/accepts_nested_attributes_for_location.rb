module AcceptsNestedAttributesForLocation
  # Module to give functionality to classes to accept nested attr for location
  module InstanceMethods
    def location_attributes=(new_location)
      # checks if there is already location with the same city in the DB
      existing_location = Location.find_by(city: new_location[:city])
      if existing_location && existing_location.state == new_location[:state]
        # if the existing entry has the same city and state as new_location
        # the existing location is set as the location
        self.location = existing_location
      else
        # if the city and state do not match the existin entry a new location
        # is created and set as the location
        self.location = Location.create(
          city: new_location[:city],
          state: new_location[:state]
        )
      end
    end
  end
end
