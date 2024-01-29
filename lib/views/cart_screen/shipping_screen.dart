import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/cart_controller.dart';
import 'package:emart_app/views/cart_screen/payment_method.dart';
import 'package:emart_app/widgets_common/custom_textfield.dart';
import 'package:emart_app/widgets_common/our_button.dart';
import 'package:get/get.dart';

class ShippingDetails extends StatelessWidget {
  const ShippingDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Shipping Info"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          onPress: () {
            if (_validateForm(controller)) {
              Get.to(() => const PaymentMethods());
            } else {
              VxToast.show(context, msg: "Please fill the form");
            }
          },
          color: blackcolor,
          textColor: whiteColor,
          title: "Continue",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            customTextField(
              hint: "Unit/building no./Street",
              isPass: false,
              title: "Unit/building no./Street",
              controller: controller.streetController,
              maxLength: 16,
            ),
            customTextField(
              hint: "Subdivision/Baranggay",
              isPass: false,
              title: "Subdivision/Baranggay",
              controller: controller.subdiviController,
              maxLength: 22,
            ),
            customTextField(
              hint: "City",
              isPass: false,
              title: "City",
              controller: controller.cityController,
              maxLength: 15,
            ),
            customTextField(
              hint: "Postal Code",
              isPass: false,
              title: "Postal Code",
              controller: controller.postalcodeController,
              maxLength: 4,
              isNumeric: true,
            ),
            customTextField(
              hint: "Phone Number",
              isPass: false,
              title: "Phone Number",
              controller: controller.phonenumberController,
              maxLength: 11,
              isNumeric: true,
            ),
          ],
        ),
      ),
    );
  }

  bool _validateForm(CartController controller) {
    return controller.streetController.text.isNotEmpty &&
        controller.subdiviController.text.isNotEmpty &&
        controller.cityController.text.isNotEmpty &&
        controller.postalcodeController.text.isNotEmpty &&
        controller.phonenumberController.text.isNotEmpty;
  }
}
