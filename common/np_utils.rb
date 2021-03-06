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
  x.each.inject(&:+)
end

def np_argmax(x, axis: nil)
  if axis.nil?
    max_idx = 0
    flatten_x = x.to_a.flatten
    flatten_x.each_with_index do |el, idx|
      max_idx = idx if el > flatten_x[max_idx]
    end
    max_idx
  else
    argmax = []
    x.each_along_dim(axis) do |row|
      max_idx = 0
      row.each_with_index do |el, idx|
        max_idx = idx if el[idx] > el[max_idx]
      end
      argmax << max_idx
    end
    argmax
  end
end
