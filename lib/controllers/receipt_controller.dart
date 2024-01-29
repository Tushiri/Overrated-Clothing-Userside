import 'package:get/get.dart';

class ReceiptController extends GetxController {
  RxBool showReceipt = false.obs;

  void toggleReceipt() {
    showReceipt.toggle();
  }
}
