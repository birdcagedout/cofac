// Dartpad: DateTime, Duration

import 'dart:async';

void main() {
  // 1. DateTime(year만 필수, positional parameter만 있음)
  final dt1 = DateTime(2024, 5, 3, 20, 30, 0, 0, 0); // 로컬(한국)
  print(dt1);

  final dt2 = DateTime.utc(2024, 5, 3, 20, 30, 0, 0, 0); // utc(영국)
  print(dt2);

  print(dt1 == dt2);
  print(dt1.toUtc()); // 오전11시반(9시간 전)
  print(dt2.toUtc()); // 저녁8시반
  print(dt2.toLocal()); // 다음날 오전5시반(9시간 후)
  print('--------------------------');

  // 1-1. 현재 시각
  final dt3 = DateTime.now();
  print(dt3);

  // 2. Duration(필수 없음, 모두 named parameter임)
  final dr = Duration(days: 1, hours: 2, minutes: 0, seconds: 0);
  print(dr); // 26:00:00.000000

  // 3. 날짜에 add, subtract
  final dt4 = dt3.add(dr);
  print(dt4);

  final dt5 = dt3.subtract(dr);
  print(dt5);

  // 4. dt.isAfter(dt) / dt.isBefore(dt) / dt.isAtSameMomentAs(dt)
  print(dt1.isAfter(dt2)); // 한국시간 5월3일20시30분
  print(dt1.isBefore(dt2));
  print('--------------------------');

  // 5. DateTime에 값을 넣을 때 month -1 같은 연산도 가능(주의: 1월일 때는 에러)
  DateTime now = DateTime(2024, 1);
  print(now); // 2024-01-01 00:00:00.000
  final lastMonth = DateTime(now.year, now.month - 1, now.day);
  print(lastMonth); // 2023-12-01 00:00:00.000
  print(lastMonth.month); // 12

  final test = DateTime(2024, 0);
  print(test); // 2023-12-01 00:00:00.000
}