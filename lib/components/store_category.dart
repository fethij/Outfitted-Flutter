import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/model/CollectionCategory.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

class StoreCategory extends StatelessWidget {
  const StoreCategory({
    Key key,
    this.collectionCategory,
    this.press,
  }) : super(key: key);
  final CollectionCategory collectionCategory;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: Platform.isIOS ? 251 : 280,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Flex(
                    direction: Axis.vertical,
                    children: [
                      Image.network(
                        collectionCategory.categoryImage,
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          kDarkGradient.withOpacity(0.6),
                          kDarkGradient.withOpacity(0.4),
                          kDarkGradient.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text: collectionCategory.categoryName,
                              style: TextStyle(
                                fontSize: 28,
                                fontFamily: "Muli",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
