import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/model/Address.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

class ShippingInfoDetails extends StatelessWidget {
  final Address address;
  final String dateOrdered;

  const ShippingInfoDetails({
    Key key,
    this.address,
    this.dateOrdered,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 105,
      decoration: BoxDecoration(color: kPrimaryColor),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address.streetAndNumber,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                address.postCode + ', ' + address.cityOrTown,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Online order',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                dateOrdered,
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: 100,
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: FlatButton(
                  onPressed: () {},
                  child: Text(
                    'Option',
                    style: TextStyle(
                      color: kWhiteColor,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
