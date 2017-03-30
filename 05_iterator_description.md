# はじめに

イーテレーターパターンは次のような場合に使います。

```
* 要素の集まったオブジェクト(配列など)にアクセスする
* 集合の要素に順にアクセスする必要がある
```

# イテレータとは?

GoFではイーテレータを次のように定義しています。

```
集約オブジェクトがもとにある内部表現を公開せずに、その要素に順にアクセスする方法を提供する
```

言い換えると、要素の集まりを持つオブジェクトの各要素に、順番にアクセスする方法を提供するためのデザインパターンです。


# 内部イテレータ

Rubyのeachと同じもの。コードブロックベースのイーテレータのこと。

# 外部イテレータ

ここでは次のようなモデルで外部イーテレータを説明します。

```
* Blogクラス(集約オブジェクト): 複数のArticleクラスを持つオブジェクト
* Articleクラス(集約オブジェクト内の要素): Blogクラスの個別の要素
* BlogIteratorクラス(外部イーテレータ): Blogの要素Articleにアクセスするためクラス
```

まず、記事を表す`Article`クラスです。

```
# 記事を表す(集約オブジェクト中の要素)
class Article
  # 記事のタイトル
  attr_reader :title

  def initialize(title)
    @title = title
  end
end
```

次は、記事を複数持つブログを表す`Blogクラス`です。

```
# ブログを表す(集約オブジェクト)
class Blog
  def initialize
    @articles = []
  end

  # 指定インデックスの要素を返す
  def [](index)
    @articles[index]
  end

  # 要素(Article)を追加する
  def <<(article)
    @articles << article
  end

  # 要素(Article)の数を返す
  def length
    @articles.length
  end

  # イテレータの生成
  def iterator
    BlogIterator.new(self)
  end
end
```

最後に外部イーテレータであるBlogIteratorクラスです。

```
# 外部イテレータ
class BlogIterator
  def initialize(blog)
    @blog = blog
    @index = 0
  end

  # 次のindexの要素が存在するかをtrue/falseで返す
  def has_next?
    @index < @blog.length
  end

   # 今のArticleクラスを返し、indexを1つ進める
   def next_article
    article = self.has_next? ? @blog[@index] : nil
    @index += 1
    article
   end
end
```

ソースコードは以上です。では、実際の動作を確認してみます。

```
blog = Blog.new
blog << Article.new("デザインパターン1")
blog << Article.new("デザインパターン2")
blog << Article.new("デザインパターン3")
blog << Article.new("デザインパターン4")
blog << Article.new("デザインパターン5")

iterator = blog.iterator
while iterator.has_next?
  article = iterator.next_article
  puts article.title
end

デザインパターン1
デザインパターン2
デザインパターン3
デザインパターン4
デザインパターン5
```

# Enumerable モジュール

唐突ですが、Rubyの便利モジュール Enumerableの紹介です。Enumerable モジュールをインクルードすると、集約オブジェクト向けの「all?やany?、include?」といった便利なメソッドを取り込むことができます。

以下は取り込んだ場合のサンプルソースです。

```
# 銀行口座を表す
class Account
  attr_accessor :name, :balance

  def initialize(name, balance)
    @name = name
    @balance = balance
  end

  def <=>(other)
    @balance <=> other.balance
  end
end

# 有価証券のセットを表す
class Portfolio
  include Enumerable

  def initialize
    @accounts = []
  end

  def each(&block)
    @accounts.each(&block)
  end

  def <<(account)
    @accounts << account
  end
end

# ===========================================

portfolio = Portfolio.new

portfolio << Account.new("account1", 1000)
portfolio << Account.new("account2", 2000)
portfolio << Account.new("account3", 3000)
portfolio << Account.new("account4", 4000)
portfolio << Account.new("account5", 5000)

# $3000より多く所有している口座があるか？
puts portfolio.any? { |account| account.balance > 3000 }
#=> true

# すべての口座が$2000以上あるか？
puts portfolio.all? { |account| account.balance >= 2000 }
#=> false
```

