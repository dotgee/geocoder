require 'geocoder/lookups/base'
require "geocoder/results/geocode_farm"
require 'uri'

module Geocoder::Lookup
  class GeocodeFarm < Base

    BASE_URI = "https://www.geocode.farm/v3/json/%s/?"

    def use_ssl?
      true
    end

    def name
      "GeocodeFarm"
    end

    def query_url(query)
      action = if query.reverse_geocode?
          'reverse'
         else
           'forward'
         end
    
      geocode_uri = BASE_URI % [ action ] + url_query_string(query)
      # url = URI.encode("http://www.geocodefarm.com/api/#{action}/json/#{configuration.api_key}/#{params}/")
      url = URI.encode(geocode_uri)
      puts "GEOCODE FARM REQUEST: #{url}"
      url
    end

    private # ---------------------------------------------------------------

    def results(query, reverse = false)
      return [] unless doc = fetch_data(query)
      request_results = doc['geocoding_results']
      return [] if request_results.nil?
      case request_results['STATUS']['status']; when 'SUCCESS'
        return [request_results]
      when 1, 3, 4
        raise_error(Geocoder::Error, messages) ||
          warn("Geocodefarm Geocoding API error: server error.")
      when 2
        raise_error(Geocoder::InvalidRequest, messages) ||
          warn("Geocodefarm Geocoding API error: invalid request.")
      when 5
        raise_error(Geocoder::InvalidApiKey, messages) ||
          warn("Geocodefarm Geocoding API error: invalid api key.")
      when 101, 102, 200..299
        raise_error(Geocoder::RequestDenied) ||
          warn("Geocodefarm Geocoding API error: request denied.")
      when 300..399
        raise_error(Geocoder::OverQueryLimitError) ||
          warn("Geocodefarm Geocoding API error: over query limit.")
      end
      return []
    end

    def query_url_params(query)
      {
        (query.reverse_geocode? ? :location : :addr) => query.sanitized_text,
        key:     configuration.api_key,
        lang:    query.options[:lang],
	country: query.options[:country],
	count: 1
      }.select { |_, value| !( value.nil? || value.to_s.strip.empty? ) }.merge(super)
    end

  end
end

