import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

class HomeScreenSecondTitle extends StatelessWidget {
  const HomeScreenSecondTitle({
    Key key,
    this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      child: Padding(
        padding: const EdgeInsets.only(
          left: kDefaultPadding / 4,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
