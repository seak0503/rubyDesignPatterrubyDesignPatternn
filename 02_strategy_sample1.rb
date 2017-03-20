# レポートの出力を抽象化したクラス(抽象戦略)
class Formatter
  def output_report(context)
    raise 'Called abstract method !!'
  end
end

# HTML形式に整形して出力(具体戦略)
class HTMLFormatter < Formatter
  def output_report(report)
    puts "<html><head><title>#{report.title}</title></head><body>"
    report.text.each { |line| puts "<p>#{line}</p>" }
    puts "</body></html>"
  end
end

# PlaneText形式に整形して出力(具体戦略)
class PlaneTextFormatter < Formatter
  def output_report(report)
    puts "***** #{report.title} *****"
    report.text.each { |line| puts(line) }
  end
end

# レポートを表す(コンテキスト)
class Report
  attr_reader :title, :text
  attr_accessor :formatter

  def initialize(formatter)
    @title = 'report title'
    @text = %w(text1 text2 text3)
    @formatter = formatter
  end

  def output_report
    @formatter.output_report(self)
  end
end

# ===========================================
puts "# HTMLReport"
report = Report.new(HTMLFormatter.new)
report.output_report

puts ""

puts "# PlainTextReportにformatter切り替え"
report.formatter = PlaneTextFormatter.new
report.output_report