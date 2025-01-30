import 'package:get/get.dart';

class AiController extends GetxController {
  String rating = "";
  String productName = "";

  Map<String, double> dataMap = {
    "Carbohydrates": 0,
    "Fat": 0,
    "Protein": 0,
    "Sodium": 0,
    "Sugar": 0,
    "Fiber": 0,
  };
}
