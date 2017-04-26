# Adapter
アダプタは既存のインタフェースとの橋渡しをするためのデザインパターンです。

アダプタは現実世界の変換コネクタのようなものです。直接つながらないコネクタと差込口であっても、それらの間を変換コネクタが結び付けます。コネクタと差込口にカスタマイズが不要な点がアダプタの利点です。

## アダプタが利用される場面
Adapterパターンは次のような場面でよく使います。

```
関連性・互換性のないオブジェクト同士を結びつける必要がある
他のコンポーネントへの変更ができるようにする
```

## アダプタの構成要素

アダプタの構成要素は次の4つです。

```
利用者(Client)：ターゲットのメソッドを呼び出す
ターゲット(Target)：インターフェースを既定する
アダプタ(Adapter)：アダプティのインターフェースを変換してターゲット向けのインターフェースを提供
アダプティ(Adaptee)：実際に動作する既存のクラス
```

## サンプルソース

次のようなモデルを例にアダプタパターンを説明していきます。

```
Client: Printerクラスを使う側

Printerクラス(Target)：Clientが使っているメソッドをもつ
  print_weakメソッド
  printer_strongメソッド

OldPrinterクラス(Adaptee)：すでに存在しているオブジェクト
  show_with_parenメソッド
  show_with_asterメソッド
```

ClientはPrinterクラスのメソッドを使うことはできますが、Oldprinterクラスはメソッドの名前/定義が異なるため、改造なしに使うことができません。そこでAdapterデザインパターンを適用してClientがOldPrinterクラスを使えるようにします。

まずは、Printerクラスを確認します。

```
# 利用者(Client)へのインターフェイス (Target)
class Printer
  def initialize(obj)
    @obj = obj
  end

  def print_weak
    @obj.print_weak
  end

  def print_strong
    @obj.print_strong
  end
end
```

次にOldPrinterクラスです。

```
# Targetにはないインターフェイスを持つ (Adaptee)
class OldPrinter
  def initialize(string)
    @string = string.dup
  end

  def show_with_paren
    puts "(#{@string})"
  end

  def show_with_aster
    puts "*#{@string}*"
  end
end
```

このOldPrinterクラスのメソッドをClientが使えるPrinterクラスのインタフェースにするAdapterクラスを作成します。このクラスには、次の2つのメソッドを定義します。

* print_weak: OldPrinter#show_with_parenを呼び出す
* print_strong: OldPrinter#show_with_asterを呼び出す

```
# 利用者(Client)へのインターフェイス (Target)
class Printer
  def initialize(obj)
    @obj = obj
  end

  def print_weak
    @obj.print_weak
  end

  def print_strong
    @obj.print_strong
  end
end
```

以上がソースコードです。

では結果を確認するために、ClientにTargetを動かしてもらいます。

```
# 利用者(Client)
p = Printer.new(Adapter.new("Hello"))
p.print_weak
#=> (Hello)

p.print_strong
#=> *Hello*
```

ClientはTargetのメソッドを呼び出しているだけですが、Adapterを介して接続したOldPrinterのメソッドにアクセスできています。このようにAdapterクラスによって**PrinterとOldprinterに変更が不要である点**がAdapterデザインパターンの特徴です。

## 特異メソッドを使ったAdapter

ここでRubyの特異メソッドを使ってAdapterを表現した場合のコードを示します。

```
# Targetにはないインターフェイスを持つ (Adaptee)
class OldPrinter
  def initialize(string)
    @string = string.dup
  end

  def show_with_bracket
    puts "[#{@string}]"
  end

  def show_with_asterisk
    puts "**#{@string}**"
  end
end

# 利用者(Client)へのインターフェイス (Target)
class Printer
  def initialize(obj)
    @obj = obj
  end

  def print_weak
    @obj.print_weak
  end

  def print_strong
    @obj.print_strong
  end
end

# textオブジェクト(OldPrinter)にAdapterの役割を持つ得意メソッドを追加
text = OldPrinter.new("Hello")

class << text
  def print_weak
    show_with_bracket
  end
  def print_strong
    show_with_asterisk
  end
end

# ===========================================

# 利用者(Client)
p = Printer.new(text)
p.print_weak
#=> [Hello]

p.print_strong
#=> **Hello**
```

このように先ほどよりもシンプルなコードでAdapterを表現できていることがわかります。

## クラス変更とアダプタ適用のどちらを選択すべきか？

必要なインタフェースを変更するのは、クラスや特定のインスタンスだけを直接変更したほうがずっとシンプルなコードになります。ではどのような場面でアダプタを適用すべきでしょうか？

次の判断材料を元に、「クラス変更」か「アダプタ適用」を選択してください。

* 問題のクラスの理解がある、変更が比較的少ない => クラス変更
* オブジェクトが複雑/完全な理解がない => アダプタ適用