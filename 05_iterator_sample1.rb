# 記事を表す(集約オブジェクト中の要素)
class Article
  # 記事のタイトル
  attr_reader :title

  def initialize(title)
    @title = title
  end
end

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

# =====================================================
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
