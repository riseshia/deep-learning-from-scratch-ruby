require "nmatrix"

def get_data()
  (x_train, t_train), (x_test, t_test) = \
    load_mnist(normalize=True, flatten=True, one_hot_label=False)
  x_test, t_test
end

def init_network()
  Marshal.load(File.binread("sample_weight.binary"))
end

def predict(network, x)
  w1, w2, w3 = network['W1'], network['W2'], network['W3']
  b1, b2, b3 = network['b1'], network['b2'], network['b3']

  a1 = x.dot(w1) + b1
  z1 = sigmoid(a1)
  a2 = z1.dot(w2) + b2
  z2 = sigmoid(a2)
  a3 = z2.dot(w3) + b3
  softmax(a3)
end

x, t = get_data()
network = init_network()
accuracy_cnt = 0

(0...x.size).each do |i|
  y = predict(network, x[i])
  p = np_argmax(y) # 最も確率の高い要素のインデックスを取得
  accuracy_cnt += 1 if p == t[i]
end

puts "Accuracy: #{str(float(accuracy_cnt) / len(x))}"

