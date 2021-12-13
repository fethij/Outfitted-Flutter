import 'package:flutter/material.dart';

import 'Product.dart';

class Cart {
  Product product;
  int amountItems;

  Cart({@required this.product, @required this.amountItems});
}
