import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Screens/Authorization/LoginScreen.dart';

import '../Constants/CustomColorCodes.dart';
import '../Constants/StringConstants.dart';
import '../Utilities/LoginModel.dart';
import 'Authorization/SignUpScreen.dart';
import 'Dashboard/Home.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  DateTime currentBackPressTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          Fluttertoast.showToast(msg: StringConstants.doubleBackExit);
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Color(colorCodeGreyPageBg),
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/ic_splash_bg.png'),
                  fit: BoxFit.fill)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(),
                flex: 1,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                alignment: FractionalOffset.centerLeft,
                child: Text(
                  "Make The \nWorld Better",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 38,
                      color: Colors.white,
                      fontFamily: 'roboto',
                      fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(
                height: 85,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 55.0,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: CommonButton(
                        buttonText: " Log In ",
                        bgColorReceived: Color(colorCoderRedBg),
                        borderColorReceived: Color(colorCoderRedBg),
                        textColorReceived: Color(colorCodeWhite),
                        buttonHandler: _loginFunction),
                  ),
                  Container(
                    height: 55.0,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: CommonButton(
                        buttonText: "Sign Up",
                        bgColorReceived: Colors.transparent,
                        borderColorReceived: Color(colorCodeWhite),
                        textColorReceived: Color(colorCodeWhite),
                        buttonHandler: _signUpFunction),
                  )
                ],
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  primary: Colors.transparent,
                  elevation: 0.0,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  side: BorderSide(
                    width: 2.0,
                    color: Colors.transparent,
                  ),
                ),
                onPressed: () {
                  Get.offAll(() => DashboardScreen(
                        fragmentToShow: 0,
                      ));
                },
                child: Text(
                  "Skip",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(colorCodeWhite),
                      fontSize: 16,
                      fontFamily: 'roboto',
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  void _signUpFunction() {
    print("_sendOtpFunction clicked");
    Get.offAll(() => SignUpScreen());
  }

  void _loginFunction() {
    print("_loginFunction clicked");
    Get.offAll(() => LoginScreen());
  }
}
