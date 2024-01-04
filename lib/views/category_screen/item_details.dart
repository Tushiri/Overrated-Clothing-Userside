import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/product_controller.dart';
import 'package:emart_app/views/chat_screen/chat_screen.dart';
import 'package:emart_app/widgets_common/our_button.dart';
import 'package:get/get.dart';

class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;
  const ItemDetails({Key? key, required this.title, this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    return WillPopScope(
      onWillPop: () async {
        controller.resetValues();
        return true;
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              controller.resetValues();
              Get.back();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: title!.text.color(blackcolor).fontFamily(bold).make(),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.share,
                )),
            Obx(
              () => IconButton(
                  onPressed: () {
                    if (controller.isFav.value) {
                      controller.removeFromWishlist(data.id, context);
                    } else {
                      controller.addToWishlist(data.id, context);
                    }
                  },
                  icon: Icon(
                    Icons.favorite_outlined,
                    color: controller.isFav.value ? redColor : darkFontGrey,
                  )),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //swiper section

                    VxSwiper.builder(
                        autoPlay: true,
                        height: 350,
                        itemCount: data['p_imgs'].length,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1.0,
                        itemBuilder: (context, index) {
                          return Image.network(
                            data['p_imgs'][index],
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        }),

                    10.heightBox,
                    title!.text
                        .size(20)
                        .color(blackcolor)
                        .fontFamily(semibold)
                        .make(),

                    10.heightBox,
                    "${data['p_price']}"
                        .numCurrency
                        .text
                        .color(redColor)
                        .fontFamily(semibold)
                        .size(18)
                        .make(),

                    10.heightBox,
                    Row(
                      children: [
                        VxRating(
                          isSelectable: false,
                          value: double.parse(data['p_rating']),
                          onRatingUpdate: (value) {},
                          normalColor: textfieldGrey,
                          selectionColor: golden,
                          count: 5,
                          maxRating: 5,
                          size: 16,
                        ),
                        5.widthBox,
                        const Text(
                          'In-stock',
                          style: TextStyle(
                            fontSize: 15,
                            color: blackcolor,
                          ),
                        ),
                      ],
                    ),

                    //color section
                    Column(
                      children: [
                        20.heightBox,
                        const Divider(), // Replace with a Divider
                        Obx(
                          () => Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: "COLOR: "
                                        .text
                                        .bold
                                        .color(blackcolor)
                                        .size(14)
                                        .make(),
                                  ),
                                  Row(
                                    children: List.generate(
                                      data['p_colors'].length,
                                      (index) => Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          VxBox()
                                              .size(35, 35)
                                              .roundedFull
                                              .color(
                                                  Color(data['p_colors'][index])
                                                      .withOpacity(1.0))
                                              .margin(
                                                const EdgeInsets.symmetric(
                                                    horizontal: 4),
                                              )
                                              .make()
                                              .onTap(() {
                                            controller.changeColorIndex(index);
                                          }),
                                          Visibility(
                                            visible: index ==
                                                controller.colorIndex.value,
                                            child: const Icon(Icons.done,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                                  .box
                                  .padding(const EdgeInsets.symmetric(
                                      horizontal: 12))
                                  .make(),

                              // quantity row
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: "QUANTITY: "
                                        .text
                                        .bold
                                        .color(blackcolor)
                                        .size(14)
                                        .make(),
                                  ),
                                  Obx(
                                    () => Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            controller.decreaseQuantity();
                                            controller.calculateTotalPrice(
                                              int.parse(data['p_price']),
                                            );
                                          },
                                          icon: const Icon(Icons.remove),
                                        ),
                                        controller.quantity.value.text
                                            .size(14)
                                            .color(darkFontGrey)
                                            .fontFamily(bold)
                                            .make(),
                                        IconButton(
                                          onPressed: () {
                                            controller.increaseQuantity(
                                              int.parse(data['p_quantity']),
                                            );
                                            controller.calculateTotalPrice(
                                              int.parse(data['p_price']),
                                            );
                                          },
                                          icon: const Icon(Icons.add),
                                        ),
                                        10.widthBox,
                                        "(${data['p_quantity']} available)"
                                            .text
                                            .size(14)
                                            .color(textfieldGrey)
                                            .make(),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                                  .box
                                  .padding(
                                      const EdgeInsets.symmetric(horizontal: 8))
                                  .make(),

                              // total row
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: "TOTAL: "
                                        .text
                                        .bold
                                        .color(blackcolor)
                                        .size(14)
                                        .make(),
                                  ),
                                  "${controller.totalPrice.value}"
                                      .numCurrency
                                      .text
                                      .color(redColor)
                                      .size(16)
                                      .fontFamily(bold)
                                      .make(),
                                ],
                              )
                                  .box
                                  .padding(const EdgeInsets.symmetric(
                                      horizontal: 12))
                                  .make(),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        10.heightBox,
                        const Divider(), // Add a divider before the box
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: CircleAvatar(
                                radius: 30.0,
                                backgroundImage: AssetImage(
                                    'assets/images/sellerprofile.jpg'),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    "${data['p_seller']}"
                                        .text
                                        .fontFamily(bold)
                                        .color(whiteColor)
                                        .size(18)
                                        .make(),
                                    "Seller"
                                        .text
                                        .fontFamily(semibold)
                                        .color(whiteColor)
                                        .size(14)
                                        .make(),
                                  ],
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.to(
                                  () => const ChatScreen(),
                                  arguments: [
                                    data['p_seller'],
                                    data['vendor_id']
                                  ],
                                );
                              },
                              style: TextButton.styleFrom(
                                side: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              child: const Text(
                                'Message',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        )
                            .box
                            .height(80)
                            .padding(const EdgeInsets.symmetric(horizontal: 16))
                            .color(blackcolor)
                            .make(),
                      ],
                    ),

                    10.heightBox,
                    const Divider(), // Add a divider
                    "Description"
                        .text
                        .color(blackcolor)
                        .fontFamily(semibold)
                        .size(18)
                        .make(),
                    10.heightBox,
                    "${data['p_desc']}"
                        .text
                        .color(darkFontGrey)
                        .size(15)
                        .make(),

                    Column(
                      children: [
                        const Divider(),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              "Reviews (0)"
                                  .text
                                  .color(blackcolor)
                                  .fontFamily(semibold)
                                  .size(18)
                                  .make()
                                  .centered(),
                              const Icon(Icons.arrow_right)
                                  .iconColor(blackcolor)
                                  .iconSize(30),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ourButton(
                  color: blackcolor,
                  onPress: () {
                    if (controller.quantity.value > 0) {
                      controller.addToCart(
                          color: data['p_colors'][controller.colorIndex.value],
                          context: context,
                          vendorID: data['vendor_id'],
                          img: data['p_imgs'][0],
                          qty: controller.quantity.value,
                          sellername: data['p_seller'],
                          title: data['p_name'],
                          tprice: controller.totalPrice.value);
                      VxToast.show(context, msg: "Added to Cart");
                    } else {
                      VxToast.show(context,
                          msg: "Minimum 1 product is required");
                    }
                  },
                  textColor: whiteColor,
                  title: "Add to cart"),
            ),
          ],
        ),
      ),
    );
  }
}
