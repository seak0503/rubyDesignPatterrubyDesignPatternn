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

module NumberingWriter
  attr_reader :line_number

  def write_line(line)
    @line_number = 1 unless @line_number
    super("#{@line_number} : #{line}")
    @line_number += 1
  end
end

module TimeStampingWriter
  def write_line(line)
    super("#{Time.new} : #{line}")
  end
end

# ===========================================

f = SimpleWriter.new('09_file4.txt')
f.extend NumberingWriter
f.extend TimeStampingWriter
f.write_line('Hello out there')
f.close
# 09_file4.txtに以下の内容が出力される
# 1 : 2017-04-22 16:44:31 +0900 : Hello out there

