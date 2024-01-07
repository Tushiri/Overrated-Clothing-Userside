import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:emart_app/views/cart_screen/instructions/gcash_instructions_screen.dart';
import 'package:emart_app/views/cart_screen/instructions/paymaya_instructions_screen.dart';
import 'package:logger/logger.dart';
import 'dart:math';

class CartController extends GetxController {
  var totalP = 0.obs;

  final Logger _logger = Logger();

  //text controller for shipping details

  var streetController = TextEditingController();
  var subdiviController = TextEditingController();
  var cityController = TextEditingController();
  var postalcodeController = TextEditingController();
  var phonenumberController = TextEditingController();

  var paymentIndex = 0.obs;

  late dynamic productSnapshot = [];
  var products = [];
  var vendors = [];

  var placingOrder = false.obs;

  calculate(data) {
    totalP.value = 0;
    for (var i = 0; i < data.length; i++) {
      totalP.value = totalP.value + int.parse(data[i]['tprice'].toString());
    }
  }

  changePaymentIndex(index) {
    paymentIndex.value = index;

    if (index == 0) {
      _logger.i("Processing GCash payment...");
    } else if (index == 1) {
      _logger.i("Processing PayMaya payment...");
    } else {
      _logger.i("Processing Cash On Delivery payment...");
    }

    showInstructions(Get.context!, index);
  }

  placeMyOrder({required orderPaymentMethod, required totalAmount}) async {
    placingOrder(true);

    // Generate a unique 10-digit order code
    String orderCode = generateOrderCode();

    await getProductDetails();
    await firestore.collection(ordersCollection).doc().set({
      'order_code': orderCode,
      'order_date': FieldValue.serverTimestamp(),
      'order_by': currentUser!.uid,
      'order_by_name': Get.find<HomeController>().username,
      'order_by_email': currentUser!.email,
      'order_by_street': streetController.text,
      'order_by_subdivi': subdiviController.text,
      'order_by_city': cityController.text,
      'order_by_phonenumber': phonenumberController.text,
      'order_by_postalcode': postalcodeController.text,
      'shipping_method': "Home Delivery",
      'payment_method': orderPaymentMethod,
      'order_placed': true,
      'order_confirmed': false,
      'order_delivered': false,
      'order_on_delivery': false,
      'total_amount': totalAmount,
      'orders': FieldValue.arrayUnion(products),
      'vendors': FieldValue.arrayUnion(vendors),
    });

    placingOrder(false);
  }

  String generateOrderCode() {
    int randomNumber = Random().nextInt(900000) + 100000;
    String currentDate =
        DateTime.now().toLocal().toString().split(' ')[0].replaceAll('-', '');
    String orderCode = currentDate + randomNumber.toString();

    return orderCode;
  }

  getProductDetails() {
    products.clear();
    vendors.clear();
    for (var i = 0; i < productSnapshot.length; i++) {
      products.add({
        'color': productSnapshot[i]['color'],
        'img': productSnapshot[i]['img'],
        'vendor_id': productSnapshot[i]['vendor_id'],
        'tprice': productSnapshot[i]['tprice'],
        'qty': productSnapshot[i]['qty'],
        'title': productSnapshot[i]['title'],
      });
      vendors.add(productSnapshot[i]['vendor_id']);
    }
  }

  clearCart() {
    for (var i = 0; i < productSnapshot.length; i++) {
      firestore.collection(cartCollection).doc(productSnapshot[i].id).delete();
    }
  }

  void showInstructions(BuildContext context, int index) {
    if (index == 0) {
      showGCashInstructions(context);
    } else if (index == 1) {
      showPaymayaInstructions(context);
    } else {
      _logger.i("Showing instructions for other payment methods...");
    }
  }

  void showGCashInstructions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return GcashInstructionScreen();
      },
    );
  }

  void showPaymayaInstructions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return PaymayaInstructionScreen();
      },
    );
  }
}
