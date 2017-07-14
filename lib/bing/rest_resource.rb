require "bing"

class Bing::RestResource
  class RateLimitedResponseError < StandardError; end

  ##
  # Base Bing Rest route.
  BASE_PATH = "/REST/#{Bing.config[:api_version]}"

  def initialize(resource)
    parse_resource(resource)
  end

  def parse_resource(resource)
    raise "Subclass responsibility"
  end

  def self.map_uri params
    Bing.config[:map_uri].merge(
      "#{path}?key=#{Bing.config[:api_key]}&#{params}"
    )
  end

  def self.map_find params
    resp = Bing::Request.get( map_uri(params) )
    body = JSON.parse resp.body

    if resp.headers["x-ms-bm-ws-info"] == "1"
      raise RateLimitedResponseError
    end

    body["resourceSets"].first["resources"].map do |resource|
      new resource
    end.compact
  end

  def self.path subclass_path = nil
    "#{BASE_PATH}#{subclass_path}"
  end

  attr_reader :bounding_box

  ##
  # Decipher bounding box from bbox in Bing response.
  def bbox box
    south, west, north, east = *box
    {
      :north => north,
      :east  => east,
      :south => south,
      :west  => west,
    }
  end

  private

  def self.format_waypoints waypoints
    return unless waypoints
    ways = []

    waypoints.each_with_index do |way, i|
      ways << "waypoint.#{i}=#{CGI.escape way}"
    end

    ways.join "&"
  end
end

