import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Blocs/AuthorisationBloc.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/StringConstants.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Elements/CommonTextFormField.dart';
import 'package:ngo_app/Models/OtpResponse.dart';
import 'package:ngo_app/Screens/Authorization/OtpScreen.dart';
import 'package:ngo_app/Screens/Dashboard/Home.dart';

import 'SignUpScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime currentBackPressTime;
  String _countryCode = "+91";
  String _phone;
  AuthorisationBloc authorisationBloc;
  bool _isTermsAndConditionsAgreed = false;

  @override
  void initState() {
    super.initState();
    authorisationBloc = new AuthorisationBloc();
  }

  @override
  Widget build(BuildContext context) {
    var _blankFocusNode = new FocusNode();
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
          resizeToAvoidBottomInset: true,
          key: _scaffoldKey,
          backgroundColor: Color(colorCodeGreyPageBg),
          body: Container(
            color: Colors.transparent,
            height: double.infinity,
            width: double.infinity,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).requestFocus(_blankFocusNode);
              },
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .04),
                      Container(
                        alignment: FractionalOffset.center,
                        child: Image(
                          image: AssetImage('assets/images/ic_login_key.png'),
                          height: MediaQuery.of(context).size.height * .30,
                          width: MediaQuery.of(context).size.width * .45,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .03),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        alignment: FractionalOffset.centerLeft,
                        child: Text(
                          "Login",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontFamily: 'roboto',
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        alignment: FractionalOffset.centerLeft,
                        child: Text(
                          "Please Login with OTP",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(colorCoderTextGrey),
                              fontFamily: 'roboto',
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .03),
                      Padding(
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
                              child: CountryCodePicker(
                                onChanged: (e) {
                                  _countryCode = e.dialCode;
                                  print(e.dialCode);
                                },
                                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                initialSelection: 'IN',
                                favorite: ['+91', 'INDIA'],
                                // optional. Shows only country name and flag
                                showCountryOnly: false,
                                // optional. Shows only country name and flag when popup is closed.
                                showOnlyCountryWhenClosed: false,
                                // optional. aligns the flag and the Text left
                                alignLeft: false,
                                showFlagDialog: true,
                                showFlagMain: false,
                                flagWidth: 20,
                                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                                textStyle: TextStyle(
                                    fontSize: 12.0,
                                    height: 1.8,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                                dialogTextStyle: TextStyle(
                                    fontSize: 13.0,
                                    height: 1.8,
                                    color: Colors.black),
                                searchStyle: TextStyle(
                                    fontSize: 13.0,
                                    height: 1.8,
                                    color: Colors.black),
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                    color: Color(colorCoderBorderWhite),
                                    width: 1.0),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                color: Color(colorCoderGreyBg),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                child: CommonTextFormField(
                                    hintText: "Mobile",
                                    maxLinesReceived: 1,
                                    isDigitsOnly: true,
                                    maxLengthReceived: 15,
                                    textColorReceived: Color(colorCodeWhite),
                                    fillColorReceived: Color(colorCoderGreyBg),
                                    hintColorReceived: Colors.white30,
                                    borderColorReceived:
                                        Color(colorCoderBorderWhite),
                                    onChanged: (val) => _phone = val,
                                    validator: CommonMethods().validateMobile),
                                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .03),
                      Container(
                        height: 50.0,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: CommonButton(
                            buttonText: "Send OTP",
                            bgColorReceived: Color(colorCoderRedBg),
                            borderColorReceived: Color(colorCoderRedBg),
                            textColorReceived: Color(colorCodeWhite),
                            buttonHandler: _validateUser),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .03),
                      Container(
                        height: 50.0,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: CommonButton(
                            buttonText: "Sign Up",
                            bgColorReceived: Colors.transparent,
                            borderColorReceived: Color(colorCodeWhite),
                            textColorReceived: Color(colorCodeWhite),
                            buttonHandler: _signUpFunction),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .02),
                      CommonButton(
                          buttonText: "Skip",
                          bgColorReceived: Colors.transparent,
                          borderColorReceived: Colors.transparent,
                          textColorReceived: Color(colorCoderRedBg),
                          buttonHandler: () {
                            Get.offAll(() => DashboardScreen(
                                  fragmentToShow: 0,
                                ));
                          }),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .02),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _validateUser() {
    String validator = CommonMethods().validateMobile(_phone);
    if (validator != null) {
      Fluttertoast.showToast(msg: validator);
    } else {
      _sendOtpFunction();
    }
  }

  void _signUpFunction() {
    Get.offAll(() => SignUpScreen());
  }

  void _sendOtpFunction() {
    var bodyParams = {};
    bodyParams["phone_number"] = _phone.trim();
    bodyParams["country_code"] = _countryCode.trim();
    CommonWidgets().showNetworkProcessingDialog();
    authorisationBloc.sendOtp(json.encode(bodyParams)).then((value) {
      Get.back();
      OtpResponse otpResponse = value;
      if (otpResponse.success) {
        Fluttertoast.showToast(
            msg: otpResponse.message ??
                "Please verify the OTP send to your phone");
        Fluttertoast.showToast(msg: otpResponse.userToken);
        Get.to(() => OtpScreen(otpResponse));
      } else {
        Fluttertoast.showToast(
            msg: otpResponse.message ?? StringConstants.apiFailureMsg);
      }
    }).catchError((err) {
      Get.back();
      CommonWidgets().showNetworkErrorDialog(err?.toString());
    });
  }
}
