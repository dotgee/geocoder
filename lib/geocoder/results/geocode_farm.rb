require 'geocoder/results/base'

module Geocoder::Result
  class GeocodeFarm < Base

    attr_accessor :copyright, :account, :status, :statistics

    def initialize(data)
      super
      @data       = data['RESULTS'].first
      @copyright  = data['LEGAL_COPYRIGHT']
      @account    = data['ACCOUNT']
      @status     = data['STATUS']
      @statistics = data['STATISTICS']
    end

    def coordinates
      ['latitude', 'longitude'].map{ |i| @data['COORDINATES'][i] }
    end

    def address(format = :full)
      formatted_address
    end

    def address_components
      @data['ADDRESS']
    end

    ##
    # Get address components of a given type. Valid types are defined in
    # Google's Geocoding API documentation and include (among others):
    #
    #   :street_number
    #   :locality
    #   :neighborhood
    #   NOPE :route
    #   :postal_code
    #
    def address_components_of_type(type)
      address_components[type.to_s] # .select{ |c| c['types'].include?(type.to_s) }
    end

    def city
      address_components_of_type(:locality)
    end

    #def state
    #  if state = address_components_of_type(:administrative_area_level_1).first
    #    state['long_name']
    #  end
    #end

    #def state_code
    #  if state = address_components_of_type(:administrative_area_level_1).first
    #    state['short_name']
    #  end
    #end

    #def sub_state
    #  if state = address_components_of_type(:administrative_area_level_2).first
    #    state['long_name']
    #  end
    #end

    #def sub_state_code
    #  if state = address_components_of_type(:administrative_area_level_2).first
    #    state['short_name']
    #  end
    #end

    def country
      address_components.last
    end

    #def country_code
    #  if country = address_components_of_type(:country).first
    #    country['short_name']
    #  end
    #end

    def postal_code
      address_components[1].split(/\s+/).first
    end

    def route
      address_components_of_type(:street_name)
    end

    def street_number
      address_components_of_type(:street_number)
    end

    def street_address
      [street_number, route].compact.join(' ')
    end

    def formatted_address
      @data['formatted_address']
    end

    def precision
      @data['accuracy']
    end
  end
end
