# Rubyによるデザインパターン

## 第7章 コレクションを操作する Iterator に関する補足

### p122の`ArrayIteratorが配列への変更に耐えられるように` の部分

この例の場合、確かに配列への変更に耐えられるようになる

```
[36] pry(main)> array = [1, 2, 3]
=> [1, 2, 3]
[37] pry(main)> @array = Array.new(array)
=> [1, 2, 3]
[40] pry(main)> array.object_id
=> 70157985309360
[42] pry(main)> @array.object_id
=> 70157997248040
[44] pry(main)> array[0] = 9
=> 9
[47] pry(main)> array
=> [9, 2, 3]
[48] pry(main)> @array
=> [1, 2, 3]
```

本に書いてある`コピーはオリジナルの内容を参照し、内容はコピーされたものではなく、新しい配列を走査します`の文が理解できる。

しかし、ネストされた配列の場合はそうはいかない。

* ネストされた配列

```
[53] pry(main)> array = [1, 2, [3, 4, 5]]
=> [1, 2, [3, 4, 5]]
[54] pry(main)> @array = Array.new(array)
=> [1, 2, [3, 4, 5]]
[55] pry(main)> array.object_id
=> 70157985562320
[56] pry(main)> @array.object_id
=> 70157993237880
[64] pry(main)> array[2][0] = 9
=> 9
[66] pry(main)> array
=> [1, 2, [9, 4, 5]]
[67] pry(main)> @array
=> [1, 2, [9, 4, 5]]
```

`array`変数のネストされた配列の値を変更すると、`@array`変数のネストされた配列の値も変更されてしまった。

その理由は下記を見るとわかる。

```
[58] pry(main)> array[2].object_id
=> 70157985562360
[59] pry(main)> @array[2].object_id
=> 70157985562360
```

ネストされた配列のobject_idが同じ。つまり、`array`も`@array`も、1次元の配列への参照はそれぞれ別のオブジェクトを参照しているが、2次元への配列への参照は`array[2]`も`@array[2]`も同じオブジェクトを参照していることになる。

