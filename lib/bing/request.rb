require "faraday"
require "bing/version"

##
# Responsible for making requests to Bing REST API.
class Bing::Request
  USER_AGENT = "Bing Client Version: #{Bing::VERSION}"

  HTTP = Faraday.new(headers: { user_agent: USER_AGENT }) do |builder|
    builder.request :url_encoded
    builder.adapter Faraday.default_adapter
  end

  ##
  # Perform a get request and ensure that the response.code == 20\d,
  # otherwise raise a BadGateway.
  def self.get(uri)
    response = HTTP.get(uri)

    puts uri if ENV["DEBUG"]

    if response.status >= 400
      raise Bing::BadGateway.bad_response(response.status, uri)
    end

    response
  end
end

