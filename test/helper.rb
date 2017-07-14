require "rubygems"
require "logger"
require "minitest/autorun"

require "webmock"
require "webmock/minitest"

require "bing/location"
require "bing/imagery"
require "bing/route"

include WebMock::API

WebMock.disable_net_connect!

def mock_map_request(status, path, body, headers={})
  stub_request(:get, /.*virtualearth.*#{path}.*/).
    to_return(status: status, body: body, headers: headers)
end
