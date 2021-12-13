import 'package:flutter/material.dart';

import 'brand_logo.dart';

class BrandPartnerships extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            BrandLogo(
              brandName: 'Nike',
              image: 'assets/icons/nike.png',
            ),
            BrandLogo(
              brandName: 'Adidas',
              image: 'assets/icons/adidas.png',
            ),
            BrandLogo(
              brandName: 'Jordans',
              image: 'assets/icons/jordans.png',
            ),
          ],
        ),
        Row(
          children: [
            BrandLogo(
              brandName: 'OutFitted',
              image: 'assets/icons/outFitted_logo_icon.png',
            ),
            BrandLogo(
              brandName: 'New Balance',
              image: 'assets/icons/new_balance.png',
            ),
            BrandLogo(
              brandName: 'Armani',
              image: 'assets/icons/armani.png',
            ),
          ],
        ),
        Row(
          children: [
            BrandLogo(
              brandName: 'Emporio',
              image: 'assets/icons/emporio.png',
            ),
            BrandLogo(
              brandName: 'Puma',
              image: 'assets/icons/puma.png',
            ),
            BrandLogo(
              brandName: 'Gucci',
              image: 'assets/icons/gucci.png',
            ),
          ],
        ),
      ],
    );
  }
}
