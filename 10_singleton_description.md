# Singleton

シングルトンパターンは、1つだけに限定されたインスタンスを複数のオブジェクト内で共有する場合に用います。たとえば、ログの書込処理を行うメソッドでのファイルへのアクセスや、システム内で共通のキャッシュテーブルを参照する場合などです。

## GoFのシングルトンの前提条件

```
作成したクラスは唯一1つだけのインスタンスを自身で作成する
システム内のどこでもその1つだけのインスタンスにアクセスできる
```

## サンプルソース

シングルトンパターンのサンプルを作成していきます。

ここでは、Rubyの標準ライブラリであるSingletonモジュールを使います。
このSingletonモジュールを使うことで、Mix-inしたクラスのインスタンスは常に同一のものを返すようになります。

```
# Singletonは、Mix-inしたクラスのinstanceは同一のインスタンスを返すようになる
require "singleton"

# シングルトン
class SingletonObject
  include Singleton
  attr_accessor :counter

  def initialize
    @counter = 0
  end
end
```

上のコードを動かしてみます。

```
obj1 = SingletonObject.instance
obj1.counter += 1
puts obj1.counter
# 1

obj2 = SingletonObject.instance
obj2.counter += 1
puts obj2.counter
# 2
```

Singletonの条件を満たすオブジェクトを生成できていることがわかります。
また、Object#newが失敗することも次のコードで確認できます。

```
obj3 = SingletonObject.new
# private method `new' called for SingletonObject:Class (NoMethodError)
```



