import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:outfitted_flutter_mobile/components/outfitted_custom_appbar_v2.dart';
import 'package:outfitted_flutter_mobile/components/rounded_button.dart';
import 'package:outfitted_flutter_mobile/components/textfield_container.dart';
import 'package:outfitted_flutter_mobile/dialog/error_alert_dialog.dart';
import 'package:outfitted_flutter_mobile/firebase/firebase_config.dart';
import 'package:outfitted_flutter_mobile/navigation/bottom_nav_bar.dart';
import 'package:outfitted_flutter_mobile/screens/forgot_password_screen.dart';
import 'package:outfitted_flutter_mobile/style/style.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isPasswordInvisible = true;

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    Future readData(User fUser) async {
      OutFittedApp.firestore
          .collection("customers")
          .doc(fUser.uid)
          .get()
          .then((dataSnapshot) async {
        await OutFittedApp.sharedPreferences.setString("uid", dataSnapshot.data()[OutFittedApp.customerUID]);
        await OutFittedApp.sharedPreferences.setString(OutFittedApp.customerEmail, dataSnapshot.data()[OutFittedApp.customerEmail]);
        await OutFittedApp.sharedPreferences.setString(OutFittedApp.customerName, dataSnapshot.data()[OutFittedApp.customerName]);

        List<String> cartList = dataSnapshot.data()[OutFittedApp.customerCartList].cast<String>(),
            wishList = dataSnapshot.data()[OutFittedApp.customerWishList].cast<String>();
        // todo: remove this print() after error (login/register) is fixed
        print("LISTTT " + cartList.length.toString());
        print("LISTTT2 " + wishList.length.toString());

        await OutFittedApp.sharedPreferences.setStringList(OutFittedApp.customerCartList, cartList);
        await OutFittedApp.sharedPreferences.setStringList(OutFittedApp.customerWishList, wishList);
      });
    }

    FirebaseAuth _auth = FirebaseAuth.instance;
    void signInCustomer() async {
      // first check if both textfields are filled. Stop method and show alert if that isn't the case.
      if(email.text.isEmpty || password.text.isEmpty){
        showDialog(
            context: context,
            builder: (c) {
              return ErrorAlertDialog(
                message: "Please, fill all the fields...",
              );
            }
        );
        return;
      }
      // else (if both textfields are filled) continue below
      showDialog(
          context: context,
          builder: (c) {
            return Center(
                child: SpinKitDualRing(
                  color: kSecondaryColor,
                  size: 50,
                )
            );
          });

      User firebaseUser;
      await _auth.signInWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim()
      ).then((authUser){
        firebaseUser = authUser.user;
      }).catchError((error){
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (c) {
              return ErrorAlertDialog(
                message: error.toString(),
              );
            });
      });

      if(firebaseUser != null){
          MaterialPageRoute route;
          readData(firebaseUser).then((s) => {
            Navigator.pop(context),
            route = MaterialPageRoute(builder: (c) => BottomNavBar()),
            Navigator.pushNamedAndRemoveUntil(context, '/home', ModalRoute.withName('/login'))
          });
      }
    }

    return Scaffold(
      appBar: OutFittedCustomAppBarV2(
        title: 'Login',
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
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Image.asset(
                  'assets/images/lady_on_couch.png',
                  width: 200,
                ),
              ),
              TextFieldContainer(
                backgroundColor: kPrimaryColor.withOpacity(0.6),
                child: TextFormField(
                  controller: email,
                  textInputAction: TextInputAction.next,     // Set 'next' button in keyboard
                  onEditingComplete: () => node.nextFocus(), // Focus next textfield when pressing 'next'
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
              TextFieldContainer(
                backgroundColor: kPrimaryColor.withOpacity(0.6),
                child: TextFormField(
                  controller: password,
                  autocorrect: false,
                  enableSuggestions: false,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,     // Set 'done' button in keyboard
                  onEditingComplete: () => signInCustomer(), // Invoke method when pressing 'done' button
                  obscureText: isPasswordInvisible,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.lock,
                      color: kWhiteColor.withOpacity(0.8),
                    ),
                    suffixIcon: IconButton(
                      icon: new Icon(
                          (isPasswordInvisible ? Icons.visibility
                                               : Icons.visibility_off),
                          color: kWhiteColor.withOpacity(0.8)
                      ),
                      onPressed: (){
                        /*If isInvisible is true, then set false. Else set true.*/
                        setState(() {
                          isPasswordInvisible = isPasswordInvisible ? false : true;
                        });
                      },
                    ),
                    hintText: 'Your Password',
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
                buttonText: 'LOGIN',
                press: () {
                  signInCustomer();
                },
              ),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                  onPressed: (){
                    Route route = MaterialPageRoute(builder: (c) => ForgotPasswordScreen());
                    Navigator.push(context, route);
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: kWhiteColor.withOpacity(0.5),
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
