import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:outfitted_flutter_mobile/components/address_card.dart';
import 'package:outfitted_flutter_mobile/components/outfitted_custom_appbar_v2.dart';
import 'package:outfitted_flutter_mobile/components/textfield_container.dart';
import 'package:outfitted_flutter_mobile/counters/address_changer.dart';
import 'package:outfitted_flutter_mobile/firebase/firebase_config.dart';
import 'package:outfitted_flutter_mobile/model/Address.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatelessWidget {

  final double totalAmount;

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController cName = TextEditingController();
  TextEditingController cStreetAndNumber = TextEditingController();
  TextEditingController cPostCode = TextEditingController();
  TextEditingController cCityOrTown = TextEditingController();
  TextEditingController cPhone = TextEditingController();
  TextEditingController cCountry = TextEditingController();

  AddressScreen({Key key, this.totalAmount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('total amount is €$totalAmount');
    return Scaffold(
      appBar: OutFittedCustomAppBarV2(
        appBar: AppBar(),
        onLeftIconPress: () {
          Navigator.pop(context);
        },
        title: 'Checkout',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                  'Address',
                style: TextStyle(
                  fontSize: 16,
                  color: kWhiteColor,
                ),
              ),
            ),
          ),
          Consumer<AddressChanger>(
            builder: (context, address, c) {
              return Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: OutFittedApp.firestore
                      .collection(OutFittedApp.collectionCustomer)
                      .doc(OutFittedApp.sharedPreferences
                          .getString(OutFittedApp.customerUID))
                      .collection(OutFittedApp.subCollectionAddress)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? Center(
                      child: SpinKitDualRing(
                        color: kSecondaryColor,
                        size: 50,
                      ),
                    )
                        : snapshot.data.docs.length == 0
                            ? Center(
                                child: Text(
                                    'No address added yet. Add new address to proceed.'),
                              )
                            : ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return AddressCard(
                                    currentIndex: address.count,
                                    value: index,
                                    addressID: snapshot.data.docs[index].id,
                                    totalAmount: this.totalAmount,
                                    addressModel: Address.getAddressFromJson(
                                        snapshot.data.docs[index].data()),
                                  );
                                });
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'showButtonSheetToAddAddress',
        onPressed: () {
          showAddressModalBottomSheet(context);
        },
        label: Text(
          "Add new address",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kSecondaryColor,
        icon: Icon(Icons.add_location_outlined),
      ),
    );
  }

  void showAddressModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext buildContext) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Add Shipping Address"),
                      IconButton(
                        icon: Icon(
                          Icons.remove,
                          color: kWhiteColor.withOpacity(0.5),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Divider(
                    height: 2,
                    color: kWhiteColor.withOpacity(0.5),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFieldContainer(
                    backgroundColor: kBackgroundOutFitted.withOpacity(0.5),
                    child: TextFormField(
                      validator: (val) =>
                          val.isEmpty ? "Field cannot be empty..." : null,
                      controller: cName,
                      autofocus: true,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.person_outline,
                          color: kWhiteColor.withOpacity(0.5),
                        ),
                        hintText: 'Name',
                        hintStyle: TextStyle(
                          color: kWhiteColor.withOpacity(0.5),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextFieldContainer(
                    backgroundColor: kBackgroundOutFitted.withOpacity(0.5),
                    child: TextFormField(
                      validator: (val) =>
                          val.isEmpty ? "Field cannot be empty..." : null,
                      controller: cStreetAndNumber,
                      autofocus: true,
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.add_location_alt_outlined,
                          color: kWhiteColor.withOpacity(0.5),
                        ),
                        hintText: 'Address (Street & number)',
                        hintStyle: TextStyle(
                          color: kWhiteColor.withOpacity(0.5),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextFieldContainer(
                    backgroundColor: kBackgroundOutFitted.withOpacity(0.5),
                    child: TextFormField(
                      validator: (val) =>
                          val.isEmpty ? "Field cannot be empty..." : null,
                      controller: cPostCode,
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.account_box_outlined,
                          color: kWhiteColor.withOpacity(0.5),
                        ),
                        hintText: 'Post Code',
                        hintStyle: TextStyle(
                          color: kWhiteColor.withOpacity(0.5),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextFieldContainer(
                    backgroundColor: kBackgroundOutFitted.withOpacity(0.5),
                    child: TextFormField(
                      validator: (val) =>
                          val.isEmpty ? "Field cannot be empty..." : null,
                      controller: cCityOrTown,
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.location_city_outlined,
                          color: kWhiteColor.withOpacity(0.5),
                        ),
                        hintText: 'City/Town',
                        hintStyle: TextStyle(
                          color: kWhiteColor.withOpacity(0.5),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextFieldContainer(
                    backgroundColor: kBackgroundOutFitted.withOpacity(0.5),
                    child: TextFormField(
                      validator: (val) =>
                          val.isEmpty ? "Field cannot be empty..." : null,
                      controller: cPhone,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.phone,
                          color: kWhiteColor.withOpacity(0.5),
                        ),
                        hintText: 'Phone #',
                        hintStyle: TextStyle(
                          color: kWhiteColor.withOpacity(0.5),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: TextFieldContainer(
                      backgroundColor: kBackgroundOutFitted.withOpacity(0.5),
                      child: TextFormField(
                        validator: (val) =>
                            val.isEmpty ? "Field cannot be empty..." : null,
                        controller: cCountry,
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.person_outline,
                            color: kWhiteColor.withOpacity(0.5),
                          ),
                          hintText: 'Country',
                          hintStyle: TextStyle(
                            color: kWhiteColor.withOpacity(0.5),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 55,
                    color: kSecondaryColor,
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        final addressModel = Address(
                          name: cName.text.trim(),
                          streetAndNumber: cStreetAndNumber.text.trim(),
                          postCode: cPostCode.text.trim(),
                          cityOrTown: cCityOrTown.text.trim(),
                          phone: cPhone.text.trim(),
                          country: cCountry.text.trim(),
                        ).createAddressToJson();

                        // add address to firestore
                        OutFittedApp.firestore
                            .collection(OutFittedApp.collectionCustomer)
                            .doc(OutFittedApp.sharedPreferences
                                .getString(OutFittedApp.customerUID))
                            .collection(OutFittedApp.subCollectionAddress)
                            .doc(DateTime.now()
                                .microsecondsSinceEpoch
                                .toString())
                            .set(addressModel)
                            .then((value) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          formKey.currentState.reset();
                          Navigator.of(context).pop();
                        });
                      }
                    },
                    child: Text(
                      "Add Shipping Address",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
