import 'package:emart_app/consts/consts.dart';
import 'package:flutter/services.dart';

Widget customTextField({
  String? title,
  String? hint,
  TextEditingController? controller,
  bool? isPass,
  int? maxLength,
  bool isNumeric = false,
  Widget? suffixIcon,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Centered title
      title!.text.color(Colors.black).fontFamily('semibold').size(16).make(),

      5.heightBox,

      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextFormField(
              obscureText: isPass ?? false,
              controller: controller,
              keyboardType:
                  isNumeric ? TextInputType.number : TextInputType.text,
              inputFormatters: [
                LengthLimitingTextInputFormatter(maxLength),
                if (isNumeric) FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value != null) {
                  if (isNumeric &&
                      value.isNotEmpty &&
                      int.tryParse(value) == null) {
                    return '$title should contain only numbers';
                  }
                }
                return null;
              },
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                  fontFamily: 'semibold',
                  color: Colors.grey,
                ),
                hintText: hint,
                isDense: true,
                fillColor: Colors.grey[200],
                filled: true,
                border: InputBorder.none,
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),
          if (suffixIcon != null) suffixIcon,
        ],
      ),

      5.heightBox,
    ],
  );
}
