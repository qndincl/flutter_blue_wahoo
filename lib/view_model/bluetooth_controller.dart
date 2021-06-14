import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_blue_project/model/wheel_model.dart';
import 'package:get/get.dart';
import 'dart:async';

const double pi = 3.1415926535897932;
const UINT16_MAX = 65536; // 2^16
const UINT32_MAX = 4294967296; // 2^32

class BluetoothController extends GetxController {
  RxList<List<int>> sensorData = <List<int>>[].obs;
  RxList<List<int>> sensorBatteryData = <List<int>>[].obs;
  // RxList<List<int>> saveResult = <List<int>>[].obs;
  RxList<int> saveLatencyResult = <int>[].obs;
  RxList<int> saveRevResult = <int>[].obs;
  RxList<double> saveResult = <double>[].obs;
  RxList<List<BluetoothService>> servicesData = <List<BluetoothService>>[].obs;
  // BluetoothAnalysis analysis = BluetoothAnalysis();

  RxList<WheelModel> wheelDataList = <WheelModel>[].obs;
  RxDouble wheelVelocityM = 0.0.obs;
  RxDouble wheelVelocityKm = 0.0.obs;
  RxDouble wheelDistence = 0.0.obs;
  double wheelDistanceRes = 0;
  double resultKm = 0;
  double resultM = 0;
  double cummulativeLatency = 0;
  double cummulativeRev = 0;
  double cummulativeResultM = 0;
  double cummulativeResultKm = 0;
  int revDiff = 0;
  double updateRatio = 0.85;
  var test;

  bool isScanning = false;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  StreamSubscription subscription;

  RxList<ScanResult> bluetoothTile = <ScanResult>[].obs;

  List<BluetoothService> services;
  bool isConnecting = false;
  bool isloading = false;
  BluetoothService thisService;
  final serviceUUID = "00001816-0000-1000-8000-00805f9b34fb";
  final characteristicUUID = "00002a5b-0000-1000-8000-00805f9b34fb";
  // final heartServiceUUID = '0000180d-0000-1000-8000-00805f9b34fb';
  // final heartUUID = '00002a37-0000-1000-8000-00805f9b34fb';
  //Rx모델 리스트

  //서비스 uuid

  Stream<void> scan() {
    if (!isScanning) {
      print("scanning start");
      isScanning = true;
      flutterBlue.startScan();

      // Listen to scan results
      subscription = flutterBlue.scanResults.listen((results) {
        // do something with scan results
        for (ScanResult r in results) {
          var temp =
              bluetoothTile.where((device) => device.device.id == r.device.id);
          if (temp.length <= 0) {
            bluetoothTile.add(r);
          }
        }
      });
    }
  }

  void stop() {
    if (isScanning) {
      print("scanning stop");
      isScanning = false;
      flutterBlue.stopScan();
    }
  }

  void connect(int index) async {
    // var _bluetoothController = Get.find<BluetoothController>();
    if (!isConnecting) {
      await bluetoothTile[index].device.connect();
      // sensorData.add([]);
      isConnecting = true;
      print("connect");
      services = await bluetoothTile[index].device.discoverServices();
      servicesData.add(services);

      for (BluetoothService service in services) {
        // print("service.uuid =  ${service.uuid}"); //! 하나씩 서비스들 체크해보기
        if (service.uuid.toString() == serviceUUID) {
          // if (service.uuid.toString() == heartServiceUUID) {
          var characteristics = service.characteristics;
          print("characteristics.uuid = ${characteristics}");
          for (BluetoothCharacteristic c in characteristics) {
            if (c.uuid.toString() == characteristicUUID) {
              // if (c.uuid.toString() == heartUUID) {
              await c.setNotifyValue(true);
              //subscription value 저장
              c.value.listen((value) {
                //hex데이터 직접 저장 => model로 변환해서 model 리스트로 저장
                sensorData.add(value);
                // print("value_Heart = $value");
                wheelDataList.add(WheelModel.fromHex(value));
                // analysis.analysisMs(value);
                analysisVec();
              });
            }
          }
        }
      }
      if (isConnecting) {
        isConnecting = true;
        print("isConnecting $isConnecting");
        Get.offNamed(
          "/detail",
          arguments: null,
        );
      }
    } else {
      bluetoothTile[index].device.disconnect();
      isConnecting = false;
      print("disconnect");
    }
  }

