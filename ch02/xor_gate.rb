require 'nmatrix'

load './and_gate.rb'
load './or_gate.rb'
load './nand_gate.rb'

def xor_gate(x1, x2)
  s1 = nand_gate(x1, x2)
  s2 = or_gate(x1, x2)
  and_gate(s1, s2)
end

# [
#   [0, 0],
#   [0, 1],
#   [1, 0],
#   [1, 1]
# ].each { |x1, x2| puts xor_gate(x1, x2) }
