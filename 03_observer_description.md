# Observer

GoFのデザインパターン(Design Pattern)のオブザーバー(Observer)のRubyコードを使った紹介記事です。

次の条件を満たす場合にオブザーバーパターンを使います。

```
* オブジェクトの状態が変化する可能性がある
* 変化したことを他のオブジェクトに通知する必要がある
```

例としては、Aで起きたイベントをB, Cが知る必要が有る場合などです。

## オブザーバーとは？
あるオブジェクトの状態が変化した際に、そのオブジェクト自身が「観察者」に「通知」する仕組みです。オブザーバは以下の3つのオブジェクトによって構成されます。

```
* サブジェクト(subject)：変化する側のオブジェクト
* オブザーバ(Observer)：状態の変化を関連するオブジェクトに通知するインタフェース
* 具象オブザーバ(ConcreteObserver)：状態の変化に関連して具体的な処理を行う
```

## オブザーバのメリット

```
* オブジェクト間の依存度を下げることができる
* 通知先の管理をオブザーバが行うことで、サブジェクトは通知側を意識しなくていい
```

## サンプルソース

次のようなモデルを通してObserverデザインパターンを説明します。

```
* Employee(サブジェクト)：従業員を表す
* JPayroll(具体オブザーバ１)：給与の小切手の発行を行う
* TaxMan(具体オブザーバ２)：税金の請求書の発行を行う
```

まずは従業員を表すEmployeeクラスについてです。このEmployeeクラスは、name, title, salaryといったデータと、salaryの変更を受け付けるメソッドを持っています。

さらに、EmployeeクラスにRubyの標準ライブラリであるObservableモジュールをincludeします。このモジュールによりオブジェクトにObserverパターンを適用するために必要なあらゆるサポートが提供されます。

具体的には書きメソッドが提供されます。

```
* add_observerメソッドで通知する先のオブジェクトを追加
* changedメソッドとnotify_observersメソッドでオブジェクトに通知
```

こちらが、Employeeクラスの実装です。

```
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
```

次に給与の小切手の発行を行うPayrollクラスと、税金の請求書の発行を行うTaxManクラスを作成します。これらは具体オブザーバ(ConcreteObserver)にあたります。

```
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
```

コーディングは以上です。では結果を確認します。

```
john = Employee.new('John', 'Senior Vice President', 5000)
john.add_observer(Payroll.new)
john.add_observer(TaxMan.new)

john.salary = 6000
#=> 彼の給料は6000になりました！Senior Vice Presidentのために新しい小切手を切ります。
#=> Johnに新しい税金の請求書を送ります
john.salary = 7000
#=> 彼の給料は7000になりました！Senior Vice Presidentのために新しい小切手を切ります。
#=> Johnに新しい税金の請求書を送ります
```

johnのsalary(給与)を変更するとObservableによってPayrollクラスと、TaxManクラスの`update`メソッドが連動して動いていることがわかります。

## ストラテジーとの違い

```
* オブザーバ：発生しているオブジェクトに対してイベントを通知している
* ストラテジー：何らかの処理を行うためにオブジェクトを取得している
```