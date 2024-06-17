// Dartpad에서 실행

import 'dart:async';

void main() {
  print("----- main 실행 -----");

  // 1. 한번만 실행
  Timer(
    Duration(seconds: 3),
    () {
      print("3초 후에 1번 실행하고 끝");
    },
  );

  // 2. 주기적 실행
  var total = 0;
  Timer.periodic(
    Duration(seconds: 1),
    (Timer timer) {
      // 최초 Timer의 인스턴스가 인자로 들어옴
      if (total < 10) {
        print("1초 지남: ${9 - total}번 남음");
        total++;
      } else {
        timer.cancel();
      }
    },
  );

  // 1번과 2번은 비동기적으로 실행되므로
  // 2번 주기적 실행이 2번 출력된 후에
  // 1번 한번만 실행이 출력된다
}
