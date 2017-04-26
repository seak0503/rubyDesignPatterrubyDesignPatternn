# Template Method

テンプレートメソッドは、2つのコードのやりたいこと(アルゴリズム)がほとんど同じで、ある一部だけ変えたいようなパターンの時に有効です。

## テンプレートメソッドとは？

テンプレートメソッドは次の2つのオブジェクトによって構成されます。

    * 骨格としての「抽象的なベースのクラス」
    * 実際の処理を行う「サブクラス」

## テンプレートメソッドのメリット

    * 抽象的なベースのクラス側に、「変わらない基本的なアルゴリズム」を置ける
    * 抽象的なベースのクラスは「高レベルの処理」を制御することに集中できる
    * サブクラス側に、「変化するロジック」を置ける
    * サブクラスは「詳細を埋めること」に集中できる

「高レベルの処理」とは、プログラミング的には「抽象度の高い処理、ロジック的な部分、処理のフレーム」といった言葉に言い換えられると思います。 「詳細を埋める」とは、プログラム的にはレポートの行を書き出すといった具体的な処理を指しています。

## サンプルソース

次のようなモデルを使って、テンプレートメソッドについて説明していきます。

    * Report(抽象的なベースのクラス)： レポートを出力する
    * HTMLReport(サブクラス)： HTMLフォーマットでレポートを出力
    * PlaneTextReport(サブクラス)： PlanTextフォーマットでレポートを出力

まず、レポートの出力を行うReportクラスです。  
Reportクラスには次の４つのメソッドを持っています。

```
class Report
  def initialize
    @title = "report title"
    @text = ["report line 1", "report line 2", "report line 3"]
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
```

次はHTML形式でのレポート出力を行うHTMLReportです。  
このクラスは、Reportクラスのメソッドの中でHTML出力の時に変化する3つのメソッドを持っています。

```
# HTML形式でのレポート出力を行う
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
    puts '</body></html>'
  end
end
```

最後がPlaneText形式(` ***** `で囲う)での出力を行うPlaneTextReportです。  
このクラスは、Reportクラスのメソッドの中でPlaneText形式で出力の際に変化する2つのメソッドを持っています。

```
# PlainText形式(<code>*****</code>で囲う)でレポートを出力
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
```

コーディングは以上です。続いて結果を確認します。

```
html_report = HTMLReport.new
html_report.output_report
#<html><head><title>html report title</title></head><body>
#<p>report line 1</p>
#<p>report line 2</p>
#<p>report line 3</p>
#</body></html>

plane_text_report = PlaneTextReport.new
plane_text_report.output_report
#**** html report title ****
#report line 1
#report line 2
#report line 3
```

ベースとしてのReportクラスの機能を持ちつつ、HTML形式とPlaneText形式で出力できていることがわかります。


## コードから読み解く、テンプレートメソッドの特徴

    output_lineメソッド => 抽象クラスで具体的な実装をせず、サブクラス側だけ定義することができる
    output_startメソッド => 抽象クラスで定義して、サブクラスでオーバライドすることができる

オーバーライド (override)とは、「抽象的なベースのクラス」側で定義されたメソッドを「サブクラス」でもう一度定義し直して処理を上書きすること。

## テンプレートメソッドの注意点

テンプレートメソッドを適用するときの注意点としては、

    「YAGNI = You Aren't Going to Need It.（今必要なことだけ行う）」を徹底する
    解決したい問題に絞って単純なコードを書いていくこと

## テンプレートメソッドの利用例

オブジェクトを初期化するメソッド`initialize`は既存の`initialize`をオーバーライドして、自由に初期化処理を行うことができます。 この`initialize`は広義でのテンプレートメソッドです。