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
  def initialize(real_writer)
    @real_writer = real_writer
  end

  def write_line(line)
    @real_writer.write_line(line)
  end

  def pos
    @real_writer.pos
  end

  def rewind
    @real_writer.rewind
  end

  def close
    @real_writer.close
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
    @line_number += 1
  end
end

# タイムスタンプ出力機能を装飾する(Decorator)
class TimeStampingWriter < WriterDecorator
  def write_line(line)
    @real_writer.write_line("#{Time.new} : #{line}")
  end
end

# ===========================================

f = NumberingWriter.new(SimpleWriter.new('09_file1-1.txt'))
f.write_line('Hello out there')
f.close
# 09_file1-1.txtに以下の内容が出力される
#1 : Hello world

f = TimeStampingWriter.new(SimpleWriter.new('09_file1-2.txt'))
f.write_line('Hello out there')
f.close
# 09_file1-2.txtに以下の内容が出力される
#2012-12-09 12:55:38 +0900 : Hello out there

f = TimeStampingWriter.new(NumberingWriter.new(SimpleWriter.new('09_file1-3.txt')))
f.write_line('Hello out there')
f.close
# 09_file1-3.txtに以下の内容が出力される
#1 : 2012-12-09 12:55:38 +0900 : Hello out there
