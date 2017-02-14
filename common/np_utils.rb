require "nmatrix"

def assign_if(matrix, filter, value) 
  raise "shapes are different between matrix and filter" \
    unless matrix.shape == filter.shape
  raise "the dtype of filter should be object" \
    unless filter.dtype == :object

  shape = matrix.shape

  flat_matrix = matrix.reshape(1, matrix.size)
  flat_filter = filter.reshape(1, filter.size)
  
  (0...flat_filter.size).each do |i|
    flat_matrix[i] = value if flat_filter[i]
  end

  flat_matrix.reshape(shape)
end

def pick_indices(m, ys, xs)
  ys = ys.to_a
  xs = xs.to_a
  picked = ys.zip(xs).map do |y, x|
    m[y][x]
  end
  N[picked]
end

def np_arange(start: 0, stop: size, step: 1, dtype: :int16)
  N[(start...stop).step(step).to_a, dtype: dtype]
end

def np_exp(x)
  x.map { |e| Math.exp(e) }
end

def np_log(x)
  x.map { |e| Math.log(e) }
end

def np_maximum(min, x)
  x.map { |n| [min, n].max }    
end

def np_sum(x)
  x.sum.inject(&:+)
end

def np_argmax(x, axis: nil)
  raise "Only support axis = nil, 1" if axis != 1 and a != nil

  if axis.nil?
    x = x.reshape(1, x.size)
  end

  argmax = []
  x.each_row do |row|
    max_idx = 0
    row.each_with_index do |el, idx|
      max_idx = idx if el[idx] > el[max_idx]
    end
    argmax << max_idx
  end

  if axis.nil?
    argmax.first
  else
    argmax
  end
end
