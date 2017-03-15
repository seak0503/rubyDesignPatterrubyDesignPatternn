class Report
  def initialize
    @title = "report title"
    @text = [ "repot line 1", "report line 2", "report line 3" ]
  end

  # レポートの出力手順を規定
  def output_report
    output_start
    output_body
    output_end
  end

  # レポートの先頭に出力
  def output_start
  end

  # レポートの本文の管理
  def output_body
    @text.each do |line|
      output_line(line)
    end
  end

  # 本文内のLINE出力部分
  # 今回は個別クラスに規定するメソッドとする。規定されてなければエラーを出す
  def output_line(line)
    raise 'Called abstract method !!'
  end

  # レポートの末尾に出力
  def output_end
  end
end

# HTML形式のレポート出力を行う
class HTMLReport < Report
  # レポートの先頭に出力
  def output_start
    puts "<html><head><title>#{@title}</title></head><body>"
  end

  # 本文内のLINE出力部分
  def output_line(line)
    puts "<p>#{line}</p>"
  end

  # レポートの末尾に出力
  def output_end
    puts "</body></html>"
  end
end

# PlainText形式(*****で囲う)でレポートを出力
class PlainTextReport < Report
  # レポートの先頭に出力
  def output_start
    puts "**** #{@title} ****"
  end

  # レポートの末尾に出力
  def output_line(line)
    puts line
  end
end

# ===========================================
puts "# HTMLReport"
html_repot = HTMLReport.new
html_repot.output_report

puts ""

puts "# PlainTextReport"
plain_text_repot = PlainTextReport.new
plain_text_repot.output_report
