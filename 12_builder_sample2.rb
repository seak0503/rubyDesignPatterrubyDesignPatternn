# SaltWater: 塩水クラス(ConcreteBuilder：ビルダーの実装部分)
class SaltWater
  attr_accessor :water, :salt
  def initialize(water, salt)
    @water = water
    @salt = salt
  end

  # 素材(塩)を加える
  def add_material(salt_amount)
    @salt += salt_amount
  end
end

# SugarWater： 砂糖水クラス (ConcreteBuilder：ビルダーの実装部分)
class SugarWater
  attr_accessor :water, :sugar
  def initialize(water, sugar)
    @water = water
    @sugar = sugar
  end

  # 素材(砂糖)を加える
  def add_material(sugar_amount)
    @sugar += sugar_amount
  end
end

# # SugarWaterBuilder： 加工した水を生成するためのインターフェイス(Builder)
class WaterWithMaterialBuilder
  def initialize(class_name)
    @water_with_material = class_name.new(0, 0)
  end

  # 素材を加える
  def add_material(material_amount)
    @water_with_material.add_material(material_amount)
  end

  # 水を加える
  def add_water(water_amount)
    @water_with_material.water += water_amount
  end

  # 砂糖水の状態を返す
  def result
    @water_with_material
  end
end

# Director: 砂糖水の作成過程を取り決める
class Director
  def initialize(builder)
    @builder = builder
  end

  def cook
    @builder.add_water(150)
    @builder.add_material(90)
    @builder.add_water(300)
    @builder.add_material(35)
  end
end

# ===========================================
builder = WaterWithMaterialBuilder.new(SugarWater)
director = Director.new(builder)
director.cook

p builder.result


builder = WaterWithMaterialBuilder.new(SaltWater)
director = Director.new(builder)
director.cook

p builder.result

#=> #<SugarWater:0x007fdd59824fe0 @water=450, @sugar=125>