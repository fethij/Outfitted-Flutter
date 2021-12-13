import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/firebase/firebase_config.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

class PriceRangeSlider extends StatefulWidget {
  @override
  _PriceRangeSliderState createState() => _PriceRangeSliderState();
}

class _PriceRangeSliderState extends State<PriceRangeSlider> {
  static double _lowerValue = 0, _upperValue;

  RangeValues values = RangeValues(0, 0);

  initMaxPrice() async {
    await OutFittedApp.firestore
        .collection(OutFittedApp.collectionProduct)
        .orderBy('price', descending: true)
        .limit(1)
        .get()
        .then((value) {
      setState(() {
        _upperValue = double.parse(value.docs[0].data()['price'].toString());
        values = RangeValues(_lowerValue, _upperValue);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initMaxPrice();
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        valueIndicatorColor: kSecondaryColor,
        inactiveTrackColor: kPrimaryColor,
      ),
      child: RangeSlider(
        activeColor: kSecondaryColor,
        inactiveColor: kBackgroundOutFitted,
        min: _lowerValue,
        max: _upperValue,
        labels: RangeLabels(
            values.start.toStringAsFixed(2), values.end.toStringAsFixed(2)),
        divisions: (_upperValue - _lowerValue).toInt() * 2.3.toInt(),
        values: values,
        onChanged: (val) {
          setState(() {
            values = val;
          });
        },
      ),
    );
  }
}
