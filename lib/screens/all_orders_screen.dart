import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:outfitted_flutter_mobile/components/order_card.dart';
import 'package:outfitted_flutter_mobile/components/outfitted_custom_appbar_v2.dart';
import 'package:outfitted_flutter_mobile/firebase/firebase_config.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

class AllOrdersScreen extends StatefulWidget {
  @override
  _AllOrdersScreenState createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OutFittedCustomAppBarV2(
        title: 'All Orders',
        customIcon: Icon(Icons.arrow_back),
        appBar: AppBar(),
        onLeftIconPress: (){
          Navigator.pop(context);
        },
      ),
      backgroundColor: kBackgroundOutFitted,
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: OutFittedApp.firestore
              .collection(OutFittedApp.collectionCustomer)
              .doc(OutFittedApp.sharedPreferences
                  .getString(OutFittedApp.customerUID))
              .collection(OutFittedApp.collectionOrders)
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (c, index) {
                      return FutureBuilder<QuerySnapshot>(
                        future: OutFittedApp.firestore
                            .collection(OutFittedApp.collectionProduct)
                            .where(FieldPath.documentId,
                                whereIn: snapshot.data.docs[index]
                                    .data()[OutFittedApp.productID])
                            .get(),
                        builder: (c, snapshot2) {
                          return snapshot2.hasData
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  FutureBuilder<DocumentSnapshot>(
                                    future: OutFittedApp.firestore
                                          .collection(OutFittedApp.collectionCustomer)
                                          .doc(OutFittedApp.sharedPreferences.getString(OutFittedApp.customerUID))
                                          .collection(OutFittedApp.collectionOrders)
                                          .doc(snapshot.data.docs[index].id)
                                          .get(),
                                      builder: (c, snapshotOrder){
                                        return snapshotOrder.hasData
                                            ? Text(
                                            DateFormat(
                                                'dd MMMM, yyyy - hh:mm aa')
                                                .format(DateTime
                                                .fromMicrosecondsSinceEpoch(
                                                int.parse(snapshotOrder.data.data()[OutFittedApp.orderTime])))
                                        )
                                            : Container();
                                      }
                                  ),
                                  OrderCard(
                                      itemCount: snapshot2.data.docs.length,
                                      data: snapshot2.data.docs,
                                      orderID: snapshot.data.docs[index].id,
                                    ),
                                ],
                              )
                              : Center(
                                  child: SpinKitDualRing(
                                    color: kSecondaryColor,
                                    size: 50,
                                  ),
                                );
                        },
                      );
                    },
                  )
                : Center(
                    child: SpinKitDualRing(
                      color: kSecondaryColor,
                      size: 50,
                    ),
                  );
          },
        ),
      ),
    );
  }
}
