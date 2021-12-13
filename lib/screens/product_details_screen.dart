import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:outfitted_flutter_mobile/components/color_dot.dart';
import 'package:outfitted_flutter_mobile/components/outfitted_custom_appbar_v2.dart';
import 'package:outfitted_flutter_mobile/components/outfitted_custom_toast.dart';
import 'package:outfitted_flutter_mobile/components/screen_animation_route.dart';
import 'package:outfitted_flutter_mobile/components/top_rounded_container.dart';
import 'package:outfitted_flutter_mobile/counters/cart_item_counter.dart';
import 'package:outfitted_flutter_mobile/dialog/error_alert_dialog.dart';
import 'package:outfitted_flutter_mobile/firebase/firebase_config.dart';
import 'package:outfitted_flutter_mobile/model/Product.dart';
import 'package:outfitted_flutter_mobile/screens/shopping_cart_screen.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({Key key, this.product}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  List sharedPrefCartList = OutFittedApp.sharedPreferences
          .getStringList(OutFittedApp.customerCartList),
      sharedPrefWishList = OutFittedApp.sharedPreferences
          .getStringList(OutFittedApp.customerWishList);

  bool isFavorite;

  @override
  Widget build(BuildContext context) {
    isFavorite = sharedPrefWishList.contains(widget.product.id);
    double discount = 0;
    if(widget.product.discountPercentage != 0){
      discount = widget.product.price * widget.product.discountPercentage / 100;
    }

    return Scaffold(
      appBar: OutFittedCustomAppBarV2(
        title: widget.product.name,
        customIcon: Icon(Icons.arrow_back),
        appBar: AppBar(),
        onLeftIconPress: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: kBackgroundOutFitted,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              //   width: 238,
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(widget.product.productImage),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  height: 68,
                  width: 58,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: kSecondaryColor),
                  ),
                  child: Image.network(widget.product.productImage),
                ),
              ],
            ),
            TopRoundedContainer(
              color: kPrimaryColor,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Row(
                              children: [
                                Text(
                                  '€' + (widget.product.price - discount).toStringAsFixed(2),
                                  style: TextStyle(
                                    color: kSecondaryColor
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                widget.product.discountPercentage != 0
                                ?
                                Text(
                                  '€' + widget.product.price.toStringAsFixed(2),
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough
                                  ),
                                )
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.all(15),
                          width: 64,
                          decoration: BoxDecoration(
                            color: kBackgroundLikeButton,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: IconButton(
                            icon: new Icon(Icons.favorite,
                                color: (isFavorite)
                                    ? kFavoriteProductColor
                                    : kNotFavoriteProductColor,
                          ),
                            onPressed: () async {
                              if (OutFittedApp.auth.currentUser != null) {
                                addItemToWish(widget.product.id, context);
                                setState(() {
                                  isFavorite = true;
                                });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (c) {
                                      return ErrorAlertDialog(
                                        message:
                                            'Create an account or Login to add to your cart.',
                                      );
                                    });
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 64,
                        ),
                        child: Text(widget.product.productDescription),
                      ),
                    ],
                  ),
                  TopRoundedContainer(
                    color: kBackgroundOutFitted,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          // horizontal: 20,
                          ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Text(
                                  "Select color",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                ColorDot(
                                  color: Colors.red,
                                ),
                                ColorDot(
                                  color: Colors.purple,
                                ),
                                ColorDot(
                                  color: Colors.brown,
                                ),
                                ColorDot(
                                  color: Colors.green,
                                ),
                                ColorDot(
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          TopRoundedContainer(
                            color: kPrimaryColor,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                height: 55,
                                color: kBackgroundOutFitted,
                                onPressed: () async {
                                  if (await OutFittedApp.auth.currentUser !=
                                      null) {
                                    checkItemInCart(widget.product.id, context);
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (c) {
                                          return ErrorAlertDialog(
                                            message:
                                                'Create an account or Login to add to your cart.',
                                          );
                                        });
                                  }
                                },
                                child: Text(
                                  "Add to Cart",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkItemInCart(String productName, BuildContext context) {
    OutFittedApp.sharedPreferences
            .getStringList(OutFittedApp.customerCartList)
            .contains(productName)
        ? customToast(
            productAndMessage: widget.product.name + ' is already added.',
            gradiantColor: kWarningGradiantColor,
            textColor: kWarningColor,
            iconIndicator: Icon(
              Icons.info_outline_rounded,
              size: 30.0,
              color: kWhiteColor,
            ),
            press: () {
              Navigator.push(
                  context,
                  ScreenAnimationRoute(
                    animationType: Curves.bounceIn,
                    screenToGoTo: ShoppingCartScreen(),
                  ));
            })
        : addItemToCart(productName, context);
  }

  void addItemToWish(String productName, BuildContext context) {
    if (sharedPrefWishList.contains(productName)) {
      sharedPrefWishList.remove(productName);

      OutFittedApp.firestore
          .collection(OutFittedApp.collectionCustomer)
          .doc(OutFittedApp.sharedPreferences
              .getString(OutFittedApp.customerUID))
          .update({OutFittedApp.customerWishList: sharedPrefWishList}).then(
              (v) {
        Fluttertoast.showToast(
          msg: widget.product.name + ' removed from wishlist successfully.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: kNotFavoriteProductColorToastBackground,
          fontSize: 15,
        );

        OutFittedApp.sharedPreferences
            .setStringList(OutFittedApp.customerWishList, sharedPrefWishList);

        setIsFavorite(false);
      });
      return;
    }

    sharedPrefWishList.add(productName);

    OutFittedApp.firestore
        .collection(OutFittedApp.collectionCustomer)
        .doc(OutFittedApp.sharedPreferences.getString(OutFittedApp.customerUID))
        .update({OutFittedApp.customerWishList: sharedPrefWishList}).then((v) {
      Fluttertoast.showToast(
        msg: widget.product.name + ' added to wish successfully 🎉',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: kSuccessColor,
        fontSize: 15,
      );

      OutFittedApp.sharedPreferences
          .setStringList(OutFittedApp.customerWishList, sharedPrefWishList);

      setIsFavorite(true);
    });
  }

  void setIsFavorite(bool pStatus) {
    setState(() {
      isFavorite = pStatus;
    });
  }

  void addItemToCart(String productName, BuildContext context) {
    List tempCartList = OutFittedApp.sharedPreferences
        .getStringList(OutFittedApp.customerCartList);
    tempCartList.add(productName);

    OutFittedApp.firestore
        .collection(OutFittedApp.collectionCustomer)
        .doc(OutFittedApp.sharedPreferences.getString(OutFittedApp.customerUID))
        .update({OutFittedApp.customerCartList: tempCartList}).then((v) {
      customToast(
        productAndMessage:
            widget.product.name + ' added to cart successfully 🎉',
        gradiantColor: kSuccessGradiantColor,
        textColor: kSuccessColor,
        iconIndicator: Icon(
          Icons.check,
          size: 30.0,
          color: kWhiteColor,
        ),
        press: () {
          Navigator.push(
            context,
            ScreenAnimationRoute(
              animationType: Curves.bounceIn,
              screenToGoTo: ShoppingCartScreen(),
            ),
          );
        },
      );
      OutFittedApp.sharedPreferences
          .setStringList(OutFittedApp.customerCartList, tempCartList);

      Provider.of<CartItemCounter>(context, listen: false).displayItemCounterResult();
    });
  }

  void customToast(
      {String productAndMessage,
      Color gradiantColor,
      Color textColor,
      Icon iconIndicator,
      Function press}) {
    var fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 2),
      child: OutFittedCustomToast(
        text: productAndMessage,
        gradiantColor: gradiantColor,
        textColor: textColor,
        iconIndicator: iconIndicator,
        press: press,
      ),
    );
  }
}
