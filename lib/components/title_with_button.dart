import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

import 'home_screen_title_more.dart';

class TitleWithButton extends StatelessWidget {
  const TitleWithButton({
    Key key,
    this.title,
    this.press,
  }) : super(key: key);

  final String title;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: [
          HomeScreenSecondTitle(text: title),
          Spacer(),
          FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: kPrimaryColor,
            onPressed: press,
            child: Text(
              "More",
              style: TextStyle(
                color: kWhiteColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
