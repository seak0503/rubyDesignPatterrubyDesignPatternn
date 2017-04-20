require 'forwardable'

# ファイルへの単純な出力を行う (ConcreteComponent)
class SimpleWriter
  def initialize(path)
    @file = File.open(path, "w")
  end

  def write_line(line)
    @file.print(line)
    @file.print("\n")
  end

  def pos
    @file.pos
  end

  def rewind
    @file.rewind
  end

  def close
    @file.close
  end
end

# 複数のデコレータの共通部分(Decorator)
class WriterDecorator
  extend Forwardable

  # forwardableで以下のメソッドの処理を委譲している
  def_delegators :@real_writer, :write_line, :pos, :rewind, :close


  def initialize(real_writer)
    @real_writer = real_writer
  end
end

# 行番号出力機能を装飾する(Decorator)
class NumberingWriter < WriterDecorator
  def initialize(real_writer)
    super(real_writer)
    @line_number = 1
  end

  def write_line(line)
    @real_writer.write_line("#{@line_number} : #{line}")
  end
end

# タイムスタンプ出力機能を装飾する(Decorator)
class TimeStampingWriter < WriterDecorator
  def write_line(line)
    @real_writer.write_line("#{Time.new} : #{line}")
  end
end

# ===========================================

f = NumberingWriter.new(SimpleWriter.new('09_test_data_sample1.txt'))
f.write_line('Hello out there')
f.close
# file1.txtに以下の内容が出力される
#1 : Hello world

f = TimeStampingWriter.new(SimpleWriter.new('09_test_data_sample2.txt'))
f.write_line('Hello out there')
f.close
# file2.txtに以下の内容が出力される
#2012-12-09 12:55:38 +0900 : Hello out there

f = TimeStampingWriter.new(NumberingWriter.new(SimpleWriter.new('09_test_data_sample3.txt')))
f.write_line('Hello out there')
f.close
# file3.txtに以下の内容が出力される
#1 : 2012-12-09 12:55:38 +0900 : Hello out there
