import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key key,
    this.buttonText,
    this.press,
    this.buttonColor,
  }) : super(key: key);

  final String buttonText;
  final Function press;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: FlatButton(
          padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 40,
          ),
          color: buttonColor,
          onPressed: press,
          child: Text(
            buttonText,
            style: TextStyle(
              color: kWhiteColor,
            ),
          ),
        ),
      ),
    );
  }
}
