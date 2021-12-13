import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

class ErrorAlertDialog extends StatelessWidget {
  final String message;

  const ErrorAlertDialog({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(
        message,
        style: TextStyle(
          color: kPrimaryColor,
        ),
      ),
      actions: [
        RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: kPrimaryColor,
          child: Center(
            child: Text("OK"),
          ),
        ),
      ],
    );
  }
}
