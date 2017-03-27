class Task
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def get_time_required
    0.0
  end
end

class AddDryIngredientsTask < Task
  def initialize
    super('Add dry ingredients')
  end

  def get_time_required
    1.0
  end
end

class MixTask < Task
  def initialize
    super('Mix that batter up!')
  end

  def  get_time_required
    3.0
  end
end

class AddLiquidsTask < Task
  def initialize
    super('Add requieds')
  end

  def  get_time_required
    2.0
  end
end

class CompositeTask < Task
  def initialize(name)
    super(name)
    @sub_tasks = []
  end

  def <<(task)
    @sub_tasks << task
  end

  def remove_sub_task(task)
    @sub_tasks.delete(task)
  end

  def get_time_required
    time = 0.0
    @sub_tasks.each { |task| time += task.get_time_required }
    time
  end
end

class MakeBatterTask < CompositeTask
  def initialize
    super('Make batter')
    self << (AddDryIngredientsTask.new)
    self << (AddLiquidsTask.new)
    self << (MixTask.new)
  end
end

# ===================================

make_batter = MakeBatterTask.new
puts make_batter.get_time_required