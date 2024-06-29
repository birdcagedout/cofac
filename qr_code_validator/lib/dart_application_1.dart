import 'data.dart';
import 'qr_core.dart';

void main() {
  var good = 0;
  var bad = 0;

  for (var i = 0; i < data.length; i++) {
    var info = getValidQRInfo(data[i]);
    if (info.isMyQR) {
      good++;
    } else {
      print(data[i]);
      bad++;
    }
  }
  print("good: $good, bad: $bad");
}
