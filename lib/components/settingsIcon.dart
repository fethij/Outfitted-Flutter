import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

class SettingsIcon extends StatelessWidget {
  const SettingsIcon({
    Key key,
    this.icon,
    this.press,
    this.text,
    this.uniqueHeroTag,
  }) : super(key: key);
  final Icon icon;
  final Function press;
  final String text, uniqueHeroTag;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: uniqueHeroTag,
      child: InkWell(
        onTap: press,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: kWhiteColor,
                ),
                shape: BoxShape.circle,
              ),
              child: icon,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
