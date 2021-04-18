import 'package:hex/hex.dart';

class BluetoothAnalysis {
  int wheelRev = 0;
  int wheelMs = 0;

  void analysis(List<int> data) {
    // 데이터 복사 및 길이 확인
    List<int> rev = data;
    if (rev.length == 0) {
      return;
    }

    //16진수 인코드
    var hextemp = HEX.encode(rev); //*결과는 String, 안엔 16진수값으로 변환됨.

    //wheelRev 분석
    String hex1Temp = hextemp.substring(2, 4);
    String hex2Temp = hextemp.substring(4, 6);
    var hexSumTemp = hex2Temp + hex1Temp;

    var number = int.parse(hexSumTemp, radix: 16);
    wheelRev = number;

    //wheelMs 분석
    String vel1Temp = hextemp.substring(10, 12);
    String vel2Temp = hextemp.substring(12, 14);
    var velSumTemp = vel2Temp + vel1Temp;
    print("velSumTemp $velSumTemp");

    var number2 = int.parse(velSumTemp, radix: 16);
    wheelMs = number2;
  }
}
