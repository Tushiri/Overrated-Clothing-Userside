import 'package:emart_app/consts/consts.dart';
import 'package:flutter/material.dart';

class PaymayaInstructionScreen extends StatelessWidget {
  const PaymayaInstructionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text("Paymaya Instructions"),
        ],
      ),
    );
  }
}
