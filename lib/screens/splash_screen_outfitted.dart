import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/navigation/bottom_nav_bar.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

class SplashScreenOutFitted extends StatelessWidget {
  const SplashScreenOutFitted({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset(
        'assets/images/logo.png',
      ),
      splashIconSize: 300,
      backgroundColor: kSplashColor,
      splashTransition: SplashTransition.fadeTransition,
      duration: 2000,
      nextScreen: BottomNavBar(),
    );
  }
}
