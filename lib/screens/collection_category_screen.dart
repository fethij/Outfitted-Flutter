import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/components/outfitted_custom_appbar.dart';
import 'package:outfitted_flutter_mobile/components/outfitted_custom_appbar_v2.dart';
import 'package:outfitted_flutter_mobile/components/price_range_slider.dart';
import 'package:outfitted_flutter_mobile/components/productInfo.dart';
import 'package:outfitted_flutter_mobile/components/product_collection_card.dart';
import 'package:outfitted_flutter_mobile/firebase/firebase_config.dart';
import 'package:outfitted_flutter_mobile/model/Product.dart';
import 'package:outfitted_flutter_mobile/screens/product_details_screen.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

class CollectionCategoryScreen extends StatefulWidget {
  const CollectionCategoryScreen({
    Key key,
    this.categoryName,
    this.brandName,
  }) : super(key: key);

  final String categoryName, brandName;

  @override
  _CollectionCategoryScreenState createState() =>
      _CollectionCategoryScreenState();
}

class _CollectionCategoryScreenState extends State<CollectionCategoryScreen> {
  static double _lowerValue = 0, _upperValue;

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  RangeValues values = RangeValues(0, 0);
  int selectedSortByRadio = 0;

  Widget content;

  bool isNotFiltered = true;

