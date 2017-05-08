# Factory

GoFのデザインパターンのひとつ、ファクトリメソッド(Factory Method)をRubyのサンプルコードで紹介します。

ファクトリメソッドは、インスタンスの生成をサブクラスに任せるパターンです。インスタンスの生成部分を切り離すことで、結合度を下げて追加・変更・保守を容易にします。

## ソースコードを使ったファクトリメソッドの説明

ファクトリメソッドをソースコードを使って説明します。ここではサックスとサックスを作る工場を例に考えます。

* サックスを表すSaxophoneクラスは、音を鳴らす(play)メソッドを持っている
* 楽器工場を表すInstrumentFactoryクラス
    * コンストラクタの引数で楽器の数を受け取る
    * 楽器を出荷するメソッド「ship_out」をもつ

を満たすコードを書いていきます。

```
# サックス (Product)
class Saxophone
  def initialize(name)
    @name = name
  end

  def play
    puts "#{@name} は音を奏でています"
  end
end

# 楽器工場 (Creator)
class InstrumentFactory
  def initialize(number_saxophones)
    @saxophones = []
    number_saxophones.times do |i|
      saxophone = Saxophone.new("サックス #{i}")
      @saxophones << saxophone
    end
  end

  # 楽器を出荷する
  def ship_out
    @tmp = @saxophones.dup
    @saxophones = []
    @tmp
  end
end
```

上のプログラムを呼び出してみます。

```
factory = InstrumentFactory.new(3)
saxophones = factory.ship_out
saxophones.each { |saxophone| saxophone.play }
#=> サックス 0 は音を奏でています
#=> サックス 1 は音を奏でています
#=> サックス 2 は音を奏でています
```

ここで、トランペット(Trumpet)のモデルを追加することになりました。インタフェースはサックスとまったく同じものとします。

```
# トランペット (Product)
class Trumpet
  def initialize(name)
    @name = name
  end

  def play
    puts "トランペット #{@name} は音を奏でています"
  end
end
```

先ほど作ったInstrumentFactoryモデルをもう一度確認してみます。

```
# 楽器工場 (Creator)
class InstrumentFactory
  def initialize(number_saxophones)
    @saxophones = []
    number_saxophones.times do |i|
      saxophone = Saxophone.new("サックス #{i}")
      @saxophones << saxophone
    end
  end

  # 楽器を出荷する
  def ship_out
    tmp = @saxophones.dup
    @saxophones = []
    tmp
  end
end
```

トランペットを追加する場合にInstrumentFactoryモデルで問題になるのは、コンストラクタ(initialize)でサックスを作っている点です。

```
saxophone = Saxophone.new("サックス #{i}")
```

そこで、InstrumentFacotory内でサックスを生成している部分をサブクラス(SaxophoneFacotory)に切り出します。また、トランペットを生成するTrumpetFactoryクラスを作成します。

```
# 楽器工場 (Creator)
class InstrumentFactory
  def initialize(number_instruments)
    @instruments = []
    number_instruments.times do |i|
      instrument = new_instrument("楽器 #{i}")
      @instruments << instrument
    end
  end

  # 楽器を出荷する
  def ship_out
    @tmp = @instruments.dup
    @instruments = []
    @tmp
  end
end

# SaxophoneFactory: サックスを生成する (ConcreteCreator)
class SaxophoneFactory < InstrumentFactory
  def new_instrument(name)
    Saxophone.new(name)
  end
end

# TrumpetFactory: トランペットを生成する (ConcreteCreator)
class TrumpetFactory < InstrumentFactory
  def new_instrument(name)
    Trumpet.new(name)
  end
end
```

InstrumentFactoryはnew_instrument(楽器の生成)の処理を抽象化しています。 (抽象化は、言い換えると「異なるものをひとまとめにする」ということです)

上のプログラムの結果を確認します。

```
factory = SaxophoneFactory.new(3)
saxophones = factory.ship_out
saxophones.each { |saxophone| saxophone.play }
#=> サックス 楽器 0 は音を奏でています
#=> サックス 楽器 1 は音を奏でています
#=> サックス 楽器 2 は音を奏でています

factory = TrumpetFactory.new(2)
trumpets = factory.ship_out
trumpets.each { |trumpet| trumpet.play }
#=> トランペット 楽器 0 は音を奏でています
#=> トランペット 楽器 1 は音を奏でています
```

上のとおり、サックス/トランペットを作成、音を奏でることができました。

この例のようにクラスの選択をサブクラスに任せることを「FactoryMethod」と呼びます。ファクトリメソッドは次の3つで構成されています。

* Creator: ConcreteFactoryの共通部分の処理を行う(InstrumentFactory)
* ConcreteCreator: 実際にオブジェクトの生成を行う(SaxophoneFactory, TrumpetFactory)
* Product: ConcreteFactoryによって生成される側のオブジェクト(Saxophone、Trumpet)

## ファクトリメソッドのメリット

生成するProductへの依存度を下げて生成部分を切り離すことで変更や追加、保守を容易になります。