import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/firebase/firebase_config.dart';

class CartItemCounter extends ChangeNotifier {
  int _counter = OutFittedApp.sharedPreferences
          .getStringList(OutFittedApp.customerCartList)
          .length -
      1;
  int get count => _counter;

  Future<void> displayItemCounterResult() async {
    _counter = OutFittedApp.sharedPreferences
            .getStringList(OutFittedApp.customerCartList)
            .length -
        1;

    await Future.delayed(Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
