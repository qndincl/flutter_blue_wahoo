import 'package:flutter/material.dart';
import 'package:flutter_blue_project/binding.dart';
import 'package:flutter_blue_project/controller/bluetooth_controller.dart';
import 'package:flutter_blue_project/screen/blueScreen.dart';
import 'package:flutter_blue_project/screen/detail.dart';
import 'package:flutter_blue_project/screen/loading.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    Get.put<BluetoothController>(BluetoothController());

    return GetMaterialApp(
      title: 'Flutter Blue demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => BlueScreen()),
        GetPage(
          name: '/detail',
          page: () => DetailScreen(),
        ),
        GetPage(
          name: '/loading',
          page: () => LoadingScreen(),
        ),
      ],
      home: BlueScreen(),
    );
  }
}
