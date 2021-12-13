import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:outfitted_flutter_mobile/components/outfitted_custom_appbar_v2.dart';
import 'package:outfitted_flutter_mobile/components/rounded_button.dart';
import 'package:outfitted_flutter_mobile/components/textfield_container.dart';
import 'package:outfitted_flutter_mobile/dialog/error_alert_dialog.dart';
import 'package:outfitted_flutter_mobile/firebase/firebase_config.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

class ForgotPasswordScreen extends StatelessWidget{

  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {

    void sendResetPasswordEmailLink() async {
      if(email.text.isNotEmpty){
        OutFittedApp.auth.sendPasswordResetEmail(
            email: email.text.trim()
        ).then((value){
          Fluttertoast.showToast(
            msg: "We've sent you an email with a reset link",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: kSuccessColor,
            fontSize: 15,
          );
          Navigator.pop(context);
        }).catchError((error){
          showDialog(
              context: context,
              builder: (c) {
                return ErrorAlertDialog(
                  message: error.toString(),
                );
              });
        });
      }else{
        showDialog(
            context: context,
            builder: (c) {
              return ErrorAlertDialog(
                message: "Please, fill in your Email...",
              );
            }
        );
      }
    }


    return Scaffold(
      appBar: OutFittedCustomAppBarV2(
        title: 'Forgot Password',
        customIcon: Icon(Icons.arrow_back),
        appBar: AppBar(),
        onLeftIconPress: (){
          Navigator.pop(context);
        },
      ),
      backgroundColor: kBackgroundOutFitted,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Fill in your email and we will send you a \nlink to reset password.',
                textAlign: TextAlign.center,
              ),
              TextFieldContainer(
                backgroundColor: kPrimaryColor.withOpacity(0.6),
                child: TextFormField(
                  controller: email,
                  textInputAction: TextInputAction.next,     // Set 'next' button in keyboard
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.alternate_email,
                      color: kWhiteColor.withOpacity(0.8),
                    ),
                    hintText: 'Your Email',
                    hintStyle: TextStyle(
                      color: kWhiteColor.withOpacity(0.8),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RoundedButton(
                buttonColor: kPrimaryColor,
                buttonText: 'SEND EMAIL',
                press: () {
                  // send reset password to the given email
                  sendResetPasswordEmailLink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }



}
