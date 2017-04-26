# Proxy

プロキシパターンは1つのオブジェクトに複数の関心ことがある場合にそれを分離するために用います。たとえば、オブジェクトの本質的な目的とは異なる「セキュリティ要件やトランザクション管理など」を切り離して実装できます。

## Porxyの構成要素

プロキシの構成要素は次の2つです。

```
対象オブジェクト(subject)：本物のオブジェクト
代理サブジェクト(proxy)：特定の「関心事」を担当、それ以外を対象サブジェクトに渡す
```

プロキシオブジェクトは対象オブジェクトと同じインタフェースを持ちます。利用する際は、プロキシオブジェクトを通して対象となるオブジェクトを操作します。

## プロキシの3つのタイプ

プロキシには次の3つの種類があります。

```
* 防御Proxy
* 仮想Proxy
* リモートProxy
```

今回は、防御プロキシと仮想プロキシについてサンプルソースで説明していきます。

## サンプルソース1：防御プロキシ

このサンプルでは銀行の窓口業務(入金/出金)を担当するBankAccountクラスと、ユーザー認証を担当するBankAccountProxyクラスにより「関心ことを分離」するプロキシデザインパターンのモデルを作ります。

まず銀行の入出金の窓口業務を行うBankAccountクラスを作成します。

```
# 銀行の入出金業務を行う(対象オブジェクト/subject)
class BankAccount
  attr_reader :balance

  def initialize(balance)
    @balance = balance
  end

  # 入金
  def deposit(amount)
    @balance += amount
  end

  # 出金
  def withdraw(amount)
    @balance -= amount
  end
end
```

次に銀行の入出金業務とは関心ことの異なるユーザー認証を担当する防御プロキシとしてBankAccountProxyクラスを作ります。このクラスはBankAccountクラスと同じインタフェースを持っており、利用する側はプロキシを介して入出金を行います。

```
# etcはRubyの標準ライブラリで、/etc に存在するデータベースから情報を得る
# この場合は、ログインユーザー名を取得するために使う
require "etc"

# ユーザーログインを担当する防御Proxy
class BankAccountProxy
  def initialize(real_object, owner_name)
    @real_object = real_object
    @owner_name = owner_name
  end

  def balance
    check_access
    @real_object.balance
  end

  def deposit(amount)
    check_access
    @real_object.deposit(amount)
  end

  def withdraw(amount)
    check_access
    @real_object.withdraw(amount)
  end

  def check_access
    if Etc.getlogin != @owner_name
      raise "Illegal access: #{@owner_name} cannot access account."
    end
  end
end
```

コーディングは以上で、こちらを実際に動かしてみます。

```
# ログインユーザーの場合
account = BankAccount.new(100)
# login_userの部分はこの処理を行うMac/Linuxのログイン中のユーザー名に書き換えて下さい
proxy = BankAccountProxy.new(account, "shyamahira")
puts proxy.deposit(50)
#=>150
puts proxy.withdraw(40)
#=>110
puts proxy.balance
#=>110

# ログインユーザではない場合
account = BankAccount.new(100)
proxy = BankAccountProxy.new(account, "no_login_user")
puts proxy.deposit(50)
# `check_access': Illegal access: no_login_user cannot access account. (RuntimeError)
```

このようにユーザー認証という「特定の関心こと」を代理オブジェクトに分離させることができました。

## 仮想プロキシ

次に仮想プロキシのサンプルです。今回は、先ほどの入出金を行うBankAccountクラスと、BankAccountのインスタンス生成を遅らせるためのVirtualAccountProxyクラスを作成します。インスタンスの生成を遅らせる理由はここではシステム全体の性能向上と仮定します。

まずさきほどと同じ入出金業務のBankAccountクラスです。

```
# 銀行の入出金業務を行う(対象オブジェクト/subject)
class BankAccount
  attr_reader :balance

  def initialize(balance)
    puts "BankAccountを生成しました。"
    @balance = balance
  end

  def deposit(amount)
    @balance += amount
  end

  def withdraw(amount)
    @balance -= amount
  end
end
```

次にシステム全体の性能向上を目的としてBankAccountクラスの生成を遅らせる仮想プロキシとして、VirtualAccountProxyクラスを作成します。

```
# BankAccountの生成を遅らせる仮想Proxy
class VirtualAccountProxy
  def initialize(starting_balance)
    puts "VirtualAccountPoxyを生成しました。BankAccountはまだ生成していません。"
    @starting_balance = starting_balance
  end

  def balance
    subject.deposit(amount)
  end

  def deposit(amount)
    subject.deposit(amount)
  end

  def withdraw(amount)
    subject.withdraw(amount)
  end

  def announce
    "Virtual Account Proxyが担当するアナウンスです"
  end

  def subject
    @subject ||= BankAccount.new(@starting_balance)
  end
end
```

コーディング以上となります。ではこのサンプルを動かしてみます。

```
proxy = VirtualAccountProxy.new(100)
#=> VirtualAccountPoxyを生成しました。BankAccountはまだ生成していません。

puts proxy.announce
#=> Virtual Account Proxyが担当するアナウンスです

puts proxy.deposit(50)
#=> BankAccountを生成しました。
#=> 150

puts proxy.withdraw(10)
#=> 140
```

結果のようにdepositメソッドを実行するまで、BankAccountクラスが生成されないようになりました。この例では、VirtualAccountProxyが「BankAccountインスタンスの生成タイミング」という関心ごとを分離しています。

## Tips：method_missingによる委譲

ここでRubyの標準機能のひとつであるmethod_missingを使ったプロキシを紹介します。

Rubyでは未定義のメソッドが呼び出された場合にmethod_missingが呼び出されます。これを利用することでさきほどの防御プロキシのBankAccountProxyクラスを次のように短くできます。

```
# etcはRubyの標準ライブラリで、/etc に存在するデータベースから情報を得る
# この場合は、ログインユーザー名を取得するために使う
require "etc"

# 銀行の入出金業務を行う(対象オブジェクト/subject)
class BankAccount
  attr_reader :balance

  def initialize(balance)
    @balance = balance
  end

  # 入金
  def deposit(amount)
    @balance += amount
  end

  # 出金
  def withdraw(amount)
    @balance -= amount
  end
end

# ユーザーログインを担当する防御Proxy
class BankAccountProxy
  def initialize(real_object, owner_name)
    @real_object = real_object
    @owner_name = owner_name
  end

  # Rubyでは未定義のメソッド呼び出しが発生 => method_missingが呼び出される
   # method_missingを用いることでdeposit, withdrawを省略
   def method_missing(name, *args)
     check_access
     @real_object.send(name, *args)
   end

  def check_access
    if Etc.getlogin != @owner_name
      raise "Illegal access: #{@owner_name} cannot access account."
    end
  end
end
```

BankAccountProxyクラスに存在しない `#depositメソッド`、`#withdraw`が呼び出された場合、`#method_missing`が呼ばれます。そして、`#method_missing`内で`@real_object`に格納したオブジェクトの同名のメソッドが呼び出されます。

この方法はForwardableと同じ「委譲」のやり方のひとつです。

ただし、method_missingの利用には次のようなデメリットもあります。このデメリットをしっかり理解したうえで、利用することが大切です。

```
ソースコードが追いづらくなる
マシンパワーを消費する
```