require "nmatrix"
require "math"

def sigmoid(x)
  x.map { |n| 1 / (1 + Math.exp(-n)) }    
end

x = N[(-5.0..5.0).step(0.1).to_a]
y = sigmoid(x)

