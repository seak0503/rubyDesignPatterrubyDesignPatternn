# Product
class Duck
  def initialize(name)
    @name = name
  end

  def eat
    puts "アヒル #{@name} は食事中です。"
  end

  def speak
    puts "アヒル #{@name} がガーガー鳴いています。"
  end

  def sleep
    puts "アヒル #{@name} は静かに眠っています。"
  end
end

# Product
class Frog
  def initialize(name)
    @name = name
  end

  def eat
    puts "カエル #{@name} は食事中です。"
  end

  def speak
    puts "カエル #{@name} はゲロゴロッと鳴いています。"
  end

  def sleep
    puts "カエル #{@name} は静かに眠りません。一晩中ゲロゲロ鳴いています。"
  end
end

# Creator
class Pond
  def initialize(number_animals)
    @animals = []
    number_animals.times do |i|
      animal = new_animal("動物#{i}")
      @animals << animal
    end
  end

  def simulate_one_day
    @animals.each { |animal| animal.speak }
    @animals.each { |animal| animal.eat }
    @animals.each { |animal| animal.sleep }
  end
end

# ConcreteCreator
class DuckPond < Pond
  def new_animal(name)
    Duck.new(name)
  end
end

# ConcreateCreator
class FrogPond < Pond
  def new_animal(name)
    Frog.new(name)
  end
end

# ======================================
pond = DuckPond.new(3)
pond.simulate_one_day

pond = FrogPond.new(3)
pond.simulate_one_day