import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/counters/cart_item_counter.dart';
import 'package:outfitted_flutter_mobile/firebase/firebase_config.dart';
import 'package:outfitted_flutter_mobile/screens/shopping_cart_screen.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';
import 'package:provider/provider.dart';

AppBar buildOutFittedCustomAppBar({
  String title,
  String underTitle = "",
  Icon customIcon,
  BuildContext context,
}) {
  return AppBar(
    elevation: 0.1,
    backgroundColor: kBackgroundOutFitted,
    leading: GestureDetector(
      onTap: () {
        //Navigate to search screen
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: Colors.black26,
            shape: BoxShape.circle,
          ),
          child: customIcon,
        ),
      ),
    ),
    title: underTitle.isEmpty
        ? Text(
            title,
            style: TextStyle(
              fontFamily: "Muli",
            ),
          )
        : Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 7),
              Text(
                underTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              )
            ],
          ),
    centerTitle: true,
    actions: [
      Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ShoppingCartScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                  ),
                ),
              ),
              OutFittedApp.auth.currentUser != null
                  ? Positioned(
                      right: 0,
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: kSecondaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 1.5,
                            color: Colors.white,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // replace text with consumer to keep up the counter
                            /*
                            ════════ Exception caught by widgets library ═══════════════════════════════════════════════════════
                            The getter 'length' was called on null.
                            Receiver: null
                            Tried calling: length
                            The relevant error-causing widget was:
                              Consumer<CartItemCounter> /lib/components/outfitted_custom_appbar.dart:94:23
                            ════════════════════════════════════════════════════════════════════════════════════════════════════
                      */
                            Consumer<CartItemCounter>(
                              builder: (context, counter, _) {
                                return Text(
                                  (OutFittedApp.sharedPreferences
                                              .getStringList(
                                                  OutFittedApp.customerCartList)
                                              .length -
                                          1)
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 8,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    ],
  );
}
