require_relative 'helper'

class TestBingRoute < MiniTest::Test
  BR = Bing::Route

  def test_cls_find
    body = {
      'resourceSets' => [
        'resources' => [
          {'travelDistance' => 1234}
        ]
      ]
    }.to_json

    mock_map_request 200, BR.path, body

    route = BR.find(:waypoints => ['start', 'end']).first
    assert_equal 1234, route.total_distance
  end

  def test_cls_path
    assert_match %r[Route], BR.path
  end

  def test_initialize_with_bbox
    resource = { 'bbox' => %w[south west north east] }

    bl = BR.new resource

    assert_equal 'north', bl.bounding_box[:north]
    assert_equal 'east',  bl.bounding_box[:east]
    assert_equal 'south', bl.bounding_box[:south]
    assert_equal 'west',  bl.bounding_box[:west]
  end

  def test_initialize_with_distance_unit
    resource = { 'distanceUnit' => 'miles' }

    br = BR.new resource

    assert_equal 'miles', br.distance_unit
  end

  def test_initialize_with_duration_unit
    resource = { 'durationUnit' => 'sec' }

    br = BR.new resource

    assert_equal 'sec', br.duration_unit
  end

  def test_initialize_with_ending_coordinates
    resource = {
      'routeLegs' => [{
        'actualEnd' => {'coordinates' => [1,2]}
      }]
    }

    br = BR.new resource

    assert_equal [1,2], br.ending_coordinates
  end

  def test_initialize_with_itinerary
    resource = {
      'routeLegs' => [{
        'itineraryItems' => [
          {'travelDistance' => 1},
          {'travelDistance' => 2},
        ]
      }]
    }

    br = BR.new resource

    assert_equal 1, br.itinerary.first.distance
    assert_equal 2, br.itinerary.last.distance
  end

  def test_initialize_with_starting_coordinates
    resource = {
      'routeLegs' => [{
        'actualStart' => {'coordinates' => [1,2]}
      }]
    }

    br = BR.new resource

    assert_equal [1,2], br.starting_coordinates
  end

  def test_initialize_with_total_distance
    resource = { 'travelDistance' => 117.406223 }

    br = BR.new resource

    assert_equal 117.406223, br.total_distance
  end

  def test_initialize_with_total_duration
    resource = { 'travelDuration' => 11723 }

    br = BR.new resource

    assert_equal 11723, br.total_duration
  end

  def test_initialize_with_type
    resource = {
      'routeLegs' => [{
        'type' => 'type'
      }]
    }

    br = BR.new resource

    assert_equal 'type', br.type
  end

  def test_initialize_without_resource_raises
    assert_raises Bing::RouteResourceMissing do
      BR.new nil
    end
  end

end

