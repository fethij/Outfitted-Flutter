import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:outfitted_flutter_mobile/components/brand_partnerships.dart';
import 'package:outfitted_flutter_mobile/components/discount_products.dart';
import 'package:outfitted_flutter_mobile/components/models_image_slider.dart';
import 'package:outfitted_flutter_mobile/components/title_with_button.dart';
import 'package:outfitted_flutter_mobile/firebase/firebase_config.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

import 'collection_category_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      )
    );
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: kHomeScreenBackground,
        //backgroundColor: kWhiteColor,

        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                left: 15
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  top: 0,
                  child: Image.asset(
                    'assets/images/dp2.jpg',
                    height: 500,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 100),
                        child: Text('New Collection',
                          style:  TextStyle(
                            fontSize: 45,
                            color: kPrimaryColor,
                            fontFamily: 'BodoniModa',
                          ),
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/dp3.jpg',
                      height: 340,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 380,
                      child: Stack(
                        children: [
                          Positioned(
                            right: 0,
                            child: Image.asset(
                              'assets/images/dp.jpg',
                              width: MediaQuery.of(context).size.width * 0.75,
                              fit: BoxFit.contain,
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Route route = MaterialPageRoute(builder: (c) => CollectionCategoryScreen(categoryName : 'All'));
                              Navigator.push(context, route);
                            },
                            child: Row(
                              children: [
                                Text(
                                  'See All ',
                                  style: TextStyle(
                                    fontSize: 30,
                                      color: kPrimaryColor,
                                    fontFamily: 'BodoniModa',
                                  ),
                                ),
                                 Icon(Icons.arrow_forward_sharp),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: 15
                      ),
                      child: TitleWithButton(
                        title: 'Best Sales',
                        press: (){
                          Route route = MaterialPageRoute(builder: (c) => CollectionCategoryScreen(categoryName : 'Sale'));
                          Navigator.push(context, route);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DiscountProducts(),
                    Padding(
                      padding: EdgeInsets.only(
                          right: 15
                      ),
                      child: TitleWithButton(
                        title: 'Shop by Brand',
                        press: (){
                          Route route = MaterialPageRoute(builder: (c) => CollectionCategoryScreen(categoryName : 'All'));
                          Navigator.push(context, route);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    BrandPartnerships(),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: 15
                      ),
                      child: TitleWithButton(
                        title: 'Follow our models',
                        press: (){
                          _scaffoldKey.currentState.showSnackBar(
                            new SnackBar(
                              backgroundColor: kPrimaryColor,
                              duration: Duration(
                                seconds: 2,
                              ),
                              content: Container(
                                height: 30,
                                child: Center(
                                  child: Text('Models screen not available yet... coming up soon!'),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ModelsImageSlider(
                      scaffoldKey: _scaffoldKey,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ],
            ),
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
