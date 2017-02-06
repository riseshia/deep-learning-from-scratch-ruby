require "nmatrix"

def relu(x)
  x.map { |n| [0, n].max }    
end

x = N[(-5.0..5.0).step(0.1).to_a]
y = relu(x)
