import 'package:flutter/services.dart';
import 'package:emart_app/consts/consts.dart';

Widget customTextField({
  String? title,
  String? hint,
  TextEditingController? controller,
  bool? isPass,
  int? maxLength,
  bool isNumeric = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title!.text.color(blackcolor).fontFamily(semibold).size(16).make(),
      5.heightBox,
      TextFormField(
        obscureText: isPass ?? false,
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxLength),
          if (isNumeric) FilteringTextInputFormatter.digitsOnly,
        ],
        validator: (value) {
          if (value != null) {
            if (isNumeric && value.isNotEmpty && int.tryParse(value) == null) {
              return '$title should contain only numbers';
            }
          }
          return null;
        },
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontFamily: semibold,
            color: textfieldGrey,
          ),
          hintText: hint,
          isDense: true,
          fillColor: lightGrey,
          filled: true,
          border: InputBorder.none,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: redColor),
          ),
        ),
      ),
      5.heightBox,
    ],
  );
}
