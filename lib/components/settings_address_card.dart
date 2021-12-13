import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/model/Address.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

class SettingsAddressCard extends StatefulWidget {
  const SettingsAddressCard({
    Key key,
    this.address,
  }) : super(key: key);

  final Address address;

  @override
  _SettingsAddressCardState createState() => _SettingsAddressCardState();
}

class _SettingsAddressCardState extends State<SettingsAddressCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 250,
      width: MediaQuery.of(context).size.width * 0.85,
      margin: EdgeInsets.only(
        right: 10,
      ),
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
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.address.streetAndNumber,
                  style: TextStyle(
                    color: kWhiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.address.cityOrTown + ', ' + widget.address.postCode,
                  style: TextStyle(
                    color: kWhiteColor,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.check_box_outlined,
                          color: kWhiteColor.withOpacity(0.5),
                        ),
                      ),
                      TextSpan(text: 'Delivery address')
                    ],
                  ),
                ),
                Text(
                  widget.address.country + ', ' + widget.address.phone,
                  style: TextStyle(
                    color: kWhiteColor,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                FloatingActionButton(
                  heroTag: 'btnAddressEdit' +
                      widget.address.country +
                      widget.address.cityOrTown +
                      widget.address.name +
                      widget.address.streetAndNumber,
                  onPressed: () {},
                  child: Icon(
                    Icons.edit_outlined,
                  ),
                  backgroundColor: kSecondaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
