import 'package:flutter/material.dart';
import 'package:outfitted_flutter_mobile/components/outfitted_custom_appbar_v2.dart';
import 'package:outfitted_flutter_mobile/components/rounded_button.dart';
import 'package:outfitted_flutter_mobile/firebase/firebase_config.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OutFittedCustomAppBarV2(
        title: 'Settings',
        customIcon: Icon(Icons.arrow_back),
        appBar: AppBar(),
        onLeftIconPress: (){
          Navigator.pop(context);
        },
      ),
      backgroundColor: kBackgroundOutFitted,
      body: Center(
        child: RoundedButton(
          buttonText: 'LOGOUT',
          buttonColor: kPrimaryColor,
          press: () async {
            OutFittedApp.auth.signOut().then((c) {
                Navigator.pushNamedAndRemoveUntil(context, '/home', ModalRoute.withName('/settings'));
            });
          },
        ),
      ),
    );
  }
}
