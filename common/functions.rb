require "nmatrix"
require_relative "np_utils"

def identity_function(x)
  x
end

def step_function(x)
  x.map { |n| n > 0 ? 1 : 0 }    
end

def sigmoid(x)
  b = np_exp(-x) + 1
  t = NMatrix.ones_like(b)
  t / b
end

def sigmoid_grad(x)
  (1.0 - sigmoid(x)) * sigmoid(x)
end 

def relu(x)
  np_maximum(0, x)
end

def relu_grad(x)
  grad = NMatrix.zeros_like(x)
  assign_if(grad, x>=0, 1)
  grad
end 

def softmax(x)
  x_row, x_col = x.shape
  x = x.reshape(x_col) if x_row == 1

  if x.dimensions == 2
    x = x.transpose
    x_max = x.max(0).to_a
    x.each_row do |row|
      (0...x_max.size).each { |i| row[i] -= x_max[i] }
    end

    y = np_exp(x)
    y_sum = y.sum(0).to_a
    y.each_row do |row|
      (0...y_sum.size).each { |i| row[i] /= y_sum[i] }
    end
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
