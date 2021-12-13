import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:outfitted_flutter_mobile/components/outfitted_custom_appbar_v2.dart';
import 'package:outfitted_flutter_mobile/components/payment_card.dart';
import 'package:outfitted_flutter_mobile/counters/cart_item_counter.dart';
import 'package:outfitted_flutter_mobile/firebase/firebase_config.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class PaymentScreen extends StatefulWidget {
  final String addressID;
  final double totalAmount;

  const PaymentScreen({
    Key key,
    this.addressID,
    this.totalAmount,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String methodName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: OutFittedCustomAppBarV2(
        title: 'Select Payment',
        customIcon: Icon(Icons.search),
        appBar: AppBar(),
      ),
      backgroundColor: kBackgroundOutFitted,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              PaymentCard(
                paymentMethodName: 'IDeal',
                paymentImage: Image.asset('assets/icons/ideal.png'),
                paymentDetails: 'ABN-AMRO',
                onPaymentPressed: () {
                  saveOrderDetails('IDeal');
                },
              ),
              PaymentCard(
                paymentMethodName: 'Mastercard',
                paymentImage: Image.asset('assets/icons/mastercard_24px.png'),
                paymentDetails: 'xxxx-xxxx-xxxx-4875',
                onPaymentPressed: () {
                  saveOrderDetails('Mastercard');
                },
              ),
              PaymentCard(
                paymentMethodName: 'Paypal',
                paymentImage:
                    Image.asset('assets/icons/icons8_paypal_24px.png'),
                paymentDetails: 'xxxx@gmail.com',
                onPaymentPressed: () {
                  saveOrderDetails('Paypal');
                },
              ),
              PaymentCard(
                paymentMethodName: 'Cash on Delivery',
                paymentImage: Image.asset('assets/icons/icons8_cash_24px.png'),
                paymentDetails: 'xxx-xxx-568-965-89',
                onPaymentPressed: () {
                  saveOrderDetails('Cash on Delivery');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  saveOrderDetails(String paymentMethod) async {

    String orderTime = DateTime.now().microsecondsSinceEpoch.toString();
    List productsToBuyID = OutFittedApp.sharedPreferences
        .getStringList(OutFittedApp.customerCartList);

    productsToBuyID.removeAt(0);
    String name = '';
    String cityOrTown = '';
    String streetAndNumber = '';
    String phone = '';
    String postCode = '';
    String country = '';

   await OutFittedApp.firestore
            .collection(OutFittedApp.collectionCustomer)
            .doc(OutFittedApp.sharedPreferences.getString(OutFittedApp.customerUID))
            .collection(OutFittedApp.subCollectionAddress)
            .doc(widget.addressID)
            .get()
            .then((value){
        name = value.data()['name'].toString();
        cityOrTown = value.data()['cityOrTown'].toString();
        streetAndNumber = value.data()['streetAndNumber'].toString();
        phone = value.data()['phone'].toString();
        postCode = value.data()['postCode'].toString();
        country = value.data()['country'].toString();
    });



    saveOrderDetailsForCustomer({
      OutFittedApp.addressID: widget.addressID,
      OutFittedApp.totalAmount: widget.totalAmount,
      "orderBy":
          OutFittedApp.sharedPreferences.getString(OutFittedApp.customerUID),
      OutFittedApp.productID: productsToBuyID,
      OutFittedApp.paymentDetails: paymentMethod,
      OutFittedApp.orderTime: orderTime,
      OutFittedApp.isSuccess: true,
      OutFittedApp.orderStatus: 'Order Pending',
      'OrderID' : OutFittedApp.sharedPreferences.getString(OutFittedApp.customerUID) +
          orderTime,
      'name' : name,
      'cityOrTown' : cityOrTown,
      'streetAndNumber' : streetAndNumber,
      'phone' : phone,
      'postCode' : postCode,
      'country' : country,
    });


    saveOrderDetailsForAdmin({
      OutFittedApp.addressID: widget.addressID,
      OutFittedApp.totalAmount: widget.totalAmount,
      "orderBy":
          OutFittedApp.sharedPreferences.getString(OutFittedApp.customerUID),
      OutFittedApp.productID: productsToBuyID,
      OutFittedApp.paymentDetails: paymentMethod,
      OutFittedApp.orderTime: orderTime,
      OutFittedApp.isSuccess: true,
      OutFittedApp.orderStatus: 'Order Pending',
      'OrderID' : OutFittedApp.sharedPreferences.getString(OutFittedApp.customerUID) +
          orderTime,
      'name' : name,
      'cityOrTown' : cityOrTown,
      'streetAndNumber' : streetAndNumber,
      'phone' : phone,
      'postCode' : postCode,
      'country' : country,
    }).whenComplete(() => {
          emptyCart(),
        });
  }

  emptyCart() {
    OutFittedApp.sharedPreferences
        .setStringList(OutFittedApp.customerCartList, ['garbageValue']);
    List tempList = OutFittedApp.sharedPreferences
        .getStringList(OutFittedApp.customerCartList);

    OutFittedApp.firestore
        .collection(OutFittedApp.collectionCustomer)
        .doc(OutFittedApp.sharedPreferences.getString(OutFittedApp.customerUID))
        .update({
      OutFittedApp.customerCartList: tempList,
    }).then((value) {
      OutFittedApp.sharedPreferences
          .setStringList(OutFittedApp.customerCartList, tempList);
      Provider.of<CartItemCounter>(context, listen: false).displayItemCounterResult();
    });

    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        backgroundColor: kPrimaryColor,
        duration: Duration(
          seconds: 1,
        ),
        content: Container(
          height: 30,
          child: Row(
            children: [
              SpinKitDualRing(
                color: kSecondaryColor,
                size: 30,
              ),
              SizedBox(
                width: 20,
              ),
              Text('Confirming payment...'),
            ],
          ),
        ),
      ),
    );
    return Timer(Duration(seconds: 3), () {
      Fluttertoast.showToast(
        msg: 'Order placed successfully.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: kSuccessColor,
        fontSize: 15,
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        ModalRoute.withName('/payment'),
      );
    });
  }

  Future saveOrderDetailsForCustomer(Map<String, dynamic> data) async {
    await OutFittedApp.firestore
        .collection(OutFittedApp.collectionCustomer)
        .doc(OutFittedApp.sharedPreferences.getString(OutFittedApp.customerUID))
        .collection(OutFittedApp.collectionOrders)
        .doc(
            OutFittedApp.sharedPreferences.getString(OutFittedApp.customerUID) +
                data['orderTime']) // to make each order unique
        .set(data);
  }

  Future saveOrderDetailsForAdmin(Map<String, dynamic> data) async {
    await OutFittedApp.firestore
        .collection(OutFittedApp.collectionOrders)
        .doc(
            OutFittedApp.sharedPreferences.getString(OutFittedApp.customerUID) +
                data['orderTime']) // to make each order unique
        .set(data);
  }
}
