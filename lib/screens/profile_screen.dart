import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:outfitted_flutter_mobile/components/outfitted_custom_card.dart';
import 'package:outfitted_flutter_mobile/components/settingsIcon.dart';
import 'package:outfitted_flutter_mobile/components/settings_address_card.dart';
import 'package:outfitted_flutter_mobile/firebase/firebase_config.dart';
import 'package:outfitted_flutter_mobile/model/Address.dart';
import 'package:outfitted_flutter_mobile/screens/all_orders_screen.dart';
import 'package:outfitted_flutter_mobile/screens/settings_screen.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

class ProfileScreen extends StatelessWidget {
  Address address;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profile'),
            SizedBox(
              height: 10,
            ),
            OutFittedCustomCard(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          OutFittedApp.sharedPreferences
                              .getString(OutFittedApp.customerName),
                          style: TextStyle(color: kWhiteColor, fontSize: 30),
                        ),
                        Text(
                          OutFittedApp.sharedPreferences
                              .getString(OutFittedApp.customerEmail),
                          style: TextStyle(color: kWhiteColor),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        FloatingActionButton(
                          heroTag: 'btnProfileEdit',
                          onPressed: () {},
                          child: Icon(
                            Icons.edit_outlined,
                          ),
                          backgroundColor: kSecondaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text('Address'),
            SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: OutFittedApp.firestore
                  .collection(OutFittedApp.collectionCustomer)
                  .doc(OutFittedApp.sharedPreferences
                  .getString(OutFittedApp.customerUID))
                  .collection(OutFittedApp.subCollectionAddress)
                  .snapshots(),
                builder: (context, snapshot){
                  return !snapshot.hasData
                      ? Center(
                    child: SpinKitDualRing(
                      color: kSecondaryColor,
                      size: 50,
                    ),
                  )
                      : snapshot.data.docs.length == 0
                      ? Text('Add address')
                      : Container(
                          height: 250,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index){
                              return SettingsAddressCard(
                                address: Address.getAddressFromJson(
                                  snapshot.data.docs[index].data()
                                ),
                              );
                            }
                  ),
                      );
                }
            ),
            SizedBox(
              height: 30,
            ),
            Divider(
              height: 2,
              color: kWhiteColor,
            ),
            SizedBox(
              height: 30,
            ),
            Text("Extra's"),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SettingsIcon(
                  uniqueHeroTag: 'Orders',
                  text: 'Orders',
                  icon: Icon(
                    Icons.store_outlined,
                    color: kWhiteColor,
                  ),
                  press: () {
                    Route route = MaterialPageRoute(builder: (c) => AllOrdersScreen());
                    Navigator.push(context, route);
                  },
                ),
                SettingsIcon(
                  uniqueHeroTag: 'Messages',
                  text: 'Messages',
                  icon: Icon(
                    Icons.mail_outline_outlined,
                    color: kWhiteColor,
                  ),
                  press: () {},
                ),
                SettingsIcon(
                  uniqueHeroTag: 'Cards',
                  text: 'Cards',
                  icon: Icon(
                    Icons.credit_card_outlined,
                    color: kWhiteColor,
                  ),
                  press: () {},
                ),
                SettingsIcon(
                  uniqueHeroTag: 'Settings',
                  text: 'Settings',
                  icon: Icon(
                    Icons.settings,
                    color: kWhiteColor,
                  ),
                  press: () {
                    Route route = MaterialPageRoute(builder: (c) => SettingsScreen());
                    Navigator.push(context, route);
                  },
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Divider(
              height: 2,
              color: kWhiteColor,
            ),
            SizedBox(
              height: 30,
            ),
            Text("Rewards"),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}


