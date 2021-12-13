import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:outfitted_flutter_mobile/components/list_dismissible.dart';
import 'package:outfitted_flutter_mobile/components/outfitted_custom_appbar_v2.dart';
import 'package:outfitted_flutter_mobile/firebase/firebase_config.dart';
import 'package:outfitted_flutter_mobile/model/Product.dart';
import 'package:outfitted_flutter_mobile/model/Wishlist.dart';
import 'package:outfitted_flutter_mobile/screens/search_product_screen.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<WishList> wishList = List<WishList>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: OutFittedCustomAppBarV2(
            title: 'Wishlist',
            customIcon: Icon(Icons.search),
            appBar: AppBar(),
            onLeftIconPress: () {
              Route route =
                  MaterialPageRoute(builder: (c) => SearchProductScreen());
              Navigator.push(context, route);
            },
          ),
          backgroundColor: kBackgroundOutFitted,
          body: OutFittedApp.auth.currentUser != null
              ? StreamBuilder<QuerySnapshot>(
                  stream: OutFittedApp.firestore
                      .collection(OutFittedApp.collectionProduct)
                      .where(FieldPath.documentId,
                          whereIn: OutFittedApp.sharedPreferences
                              .getStringList(OutFittedApp.customerWishList))
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      // als snapshot (aka database) leeg is?
                      return Center(
                          child: SpinKitDualRing(
                        color: kSecondaryColor,
                        size: 50,
                      ));
                    } else {
                      return ListDismissible(
                          emptyListText: "Add a product by pressing the ❤ icon",
                          list: snapshot.data.docs.length == 0
                              ? wishList
                              : getItemsForWishList(snapshot),
                          funcOnDismissible: removeItemFromWishList);
                    }
                  },
                )
              : Container(
                  child: Center(
                    child: Text('Please register or login to add to wishlist.'),
                  ),
                ),
      ),
      onWillPop: (){
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text(
                    "Confirm Exit",
                  style: TextStyle(
                    color: kPrimaryColor
                  ),
                ),
                content: Text(
                    "Are you sure you want to exit?",
                  style: TextStyle(
                      color: kPrimaryColor
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    color: kPrimaryColor,
                    child: Text("YES"),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                  FlatButton(
                    color: kPrimaryColor,
                    child: Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            }
        );
      },
    );
  }

  // Get list of products from Firebase snapshot
  List<WishList> getItemsForWishList(AsyncSnapshot<QuerySnapshot> pSnapshot) {
    for (var i = 0; i < pSnapshot.data.docs.length; i++) {
      Product productFromJson =
          Product.getProductFromJson(pSnapshot.data.docs[i].data());

      double discount = 0;
      if (productFromJson.discountPercentage != 0) {
        discount =
            productFromJson.price * productFromJson.discountPercentage / 100;
        productFromJson.price = productFromJson.price - discount;
      }

      productFromJson.id = pSnapshot.data.docs[i].id;

      wishList.add(WishList(product: productFromJson));
    }
    return wishList;
  }

  removeItemFromWishList(Product pProduct) {
    List tempWishList = OutFittedApp.sharedPreferences
        .getStringList(OutFittedApp.customerWishList);

    tempWishList.remove(pProduct.id);

    OutFittedApp.firestore
        .collection(OutFittedApp.collectionCustomer)
        .doc(OutFittedApp.sharedPreferences.getString(OutFittedApp.customerUID))
        .update({OutFittedApp.customerWishList: tempWishList}).then((v) {
      Fluttertoast.showToast(
        msg: pProduct.name + ' removed from wishlist successfully.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: kNotFavoriteProductColorToastBackground,
        fontSize: 15,
      );

      OutFittedApp.sharedPreferences
          .setStringList(OutFittedApp.customerWishList, tempWishList);
    });
  }
}
