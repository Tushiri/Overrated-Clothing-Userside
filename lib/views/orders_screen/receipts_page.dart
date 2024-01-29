import 'dart:typed_data';
import 'package:emart_app/views/orders_screen/components/order_place_details.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;
import 'package:esc_pos_utils/esc_pos_utils.dart';
// ignore: unused_import
import 'package:esc_pos_utils/esc_pos_utils.dart' as esc;
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'components/download_receipt.dart';

class ReceiptsPage extends StatelessWidget {
  final dynamic data;
  final Logger _logger = Logger();

  ReceiptsPage({Key? key, required this.data}) : super(key: key);
  Future<Uint8List?> fetchImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        _logger.e('Failed to load image, status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      _logger.e('Error fetching image: $e');
      return null;
    }
  }

  Future<void> _printReceipt() async {
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(PaperSize.mm80, profile);

    final PosPrintResult res =
        await printer.connect('192.168.0.100', port: 9100);

    if (res != PosPrintResult.success) {
      _logger.e('Could not connect to the printer');
      return;
    }

    printer.text("Your receipt content goes here");
    printer.cut();
    printer.disconnect();

    if (res != PosPrintResult.success) {
      _logger.e('Could not print the receipt');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Receipts".text.fontFamily(semibold).color(blackcolor).make(),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'download') {
                await downloadReceipt(context, data);
              } else if (value == 'print') {
                await _printReceipt();
              }
            },
            itemBuilder: (BuildContext context) {
              return ['Download', 'Print'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice.toLowerCase(),
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Overrated Clothing",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: blackcolor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "123 Main Street, Cityville",
                style: TextStyle(
                  fontSize: 16,
                  color: blackcolor,
                ),
              ),
              const Text(
                "Tel: +123 456 7890",
                style: TextStyle(
                  fontSize: 16,
                  color: blackcolor,
                ),
              ),
              const Divider(
                height: 30,
                thickness: 2,
                color: blackcolor,
              ),
              // Receipt Header
              const Text(
                "RECEIPT",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 2,
                  color: blackcolor,
                ),
              ),
              const Divider(
                height: 30,
                thickness: 2,
                color: blackcolor,
              ),
              10.heightBox,
              "Ordered Product"
                  .text
                  .size(20)
                  .color(blackcolor)
                  .fontFamily(bold)
                  .makeCentered(),
              10.heightBox,

              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(data['orders'].length, (index) {
                  final imageUrl = data['orders'][index]['imageUrl'];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      orderPlaceDetail(
                          title1: data['orders'][index]['title'],
                          title2: data['orders'][index]['tprice'],
                          d1: "${data['orders'][index]['qty']}x",
                          d2: "Refundable",
                          textColor: blackcolor),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: imageUrl != null
                            ? FutureBuilder<Uint8List?>(
                                future: fetchImage(imageUrl),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return const Text('Error loading image');
                                  } else if (snapshot.hasData) {
                                    return Image.memory(snapshot.data!);
                                  } else {
                                    return Container();
                                  }
                                },
                              )
                            : Container(),
                      ),
                    ],
                  );
                }),
              ),

              const Divider(
                height: 30,
                thickness: 2,
                color: blackcolor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: blackcolor,
                    ),
                  ),
                  SizedBox(
                    width: 130,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "${data['total_amount']}"
                            .text
                            .size(20)
                            .fontFamily(bold)
                            .make(),
                      ],
                    ),
                  ),
                ],
              ),

              const Divider(
                height: 30,
                thickness: 2,
                color: blackcolor,
              ),
              10.heightBox,
              Column(
                children: [
                  orderPlaceDetail(
                      d1: data['order_code'],
                      d2: data['shipping_method'],
                      title1: "Order Code",
                      title2: "Shipping Method",
                      textColor: blackcolor),
                  orderPlaceDetail(
                      d1: intl.DateFormat()
                          .add_yMd()
                          .format((data['order_date'].toDate())),
                      d2: data['payment_method'],
                      title1: "Order Date",
                      title2: "Payment Method",
                      textColor: blackcolor),
                  orderPlaceDetail(
                      d1: data['payment_status'] ?? "Unpaid",
                      d2: data['order_placed'] ? "Order Placed" : "Not Placed",
                      title1: "Payment Status",
                      title2: "Delivery Status",
                      textColor: blackcolor),
                  const Divider(
                    height: 30,
                    thickness: 2,
                    color: blackcolor,
                  ),
                  const Text(
                    "THANK YOU!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      letterSpacing: 2,
                      color: blackcolor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
