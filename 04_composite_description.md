## コンポジットとは？

「全体-部分」（個別のオブジェクトと合成したオブジェクト）を同一のものとして捉えることで、再帰的な構造をクラスで表現することをCompositeデザインパターンと呼びます。「全体-部分」は同じインターフェイスを継承します。

コンポジットは次の3つの要素によって構成されます。

```
* コンポーネント(Component)：すべてのオブジェクトの基底となるクラス
* リーフ(Leaf)：プロセスの単純な構成要素、再帰しない
* コンポジット(Composite)：コンポーネントの一つでサブコンポーネントで構成
```

例としては、ディレクトリとフォルダを同様のコンポーネントとして扱うことで、削除処理などを再帰的に行えるようにできることが挙げられます。

ちなみに「再帰」とは、ある処理の中で再びその手続きを呼び出すことです。

## コンポジットのメリット

```
* ファイルシステムなどの木構造を伴う再帰的なデータ構造を表現できる
* 階層構造で表現されるオブジェクトの取扱いを楽にする
```

## ソースコード

ここではファイルシステムのモデルを使ってCompositeデザインパターンを説明します。

```
* FileEntryクラス(Leaf)：ファイルを表す
* DirEntryクラス(Composite)：ディレクトリを表す
* Entryクラス(Component)：FileEntry, DirEntryクラスの共通メソッドを規定
```

まず`FileEntryクラス`, `DirEntryクラス`の共通メソッドを規定する`Entryクラス`です。Componentにあたります。メソッドの実装はFileEntry/DirEntryクラスが個別に持っています。

```
# FileEntry, DirEntryクラスの共通メソッドを規定(Component)
class Entry
  # ファイル/ディレクトリの名称を返す
  def get_name; end

  # ファイル/ディレクトリのパスを返す
  def ls_entry(prefix) end

  # ファイル/ディレクトリの削除を行う
  def remove; end
end
```

次にファイルを表す`FileEntryクラス`です。ファイルはその下にファイルを持つことができない、つまり再帰できないのでCompositeデザインパターンのLeafにあたります。

```
# ファイルを表す(Leaf)
class FileEntry < Entry
  def initialize(name)
    @name = name
  end

  # ファイルの名称を返す
  def get_name
    @name
  end

  # ファイルのパスを返す
  def ls_entry(prefix)
    puts(prefix + "/" + get_name)
  end

  # ファイルの削除を行う
  def remove
    puts @name + "を削除しました"
  end
end
```

最後がディレクトリを表す`DirEntryクラス`です。ディレクトリはその下にファイルを持つことができる、つまり再帰できるのでCompositeデザインパターンのCompositeにあたります。このクラスは独自のクラスとして、ファイルを追加する`#addメソッド`を持っています。

```
# ディレクトリを表す(Composite)
class DirEntry < Entry
  def initialize(name)
    @title = name
    @directory = Array.new
  end

  # ディレクトリの名称を返す
  def get_name
    @title
  end

  # ディレクトリにファイルを追加する
  def add(entry)
    @directory.push(entry)
  end

  # ファイル/ディレクトリのパスを返す
  def ls_entry(prefix)
    puts(prefix + "/" + get_name)
    @directory.each do |e|
      e.ls_entry(prefix + "/" + @title)
    end
  end

  # ファイル/ディレクトリの削除を行う
  def remove
    @directory.each do |i|
      i.remove
    end
    puts @title + "を削除しました"
  end
end
```

コーディングは以上です。結果を確認します。

```
root = DirEntry.new("root")
tmp = DirEntry.new("tmp")
tmp.add(FileEntry.new("conf"))
tmp.add(FileEntry.new("data"))
root.add(tmp)

root.ls_entry("")
#/root
#/root/tmp
#/root/tmp/conf
#/root/tmp/data

root.remove
#confを削除しました
#dataを削除しました
#tmpを削除しました
#rootを削除しました
```

ディレクトリの中にディレクトリ/ファイルを追加できて、`#ls_entryメソッド`、`#removeメソッド`で同一のものとみなして処理できていることがわかります。 (再帰的にメソッドを呼び出せていることがわかります)

## コンポジットパターンの注意点
コンポジットパターンでは、コンポジット(Composite)が任意の深さのツリーを作れるようにしておくことが重要となります。