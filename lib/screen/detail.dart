import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_blue_project/model/wheel_model.dart';
import 'package:flutter_blue_project/view_model/bluetooth_controller.dart';
import 'package:get/get.dart';
import 'package:hex/hex.dart';

import '../convert.dart';

class DetailScreen extends StatefulWidget {
  // RxList<ScanResult> bluetoothTile;

  DetailScreen({
    // this.bluetoothTile,
    // @required this.sensorData,
    Key key,
  }) : super(key: key);
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  BluetoothController _bluetoothController = Get.find<BluetoothController>();
  // BluetoothAnalysis bluetoothAnalysis = BluetoothAnalysis();
  WheelModel wheelModel;
  var temp = Get.arguments ?? "";

  int wheel_rev = 0;
  int wheel_ms = 0;
  void velocityData(List<int> sensorData) {
    //!안씀 analysis에서 처리함
    print("temp $temp");
    List<int> rev = sensorData;
    if (rev.length == 0) {
      return;
    }
    // String rev1Temp = rev[1].toString();
    // String rev2Temp = rev[2].toString();
    // print("rev1Temp $rev1Temp");
    // print("rev2Temp $rev2Temp");

    // String revSumTemp = rev2Temp + rev1Temp;
    // print("revSumTemp $revSumTemp");

    var hextemp = HEX.encode(rev); //*결과는 String, 안엔 16진수값으로 변환됨.
    print("hextemp $hextemp");

    //! 01234 중 2, 3번째
    print("hextemp.substring(2,4) ${hextemp.substring(2, 4)}");
    //! 4, 5 번째
    print("hextemp.substring(4,6) ${hextemp.substring(4, 6)}");

    String hex1Temp = hextemp.substring(2, 4);
    String hex2Temp = hextemp.substring(4, 6);
    var hexSumTemp = hex2Temp + hex1Temp;
    print("hexSumTemp $hexSumTemp");

    // var hexResult = HEX.decode(hexSumTemp);
    // print("hexResult $hexResult");

    // var hexAllResult = HEX.encode(hexResult);
    // print("hexAllResult $hexAllResult");

    var number = int.parse(hexSumTemp, radix: 16);
    wheel_rev = number;
    print("number $number");
    print("WheelRev $wheel_rev");

    String vel1Temp = hextemp.substring(10, 12);
    String vel2Temp = hextemp.substring(12, 14);
    var velSumTemp = vel2Temp + vel1Temp;
    print("velSumTemp $velSumTemp");

    var number2 = int.parse(velSumTemp, radix: 16);
    wheel_ms = number2;
    print("number2 $number2 ms");
    print("velocity $wheel_ms ms");
    // var hexAllResult = Convert.getHextoString(hexResult);
    // print("hexAllResult $hexAllResult");

    // var convertHex = Convert.getStringtoHex(hexSumTemp);
    // print("convertHex $convertHex");
    // int revSum = int.parse(revSumTemp);
    // print("revSum $revSum");
  }

// List<int> batteryCheck(List<int> sensorBatteryData){
//   List<int> rev = sensorBatteryData;
//     if (rev.length == 0) {
//       return sensorBatteryData;
//     }

// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("detail"),
        ),
        body: Obx(
          () {
            List<WheelModel> wheelDataList = _bluetoothController.wheelDataList;
            List<List<int>> sensorData = (_bluetoothController.sensorData);
            List<double> wheelVelocity = _bluetoothController.saveResult;
//toStringAsFixed(1)
            var wheelVM = _bluetoothController.wheelVelocityM;
            var wheelVKm = _bluetoothController.wheelVelocityKm;
            var wheelDistence = _bluetoothController.wheelDistence;
            // var wheelVs = wheelVec?.value?.toDouble() ?? 0;
            var wheelVMs =
                wheelVM?.value?.toStringAsFixed(1); //! 최종 속도값, m/s 출력되는 값
            var wheelVKmh =
                wheelVKm?.value?.toStringAsFixed(1); //! 최종 속도값, km/h 출력되는 값
            var wheelDis = wheelDistence?.value?.toStringAsFixed(2);
            // var wheelVMs = wheelVM?.value?.toInt() ?? 0; //! 최종 속도값, m/s 출력되는 값
            // var wheelVKmh =
            //     wheelVKm?.value?.toInt() ?? 0; //! 최종 속도값, km/h 출력되는 값

            // bluetoothAnalysis.analysis(sensorData.last ?? []);

            // wheelModel = WheelModel.fromHex(sensorData.last ?? []);

            //?test
            // return ListView.builder(
            //     itemCount: wheelDataList.length,
            //     itemBuilder: (_, index) {
            //       return Container(
            //         child: Text(wheelDataList[index].wheelRev.toString()),
            //       );
            //     });
            //?

            // return ListView(
            //   children: [
            //     ...wheelDataList.map((e) {
            //       return Container(
            //         child: Text(e.wheelRev.toString()),
            //       );
            //     }).toList()
            //   ],
            // );
//? 배터리 체크용이었나?
            // return ListView.builder(
            //     itemCount: sensorData.length,
            //     itemBuilder: (ctx, index) {
            //       return ListTile(
            //         title: Column(
            //           children: [
            //             Center(
            //                 child: Text(
            //               "Get",
            //               style: TextStyle(
            //                   fontSize: 18.0, fontWeight: FontWeight.bold),
            //             )),
            //             Divider(thickness: 8.0),
            //             Center(
            //                 child: Text(
            //               // "Get.arguments last  ${temp.last}",
            //               "sensorData last  ${sensorData.last ?? ""}",
            //               style: TextStyle(
            //                   color: Colors.blue,
            //                   fontSize: 15.0,
            //                   fontWeight: FontWeight.bold),
            //             )),
            //             SizedBox(height: 20.0),
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: <Widget>[
            //                 Text("Wheel_Rev : ${wheelModel.wheelRev}"),
            //                 // Text("  "),
            //                 SizedBox(
            //                   width: 10.0,
            //                 ),
            //                 Text("Wheel_Last_event : ${wheelModel.wheelMs}"),
            //               ],
            //             ),
            //             FlatButton(
            //                 onPressed: () async {
            //                   await bluetoothAnalysis.batteryCheck();
            //                 },
            //                 color: Colors.green,
            //                 shape: new RoundedRectangleBorder(
            //                     borderRadius: new BorderRadius.circular(30.0)),
            //                 child: Text(
            //                     "battery : ${_bluetoothController?.sensorBatteryData?.length > 0 ? _bluetoothController.sensorBatteryData.last.toString() : "Check"} %"))
            //           ],
            //         ),
            //       );
            //     });

            return Column(
              children: [
                Center(
                    child: Text(
                  "Get",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                )),
                Divider(thickness: 8.0),
                Center(
                    child: Text(
                  // "Get.arguments last  ${temp.last}",
                  "sensorData last  ${sensorData.last ?? ""}",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                )),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Wheel_Rev : ${wheelDataList?.last?.wheelRev ?? 0}"),
                    Text("  "),
                    Text(
                        "Wheel_Latency : ${wheelDataList?.last?.wheelLatencyMs ?? 0}"),
                  ],
                ),
                Text("Wheel_M/S : ${wheelVMs ?? 0}m/s"),
                Text("Wheel_Km/H : ${wheelVKmh ?? 0}km/h"),
                Text("Distence : ${wheelDis ?? 0}m"),
                // FlatButton(
                //     onPressed: () {
                //       velocityData();
                //     },
                //     child: Text("thisButton"))
              ],
            );
          },
        )
        // Obx(
        // if (temp != null) {
        //   Center(child: Text("Get.arguments last  $temp"));
        // }
        //   () =>
        //   ListView.builder(
        // itemCount: 1,
        // itemBuilder: (context, index) {
        // else {
        //   return Center(
        //     child: Text("ready"),
        //   );
        // }

        // return;
        //   },
        // ),
        // ),
        );
  }
}
