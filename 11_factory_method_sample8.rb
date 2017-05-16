# Product
class HTMLReader
  def initialize
    puts "HTMLReaderが初期化されました。"
  end
end

# Product
class HTMLWriter
  def initialize
    puts "HTMLWriterが初期化されました。"
  end
end

# Product
class PDFReader
  def initialize
    puts "PDFReaderが初期化されました。"
  end
end

# Product
class PDFWriter
  def initialize
    puts "PDFWriterが初期化されました。"
  end
end

# Factory
class IOFactory
  def initialize(format)
    @reader_class = self.class.const_get("#{format}Reader")
    @writer_class = self.class.const_get("#{format}Writer")
  end

  def new_reader
    @reader_class.new
  end

  def new_writer
    @writer_class.new
  end
end

# ======================================

html_factory = IOFactory.new("HTML")
html_reader = html_factory.new_reader
html_writer = html_factory.new_writer

pdf_factory = IOFactory.new("PDF")
pdf_reader = pdf_factory.new_reader
pdf_writer = pdf_factory.new_writer