  initMaxPrice() async {
    await OutFittedApp.firestore
        .collection(OutFittedApp.collectionProduct)
        .orderBy('price', descending: true)
        .limit(1)
        .get()
        .then((value) {
      setState(() {
        _upperValue = double.parse(value.docs[0].data()['price'].toString());
        // 55 = 100
        //    = 20
        print('before discount: $_upperValue');
        int discountPercentage = int.parse(value.docs[0].data()['discount'].toString());

        double priceWithDiscount = (_upperValue) - (_upperValue * discountPercentage / 100);

        _upperValue = priceWithDiscount;

        print('after discount: $_upperValue');

        values = RangeValues(_lowerValue, _upperValue);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initMaxPrice();
  }

  @override
  Widget build(BuildContext context) {
    initContent();

    return Scaffold(
      key: _drawerKey,
      appBar: OutFittedCustomAppBarV2(
        title: 'Collection',
        customIcon: Icon(Icons.arrow_back),
        appBar: AppBar(),
        onLeftIconPress: () {
          Navigator.pop(context);
        },
      ),
      drawer: Drawer(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: kPrimaryColor,
          ),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Filter',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Text('Sort By'),
                Column(
                  children: [
                    SizedBox(
                      height: 35,
                      child: RadioListTile(
                        activeColor: kSecondaryColor,
                        value: 0,
                        groupValue: selectedSortByRadio,
                        title: Text('Sale'),
                        onChanged: (val) {
                          setState(() {
                            selectedSortByRadio = val;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 35,
                      child: RadioListTile(
                          activeColor: kSecondaryColor,
                          value: 1,
                          groupValue: selectedSortByRadio,
                          title: Text('Newest'),
                          onChanged: (val) {
                            setState(() {
                              selectedSortByRadio = val;
                            });
                          }),
                    ),
                    SizedBox(
                      height: 35,
                      child: RadioListTile(
                          activeColor: kSecondaryColor,
                          value: 2,
                          groupValue: selectedSortByRadio,
                          title: Text('Price High-Low'),
                          onChanged: (val) {
                            setState(() {
                              selectedSortByRadio = val;
                            });
                          }),
                    ),
                    SizedBox(
                      height: 35,
                      child: RadioListTile(
                          activeColor: kSecondaryColor,
                          value: 3,
                          groupValue: selectedSortByRadio,
                          title: Text('Price Low-High'),
                          onChanged: (val) {
                            setState(() {
                              selectedSortByRadio = val;
                            });
                          }),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  thickness: 1,
                  color: kWhiteColor.withOpacity(0.3),
                ),
                Text('Price Range'),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    valueIndicatorColor: kSecondaryColor,
                    inactiveTrackColor: kPrimaryColor,
                  ),
                  child: RangeSlider(
                    activeColor: kSecondaryColor,
                    inactiveColor: kBackgroundOutFitted,
                    min: _lowerValue,
                    max: _upperValue,
                    labels: RangeLabels(
                        values.start.toStringAsFixed(2),
                        values.end.toStringAsFixed(2),
                    ),
                    divisions:(_upperValue - _lowerValue).toInt(),
                    values: values,
                    onChanged: (val) {
                      setState(() {
                        values = val;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      isNotFiltered = false;
                    });
                  },
                  child: Center(
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: kSecondaryColor,
                      ),
                      child: Center(
                        child: Text(
                          'Apply',
                          style: TextStyle(
                            color: kWhiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: widget.categoryName == 'All' ? FloatingActionButton(
        heroTag: 'filterCollection',
        onPressed: () {
          _drawerKey.currentState.openDrawer();
          // showFilterModalBottomSheet(context);
        },
        child: Icon(Icons.filter_list_outlined),
        backgroundColor: kSecondaryColor,
      )
      : Container(),
      backgroundColor: kBackgroundOutFitted,
      body: initContent(),
    );
  }

  Widget initContent() {

    print('start values:${values.start}');
    print('end values:${values.end}');
    return Column(
      children: [
        Text(widget.categoryName),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: isNotFiltered
            // non-filter
                ? (widget.categoryName == 'All'
                    ? OutFittedApp.firestore
                        .collection(OutFittedApp.collectionProduct)
                        .snapshots()
                    : widget.categoryName == widget.brandName
                        ? OutFittedApp.firestore
                            .collection(OutFittedApp.collectionProduct)
                            .where('supplier', isEqualTo: widget.brandName)
                            .snapshots()
                        : widget.categoryName == 'Sale'
                            ? OutFittedApp.firestore
                                .collection(OutFittedApp.collectionProduct)
                                .where('discount', isGreaterThan: 0)
                                .snapshots()
                            : OutFittedApp.firestore
                                .collection(OutFittedApp.collectionProduct)
                                .where('category',
                                    isEqualTo: widget.categoryName)
                                .snapshots())
            // filter
                : (widget.categoryName == 'All'
                    ? OutFittedApp.firestore
                        .collection(OutFittedApp.collectionProduct)
                        .where('price', isGreaterThanOrEqualTo: values.start)
                        .where('price', isLessThanOrEqualTo: values.end)
                        .snapshots()
                    : widget.categoryName == widget.brandName
                        ? OutFittedApp.firestore
                            .collection(OutFittedApp.collectionProduct)
                            .where('supplier', isEqualTo: widget.brandName)
                            .snapshots()
                        : widget.categoryName == 'Sale'
                            ? OutFittedApp.firestore
                                .collection(OutFittedApp.collectionProduct)
                                .where('discount', isGreaterThan: 0)
                                .snapshots()
                            : OutFittedApp.firestore
                                .collection(OutFittedApp.collectionProduct)
                                .where('category',
                                    isEqualTo: widget.categoryName)
                                .snapshots()),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    child: GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.7,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        Product product = Product.getProductFromJson(
                            snapshot.data.docs[index].data());
                        // set name of document as id of the product
                        product.id = snapshot.data.docs[index].id;
                        return productInfo(product, context);
                      },
                    ),
                  );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget updateContent() {
    return Center(
      child: Text(
        'Apply',
        style: TextStyle(
          color: kWhiteColor,
        ),
      ),
    );
  }

  // void initContent() {
  //   if (firstStart) {
  //     content = Column(
  //       children: [
  //         Text("NOO"),
  //         Expanded(
  //           child: StreamBuilder<QuerySnapshot>(
  //             stream: widget.categoryName == 'All'
  //                 ? OutFittedApp.firestore
  //                     .collection(OutFittedApp.collectionProduct)
  //                     .snapshots()
  //                 : widget.categoryName == widget.brandName
  //                     ? OutFittedApp.firestore
  //                         .collection(OutFittedApp.collectionProduct)
  //                         .where('supplier', isEqualTo: widget.brandName)
  //                         .snapshots()
  //                     : widget.categoryName == 'Sale'
  //                         ? OutFittedApp.firestore
  //                             .collection(OutFittedApp.collectionProduct)
  //                             .where('discount', isGreaterThan: 0)
  //                             .snapshots()
  //                         : OutFittedApp.firestore
  //                             .collection(OutFittedApp.collectionProduct)
  //                             .where('category', isEqualTo: widget.categoryName)
  //                             .snapshots(),
  //             builder: (BuildContext context,
  //                 AsyncSnapshot<QuerySnapshot> snapshot) {
  //               if (snapshot.hasError)
  //                 return Center(
  //                   child: Text('Error: ${snapshot.error}'),
  //                 );
  //               if (!snapshot.hasData)
  //                 return Center(
  //                   child:
  //                       Text('There are no products yet! Sign up for updates'),
  //                 );
  //               switch (snapshot.connectionState) {
  //                 case ConnectionState.waiting:
  //                   return Center(
  //                     child: Text('Loading'),
  //                   );
  //                 default:
  //                   return Padding(
  //                     padding: EdgeInsets.only(
  //                       top: 5,
  //                       right: 5,
  //                     ),
  //                     child: GridView.builder(
  //                       physics: ScrollPhysics(),
  //                       shrinkWrap: true,
  //                       itemCount: snapshot.data.docs.length,
  //                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                         childAspectRatio: 0.7,
  //                         crossAxisCount: 2,
  //                       ),
  //                       itemBuilder: (context, index) {
  //                         Product product = Product.getProductFromJson(
  //                             snapshot.data.docs[index].data());
  //                         // set name of document as id of the product
  //                         product.id = snapshot.data.docs[index].id;
  //                         return productInfo(product, context);
  //                       },
  //                     ),
  //                   );
  //               }
  //             },
  //           ),
  //         ),
  //       ],
  //     );
  //   }
  //   firstStart = false;
  // }

  // void updateContent() {
  //   setState(() {
  //     // todo: change @content with new Column
  //     content = Center(
  //       child: Text(
  //         'Apply',
  //         style: TextStyle(
  //           color: kWhiteColor,
  //         ),
  //       ),
  //     );
  //     print("CONTENTT " + content.toString());
  //   });
  // }

  void setSelectedRadioValue(int val) {
    setState(() {
      selectedSortByRadio = val;
    });
  }

  void showFilterModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext buildContext) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter state) {
              OutFittedApp.firestore
                  .collection(OutFittedApp.collectionProduct)
                  // .where('price', isGreaterThanOrEqualTo: lowerPrice)
                  // .where('price', isLessThanOrEqualTo: higherPrice)
                  .get();
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(color: kPrimaryColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'Filter',
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    Text('Sort By'),
                    Column(
                      children: [
                        SizedBox(
                          height: 35,
                          child: RadioListTile(
                            activeColor: kSecondaryColor,
                            value: 0,
                            groupValue: selectedSortByRadio,
                            title: Text('Sale'),
                            onChanged: (val) {
                              state(() {
                                selectedSortByRadio = val;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 35,
                          child: RadioListTile(
                              activeColor: kSecondaryColor,
                              value: 1,
                              groupValue: selectedSortByRadio,
                              title: Text('Newest'),
                              onChanged: (val) {
                                state(() {
                                  selectedSortByRadio = val;
                                });
                              }),
                        ),
                        SizedBox(
                          height: 35,
                          child: RadioListTile(
                              activeColor: kSecondaryColor,
                              value: 2,
                              groupValue: selectedSortByRadio,
                              title: Text('Price High-Low'),
                              onChanged: (val) {
                                state(() {
                                  selectedSortByRadio = val;
                                });
                              }),
                        ),
                        SizedBox(
                          height: 35,
                          child: RadioListTile(
                              activeColor: kSecondaryColor,
                              value: 3,
                              groupValue: selectedSortByRadio,
                              title: Text('Price Low-High'),
                              onChanged: (val) {
                                state(() {
                                  selectedSortByRadio = val;
                                });
                              }),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      thickness: 1,
                      color: kWhiteColor.withOpacity(0.3),
                    ),
                    Text('Price Range'),
                    PriceRangeSlider(),
                    SizedBox(
                      height: 30,
                    ),
                    FlatButton(
                      onPressed: () {
                        // filter uit
                      },
                      child: Center(
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            color: kSecondaryColor,
                          ),
                          child: Center(
                            child: Text(
                              'Apply',
                              style: TextStyle(
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }
}
