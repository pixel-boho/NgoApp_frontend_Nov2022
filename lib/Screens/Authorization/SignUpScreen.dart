import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ngo_app/Blocs/AuthorisationBloc.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/StringConstants.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Elements/CommonTextFormField.dart';
import 'package:ngo_app/Models/CommonResponse.dart';
import 'package:ngo_app/Screens/Authorization/LoginScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime currentBackPressTime;
  AuthorisationBloc authorisationBloc;

  String _phone;
  String _name;
  String _email;
  String _countryCode = "+91";
  var customDateFormatToShow = DateFormat('dd MMM yyyy');
  var customDateFormatToPass = DateFormat('yyyy-MM-dd');
  DateTime selectedDate;
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
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                        Container(
                          alignment: FractionalOffset.center,
                          child: Image(
                            image: AssetImage('assets/images/ic_sign_up.png'),
                            height: MediaQuery.of(context).size.height * .20,
                            width: MediaQuery.of(context).size.width * .35,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          alignment: FractionalOffset.centerLeft,
                          child: Text(
                            "Sign Up",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          alignment: FractionalOffset.centerLeft,
                          child: Text(
                            "Please fill the follwing fields",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(colorCoderTextGrey),
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                        Padding(
                          child: CommonTextFormField(
                              hintText: "Name",
                              maxLinesReceived: 1,
                              maxLengthReceived: 150,
                              textColorReceived: Color(colorCodeWhite),
                              fillColorReceived: Color(colorCoderGreyBg),
                              hintColorReceived: Colors.white30,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              onChanged: (val) => _name = val,
                              validator: CommonMethods().nameValidator),
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                        Padding(
                          child: CommonTextFormField(
                              hintText: "Email",
                              maxLinesReceived: 1,
                              maxLengthReceived: 150,
                              isEmail: true,
                              textColorReceived: Color(colorCodeWhite),
                              fillColorReceived: Color(colorCoderGreyBg),
                              hintColorReceived: Colors.white30,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              onChanged: (val) => _email = val,
                              validator: CommonMethods().emailValidator),
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                        Padding(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            width: double.infinity,
                            height: 50,
                            alignment: FractionalOffset.centerLeft,
                            child: SizedBox.expand(
                              child: CountryCodePicker(
                                onChanged: (e) {
                                  _countryCode = e.dialCode;
                                  print(e.dialCode);
                                },
                                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                initialSelection: '+91',
                                favorite: ['+91', 'INDIA'],
                                // optional. Shows only country name and flag
                                showCountryOnly: false,
                                // optional. Shows only country name and flag when popup is closed.
                                showOnlyCountryWhenClosed: false,
                                // optional. aligns the flag and the Text left
                                alignLeft: true,
                                showFlagDialog: true,
                                showFlagMain: true,
                                flagWidth: 25,
                                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                                textStyle: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                                dialogTextStyle: TextStyle(
                                    fontSize: 13.0, color: Colors.black),
                                searchStyle: TextStyle(
                                    fontSize: 13.0, color: Colors.black),
                              ),
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
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                        Padding(
                          child: CommonTextFormField(
                              hintText: "Mobile",
                              maxLinesReceived: 1,
                              isDigitsOnly: true,
                              maxLengthReceived: 15,
                              textColorReceived: Color(colorCodeWhite),
                              fillColorReceived: Color(colorCoderGreyBg),
                              hintColorReceived: Colors.white30,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              onChanged: (val) => _phone = val,
                              validator: CommonMethods().validateMobile),
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                        _buildDateSection(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        _buildTermsAndCondition(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Container(
                          height: 50.0,
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: CommonButton(
                              buttonText: "Sign Up",
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
                              buttonText: " Log In ",
                              bgColorReceived: Colors.transparent,
                              borderColorReceived: Color(colorCodeWhite),
                              textColorReceived: Color(colorCodeWhite),
                              buttonHandler: _loginFunction),
                        ),
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
      ),
    );
  }

  _buildDateSection() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        maxWidth: double.infinity,
        minHeight: 50,
      ),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: BoxDecoration(
            color: Color(colorCoderGreyBg),
            border: Border.all(color: Color(colorCoderBorderWhite), width: 1.0),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        child: InkWell(
          child: Container(
            alignment: FractionalOffset.centerLeft,
            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? customDateFormatToShow.format(selectedDate)
                        : "Select Date of birth",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: selectedDate != null
                            ? Colors.white
                            : Colors.white30,
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Image(
                  image: AssetImage('assets/images/ic_date.png'),
                  height: 20,
                  width: 20,
                ),
              ],
            ),
          ),
          onTap: () {
            setDateOfBirth();
          },
        ),
      ),
    );
  }

  void setDateOfBirth() async {
    DateTime picked = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  _validateUser() {
    if (_formKey.currentState.validate()) {
      if (selectedDate != null) {
        FocusScope.of(context).requestFocus(FocusNode());
        if (_isTermsAndConditionsAgreed) {
          _signUpFunction();
        } else {
          Fluttertoast.showToast(
              msg: "You need to agree our terms and conditions to continue!");
          return;
        }
      } else {
        Fluttertoast.showToast(msg: "Date of birth is mandatory");
        return;
      }
    } else {
      Fluttertoast.showToast(msg: StringConstants.formValidationMsg);
      return;
    }
  }

  void _signUpFunction() {
    var bodyParams = {};
    bodyParams["name"] = _name.trim();
    bodyParams["email"] = _email.trim();
    bodyParams["phone_number"] = _phone.trim();
    bodyParams["country_code"] = _countryCode.trim();
    bodyParams["date_of_birth"] = customDateFormatToPass.format(selectedDate);

    CommonWidgets().showNetworkProcessingDialog();
    authorisationBloc.userRegistration(json.encode(bodyParams)).then((value) {
      Get.back();
      CommonResponse commonResponse = value;
      if (commonResponse.success) {
        Fluttertoast.showToast(
            msg: commonResponse.message ??
                "Registration successful, pls login to continue");
        Get.offAll(() => LoginScreen());
      } else {
        Fluttertoast.showToast(
            msg: commonResponse.message ?? StringConstants.apiFailureMsg);
      }
    }).catchError((err) {
      Get.back();
      CommonWidgets().showNetworkErrorDialog(err?.toString());
    });
  }

  void _loginFunction() {
    print("_signUpFunction clicked");
    Get.offAll(() => LoginScreen());
  }

  _buildTermsAndCondition() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              activeColor: Colors.red,
              value: _isTermsAndConditionsAgreed,
              onChanged: (val) {
                setState(() {
                  _isTermsAndConditionsAgreed = val;
                });
              },
            ),
          ),
          Expanded(
            child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(children: [
                  TextSpan(
                    text:
                        "To continue, you need to agree our terms and conditions!  ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                      text: "Click here to read",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          var url = "";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }),
                ])),
            flex: 1,
          )
        ],
      ),
    );
  }
}
