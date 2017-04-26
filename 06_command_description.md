# Command

コマンドデザインパターンは、あるオブジェクトに対してコマンドを送ることでそのオブジェクトのメソッドを呼び出すことです。

たとえば、ファイルシステムの実装は知らなくてもユーザーはファイルの追加、削除といったコマンドを実行できます。これもコマンドパターンのひとつです。

## コマンドの構成要素

コマンドの構成要素は、シンプルに2つです。

```
Command(コマンド)：コマンドのインターフェイス
ConcreteCommand(具体コマンド)：Commandの具体的な処理
```

## コマンドのメリット

```
コマンドの変更・追加・削除に対して柔軟になる
```

## ソースコード

コマンドデザインパターンを説明するために、ファイルの作成・削除・コピーができるモデルを考えます。

```
Commandクラス：すべてのCommandのインターフェイス
CreateFileクラス(ConcreteCommand):ファイルを作成する
DeleteFileクラス(ConcreteCommand):ファイルを削除する
CopyFileクラス(ConcreteCommand):ファイルをコピーする
CompositeCommand(ConcreteCommand):複数のコマンドをまとめて実行できるようにした、CreateFile, DeleteFile, CopyFileのコマンドを集約するクラス。
```

まず、すべてのコマンドのインタフェースを規定するCommandクラスです。
このクラスで定義した`execute`メソッドと`undo_execute`メソッドをCreateFile, DeleteFile, CopyFileが持っています。

```
# コマンドのインターフェース
class Command
  attr_reader :description
  def initialize(description)
    @description = description
  end
  def execute
  end
  def undo_execute
  end
end
```

次にCreateFileクラス, DeleteFileクラス, CopyFileクラスです。各クラスの共通した特徴は次のとおりです。

```
* 各クラスはCommandクラスを継承したConcreteCommand
* #executeメソッド：ファイル作成、ファイル削除、ファイルコピーを実装
* #undo_executeメソッド：ファイル作成、ファイル削除、ファイルコピーを取り消す
```

なお、最初にrequireしているfileutilsは、ファイルを操作するためのライブラリです。

```
require "fileutils"

# ファイルを作成する命令
class CreateFile < Command
  def initialize(path, contents)
    super("Create file : #{path}")
    @path = path
    @contents = contents
  end

  def execute
    f = File.open(@path, "w")
    f.write(@contents)
    f.close
  end

  def undo_execute
    File.delete(@path)
  end
end

# ファイルを削除する命令
class DeleteFile < Command
  def initialize(path)
    super("Delte file : #{path}")
    @path = path
  end

  def execute
    if File.exists?(@path)
      @contents = File.read(@path)
    end
    File.delete(@path)
  end

  def undo_execute
    f = File.open(@path, "w")
    f.write(@contents)
    f.close
  end
end

# ファイルをコピーする命令
class CopyFile < Command
  def initialize(source, target)
    super("Copy file : #{source} to #{target}")
    @source = source
    @target = target
  end

  def execute
    FileUtils.copy(@source, @target)
  end

  def undo_execute
    File.delete(@target)
  end
end
```

最後にCreateFileクラス, DeleteFileクラス, CopyFileクラスを組み合わせて実行できるようにしたCompositeCommandクラスです。
このクラスもCommandを継承している、ConcreteCommandのひとつです。

```
# 複数のコマンドをまとめて実行できるようにしたオブジェクト
class CompositeCommand < Command
  def initialize
    @commands = []
  end

  def <<(cmd)
    @commands << cmd
  end

  def execute
    @commands.each { |cmd| cmd.execute }
  end

  def undo_execute
    @commands.reverse.each { |cmd| cmd.undo_execute }
  end

  def description
    description = ""
    @commands.each { |cmd| description += cmd.description + "\n" }
    description
  end
end
```

コーディングは以上です。実際に動かしてみます。

```
command_list = CompositeCommand.new
command_list << CreateFile.new("file1.txt", "hello world\n")
command_list << CopyFile.new("file1.txt", "file2.txt")
command_list << DeleteFile.new("file1.txt")

command_list.execute
puts command_list.description
#=> Create file : file1.txt
#=> Copy file : file1.txt to file2.txt
#=> Delete file : file1.txt

# 処理を取り消すコマンド
command_list.undo_execute
#=> file2が消えている
```