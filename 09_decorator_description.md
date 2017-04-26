# Decorator

デコレータは、既存のオブジェクトに対して簡単に機能の追加をするためのパターンです。
デコレータパターンを使うと、レイヤ状に機能を積み重ねて、必要な機能をもつオブジェクトを作ることができます。

## デコレータの構成要素

デコレータは次の2つの要素で構成されます。

```
具体コンポーネント(ConcreteComponent)：ベースとなる処理をもつオブジェクト
デコレータ(Decorator)：追加する機能を持つ
```

## デコレータのメリット

```
* 既存のオブジェクトの中身を変更することなく、機能を追加できる
* 組み合わせで様々な機能を実現できる
* 継承よりも変更の影響を限定しやすい
```

## サンプルソース

デコレータの概要を次のモデルを使って説明します。

```
SimpleWriter(具体コンポーネント): ファイルへの単純な出力を行う
NumberingWriter(デコレータ): 行番号出力を装飾する機能を持つ
TimestampingWriter(デコレータ): タイムスタンプを追加する機能を持つ
```

まず「ファイルへの出力機能」をもつSimpleWriterクラスを作成します。

```
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
```

このクラスを動かしてみます。

```
writer = SimpleWriter.new('09_file1.txt')
writer.write_line('飾り気のない一行')
writer.close
```

このコードを実行すると、09_file1.txtに飾り気のない一行が入っていました。

タイムスタンプ/行番号クラスを作成する前に、それらのクラスの共通する機能を切り出したWriteDecoratorクラスを定義します。これは、Decoratorを複数作る場合に重複したコードをできるだけ書かないための工夫です。

```
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
```

タイムスタンプを出力するNumberingWriterクラスを定義します。
write_lineメソッドは、`#{@line_number} : #{LINE}`でLINEに行番号を付加しています。そして、コンストラクタで受け取ったオブジェクト(SimpleWriter)のwrite_lineメソッドに処理を委譲しています。
このクラスは、デコレータパターンのDecoratorの役割を持ちます。

```
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
```

最後にタイムスタンプを出力するNumberingWriterクラスを定義します。
write_lineメソッドは、`#{Time.new} : #{LINE}`でLINEにタイムスタンプを付加して、オブジェクト(SimpleWriter)のwrite_lineメソッドに処理を委譲しています。
このクラスもデコレータパターンのDecoratorの役割を持ちます。

```
# タイムスタンプ出力機能を装飾する(Decorator)
class TimeStampingWriter < WriterDecorator
  def write_line(line)
    @real_writer.write_line("#{Time.new} : #{line}")
  end
end
```

ここまでがコーディング部分です。では、上のサンプルを動かしてみます。

```
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
```

このようにデコレータパターンでは既存のクラス(SimpleWriter)を変更することなく、
機能を自由に組み合わせて使うことがてきています。

## Rubyの標準ライブラリForwardableによる委譲

ここではクラスに対しメソッドの委譲機能を追加するForwardableを使って先ほどのソースをリファクタリングします。この委譲とは、ある機能をもつオブジェクトにその機能での処理を依頼することです。

先ほどのサンプルソースのWriterDecoratorクラスを次の様に修正できます。

```
# 複数のデコレータの共通部分(Decorator)
class WriterDecorator
  extend Forwardable

  # forwardableで以下のメソッドの処理を委譲している
  def_delegators :@real_writer, :write_line, :pos, :rewind, :close


  def initialize(real_writer)
    @real_writer = real_writer
  end
end
```

## Rubyの委譲：Forwardableとmethod_missingについて

Rubyでのメソッドの委譲は、forwardableとmethod_missingを使う方法があります。それぞれの特徴を活かしてうまく使い分けるとよさそうです。

```
* forwardableを使う場合、委譲しているメソッドを明確にすることができる
* method_missingを使う場合は、メソッドが多い場合に有利、間違いがなくなる
```

## Decoratorのモジュール化

Decoratorをモジュールにすることでも同様の機能を実現できます。

```
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
```

## Adapter/プロキシ/Decoratorの違い

Adapter/プロキシ/Decoratorはいずれも「別のオブジェクトの代理」パターンといえます。
この3つの違いをシンプルに説明すると次のようになります。

```
Adapter: オブジェクトの不適切なインターフェイスをラップする
Proxy: ラップするオブジェクトと同じインターフェイスを持ち、一部の機能を受け持つ
Decorator: 基本的なオブジェクトにレイヤ状に機能を追加する
```

