import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/model/Product.dart';
import 'package:outfitted_flutter_mobile/screens/order_details_screen.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

int counter = 0;

class OrderCard extends StatelessWidget {
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;

  const OrderCard({Key key, this.itemCount, this.data, this.orderID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Route route;
        route = MaterialPageRoute(
            builder: (c) => OrderDetailsScreen(
                  orderID: orderID,
                ));
        Navigator.push(context, route);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        margin: EdgeInsets.symmetric(vertical: 5),
        height: itemCount * 125.0,
        child: ListView.builder(
            itemCount: itemCount,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (c, index) {
              Product product = Product.getProductFromJson(data[index].data());
              return productInfo(product, context);
            }),
      ),
    );
  }

  Widget productInfo(Product product, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
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
                child: Image.network(product.productImage),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: TextStyle(
                  fontSize: 16,
                ),
                maxLines: 2,
              ),
              SizedBox(
                height: 10,
              ),
              Text.rich(
                TextSpan(
                  text: product.price.toStringAsFixed(2),
                  style: TextStyle(color: kSecondaryColor),
                  children: [
                    TextSpan(
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
