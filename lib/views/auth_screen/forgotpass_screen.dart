import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/auth_controller.dart';
import 'package:emart_app/views/auth_screen/login_screen.dart';
import 'package:emart_app/widgets_common/applogo_widget.dart';
import 'package:emart_app/widgets_common/bg_widget.dart';
import 'package:emart_app/widgets_common/custom_textfield.dart';
import 'package:emart_app/widgets_common/our_button.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());

    return bgWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.1).heightBox,
            applogoWidget(),
            10.heightBox,
            "Forgot Password".text.fontFamily(bold).white.size(18).make(),
            15.heightBox,
            Column(
              children: [
                customTextField(
                    hint: forgotHint,
                    title: email,
                    isPass: false,
                    controller: controller.forgotController),
                5.heightBox,
                ourButton(
                    color: lightGolden,
                    title: resetpass,
                    textColor: redColor,
                    onPress: () async {
                      await Get.put(AuthController()).forgetPassword(
                          email: controller.emailController.text,
                          context: context);
                      Get.to(() => const LoginScreen());
                    }).box.width(context.screenWidth - 50).make(),
                10.heightBox,
              ],
            )
                .box
                .white
                .rounded
                .padding(const EdgeInsets.all(16))
                .width(context.screenWidth - 70)
                .shadowSm
                .make(),
            10.heightBox,
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: wanttogoback,
                    style: TextStyle(fontFamily: regular, color: whiteColor),
                  ),
                  TextSpan(
                    text: loginbut,
                    style: TextStyle(fontFamily: bold, color: whiteColor),
                  ),
                ],
              ),
            ).onTap(() {
              Get.back();
            }),
          ],
        ),
      ),
    ));
  }
}
