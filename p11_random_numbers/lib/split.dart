// String에 split 적용

void main() {

  // 1. String에 split
  final a = 'apple,banana,candy';
  final b = a.split(',');
  print(b);    // [apple, banana, candy]

  final c = '12345';
  final d = c.split('');
  print(d);   // [1, 2, 3, 4, 5]


  // 2. '123'을 ['1','2','3']으로 만들기
  final numbers = [123, 456, 789];
  final result = numbers.
    map(
      (e) => e.toString().split(''),
    ).
    toList();
  print(result);    // [[1, 2, 3], [4, 5, 6], [7, 8, 9]]


  // 3. double을 toString하면 ==> 소숫점 아래 숫자에 따라 달라짐
  final double d1 = 1000.0;
  print(d1.toString());       // 1000

  final double d2 = 1000.00;
  print(d2.toString());       // 1000

  final double d3 = 1000.01;
  print(d3.toString());       // 1000.01

}
