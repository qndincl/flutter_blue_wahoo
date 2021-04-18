import 'dart:convert';

class Convert {
  static List<int> getStringtoHex(String string) {
    print("getStringtoHex11 $string");
    return ascii.encode(string);
  }

  static String getHextoString(List<int> hexList) {
    print("getHextoString22 $hexList");
    return ascii.decode(hexList);
    // print("temp $temp");
    // return temp;
  }
}
