import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({
    Key key,
    this.paymentImage,
    this.paymentMethodName,
    this.paymentDetails,
    this.onPaymentPressed,
  }) : super(key: key);

  final Image paymentImage;
  final String paymentMethodName, paymentDetails;
  final Function onPaymentPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPaymentPressed,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Container(
          height: 100,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                paymentMethodName,
                style: TextStyle(color: kWhiteColor, fontSize: 18),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  paymentImage,
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    paymentDetails,
                    style: TextStyle(
                      color: kWhiteColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
