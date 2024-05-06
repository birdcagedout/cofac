// map함수

void main() {

  // 1. 간단한 map: [1,2,3] => ['1','2','3']
  final result = [1, 2, 3].map((e) => e.toString()).toList();
  print(result[0].runtimeType);   // String
  print(result);    // ['1', '2', '3']

  // 2. 복잡한 map
  final result2 = [[1,2,3], [4,5,6], [7,8,9]].
    map(
      (e) => e.
        map(
          (f) => f.toString(),
        ).
      toList(),
    ).
  toList();
  print(result2);   // [['1','2','3'], ['4','5','6'], ['7','8','9']]


  // 3. map에 index 사용하기1: asMap
  final asMap = ['a', 'b', 'c'].asMap();
  print(asMap);   // {0: a, 1: b, 2: c}

  // 4. map에 index 사용하기2: asMap + keys/values
  final keys = ['a', 'b', 'c'].asMap().keys;
  final values = ['a', 'b', 'c'].asMap().values;
  print(keys);      // (0, 1, 2)
  print(values);    // (a, b, c)

  // 5. map에 index 사용하기2: asMap + map(i, e) + MapEntry(i, e) + values
  final result3 = ['a','b','c','d','e','f'].
    asMap().
      map(
        (i, e) => MapEntry(i, 'asset/img/${i+1}.png'),
      ).
    values.toList();
  print(result3);   // [asset/img/1.png, asset/img/2.png, asset/img/3.png, asset/img/4.png, asset/img/5.png, asset/img/6.png]
}