  void analysisVec() {
    //! 현재 실제 속력 계산 부분
    if (wheelDataList.length < 2) return;
    var prevWheelData = wheelDataList[wheelDataList.length - 2];
    var currentWheelData = wheelDataList[wheelDataList.length - 1];
    //최초의 값이면 0을 만들어주기 위함. distence의 초기값을 0으로 해주기 위한것
    if (wheelDataList[wheelDataList.length - 2] == wheelDataList.first)
      prevWheelData.wheelRev = currentWheelData.wheelRev;

    if (prevWheelData.wheelRev == currentWheelData.wheelRev ||
        prevWheelData.wheelLatencyMs == currentWheelData.wheelLatencyMs) {
      wheelVelocityM.value = 0;
      wheelVelocityKm.value = 0;
    } else {
      //? 레이턴시 누적값 5초초과시 0으로 리셋
      // if (cummulativeLatency > 5.0) {
      //   cummulativeLatency = 0;
      //   cummulativeRev = 0;
      // }

      // cummulativeRev += revDiff; //? Rev 누적 테스트
      // print("resultCurrRev  ==${currentWheelData.wheelRev}");
      // print("resultPreRev  ==${prevWheelData.wheelRev}");
      //초속으로 변환
      double latencyDiff = 0;
      // int revDiffTmp =
      int latencyDiffTmp =
          currentWheelData.wheelLatencyMs - prevWheelData.wheelLatencyMs;
      // int latencyDiffTmp = latencyDiff;

      if (currentWheelData.wheelRev >= prevWheelData.wheelRev) {
        revDiff = (currentWheelData.wheelRev - prevWheelData.wheelRev);
        // cummulativeRev += revDiff; //? Rev 누적 테스트
      } else {
        revDiff += UINT32_MAX - prevWheelData.wheelRev;
      }

      if (latencyDiffTmp >= 0) {
        latencyDiff = latencyDiffTmp / 1024; //? 2^10으로 나눠주는 용도 정도라고 추측.
        // cummulativeLatency += latencyDiff; //? 레이턴시 누적 테스트
      } else {
        // latencyDiffTmp += (65535 - prevWheelData.wheelLatencyMs);
        latencyDiffTmp = currentWheelData.wheelLatencyMs +
            (UINT16_MAX - prevWheelData.wheelLatencyMs); //! 음수가 되는 경우를 없애주기 위함
        latencyDiff = latencyDiffTmp / 1024;
        // cummulativeLatency += latencyDiff; //? 레이턴시 누적 테스트
      }
//! 5초간의 누적 계산법
      // if (latencyDiff > 0.8 && latencyDiff < 1.3) latencyDiff = 1;

      // if (revDiff == 0) {
      //   //의미없.
      //   wheelVelocityM.value = 0.0;
      //   return;
      // }
      double result2 = revDiff / latencyDiff; // 바퀴/1초 //!!!test
      double result3 = revDiff / 1; // 바퀴/1초
      double cummulativeDivision =
          cummulativeRev / cummulativeLatency; //? 누적 값끼리의 계산

      // double result2 = (revDiff *
      //     (1000 / (latencyDiff + 1)) /
      //     (latencyDiff + 1) *
      //     (1000 / (latencyDiff + 1)));
      double wheelDistanceM = revDiff * 2 * pi * 0.3; // M로 거리(길이)나옴
      wheelDistanceRes += wheelDistanceM; //누적

      cummulativeResultM = cummulativeDivision * 2 * pi * 0.3;
      cummulativeResultKm = cummulativeResultM * 3.6;

      // var speed = (latencyDiff == 0) ? 0 : wheelDistanceM / latencyDiff * 3.6;
      resultM = result2 * 2 * pi * 0.3; // 1바퀴 길이=2*pi*0.3m
      // resultKm = resultM * 3.6 + 0.51; //3600 / 1000 = 3.6
      resultKm = resultM * 3.6 + 0.45; //3600 / 1000 = 3.6
      // if (latencyDiff < 0.85 || latencyDiff > 1.35) {
      //   test = .. * (1 - updateRatio) + resultKm * updateRatio;
      // }

      var res = resultM.abs();
      // print("result2 = $result2");
      // print("resultRevDiff $revDiff");
      // print("resultDistance $wheelDistanceRes");
      print("resultLatencyDiff = $latencyDiff");
      // print("cummulativeLatency = $cummulativeLatency");
      // print("cummulativeRev = $cummulativeRev");
      // print("resultM = $resultM");
      print("resultKm = $resultKm");
      // print("resultTest = $test");
      // print("resultSpeed = $speed");
      // print("cummulativeResultM = $cummulativeResultM");
      // print("cummulativeResultKm = $cummulativeResultKm");
      // print("result = $res");
      wheelVelocityM.value = resultM; // m로 출력
      wheelVelocityKm.value = resultKm; // km로 출력
      wheelDistence.value = wheelDistanceRes;
    }
  }

  void wheelDataToModel(List<int> data) {
    wheelDataList.add(WheelModel.fromHex(data));
  }

  void wheelMS(int data) {}

  void getWheelRevAndMs() {}

  void getBattery() {}
}
