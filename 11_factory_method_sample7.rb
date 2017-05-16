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

# Product
class Algae
  def initialize(name)
    @name = name
  end

  def grow
    puts "藻 #{@name} は日光を浴びて育ちます。"
  end
end

# Product
class WaterLily
  def initialize(name)
    @name = name
  end

  def grow
    puts "スイレン #{@name} は浮きながら日光を浴びて育ちます。"
  end
end

# Product
class Tree
  def initialize(name)
    @name = name
  end

  def grow
    puts "樹木 #{@name} が高く育っています。"
  end
end

# Product
class Tiger
  def initialize(name)
    @name = name
  end

  def eat
    puts "トラ #{@name} は食べたいものを何でも食べます。"
  end

  def speak
    puts "トラ #{@name} はガォーとほえています。"
  end

  def sleep
    puts "トラ #{@name} は眠くなったら眠ります。"
  end
end

# Factory
class OrganismFactory
  def initialize(plant_class, animal_class)
    @plant_class = plant_class
    @animal_class = animal_class
  end

  def new_animal(name)
    @animal_class.new(name)
  end

  def new_plant(name)
    @plant_class.new(name)
  end
end

# Creator
class Habitat
  def initialize(number_animals, number_plants, organism_factory)
    @organism_factory = organism_factory

    @animals = []
    number_animals.times do |i|
      animal = @organism_factory.new_animal("動物#{i}")
      @animals << animal
    end

    @plants = []
    number_plants.times do |i|
      plant = @organism_factory.new_plant("植物#{i}")
      @plants << plant
    end
  end

  def simulate_one_day
    @plants.each { |plant| plant.grow }
    @animals.each { |animal| animal.speak }
    @animals.each { |animal| animal.eat }
    @animals.each { |animal| animal.sleep }
  end
end

# ======================================
jungle_organism_factory = OrganismFactory.new(Tree, Tiger)
pond_organism_factory = OrganismFactory.new(WaterLily, Frog)
jungle = Habitat.new(1, 4, jungle_organism_factory)
jungle.simulate_one_day

pond = Habitat.new(2, 4, pond_organism_factory)
pond.simulate_one_day