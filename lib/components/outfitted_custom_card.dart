import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

class OutFittedCustomCard extends StatelessWidget {
  const OutFittedCustomCard({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: kPrimaryColor,
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
