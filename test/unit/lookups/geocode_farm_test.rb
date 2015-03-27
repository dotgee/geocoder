# encoding: utf-8
require 'test_helper'

class GeocodeFarmTest < GeocoderTestCase

  def setup
    Geocoder.configure(lookup: :geocode_farm)
    # set_api_key!(nil)
  end

  def test_geocode_farm_result_components
    # result = Geocoder.search("Madison Square Garden, New York, NY").first
    result = Geocoder.search("34 rue frederic le guyader, 35200, Rennes, France").first
    assert_equal "New York",
      result.address_components_of_type(:locality)
  end

  def test_geocode_farm_result_components_contains_street_name
    result = Geocoder.search("Madison Square Garden, New York, NY").first
    assert_equal "Pennsylvania Plaza",
      result.address_components_of_type(:street_name)
  end

  def test_geocode_farm_result_components_contains_street_number
    result = Geocoder.search("Madison Square Garden, New York, NY").first
    assert_equal "4",
      result.address_components_of_type(:street_number).to_s
  end

  def test_geocode_farm_street_address_returns_formatted_street_address
    result = Geocoder.search("Madison Square Garden, New York, NY").first
    assert_equal "4 Pennsylvania Plaza", result.street_address
  end

  def test_geocode_farm_precision
    result = Geocoder.search("Madison Square Garden, New York, NY").first
    assert_equal "EXACT_MATCH",
      result.precision
  end

  def test_geocode_farm_query_url_contains_address
    lookup = Geocoder::Lookup::GeocodeFarm.new
    url = lookup.query_url(Geocoder::Query.new(
      "Some Intersection"
    ))
    assert_match(/addr=Some\+Intersection/, url)
  end

  #def test_geocode_farm_query_url_contains_bounds
  #  lookup = Geocoder::Lookup::GeocodeFarm.new
  #  url = lookup.query_url(Geocoder::Query.new(
  #    "Some Intersection",
  #    :bounds => [[40.0, -120.0], [39.0, -121.0]]
  #  ))
  #  assert_match(/bounds=40.0+%2C-120.0+%7C39.0+%2C-121.0+/, url)
  #end

  def test_geocode_farm_query_url_contains_country
    lookup = Geocoder::Lookup::GeocodeFarm.new
    url = lookup.query_url(Geocoder::Query.new(
      "Some Intersection",
      :country => "gb"
    ))
    assert_match(/country=gb/, url)
  end

end
