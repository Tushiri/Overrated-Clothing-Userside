import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// ignore: unused_import
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import 'package:velocity_x/velocity_x.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;
import 'package:permission_handler/permission_handler.dart';
// ignore: unused_import
import 'package:path/path.dart';

Future<void> downloadReceipt(context, dynamic data) async {
  var status = await Permission.storage.request();
  if (status.isDenied) {
    VxToast.show(context, msg: "Permission denied for storage");
    return;
  }

  const String baseFileName = 'receipt';
  const String fileExtension = '.pdf';

  const String downloadDirectory = '/storage/emulated/0/Download';

  final Directory dir = Directory(downloadDirectory);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  final Logger logger = Logger();
  final pdf = pw.Document();
  pdf.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              "Overrated Clothing",
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 20,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              "123 Main Street, Cityville",
              style: const pw.TextStyle(
                fontSize: 16,
              ),
            ),
            pw.Text(
              "Tel: +123 456 7890",
              style: const pw.TextStyle(
                fontSize: 16,
              ),
            ),
            pw.Divider(
                height: 30, thickness: 2, color: PdfColor.fromHex(Vx.blackHex)),
            pw.Text(
              "RECEIPT",
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 20,
                letterSpacing: 2,
              ),
            ),
            pw.Divider(
                height: 30, thickness: 2, color: PdfColor.fromHex(Vx.blackHex)),
            pw.SizedBox(height: 10),
            pw.Text(
              "Ordered Product",
              style: pw.TextStyle(
                fontSize: 20,
                color: PdfColor.fromHex(Vx.blackHex),
                fontWeight: pw.FontWeight.bold,
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 10),
            for (var order in data['orders'])
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        order['title'],
                        style: const pw.TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      pw.Text(
                        "${order['qty']}x ${order['tprice']}",
                        style: const pw.TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    "Refundable",
                    style: const pw.TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                ],
              ),
            pw.Divider(
                height: 30, thickness: 2, color: PdfColor.fromHex(Vx.blackHex)),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "Total",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                pw.Text(
                  "${data['total_amount']}",
                  style: const pw.TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            pw.Divider(
                height: 30, thickness: 2, color: PdfColor.fromHex(Vx.blackHex)),
            pw.SizedBox(height: 10),
            for (var detail in [
              {"title": "Payment Method", "value": data['payment_method']},
              {
                "title": "Order Date",
                "value": intl.DateFormat()
                    .add_yMd()
                    .format((data['order_date'].toDate()))
              },
              {
                "title": "Payment Status",
                "value": data['payment_status'] ?? 'Unpaid'
              },
              {
                "title": "Delivery Status",
                "value": data['order_placed'] ? 'Order Placed' : 'Not Placed'
              },
            ])
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        detail["title"]!,
                        style: const pw.TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      pw.Text(
                        detail["value"]!,
                        style: const pw.TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 8),
                ],
              ),
            pw.Divider(
                height: 30, thickness: 2, color: PdfColor.fromHex(Vx.blackHex)),
            pw.SizedBox(height: 10),
            pw.Text(
              "THANK YOU!",
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 24,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  int fileNumber = 0;
  late File file;
  String filePath;

  do {
    fileNumber++;
    filePath = '$downloadDirectory/$baseFileName';
    if (fileNumber > 1) {
      filePath = '$downloadDirectory/$baseFileName($fileNumber)';
    }

    filePath = '$filePath$fileExtension';

    file = File(filePath);

    if (await file.exists()) {
      continue;
    }
  } while (await file.exists());

  await file.writeAsBytes(await pdf.save());

  logger.w('PDF saved to: $filePath');

  VxToast.show(context, msg: "Downloaded successfully");
}
