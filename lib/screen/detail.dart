import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_blue_project/controller/bluetooth_controller.dart';
import 'package:flutter_blue_project/util/bluetooth_analysis.dart';
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
  BluetoothAnalysis bluetoothAnalysis = BluetoothAnalysis();
  var temp = Get.arguments ?? "";

  int wheel_rev = 0;
  int wheel_ms = 0;
  void velocityData(List<int> sensorData) {
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

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Obx(
          () {
            List<List<int>> sensorData = (_bluetoothController.sensorData);

            bluetoothAnalysis.analysis(sensorData.last ?? []);

            return ListView.builder(
                itemCount: sensorData.length,
                itemBuilder: (ctx, index) {
                  return ListTile(
                    title: Column(
                      children: [
                        Center(
                            child: Text(
                          "Get",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
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
                            Text("Wheel_Rev : ${bluetoothAnalysis.wheelRev}"),
                            // Text("  "),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                                "Wheel_Last_event : ${bluetoothAnalysis.wheelMs}"),
                          ],
                        ),
                        // FlatButton(
                        //     onPressed: () {
                        //       velocityData();
                        //     },
                        //     child: Text("thisButton"))
                      ],
                    ),
                  );
                });

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
                    Text("Wheel_Rev : $wheel_rev"),
                    Text("Wheel_ms : $wheel_ms"),
                  ],
                ),
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
