import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Blocs/CommonBloc.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/StringConstants.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Elements/CommonTextFormField.dart';
import 'package:ngo_app/Models/CommonResponse.dart';

class PartnerRequestScreen extends StatefulWidget {
  @override
  _PartnerRequestScreenState createState() => _PartnerRequestScreenState();
}

class _PartnerRequestScreenState extends State<PartnerRequestScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name;
  String _email;
  String _company;
  String _phone;
  String _designation;
  String _countryCode = "+91";
  CommonBloc _commonBloc;

  @override
  void initState() {
    super.initState();
    _commonBloc = new CommonBloc();
  }

  @override
  Widget build(BuildContext context) {
    var _blankFocusNode = new FocusNode();
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // here the desired height
            child: CommonAppBar(
              text: "Partners",
              buttonHandler: _backPressFunction,
            ),
          ),
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
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 4,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ]),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  margin: EdgeInsets.fromLTRB(10, 15, 10, 15),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          alignment: FractionalOffset.center,
                          child: Image(
                            image: AssetImage('assets/images/ic_partners.png'),
                            height: MediaQuery.of(context).size.height * .30,
                            width: MediaQuery.of(context).size.width * .50,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          alignment: FractionalOffset.centerLeft,
                          child: Text(
                            "Lorem Ipsum",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.0,
                                height: 1.8),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          alignment: FractionalOffset.centerLeft,
                          child: Text(
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. ",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.0,
                                height: 1.8),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          alignment: FractionalOffset.centerLeft,
                          child: Text(
                            "Fill up the details",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.0,
                                height: 1.8),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Padding(
                          child: CommonTextFormField(
                              hintText: "Name",
                              maxLinesReceived: 1,
                              maxLengthReceived: 150,
                              textColorReceived: Color(colorCodeBlack),
                              fillColorReceived: Colors.black12,
                              hintColorReceived: Colors.black87,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              onChanged: (val) => _name = val,
                              validator: CommonMethods().nameValidator),
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Padding(
                          child: CommonTextFormField(
                              hintText: "Company",
                              maxLinesReceived: 1,
                              maxLengthReceived: 150,
                              textColorReceived: Color(colorCodeBlack),
                              fillColorReceived: Colors.black12,
                              hintColorReceived: Colors.black87,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              onChanged: (val) => _company = val,
                              validator: CommonMethods().requiredValidator),
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Padding(
                          child: CommonTextFormField(
                              hintText: "Designation",
                              maxLinesReceived: 1,
                              maxLengthReceived: 150,
                              textColorReceived: Color(colorCodeBlack),
                              fillColorReceived: Colors.black12,
                              hintColorReceived: Colors.black87,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              onChanged: (val) => _designation = val,
                              validator: CommonMethods().requiredValidator),
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Padding(
                          child: CommonTextFormField(
                              hintText: "Email",
                              maxLinesReceived: 1,
                              maxLengthReceived: 150,
                              isEmail: true,
                              textColorReceived: Color(colorCodeBlack),
                              fillColorReceived: Colors.black12,
                              hintColorReceived: Colors.black87,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              onChanged: (val) => _email = val,
                              validator: CommonMethods().emailValidator),
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Padding(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                              dialogTextStyle: TextStyle(
                                  fontSize: 13.0, color: Colors.black),
                              searchStyle: TextStyle(
                                  fontSize: 13.0, color: Colors.black),
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
                              color: Colors.black12,
                            ),
                          ),
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Padding(
                          child: CommonTextFormField(
                              hintText: "Mobile",
                              maxLinesReceived: 1,
                              isDigitsOnly: true,
                              maxLengthReceived: 15,
                              textColorReceived: Color(colorCodeBlack),
                              fillColorReceived: Colors.black12,
                              hintColorReceived: Colors.black87,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              onChanged: (val) => _phone = val,
                              validator: CommonMethods().validateMobile),
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .03),
                        Container(
                          height: 50.0,
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: CommonButton(
                              buttonText: "Submit",
                              bgColorReceived: Color(colorCoderRedBg),
                              borderColorReceived: Color(colorCoderRedBg),
                              textColorReceived: Color(colorCodeWhite),
                              buttonHandler: _validateUser),
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

  _validateUser() {
    if (_formKey.currentState.validate()) {
      _submitFunction();
    } else {
      Fluttertoast.showToast(msg: StringConstants.formValidationMsg);
      return;
    }
  }

  void _submitFunction() {
    var bodyParams = {};
    bodyParams["name"] = _name.trim();
    bodyParams["email"] = _email.trim();
    bodyParams["company"] = _company.trim();
    bodyParams["designation"] = _designation.trim();
    bodyParams["phone_number"] = _countryCode + "-" + _phone.trim();

    CommonWidgets().showNetworkProcessingDialog();
    _commonBloc.addPartner(json.encode(bodyParams)).then((value) {
      Get.back();
      CommonResponse commonResponse = value;
      if (commonResponse.success) {
        Fluttertoast.showToast(msg: commonResponse.message);
        Get.back();
      } else {
        Fluttertoast.showToast(
            msg: commonResponse.message ?? StringConstants.apiFailureMsg);
      }
    }).catchError((err) {
      Get.back();
      CommonWidgets().showNetworkErrorDialog(err?.toString());
    });
  }

  void _backPressFunction() {
    print("_sendOtpFunction clicked");
    Get.back();
  }

  Future<bool> onWillPop() {
    return Future.value(true);
  }
}
