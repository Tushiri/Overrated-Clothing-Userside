// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:emart_app/consts/consts.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:logger/logger.dart';

class GcashInstructionScreen extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final Logger _logger = Logger();

  GcashInstructionScreen({super.key});

  Future<void> _downloadImage(BuildContext context) async {
    final Completer<void> completer = Completer<void>();

    try {
      final ByteData data = await rootBundle.load('assets/images/gcash_qr.jpg');
      final Uint8List bytes = data.buffer.asUint8List();

      final result =
          await ImageGallerySaver.saveImage(bytes, name: 'gcash_qr.jpg');

      if (result != null && result.isNotEmpty) {
        VxToast.show(context, msg: "Image downloaded successfully");
      } else {
        VxToast.show(context, msg: "Failed to download image");
      }
    } catch (e) {
      _logger.e("Error downloading image: $e");
      VxToast.show(context, msg: "Error downloading image");
    } finally {
      completer.complete();
    }

    await completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: Text(
                "Steps to Pay via GCash:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "1. First, you need to scan this picture or download it to scan using GCash.",
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Image.asset(
                        gcashQr,
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "2. Second, click \"done\" and place the order.",
                    ),
                    const Text(
                      "3. Third, send the reference number and a screenshot as proof of payment to the designated staff.",
                    ),
                    const Text(
                      "4. Fourth, just wait for the confirmation from the staff to confirm the payment.",
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => _downloadImage(context),
                          child: const Text("Download Image"),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Done"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
