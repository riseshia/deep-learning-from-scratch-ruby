require "nmatrix"
require_relative "np_utils"

def identity_function(x)
  x
end

def step_function(x)
  x.map { |n| x > 0 ? 1 : 0 }    
end

def sigmoid(x)
  1 / (1 + np_exp(-x))
end

def sigmoid_grad(x)
  (1.0 - sigmoid(x)) * sigmoid(x)
end 

def relu(x)
  np_maximum(0, x)
  x.map { |n| [0, n].max }    
end

def relu_grad(x)
  grad = NMatrix.zeros_like(x)
  assign_if(grad, x>=0, 1)
  grad
end 

def softmax(x)
  if x.dimensions == 2
    x = x.transpose
    x = x - x.max
    exp_x = np_exp(x)
    y = exp_x / np_sum(exp_x)
    y.transpose 
  else
    x = x - x.max # オーバーフロー対策
    exp_x = np_exp(x)
    exp_x / np_sum(exp_x)
  end
end

def mean_squared_error(y, t)
  0.5 * np_sum((y-t)**2)
end

def cross_entropy_error(y, t)
  if y.dimensions == 1
    t = t.reshape(1, t.size)
    y = y.reshape(1, y.size)
  end
      
  # 教師データがone-hot-vectorの場合、正解ラベルのインデックスに変換
  if t.size == y.size
    t = np_argmax(t, axis: 1)
  end
           
  batch_size = y.shape[0]
  -np_sum(np.log(pick_indices(y, np_arange(stop: batch_size), t))) / batch_size
end

def softmax_loss(x, t)
  y = softmax(x)
  cross_entropy_error(y, t)
end
