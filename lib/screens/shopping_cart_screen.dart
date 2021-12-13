import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:outfitted_flutter_mobile/components/list_dismissible.dart';
import 'package:outfitted_flutter_mobile/components/outfitted_custom_appbar_v2.dart';
import 'package:outfitted_flutter_mobile/counters/cart_item_counter.dart';
import 'package:outfitted_flutter_mobile/counters/total_amount.dart';
import 'package:outfitted_flutter_mobile/firebase/firebase_config.dart';
import 'package:outfitted_flutter_mobile/model/Cart.dart';
import 'package:outfitted_flutter_mobile/model/Product.dart';
import 'package:outfitted_flutter_mobile/screens/address_screen.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';
import 'package:provider/provider.dart';

class ShoppingCartScreen extends StatefulWidget {
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  double totalAmount;
  // Initialize empty list as if shopping cart is empty
  List<Cart> shoppingCartList = List<Cart>();

  @override
  void initState() {
    super.initState();
    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayTotalAmountResult(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: OutFittedCustomAppBarV2(
        appBar: AppBar(),
        onLeftIconPress: (){
          Navigator.pop(context);
        },
        title: 'Shopping cart',
        underTitle: OutFittedApp.auth.currentUser != null
            ? (OutFittedApp.sharedPreferences
            .getStringList(OutFittedApp.customerCartList)
            .length -
            1)
            .toString() +
            " items"
            : '',
        customIcon: Icon(Icons.arrow_back),
      ),
      backgroundColor: kBackgroundOutFitted,
      body: OutFittedApp.auth.currentUser != null
          ? StreamBuilder<QuerySnapshot>(
        stream: OutFittedApp.firestore
            .collection(OutFittedApp.collectionProduct)
            .where(FieldPath.documentId,
                whereIn: OutFittedApp.sharedPreferences
                    .getStringList(OutFittedApp.customerCartList))
            .snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            // als snapshot (aka database) leeg is?
            return Center(
              child: SpinKitDualRing(
                color: kSecondaryColor,
                size: 50,
              )
            );
          }
          else{
            return ListDismissible(
                emptyListText:"Add a product by pressing the 🛒️ icon",
                list: snapshot.data.docs.length == 0 ? shoppingCartList : getItemsForCustomerCart(snapshot),
                funcOnDismissible: removeItemFromCustomerCart,
                scaffoldState: _scaffoldKey,
            );
          }
        },
      )
          : Container(
        child: Center(
          child: Text('Register or Login to add to cart.'),
        ),
      ),
      bottomNavigationBar: OutFittedApp.auth.currentUser != null
          ? Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        // height: 175,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -15),
              blurRadius: 20,
              color: kShadowColor.withOpacity(0.15),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.receipt,
                      color: kSecondaryColor,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: (){
                      _scaffoldKey.currentState.showSnackBar(
                        new SnackBar(
                          backgroundColor: kPrimaryColor,
                          duration: Duration(
                            seconds: 2,
                          ),
                          content: Container(
                            height: 30,
                            child: Center(
                              child: Text('We are working on this voucher... coming up soon!'),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Add voucher code",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer2<TotalAmount, CartItemCounter>(
                    builder: (context, amountProvider, cartProvider, c) {
                      return Text.rich(
                        TextSpan(
                          text: "Total:\n",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                          ),
                          children: [
                            TextSpan(
                              text: cartProvider.count == 0 ||
                                  cartProvider.count == null
                                  ? "\€0.00"
                                  : "\€${amountProvider.totalAmount.toStringAsFixed(2)}", 
                                  style: TextStyle(
                                fontSize: 16,
                                color: kSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    width: 190,
                    child: TextButton(
                      child: Text(
                          "Check out"), // hide check out button when not logged in
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: kSecondaryColor,
                        onSurface: Colors.grey,
                      ),
                      onPressed: () {
                        if (OutFittedApp.sharedPreferences
                            .getStringList(
                            OutFittedApp.customerCartList)
                            .length ==
                            1) {
                          Fluttertoast.showToast(
                            msg: 'Your cart is empty.',
                            textColor: kWhiteColor,
                            backgroundColor: kErrorBackground,
                          );
                        } else {
                          // Navigate customer to fill in address screen.
                          Route route = MaterialPageRoute(builder: (c) => AddressScreen(totalAmount: totalAmount,));
                          Navigator.push(context, route,);
                        }
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      )
          : null,
    );
  }

  // Get list of products from Firebase snapshot
  List<Cart> getItemsForCustomerCart(AsyncSnapshot<QuerySnapshot> pSnapshot){
    for (var i = 0; i < pSnapshot.data.docs.length; i++) {
      Product productFromJson = Product.getProductFromJson(pSnapshot.data.docs[i].data());
      double discount = 0;
      if(productFromJson.discountPercentage != 0){
        discount = productFromJson.price * productFromJson.discountPercentage / 100;
      }
      totalAmount += productFromJson.price;
      totalAmount = totalAmount - discount;
      productFromJson.id = pSnapshot.data.docs[i].id;

      
      shoppingCartList.add(Cart(product: productFromJson, amountItems: 0));


      if (pSnapshot.data.docs.length - 1 == i) {
        WidgetsBinding.instance
            .addPostFrameCallback((t) {
          Provider.of<TotalAmount>(context,
              listen: false)
              .displayTotalAmountResult(totalAmount);
        });
      }
    }
    return shoppingCartList;
  }

  removeItemFromCustomerCart(Product pProduct) {
    String productName = pProduct.id;
    double productPrice = pProduct.price;


    List tempCartList = OutFittedApp.sharedPreferences
        .getStringList(OutFittedApp.customerCartList);
    tempCartList.remove(productName);

    OutFittedApp.firestore
        .collection(OutFittedApp.collectionCustomer)
        .doc(OutFittedApp.sharedPreferences.getString(OutFittedApp.customerUID))
        .update({OutFittedApp.customerCartList: tempCartList}).then((v) {
          Fluttertoast.showToast(
            msg: '${pProduct.name} removed from cart successfully.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: kNotFavoriteProductColorToastBackground,
            fontSize: 15,
          );
          OutFittedApp.sharedPreferences
              .setStringList(OutFittedApp.customerCartList, tempCartList);

      Provider.of<CartItemCounter>(context, listen: false).displayItemCounterResult();

      totalAmount = 0;
    });
  }
}
