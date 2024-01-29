import 'package:emart_app/controllers/auth_controller.dart';
import 'package:emart_app/views/auth_screen/forgotpass_screen.dart';
import 'package:emart_app/views/auth_screen/signup_screen.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/views/home_screen/home.dart';
import 'package:emart_app/widgets_common/applogo_widget.dart';
import 'package:emart_app/widgets_common/bg_widget.dart';
import 'package:emart_app/widgets_common/custom_textfield.dart';
import 'package:emart_app/widgets_common/exit_dialog.dart';
import 'package:emart_app/widgets_common/our_button.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());

    return WillPopScope(
      onWillPop: () async {
        if (Get.currentRoute == '/login') {
          return true;
        } else {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => exitDialog(context),
          );
          return false;
        }
      },
      child: bgWidget(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Column(
              children: [
                (context.screenHeight * 0.1).heightBox,
                applogoWidget(),
                10.heightBox,
                "Log in to $appname"
                    .text
                    .fontFamily(bold)
                    .white
                    .size(18)
                    .make(),
                15.heightBox,
                Obx(() => Column(
                      children: [
                        customTextField(
                          hint: emailHint,
                          title: email,
                          isPass: false,
                          controller: controller.emailController,
                        ),
                        customTextField(
                          hint: passwordHint,
                          title: password,
                          isPass: !controller.isPasswordVisible.value,
                          controller: controller.passwordController,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              controller.togglePasswordVisibility();
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const ForgotPassword();
                                  },
                                ),
                              );
                            },
                            child: forgetPass.text.make(),
                          ),
                        ),
                        5.heightBox,
                        controller.isloading.value
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(blackcolor),
                              )
                            : ourButton(
                                color: blackcolor,
                                title: login,
                                textColor: whiteColor,
                                onPress: () async {
                                  controller.isloading(true);

                                  await controller
                                      .loginMethod(context: context)
                                      .then((value) {
                                    if (value != null) {
                                      VxToast.show(context, msg: loggedin);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Home(),
                                        ),
                                      );
                                    } else {
                                      controller.isloading(false);
                                    }
                                  });
                                },
                              ).box.width(context.screenWidth - 50).make(),
                        5.heightBox,
                        createNewAccount.text.color(fontGrey).make(),
                        5.heightBox,
                        ourButton(
                          color: lightGolden,
                          title: signup,
                          textColor: redColor,
                          onPress: () {
                            Get.to(() => const SignupScreen());
                          },
                        ).box.width(context.screenWidth - 50).make(),
                        10.heightBox,
                        loginWith.text.color(fontGrey).make(),
                        5.heightBox,
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: whiteColor,
                            foregroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          icon: Image.asset(icGoogleLogo)
                              .box
                              .rounded
                              .size(30, 30)
                              .make(),
                          label: Obx(() {
                            if (controller.googleIsLoading) {
                              return const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(blackcolor),
                              );
                            } else {
                              return signupWith.text.make();
                            }
                          }),
                          onPressed: () async {
                            controller.setGoogleIsLoading(true);
                            await controller.googleLogin().then((i) {
                              if (i != null) {
                                VxToast.show(context, msg: loggedin);

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Home(),
                                  ),
                                );
                              } else {
                                controller.setGoogleIsLoading(false);
                              }
                            }).then((_) {
                              controller.setGoogleIsLoading(false);
                            });
                          },
                        ).box.width(context.screenWidth - 50).make(),
                      ],
                    )
                        .box
                        .white
                        .rounded
                        .padding(const EdgeInsets.all(16))
                        .width(context.screenWidth - 70)
                        .shadowSm
                        .make()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
