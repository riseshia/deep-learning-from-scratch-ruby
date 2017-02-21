require "minitest/autorun"
require_relative "../../common/functions"

class FunctionsTest < Minitest::Test
  def test_identify_function
    expected = N[[1, 2, 3], [4, 5, 6]]
    assert_equal expected, identity_function(expected)
  end

  def test_step_function
    input = N[[1, -2, 3], [-4, 5, -6]]
    expected = N[[1, 0, 1], [0, 1, 0]]

    assert_equal expected, step_function(input)
  end

  def test_sigmoid
    input = N[1.0, 2.0]
    expected = N[0.731, 0.880]
    actual = sigmoid(input)

    (0..1).each do |i|
      assert_in_delta expected[i], actual[i]
      assert_in_delta expected[i], actual[i]
    end
  end

  def test_relu
    input = N[-2, -1, 0, 1, 2]
    expected = N[0, 0, 0, 1, 2]

    assert_equal expected, relu(input)
  end
end
