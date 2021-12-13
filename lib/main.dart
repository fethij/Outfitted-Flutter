import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/counters/address_changer.dart';
import 'package:outfitted_flutter_mobile/counters/cart_item_counter.dart';
import 'package:outfitted_flutter_mobile/counters/item_quantity.dart';
import 'package:outfitted_flutter_mobile/counters/total_amount.dart';
import 'package:outfitted_flutter_mobile/navigation/bottom_nav_bar.dart';
import 'package:outfitted_flutter_mobile/screens/account_screen.dart';
import 'package:outfitted_flutter_mobile/screens/login_screen.dart';
import 'package:outfitted_flutter_mobile/screens/payment_screen.dart';
import 'package:outfitted_flutter_mobile/screens/register_screen.dart';
import 'package:outfitted_flutter_mobile/screens/settings_screen.dart';
import 'package:outfitted_flutter_mobile/screens/splash_screen_outfitted.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase/firebase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  OutFittedApp.auth = FirebaseAuth.instance;
  OutFittedApp.firestore = FirebaseFirestore.instance;
  OutFittedApp.sharedPreferences = await SharedPreferences.getInstance();

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartItemCounter>(
            create: (c) => CartItemCounter()),
        ChangeNotifierProvider<ItemQuantity>(create: (c) => ItemQuantity()),
        ChangeNotifierProvider<AddressChanger>(create: (c) => AddressChanger()),
        ChangeNotifierProvider<TotalAmount>(create: (c) => TotalAmount()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'OutFitted',
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreenOutFitted(),
          '/home': (context) => BottomNavBar(),
          '/account': (context) => AccountScreen(),
          '/settings': (context) => SettingsScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/payment': (context) => PaymentScreen(),
        },
        theme: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: kWhiteColor.withOpacity(0.5),
                fontFamily: "Muli",
              ),
          canvasColor: Colors.transparent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}
