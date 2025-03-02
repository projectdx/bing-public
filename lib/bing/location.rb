require 'bing/rest_resource'

##
# Responsible for obtaining a location based off of data passed in.

class Bing::Location < Bing::RestResource

  ##
  # Will find locations based off of +query+ and return an array of
  # Bing::Location objects. Will support any param that bing supports.
  #
  # === Example
  #
  # Bing::Location.find :query => '123 Address City State'

  def self.find opts
    map_find opts.to_lower_camelized_param
  end

  ##
  # Path to route resource.

  def self.path
    super '/Locations'
  end

  attr_reader :address
  attr_reader :canonical_description
  attr_reader :coordinates
  attr_reader :city
  attr_reader :confidence
  attr_reader :calculation_method
  attr_reader :country
  attr_reader :county
  attr_reader :entity_type
  attr_reader :full_name
  attr_reader :state
  attr_reader :zip
  attr_reader :latitude
  attr_reader :longitude

  def parse_resource(resource)
    raise Bing::LocationResourceMissing if resource.blank?

    @confidence  = resource['confidence']
    @entity_type = resource['entityType']
    @full_name   = resource['name']

    if resource['address'] then
      @address = resource['address']['addressLine']
      @city    = resource['address']['locality']
      @country = resource['address']['countryRegion']
      @state   = resource['address']['adminDistrict']
      @county  = resource['address']['adminDistrict2']
      @zip     = resource['address']['postalCode']
    end

    if resource['point']
      @latitude, @longitude = resource['point']['coordinates']
      if resource['geocodePoints']
        # use the calculation method of the geocode Point that matches the
        # coordinates of the point
        @calculation_method = resource['geocodePoints'].detect { |p|
          p['coordinates'] == resource['point']['coordinates']
        }['calculationMethod']
      end
    end

    if resource['bbox'] then
      @bounding_box = bbox resource['bbox']
    end

    if resource['point'] && resource['point']['coordinates'] then
      @coordinates = resource['point']['coordinates']
    end
  end
end

