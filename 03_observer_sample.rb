require 'observer'

# 従業員を表す
class Employee
  include Observable # オブザーバブル(Subject)として働く

  attr_reader :name, :title, :salary

  def initialize(name, title, salary)
    @name =name
    @title = title
    @salary = salary
  end

  # 給与をセットして、ConcreteObserverに通知する
  def salary=(new_salary)
    @salary = new_salary
    changed
    notify_observers(self)
  end
end

# 給与の小切手の発行を行う(ConcreteObserver)
class Payroll
  def update(changed_employee)
    puts "彼の給料は#{changed_employee.salary}になりました!#{changed_employee.title}のために新しい小切手を切ります。"
  end
end

# 税金の請求書の発行を行う(ConcreteObserver)
class TaxMan
  def update(changed_employee)
    puts "#{changed_employee.name}に新しい税金の請求書を送ります。"
  end
end

# ===========================================

john = Employee.new('John', 'Senior Vice President', 5000)
john.add_observer(Payroll.new)
john.add_observer(TaxMan.new)
john.salary = 6000
john.salary = 7000