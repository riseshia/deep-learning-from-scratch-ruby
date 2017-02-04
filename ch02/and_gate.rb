require 'nmatrix'

def and_gate(x1, x2)
  x = N[x1, x2]
  w = N[0.5, 0.5]
  b = -0.7
  tmp = (x * w).sum.first + b

  tmp > 0 ? 1 : 0
end

# [
#   [0, 0],
#   [0, 1],
#   [1, 0],
#   [1, 1]
# ].each { |x1, x2| puts and_gate(x1, x2) }
