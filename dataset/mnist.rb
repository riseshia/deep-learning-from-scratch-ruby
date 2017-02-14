require "nmatrix"
require "open-uri"
require "zlib"

URL_BASE = "http://yann.lecun.com/exdb/mnist/"
KEY_FILE = {
  "train_img" => "train-images-idx3-ubyte.gz",
  "train_label" => "train-labels-idx1-ubyte.gz",
  "test_img" => "t10k-images-idx3-ubyte.gz",
  "test_label" => "t10k-labels-idx1-ubyte.gz"
}

DATASET_DIR = "#{Dir.pwd}/dataset"
SAVE_FILE = "#{DATASET_DIR}/mnist.binary"
TRAIN_NUM = 60_000
TEST_NUM = 10_000
IMG_DIM = [1, 28, 28]
IMG_SIZE = 784

def _download(filename)
  file_path = DATASET_DIR + "/" + filename

  return if File.exist?(file_path)

  puts "Downloading #{filename} ..."
  open(DATASET_DIR + "/" + filename, "wb") do |fout|
    open(URL_BASE + filename, "rb") do |fin|
      fout.write(fin.read)
    end
  end
  puts "Done"
end

def download_mnist()
  KEY_FILE.each { |_, file| _download(file) }
end

# Reference: http://d.hatena.ne.jp/n_shuyo/20090913/mnist
def _load_label(filename)
  file_path = DATASET_DIR + "/" + filename

  puts "Converting #{filename} to NMatrix Array ..."    
  Zlib::GzipReader.open(file_path) do |f|
    magic, n_labels = f.read(8).unpack('N2')
    raise "This is not MNIST label file" if magic != 2049
    f.read(n_labels).unpack('C*')
  end 
end

def _load_img(filename)
  file_path = DATASET_DIR + "/" + filename

  puts "Converting #{filename} to NMatrix Array ..."    
  Zlib::GzipReader.open(file_path) do |f|
    magic, n_images = f.read(8).unpack('N2')
    raise "This is not MNIST image file" if magic != 2051
    n_rows, n_cols = f.read(8).unpack('N2')
    Array.new(n_images) { f.read(n_rows * n_cols).unpack('C*') }
  end
end

def _convert_array()
  {
    "train_img" => _load_img(KEY_FILE["train_img"]),
    "train_label" => _load_label(KEY_FILE["train_label"]),
    "test_img" => _load_img(KEY_FILE["test_img"]),
    "test_label" => _load_label(KEY_FILE["test_label"])
  }
end

def init_mnist()
  download_mnist
  dataset = _convert_array
  puts "Creating marshal dump ..."
  File.open(SAVE_FILE, "wb") { |f| f.write(Marshal.dump(dataset)) }
  puts "Done!"
end

def _change_one_hot_label(x)
  t = NMatrix.zeros([x.size, 10], dtype: :int8)
  t.each_row.with_index do |row, idx|
    row[x[idx]] = 1
  end
  t
end

# MNISTデータセットの読み込み
#
# Parameters
# ----------
# normalize : 画像のピクセル値を0.0~1.0に正規化する
# one_hot_label : 
#     one_hot_labelがTrueの場合、ラベルはone-hot配列として返す
#     one-hot配列とは、たとえば[0,0,1,0,0,0,0,0,0,0]のような配列
# flatten : 画像を一次元配列に平にするかどうか 
#
# Returns
# -------
# [訓練画像, 訓練ラベル], [テスト画像, テストラベル]
def load_mnist(normalize: true, flatten: true, one_hot_label: false)
  init_mnist() if !File.exist?(SAVE_FILE)

  dataset = Marshal.load(File.binread(SAVE_FILE))
  # NMatrix cannot be marshaled
  dataset.keys.each do |key|
    dataset[key] = N[*dataset[key], dtype: :int16]
  end

  if normalize
    %w[train_img test_img].each do |key|
      dataset[key] /= 255.0
    end
  end

  if one_hot_label
    dataset['train_label'] = _change_one_hot_label(dataset['train_label'])
    dataset['test_label'] = _change_one_hot_label(dataset['test_label'])    
  end

  unless flatten
    %w[train_img test_img].each do |key|
      n = shape.inject(&:*) / 28 / 28
      dataset[key] = dataset[key].reshape(n, 1, 28, 28)
    end
  end

  [[dataset['train_img'], dataset['train_label']],
   [dataset['test_img'], dataset['test_label']]] 
end

