require_relative 'helper'

class TestRequest < MiniTest::Test
  def setup
    @uri = URI.parse 'http://example.com'
  end

  def test_get_failure
    stub_request(:any, "http://example.com").to_return(:status => 500)

    assert_raises Bing::BadGateway do
      Bing::Request.get @uri
    end
  end

  def test_get_success
    stub_request(:any, "http://example.com").to_return(:status => 200)

    response = Bing::Request.get @uri

    assert_equal 200, response.status
  end

  def test_get_client
    stub_request(:any, "http://example.com").to_return(:status => 200)

    response = Bing::Request.get @uri

    assert_kind_of Faraday::Response, response
  end
end
