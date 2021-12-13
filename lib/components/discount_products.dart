import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/components/productInfo.dart';
import 'package:outfitted_flutter_mobile/firebase/firebase_config.dart';
import 'package:outfitted_flutter_mobile/model/Product.dart';

class DiscountProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: OutFittedApp.firestore
          .collection(OutFittedApp.collectionProduct)
          .where('discount', isGreaterThan: 0)
          .limit(5)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        if (!snapshot.hasData)
          return Center(
            child: Text('There are no products yet! Sign up for updates'),
          );
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: Text('Loading'),
            );
          default:
            return Padding(
              padding: EdgeInsets.only(
                top: 5,
                right: 5,
              ),
              child: Container(
                height: 350,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1.5,
                    crossAxisCount: 1,
                  ),
                  itemBuilder: (context, index) {
                    Product product = Product.getProductFromJson(
                        snapshot.data.docs[index].data());
// set name of document as id of the product
                    product.id = snapshot.data.docs[index].id;

                    return productInfo(product, context);
                  },
                ),
              ),
            );
        }
      },
    );
  }
}
