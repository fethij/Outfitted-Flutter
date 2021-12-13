import 'package:flutter/foundation.dart';

class TotalAmount extends ChangeNotifier {
  double _totalAmount = 0;

  double get totalAmount => _totalAmount;

  displayTotalAmountResult(double amount) async {
    _totalAmount = amount;

    await Future.delayed(
        Duration(
          milliseconds: 100,
        ), () {
      notifyListeners();
    });
  }
}
