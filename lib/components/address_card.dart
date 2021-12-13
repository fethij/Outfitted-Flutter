import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/components/rounded_button.dart';
import 'package:outfitted_flutter_mobile/counters/address_changer.dart';
import 'package:outfitted_flutter_mobile/model/Address.dart';
import 'package:outfitted_flutter_mobile/screens/payment_screen.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';
import 'package:provider/provider.dart';

class AddressCard extends StatefulWidget {
  final Address addressModel;
  final String addressID;
  final double totalAmount;
  final int currentIndex;
  final int value;

  const AddressCard(
      {Key key,
      this.addressModel,
      this.addressID,
      this.totalAmount,
      this.value,
      this.currentIndex})
      : super(key: key);

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<AddressChanger>(context, listen: false)
            .displayResult(widget.value);
      },
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
        ),
        child: Card(
          color: kPrimaryColor,
          child: Column(
            children: [
              Row(
                children: [
                  Radio(
                    groupValue: widget.currentIndex,
                    value: widget.value,
                    activeColor: kSecondaryColor,
                    onChanged: (val) {
                      Provider.of<AddressChanger>(context, listen: false)
                          .displayResult(val);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.addressModel.name,
                          style: TextStyle(
                            color: kWhiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.addressModel.streetAndNumber,
                          style: TextStyle(
                            color: kWhiteColor,
                          ),
                        ),
                        Text(
                          widget.addressModel.cityOrTown +
                              ', ' +
                              widget.addressModel.postCode,
                          style: TextStyle(
                            color: kWhiteColor,
                          ),
                        ),
                        Text(
                          widget.addressModel.country,
                          style: TextStyle(
                            color: kWhiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              widget.value == Provider.of<AddressChanger>(context).count
                  ? RoundedButton(
                      buttonText: 'Proceed',
                      buttonColor: kSecondaryColor,
                      press: () {
                        // navigate customer to payment screen
                        // with address id and the total amount
                        Route route = MaterialPageRoute(
                            builder: (c) => PaymentScreen(
                                  addressID: widget.addressID,
                                  totalAmount: widget.totalAmount,
                                ));
                        Navigator.push(context, route);
                      },
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
