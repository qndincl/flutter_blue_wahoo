import 'package:flutter_blue_project/view_model/bluetooth_controller.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<HomeController>(() => HomeController());
    // Get.put<Service>(()=> Api());
    // Get.
    Get.lazyPut<BluetoothController>(() => BluetoothController());
  }
}
