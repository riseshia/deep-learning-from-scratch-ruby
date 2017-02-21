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

  def test_softmax_with_dim_one
    input = N[0.3, 2.9, 4.0]
    expected = N[0.01821127, 0.24519181, 0.73659691]
    actual = softmax(input)

    (0..2).each do |i|
      assert_in_delta expected[i], actual[i]
      assert_in_delta expected[i], actual[i]
    end
  end

  def test_softmax_with_dim_two
    input = N[[1, 2, 3], [4, 5, 6]]
    expected = N[[0.09,  0.2447,  0.66524], [0.09,  0.2447,  0.66524]]
    actual = softmax(input)

    pair = expected.to_a.flatten.zip(actual.to_a.flatten)
    pair.each do |e, a|
      assert_in_delta e, a
    end
  end

  def test_softmax_with_dim_two_like_one
    input = N[[0.0968, -3.37, 2.234]]
    expected = N[[0.10518144,  0.0032834 ,  0.89153516]]
    actual = softmax(input)

    pair = expected.to_a.flatten.zip(actual.to_a.flatten)
    pair.each do |e, a|
      assert_in_delta e, a
    end
  end
end
