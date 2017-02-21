require "minitest/autorun"
require_relative "../../common/np_utils"

class NpUtilsTest < Minitest::Test
  def test_np_argmax_with_dim_one
    target = N[0.1, 0.2, 0.3, 0.6, 0.5, 0.4]
    assert_equal 3, np_argmax(target)
  end

  def test_np_argmax_with_dim_two
    target = N[[1, 2, 3], [6, 5, 4]]
    assert_equal 3, np_argmax(target)
  end

  def test_np_argmax_with_dim_two_with_axis
    target = N[[1, 2, 3], [6, 5, 4]]
    assert_equal N[2, 0], np_argmax(target, axis: 0)
  end
end

