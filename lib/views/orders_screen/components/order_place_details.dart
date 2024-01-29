import 'package:emart_app/consts/consts.dart';

Widget orderPlaceDetail(
    {title1,
    title2,
    d1,
    d2,
    Color textColor = redColor,
    Color color = blackcolor}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "$title1".text.fontFamily(semibold).color(color).make(),
            "$d1".text.fontFamily(semibold).color(textColor).make(),
          ],
        ),
        SizedBox(
          width: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "$title2".text.fontFamily(semibold).color(color).make(),
              "$d2".text.color(textColor).make(),
            ],
          ),
        ),
      ],
    ),
  );
}
