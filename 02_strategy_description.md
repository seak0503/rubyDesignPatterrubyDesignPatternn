## はじめに

ストラテジーパターンは、例えば5ステップの中の3ステップが異なったAとBがあり、このAとBをスイッチしたい時に使えるパターンです。

## ストラテジの構成

ストラテジは以下の3つのオブジェクトによって構成されます。

```
* コンテキスト(Context)：ストラテジの利用者
* 抽象戦略(Strategy)：同じ目的をもった一連のオブジェクトを抽象化したもの
* 具象戦略(ConcreteStrategy)：具体的なアルゴリズム
```

ストラテジのアイデアは、コンテキストが**委譲**によってアルゴリズムを交換できるようにすることです。委譲とは、ある機能を持つオブジェクトを生成してオブジェクトに処理を依頼することです。

## ストラテジのメリット

```
* 使用するアルゴリズムに多様性を持たせることができる
* コンテキストと戦略を分離することでデータも分離できる
* 継承よりもストラテジを切り替えるのが楽
```

## サンプルソース１

レポートをHTML形式とプレーンテキスト形式で作成するプログラムをサンプルとしてストラテジーパターンを解説します。サンプルの概要は次の通りです。

```
* Report(コンテキスト)：レポートを表す
* Formatter(抽象戦略)：レポートの出力を抽象化したクラス
* HTMLFormatter(具象戦略１)：HTMLフォーマットでレポートを出力
* PlaneTextFormatter(具象戦略２)：PlanTextフォーマットでレポートを出力
```

まずイメージしやすい、HTML形式で出力する`HTMLFormatterクラス`と`PlaneTextFormatterクラス`、そしてその2つのクラスのインターフェイスを規定するFormatterクラスを作成します。

```
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
```

続いてレポートを表すReportクラスを作成します。このクラスには`formatter`があり、このformatterによって出力フォーマットを設定します。

```
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
```

コーディングは以上です。では結果を確認します。

```
report = Report.new(HTMLFormatter.new)
report.output_report
#<html><head><title>report title</title></head><body>
#<p>text1</p>
#<p>text2</p>
#<p>text3</p>
#</body></html>

report.formatter = PlaneTextFormatter.new
report.output_report
#***** report title *****
#text1
#text2
#text3
```

Reportクラス内の`formatter`がレポートの出力を委譲されています。 上の結果からformatterをスイッチすれば出力形式(戦略)を変更させることができるのを確認できました。

ちなみに、ここにある`Formatterクラス`はインターフェースを規定するだけのクラスなので、Rubyらしく書くなら不要です。(ダック・タイピング哲学)

## サンプルソース２

先ほどのソースコードをProcオブジェクト(コードブロック)を使って置き換えると次のようになります。

Procオブジェクトは、コードのかたまりを保持するオブジェクトです。lambdaメソッドが良く使われます。

```
# HTML形式に整形して出力(具体戦略)
HTML_FORMATTER = lambda do |context|
  puts "<html><head><title>#{context.title}</title></head><body>"
  context.text.each { |line| puts "<p>#{line}</p>" }
  puts "</body></html>"
end

# PlaneText形式(*****で囲う)に整形して出力(具体戦略)
PLANE_TEXT_FORMATTER = lambda do |context|
  puts "***** #{context.title} *****"
  context.text.each { |line| puts(line) }
end

# レポートを表す(コンテキスト)
class Report
  attr_reader :title, :text
  attr_accessor :formatter

  def initialize(&formatter)
    @title = 'report title'
    @text = %w(text1 text2 text3)
    @formatter = formatter
  end

  def output_report
    @formatter.call(self)
  end
end
```

コーディングは以上です。では結果を確認します。

```
report = Report.new(&HTML_FORMATTER)
report.output_report
#<html><head><title>report title</title></head><body>
#<p>text1</p>
#<p>text2</p>
#<p>text3</p>
#</body></html>

report.formatter = PLANE_TEXT_FORMATTER
report.output_report
#***** report title *****
#text1
#text2
#text3
```

先ほどよりもRubyらしいコードで同様の結果を得ることができました。

## ストラテジの注意点

```
* コンテキストと1つめのストラテジの依存関係をあまりにも強くしてしまい、2つ目3つ目のストラテジの設計に盛り込めなくなってしまうことで、ストラテジの種類の増加を妨げないようにする
* コンテキストの変更がストラテジに影響を与えないようにする
```