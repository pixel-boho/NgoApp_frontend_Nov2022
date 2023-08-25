import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Blocs/AuthorisationBloc.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/StringConstants.dart';
import 'package:ngo_app/CustomLibraries/pin_code_fields.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Models/LoginResponse.dart';
import 'package:ngo_app/Models/OtpResponse.dart';
import 'package:ngo_app/Notification/OneSignalNotifications.dart';
import 'package:ngo_app/Screens/Dashboard/Home.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';
import 'package:ngo_app/Utilities/PreferenceUtils.dart';

class OtpScreen extends StatefulWidget {
  OtpResponse otpResponse;

  OtpScreen(this.otpResponse);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String currentText = "";
  bool hasError = false;
  AuthorisationBloc authorisationBloc;
  TextEditingController pinController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    authorisationBloc = new AuthorisationBloc();
    pinController.text = "${widget.otpResponse?.userToken}";
    currentText = pinController.text;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          return Future.value(true);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Color(colorCodeGreyPageBg),
          body: SingleChildScrollView(
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  Container(
                    alignment: FractionalOffset.center,
                    child: Image(
                      image: AssetImage('assets/images/ic_otp.png'),
                      height: MediaQuery.of(context).size.height * .25,
                      width: MediaQuery.of(context).size.width * .35,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .04),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    alignment: FractionalOffset.centerLeft,
                    child: Text(
                      "Verify OTP",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    alignment: FractionalOffset.centerLeft,
                    child: Text(
                      "Enter the OTP received\n${widget.otpResponse.countryCode}-${widget.otpResponse.phone}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 16,
                          height: 1.8,
                          color: Color(colorCoderTextGrey),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .03),
                  Padding(
                    child: Container(
                      alignment: FractionalOffset.center,
                      child: PinCodeTextField(
                        maxLength: 4,
                        wrapAlignment: WrapAlignment.spaceBetween,
                        keyboardType: TextInputType.number,
                        pinTextAnimatedSwitcherTransition:
                            ProvidedPinBoxTextAnimation.scalingTransition,
                        pinBoxDecoration:
                            ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                        highlightAnimationBeginColor: Color(colorCoderGreyBg),
                        highlightAnimationEndColor: Color(colorCoderGreyBg),
                        hasTextBorderColor: Color(colorCoderBorderWhite),
                        pinBoxColor: Color(colorCoderGreyBg),
                        highlightPinBoxColor: Color(colorCoderGreyBg),
                        pinBoxBorderWidth: 1,
                        pinBoxHeight: 50,
                        pinBoxWidth: 50,
                        pinBoxOuterPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        pinBoxRadius: 10,
                        pinTextStyle: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                        pinTextAnimatedSwitcherDuration:
                            Duration(milliseconds: 300),
                        onTextChanged: (value) {
                          setState(() {
                            currentText = value;
                          });
                        },
                        controller: pinController,
                        onDone: (txt) => _verifyOtpFunction(),
                        defaultBorderColor: Color(colorCoderBorderWhite),
                        highlightColor: Color(colorCoderGreyBg),
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    // error showing widget
                    child: Text(
                      hasError ? "*Please fill up all the cells properly" : "",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Colors.red.shade300, fontSize: 12),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .01),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                        // error showing widget
                        child: Text("Didn't get any OTP  ",
                            textAlign: TextAlign.end,
                            style: new TextStyle(
                                fontSize: 12.0,
                                color: Color(colorCoderTextGrey),
                                fontWeight: FontWeight.w400)),
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
                        onPressed: () => _resendOtp(),
                        child: Text(
                          "Resend",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(colorCoderRedBg),
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .01),
                  Container(
                    height: 50.0,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: CommonButton(
                        buttonText: "Verify OTP",
                        bgColorReceived: Color(colorCoderRedBg),
                        borderColorReceived: Color(colorCoderRedBg),
                        textColorReceived: Color(colorCodeWhite),
                        buttonHandler: () {
                          if (currentText.length != 4) {
                            setState(() {
                              hasError = true;
                            });
                          } else {
                            setState(() {
                              hasError = false;
                            });

                            _verifyOtpFunction();
                          }
                        }),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .045),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _verifyOtpFunction() {
    var bodyParams = {};
    bodyParams["otp"] = currentText;
    bodyParams["api_token"] = widget.otpResponse.apiToken;
    CommonWidgets().showNetworkProcessingDialog();
    authorisationBloc.userLogin(json.encode(bodyParams)).then((value) {
      Get.back();
      LoginResponse loginResponse = value;
      if (loginResponse.success) {
        LoginModel().authToken = loginResponse.apiToken;
        LoginModel().userDetails = loginResponse.userDetails;
        PreferenceUtils.setStringToSF(
            PreferenceUtils.prefAuthToken, loginResponse.apiToken);
        PreferenceUtils.setBoolToSF(PreferenceUtils.prefIsLoggedIn, true);
        PreferenceUtils.setObjectToSF(
            PreferenceUtils.prefUserDetails, loginResponse.userDetails);
        OneSignalNotifications().handleSendTags();
        Get.offAll(() => DashboardScreen(
              fragmentToShow: 0,
            ));
      } else {
        Fluttertoast.showToast(
            msg: loginResponse.message ?? StringConstants.apiFailureMsg);
      }
    }).catchError((err) {
      Get.back();
      CommonWidgets().showNetworkErrorDialog(err?.toString());
    });
  }

  void _resendOtp() {
    pinController.text = "";
    currentText = "";
    var bodyParams = {};
    bodyParams["phone_number"] = widget.otpResponse.phone;
    bodyParams["country_code"] = widget.otpResponse.countryCode;
    CommonWidgets().showNetworkProcessingDialog();
    authorisationBloc.sendOtp(json.encode(bodyParams)).then((value) {
      Get.back();
      OtpResponse otpResponse = value;
      if (otpResponse.success) {
        widget.otpResponse = otpResponse;
        Fluttertoast.showToast(msg: otpResponse.userToken);
        setState(() {
          pinController.text = "${otpResponse.userToken}";
          currentText = "${otpResponse.userToken}";
        });
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
