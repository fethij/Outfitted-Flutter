import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/model/Wishlist.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

List<Widget> buildWishListCard({
  @required WishList wishListItem,
}) {
  final String image = wishListItem.product.productImage,
      productName = wishListItem.product.name,
      price = wishListItem.product.price.toStringAsFixed(2);

  return [
    SizedBox(
      width: 88,
      child: AspectRatio(
        aspectRatio: 0.88,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Image.network(image),
        ),
      ),
    ),
    SizedBox(width: 20),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          productName,
          style: TextStyle(
            fontSize: 16,
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 10),
        Text.rich(TextSpan(
          text: "\€$price",
          style: TextStyle(
            color: kSecondaryColor,
          ),
        ))
      ],
    )
  ];
}
