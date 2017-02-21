require "nmatrix"
require "math"

def sigmoid(x)
  b = np_exp(-x) + 1
  t = NMatrix.ones_like(b)
  t / b
end

x = N[(-5.0..5.0).step(0.1).to_a]
y = sigmoid(x)

