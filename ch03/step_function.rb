require "nmatrix"

def step_function(x)
  x.map { |n| x > 0 ? 1 : 0 }    
end

x = N[(-5.0..5.0).step(0.1).to_a]
y = step_function(x)
