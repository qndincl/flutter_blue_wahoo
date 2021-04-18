import 'package:flutter/material.dart';
import 'package:flutter_blue_project/convert.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // void test() {
    //   List<int> hexList = [3, 177, 0, 0, 0, 223, 66, 0, 0, 19, 1];
    //   String string = Convert.getHextoString(hexList);
    //   print("hexList $hexList");
    //   List<int> result = Convert.getStringtoHex(string);
    //   print("reslut $result");
    // }

    // return Scaffold(
    //   body: Center(
    //     child: FlatButton(
    //       child: Text("tetsetest"),
    //       onPressed: () {
    //         test();
    //       },
    //     ),
    //   ),
    // );

    return Center(
      child: Container(
        height: size.height / 4,
        width: size.width / 2,
        child: CircularProgressIndicator(
          strokeWidth: 10.0,
          backgroundColor: Colors.grey,
        ),
      ),
    );
  }
}
