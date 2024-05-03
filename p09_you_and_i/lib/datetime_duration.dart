// Dartpad: DateTime, Duration

import 'dart:async';

void main() {
  // 1. DateTime(year만 필수, positional parameter만 있음)
  final dt1 = DateTime(2024, 5, 3, 20, 30, 0, 0, 0);
  print(dt1);

  final dt2 = DateTime.utc(2024, 5, 3, 20, 30, 0, 0, 0);
  print(dt2);

  print(dt1 == dt2);

  // 1-1. 현재 시각
  final dt3 = DateTime.now();
  print(dt3);

  // 2. Duration(필수 없음, 모두 named parameter임)
  final dr = Duration(days: 1, hours: 2, minutes: 0, seconds: 0);
}
