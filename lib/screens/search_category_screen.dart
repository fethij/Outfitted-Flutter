import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:outfitted_flutter_mobile/components/outfitted_custom_appbar_v2.dart';
import 'package:outfitted_flutter_mobile/components/store_category.dart';
import 'package:outfitted_flutter_mobile/firebase/firebase_config.dart';
import 'package:outfitted_flutter_mobile/model/CollectionCategory.dart';
import 'package:outfitted_flutter_mobile/screens/collection_category_screen.dart';
import 'package:outfitted_flutter_mobile/screens/search_product_screen.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

class SearchCategoryScreen extends StatefulWidget {
  @override
  _SearchCategoryScreenState createState() => _SearchCategoryScreenState();
}

class _SearchCategoryScreenState extends State<SearchCategoryScreen> {
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      child: Scaffold(
        appBar: OutFittedCustomAppBarV2(
          title: 'Search Category',
          customIcon: Icon(Icons.search),
          appBar: AppBar(),
          onLeftIconPress: () {
            Route route = MaterialPageRoute(builder: (c) => SearchProductScreen());
            Navigator.push(context, route);
          },
        ),
        //resizeToAvoidBottomPadding: false,
        backgroundColor: kBackgroundOutFitted,
        body: Padding(
          padding: EdgeInsets.all(10),
          child: StreamBuilder<QuerySnapshot>(
            stream: OutFittedApp.firestore
                .collection(OutFittedApp.collectionCategory)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: Text('Loading'),
                  );
                default:
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index){
                         CollectionCategory category = CollectionCategory.getCategoryFromJson(snapshot.data.docs[index].data());
                          return categoryInfo(category, context);
                      }
                  );
              }
            },
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
}

Widget categoryInfo(CollectionCategory pCollectionCategory, BuildContext context) {
  return StoreCategory(
    collectionCategory: pCollectionCategory,
    press: (){
      Route route = MaterialPageRoute(builder: (c) => CollectionCategoryScreen(categoryName : pCollectionCategory.categoryName));
      Navigator.push(context, route);
    },
  );
}
