require_relative 'helper'

class TestCoreExt < MiniTest::Test

  def test_camelize
    assert_equal 'hiMom', 'hi_mom'.camelize(:lower)
    assert_equal 'HiMom', 'hi_mom'.camelize
    assert_equal 'Hi', 'hi'.camelize
  end

  def test_to_param
    query = {:hi_mom => true}
    assert_equal 'hiMom=true', query.to_lower_camelized_param

    query[:yep] = false
    assert_equal 'hiMom=true&yep=false', query.to_lower_camelized_param
  end

end

