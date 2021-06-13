import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_blue_project/binding.dart';
import 'package:flutter_blue_project/view_model/bluetooth_controller.dart';
import 'package:get/get.dart';

import 'detail.dart';

class BlueScreen extends StatefulWidget {
  const BlueScreen({
    Key key,
  }) : super(key: key);

  @override
  _BlueScreenState createState() => _BlueScreenState();
}

// TODO: 와우 센서만 검색되도록 해야함.
// TODO: 한번 멈췄다가 재시작하면 notify가 작동을 안하는 문제가있음 -> 해결해야함? => (와후 센서) nRf앱도 오랫동안 입력이 없을시 자동 디스커넥트됨.
class _BlueScreenState extends State<BlueScreen> {
  BluetoothController _bluetoothController = Get.find<BluetoothController>();
  Stream<bool> isScanning;
  bool _isScanning = false;
  bool _isConnecting = false;
  bool isloading = false;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  RxList<ScanResult> bluetoothTile = <ScanResult>[].obs;
  RxList<List<int>> sensorData = <List<int>>[].obs;
  List<BluetoothService> services;
  BluetoothService thisService;
  final serviceUUID = "00001816-0000-1000-8000-00805f9b34fb";
  final characteristicUUID = "00002a5b-0000-1000-8000-00805f9b34fb";
  StreamSubscription _subscription;
  void startBle() {}

  // List<ScanResult> bluetoothTile = [];

//  _bluetoothController.bluetoothTile.toList();

//   Stream<void> scan() {
//     if (!_isScanning) {
//       print("scanning start");
//       _isScanning = true;

//       flutterBlue.startScan();
// // Listen to scan results
//       _subscription = flutterBlue.scanResults.listen((results) {
//         // do something with scan results
//         for (ScanResult r in results) {
//           var temp =
//               bluetoothTile.where((device) => device.device.id == r.device.id);
//           if (temp.length <= 0) {
//             bluetoothTile.add(r);
//           }
//           // print(
//           // 'name : ${r.device.name} rssi: ${r.rssi} advertisement: ${r.advertisementData}, blueTile: $bluetoothTile');
//           // 'name : ${r.device.name} rssi: ${r.rssi} advertisement: ${r.advertisementData}');
//         }
//       });

//       //

//     }
//   }

//   void stop() {
//     if (_isScanning) {
//       print("scanning stop");
//       _isScanning = false;
//       flutterBlue.stopScan();
//     }
//   }

//TODO: 클릭 2번시 disconnect 구현 - 됨 => 다른거 눌렀을때 꺼지는지, 아니면 그거랑 연결이 되는지 암튼 에러남
  // void connect(int index) async {
  //   var _bluetoothController = Get.find<BluetoothController>();
  //   if (!_isConnecting) {
  //     await bluetoothTile[index].device.connect();
  //     // sensorData.add([]);
  //     _isConnecting = true;
  //     print("connect");
  //     services = await bluetoothTile[index].device.discoverServices();
  //     _bluetoothController.servicesData.add(services);

  //     for (BluetoothService service in services) {
  //       // print("service.uuid =  ${service.uuid}");

  //       if (service.uuid.toString() == serviceUUID) {
  //         var characteristics = service.characteristics;
  //         print("characteristics.uuid = ${characteristics}");
  //         for (BluetoothCharacteristic c in characteristics) {
  //           if (c.uuid.toString() == characteristicUUID) {
  //             // var descriptors = c.descriptors;
  //             // for (BluetoothDescriptor d in descriptors) {
  //             //   //* 대관절 이 descriptors 부분으로 뭘 할수있을지 알아보자.
  //             //   List<int> value = await d.read();
  //             //   // print("d 1 :  $d");
  //             //   // print("value1 :  $value");

  //             //   await d.write([0x12, 0x34]); //!
  //             //   List<int> value3 = await d.read();
  //             //   // print("d 2 :  $d");
  //             //   // print(
  //             //   //     "writevalue3 :  $value3"); //* value를 write로 입력해주면 정확히 출력됨 약간 뭐 식별하는데 필요하다던가 할때 사용하는것 같기도한데 정확히 알아봐야한다
  //             // }

  //             await c.setNotifyValue(true);
  //             c.value.listen((value) {
  //               // do something with new value
  //               _bluetoothController.sensorData.add(value);
  //               // _bluetoothController.wheelDataList(value);
  //               // sensorData.add(value);
  //               // print("value2 : $value"); //! 현재 10진수로 출력된다.
  //             });
  //           }
  //         }
  //       }
  //     }
  //     // services.forEach((service) async {
  //     //   // print(service.uuid);
  //     //   if (service.uuid.toString() == serviceUUID) {
  //     //     var characteristics = service.characteristics;
  //     //     for (BluetoothCharacteristic c in characteristics) {
  //     //       if (c.properties.read) {
  //     //         List<int> value = await c.read();
  //     //         print("value $value");
  //     //       }
  //     //     }
  //     //   }
  //     // });
  //     if (_isConnecting) {
  //       // _isConnecting = true;
  //       print("_isConnecting $_isConnecting");
  //       Get.offNamed(
  //         "/detail",
  //         arguments: null,
  //       );
  //     }
  //   } else {
  //     bluetoothTile[index].device.disconnet();
  //     _isConnecting = false;
  //     print("disconnect");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blue"),
      ),
      body: Obx(
        () => ListView.builder(
            itemCount: _bluetoothController.bluetoothTile.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _bluetoothController.connect(index);
                  _bluetoothController.isloading =
                      !_bluetoothController.isloading;
                  if (_bluetoothController.isloading) {
                    Get.toNamed("/loading");
                  }
                  // }
                },
                child: ListTile(
                  title: Text(
                    'name : ${_bluetoothController.bluetoothTile[index].device.name}',
                  ),
                  subtitle: Text(_bluetoothController
                      .bluetoothTile[index].device.id
                      .toString()),
                  trailing: Text(_bluetoothController.bluetoothTile[index].rssi
                      .toString()),
                  //     Text(bluetoothTile[index].advertisementData.toString()),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'scan',
        // child: _isScanning ? Icon(Icons.stop) : Icon(Icons.play_arrow),
        child: IconButton(
          icon: _bluetoothController.isScanning
              ? Icon(Icons.stop)
              : Icon(Icons.play_arrow),
          onPressed: () {
            if (_bluetoothController.isScanning) {
              print('_isScanning1 ${_bluetoothController.isScanning}');
              setState(() {}); //icon 모양 바꾸기 위한 setState
              _bluetoothController.stop();
            } else {
              print('_isScanning22 ${_bluetoothController.isScanning}');
              setState(() {});
              _bluetoothController.scan();
            }
          },
        ),
      ),
    );
  }
}
