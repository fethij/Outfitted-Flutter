import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';
import 'dart:io' show Platform;

class OutFittedCustomToast extends StatelessWidget {
  final String text;
  final Color gradiantColor, textColor;
  final Icon iconIndicator;
  final Function press;

  const OutFittedCustomToast({
    Key key,
    this.text,
    this.gradiantColor,
    this.textColor,
    this.iconIndicator,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            gradiantColor.withOpacity(0.5),
            gradiantColor.withOpacity(0.5),
            kPrimaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Row(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Container(
                  width: 40.0,
                  height: 40.0,
                  color: textColor,
                  child: iconIndicator),
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Container(
            width: Platform.isIOS ? 200 : 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
                SizedBox(
                  width: 190,
                  child: TextButton(
                    child: Text(
                      'Go to Cart',
                    ),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: textColor,
                      onSurface: Colors.grey,
                    ),
                    onPressed: press,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
