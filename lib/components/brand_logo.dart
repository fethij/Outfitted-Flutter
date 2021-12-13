import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/screens/collection_category_screen.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

class BrandLogo extends StatelessWidget {
  final String image, brandName;

  const BrandLogo({Key key, this.image, this.brandName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Route route = MaterialPageRoute(
          builder: (c) => CollectionCategoryScreen(
            categoryName: brandName,
            brandName: brandName,
          ),
        );
        Navigator.push(context, route);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.31,
        height: MediaQuery.of(context).size.width * 0.31,
        decoration: BoxDecoration(
            color: kWhiteColor,
            border: Border(
              top: BorderSide(width: 1, color: Colors.black.withOpacity(0.03)),
              right:
                  BorderSide(width: 1, color: Colors.black.withOpacity(0.03)),
            )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                width: 30,
              ),
              Text(
                brandName,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
