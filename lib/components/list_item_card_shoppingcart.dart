import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/model/Cart.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

List<Widget> buildShoppingCartCard(
    {@required Cart cartItem, GlobalKey<ScaffoldState> scaffoldKey}) {
  double discount = 0;
  if (cartItem.product.discountPercentage != 0) {
    discount =
        cartItem.product.price * cartItem.product.discountPercentage / 100;
  }

  final String image = cartItem.product.productImage,
      productName = cartItem.product.name,
      price = cartItem.product.discountPercentage == 0
          ? cartItem.product.price.toStringAsFixed(2)
          : (cartItem.product.price - discount).toStringAsFixed(2),
      totalOfItems = (cartItem.amountItems + 1).toString();

  return [
    SizedBox(
      width: 92,
      child: AspectRatio(
        aspectRatio: 0.92,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Image.network(image),
          // child: Image.asset(image),
        ),
      ),
    ),
    SizedBox(
      width: 20,
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 200,
          child: Text(
            '$productName',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
            ),
            maxLines: 2,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text.rich(
              TextSpan(
                text: '€$price',
                style: TextStyle(color: kSecondaryColor),
                children: [
                  TextSpan(
                    text: ' x$totalOfItems',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(4)),
              child: GestureDetector(
                onTap: () {
                  scaffoldKey.currentState.showSnackBar(
                    new SnackBar(
                      backgroundColor: kPrimaryColor,
                      duration: Duration(
                        seconds: 2,
                      ),
                      content: Container(
                        height: 30,
                        child: Center(
                          child: Text(
                            'We are working on this... coming up soon!',
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Icon(
                  Icons.remove,
                  color: kWhiteColor,
                  size: 20,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                '$totalOfItems',
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.circular(4)),
              child: GestureDetector(
                onTap: () {
                  scaffoldKey.currentState.showSnackBar(
                    new SnackBar(
                      backgroundColor: kPrimaryColor,
                      duration: Duration(
                        seconds: 2,
                      ),
                      content: Container(
                        height: 30,
                        child: Center(
                          child: Text(
                            'We are working on this... coming up soon!',
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Icon(
                  Icons.add,
                  color: kWhiteColor,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    ),
  ];
}
