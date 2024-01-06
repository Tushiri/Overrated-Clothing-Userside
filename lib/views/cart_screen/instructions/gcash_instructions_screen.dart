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

      final result = await ImageGallerySaver.saveImage(bytes);

      if (result['isSuccess']) {
        _showSnackBar(context, "Image downloaded successfully");
      } else {
        _showSnackBar(context, "Failed to download image");
      }
    } catch (e) {
      _logger.e("Error downloading image: $e");
      _showSnackBar(context, "Error downloading image");
    } finally {
      completer.complete();
    }

    await completer.future; // Wait for the completer to complete
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Gcash Instructions"),
            const SizedBox(height: 16),
            Image.asset(
              gcashQr, // Update with the correct path
              width: 200.0,
              height: 200.0,
              fit: BoxFit.cover,
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
    );
  }
}
