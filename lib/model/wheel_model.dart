import 'package:hex/hex.dart';

class WheelModel {
  int wheelRev;
  int wheelLatencyMs;
  // int wheelVelMs_data;

  WheelModel(this.wheelRev, this.wheelLatencyMs);

//? analysis  함수 안쓰고 여기서 계산한다
  factory WheelModel.fromHex(List<int> data) {
    //! 초기화 빼먹는 실수
    // WheelModel wheelModel;
    // WheelModel wheelModel = WheelModel(0, 0);
    //연산 16진수 => Model변경

    // List<int> rev = data;
    // if (rev.length == 0) {
    //   wheelModel.wheelMs = null;
    //   wheelModel.wheelRev = null;
    //   return wheelModel;
    // }

    //16진수 인코드
    var hextemp = HEX.encode(data); //*결과는 String, 안엔 16진수값으로 변환됨.

    if (hextemp.length < 1) return WheelModel(0, 0);

    //*wheelRev 분석
    String hex1Temp = hextemp.substring(2, 4);
    String hex2Temp = hextemp.substring(4, 6);
    var hexSumTemp = hex2Temp + hex1Temp;

    var wheelRev = int.parse(hexSumTemp, radix: 16);
    // wheelModel.wheelRev = number;

    //*wheelMs 분석
    String vel1Temp = hextemp.substring(10, 12);
    String vel2Temp = hextemp.substring(12, 14);
    var velSumTemp = vel2Temp + vel1Temp;
    print("velSumTemp $velSumTemp");

    var wheelLatencyMs = int.parse(velSumTemp, radix: 16);

    // var wheelVelMs_data =

//* 속력 계산.

    // wheelModel.wheelMs = number2;

    return WheelModel(wheelRev, wheelLatencyMs);
  }

  // factory WheelModel.fromBattery(){

  // }

  //from Json
  //
  //to Json
}
