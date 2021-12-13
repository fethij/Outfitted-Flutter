import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:outfitted_flutter_mobile/components/order_card.dart';
import 'package:outfitted_flutter_mobile/components/outfitted_custom_appbar_v2.dart';
import 'package:outfitted_flutter_mobile/components/shipping_info_details.dart';
import 'package:outfitted_flutter_mobile/firebase/firebase_config.dart';
import 'package:outfitted_flutter_mobile/model/Address.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderID;

  const OrderDetailsScreen({Key key, this.orderID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OutFittedCustomAppBarV2(
        title: 'Order Details',
        customIcon: Icon(Icons.arrow_back),
        onLeftIconPress: () {
          Navigator.of(context).pop();
        },
        appBar: AppBar(),
      ),
      backgroundColor: kBackgroundOutFitted,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              FutureBuilder<DocumentSnapshot>(
                future: OutFittedApp.firestore
                    .collection(OutFittedApp.collectionCustomer)
                    .doc(OutFittedApp.sharedPreferences
                        .getString(OutFittedApp.customerUID))
                    .collection(OutFittedApp.collectionOrders)
                    .doc(orderID)
                    .get(),
                builder: (c, snapshot) {
                  Map dataMap;
                  if (snapshot.hasData) {
                    dataMap = snapshot.data.data();
                  }
                  return snapshot.hasData
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order ID',
                            style: TextStyle(
                              color: kWhiteColor
                            ),),
                            Container(
                              child: Text(
                                snapshot.data.id,
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 0.1,
                              color: kWhiteColor.withOpacity(0.3),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Address & Date'),
                            FutureBuilder<DocumentSnapshot>(
                                future: OutFittedApp.firestore
                                    .collection(OutFittedApp.collectionCustomer)
                                    .doc(OutFittedApp.sharedPreferences
                                        .getString(OutFittedApp.customerUID))
                                    .collection(OutFittedApp.subCollectionAddress)
                                    .doc(dataMap[OutFittedApp.addressID])
                                    .get(),
                                builder: (c, snapsho2) {
                                  return snapsho2.hasData
                                      ? ShippingInfoDetails(
                                          address: Address.getAddressFromJson(
                                              snapsho2.data.data()),
                                          dateOrdered: DateFormat(
                                                  'dd MMMM, yyyy - hh:mm aa')
                                              .format(DateTime
                                                  .fromMicrosecondsSinceEpoch(
                                                      int.parse(dataMap[
                                                          OutFittedApp
                                                              .orderTime]))),
                                        )
                                      : Center(
                                          child: SpinKitDualRing(
                                            color: kSecondaryColor,
                                            size: 50,
                                          ),
                                        );
                                },
                            ),

                            SizedBox(
                              height: 30,
                            ),
                            Text('Items ordered'),
                            FutureBuilder<QuerySnapshot>(
                              future: OutFittedApp.firestore
                                  .collection(OutFittedApp.collectionProduct)
                                  .where(FieldPath.documentId,
                                      whereIn: dataMap[OutFittedApp.productID])
                                  .get(),
                              builder: (c, dataSnapshot) {
                                return dataSnapshot.hasData
                                    ? OrderCard(
                                        itemCount: dataSnapshot.data.docs.length,
                                        data: dataSnapshot.data.docs,
                                      )
                                    : Center(
                                        child: SpinKitDualRing(
                                          color: kSecondaryColor,
                                          size: 50,
                                        ),
                                      );
                              },
                            ),
                            Container(
                              child: Text(
                                'Total : €' +
                                    double.parse(dataMap[OutFittedApp.totalAmount].toString()).toStringAsFixed(2),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Divider(
                              thickness: 0.1,
                              color: kWhiteColor.withOpacity(0.3),
                            ),
                            FutureBuilder<DocumentSnapshot>(
                              future: OutFittedApp.firestore
                                  .collection(OutFittedApp.collectionOrders)
                                  .doc(orderID)
                                  .get(),
                              builder: (c, dataSnapshot) {
                                return dataSnapshot.hasData
                                    ? Container(
                                  child: Row(
                                    children: [
                                      Text('Order status : '),
                                      Text(
                                        dataSnapshot.data.get(OutFittedApp.orderStatus)
                                      ),
                                    ],
                                  ),
                                )
                                    : Center(
                                  child: SpinKitDualRing(
                                    color: kSecondaryColor,
                                    size: 50,
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        )
                      : SpinKitDualRing(
                          color: kSecondaryColor,
                          size: 50,
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
