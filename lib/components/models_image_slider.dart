import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

class ModelsImageSlider extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ModelsImageSlider({
    Key key,
    this.scaffoldKey,
  }) : super(key: key);
  @override
  _ModelsImageSliderState createState() => _ModelsImageSliderState();
}

class _ModelsImageSliderState extends State<ModelsImageSlider> {
  List imageList = [
    'assets/images/model1.jpg',
    'assets/images/model2.jpg',
    'assets/images/model3.jpg',
    'assets/images/model4.jpg',
    'assets/images/model5.jpg',
    'assets/images/model6.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 15),
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
                disableCenter: true,
                aspectRatio: 0.857,
                autoPlay: true,
                autoPlayCurve: Curves.easeOutCirc),
            items: imageList.map((image) {
              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: kWhiteColor),
                    ),
                    child: Center(
                      child: Image.asset(
                        image,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      // redirect to instagram page
                      widget.scaffoldKey.currentState.showSnackBar(
                        new SnackBar(
                          backgroundColor: kPrimaryColor,
                          duration: Duration(
                            seconds: 2,
                          ),
                          content: Container(
                            height: 30,
                            child: Center(
                              child: Text(
                                  'Follow models not available yet... coming up soon!'),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: kWhiteColor,
                          ),
                        ),
                        child: Center(
                            child: Text(
                          'Follow',
                          style: TextStyle(color: kWhiteColor),
                        )),
                      ),
                    ),
                  )
                ],
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
