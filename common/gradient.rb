require "nmatrix"

def _numerical_gradient_1d(f, x)
  h = 1e-4 # 0.0001
  grad = NMatrix.zeros_like(x)
  
  (0...x.size).each do |idx|
    tmp_val = x[idx]
    x[idx] = tmp_val + h
    fxh1 = f.call(x) # f(x+h)
    
    x[idx] = tmp_val - h 
    fxh2 = f.call(x) # f(x-h)
    grad[idx] = (fxh1 - fxh2) / (2*h)
    
    x[idx] = tmp_val # 値を元に戻す
  end
      
  grad
end


def numerical_gradient_2d(f, x)
  if x.dimensions == 1
    _numerical_gradient_1d(f, x)
  else
    grad = NMatrix.zeros_like(x)
    
    x.each_with_index do |el, *idxs|
      grad[*idxs] = _numerical_gradient_1d(f, el)
    end

    grad
  end
end


def numerical_gradient(f, x)
  h = 1e-4 # 0.0001
  grad = NMatrix.zeros_like(x)
  
  x.each_with_index do |el, *idxs|
    tmp_val = x[*idxs]
    x[*idxs] = tmp_val + h
    fxh1 = f.call(x) # f(x+h)
    
    x[*idxs] = tmp_val - h 
    fxh2 = f.call(x) # f(x-h)
    grad[idx] = (fxh1 - fxh2) / (2*h)
    
    x[*idxs] = tmp_val # 値を元に戻す
  end

  grad
end

