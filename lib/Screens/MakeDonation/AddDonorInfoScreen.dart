import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/StringConstants.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Elements/CommonTextFormField.dart';
import 'package:ngo_app/Screens/Lend/PaymentScreen.dart';

class AddDonorInfoScreen extends StatefulWidget {
  final PaymentInfo paymentInfo;

  const AddDonorInfoScreen({Key key, @required this.paymentInfo, String amount})
      : super(key: key);

  @override
  _AddDonorInfoScreenState createState() => _AddDonorInfoScreenState();
}

class _AddDonorInfoScreenState extends State<AddDonorInfoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _phone = '';
  String _name = '';
  String _email = '';
  String _address = '';
  String _countryCode = '+91';
  bool _isAnonymous = false;
  bool _is80gFormRequired = false;
  String _panCard;
  TextEditingController _panCardController = new TextEditingController();

  PaymentInfo paymentInfo;

  @override
  void initState() {
    super.initState();
    paymentInfo = widget.paymentInfo;
  }

  @override
  void dispose() {
    _panCardController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Color(colorCodeGreyPageBg),
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // here the desired height
            child: CommonAppBar(
              text: "Donate",
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
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
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
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          alignment: FractionalOffset.centerLeft,
                          child: Text(
                            "Donor Information",
                            style: TextStyle(
                                color: Color(colorCoderBorderWhite),
                                fontWeight: FontWeight.w600,
                                fontSize: 15.0),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                        Padding(
                          child: CommonTextFormField(
                              hintText: "Full Name",
                              maxLinesReceived: 1,
                              maxLengthReceived: 150,
                              textColorReceived: Color(colorCodeWhite),
                              fillColorReceived: Color(colorCoderGreyBg),
                              hintColorReceived: Colors.white30,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              onChanged: (val) => _name = val,
                              validator: CommonMethods().nameValidator),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        Visibility(
                          child: _buildCheckBoxSection(),
                          visible: CommonMethods().isAuthTokenExist(),
                        ),
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
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
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
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
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
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Padding(
                          child: CommonTextFormField(
                              hintText: "Address",
                              maxLinesReceived: 1,
                              maxLengthReceived: 150,
                              isEmail: true,
                              textColorReceived: Color(colorCodeWhite),
                              fillColorReceived: Color(colorCoderGreyBg),
                              hintColorReceived: Colors.white30,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              onChanged: (val) => _address = val,
                              validator:  CommonMethods().addressValidator),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        Visibility(
                          child: _build80gFormCheckBoxSection(),
                          visible: true,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .04),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 50.0,
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: CommonButton(
                buttonText: "Proceed to pay",
                bgColorReceived: Color(colorCoderRedBg),
                borderColorReceived: Color(colorCoderRedBg),
                textColorReceived: Color(colorCodeWhite),
                buttonHandler: _nextBtnClickFunction),
          ),
        ),
      ),
    );
  }

  void _backPressFunction() {
    print("_sendOtpFunction clicked");
    Get.back();
  }

  void _nextBtnClickFunction() {
    print("_clearBtnClickFunction clicked");
    if (_formKey.currentState.validate()) {
      paymentInfo.name = _name.trim();
      paymentInfo.email = _email.trim();
      paymentInfo.countryCode = _countryCode;
      paymentInfo.mobile = _phone.trim();
      paymentInfo.address = _address.trim();
      paymentInfo.isAnonymous =
      CommonMethods().isAuthTokenExist() ? _isAnonymous : true;
      if (_is80gFormRequired) {
        paymentInfo.form80G = Form80G(
            name: _name.trim(),
            pan: _panCard.trim(),
            address: _address.trim(),
            countryCode: _countryCode,
            mobile: _phone.trim());
      }

      Get.to(
              () => PaymentScreen(
            paymentInfo: paymentInfo,
          ),
          opaque: false,
          fullscreenDialog: true);
    } else {
      Fluttertoast.showToast(msg: StringConstants.formValidationMsg);
      return;
    }
  }

  Future<bool> onWillPop() {
    CommonWidgets().showDonationAlertDialog();
    return Future.value(false);
  }

  _buildCheckBoxSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * .01),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                activeColor: Colors.red,
                value: _isAnonymous,
                onChanged: (val) {
                  _setRememberMe();
                },
              ),
            ),
            Text(
              "Make My Donation Anonymous",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 12.0,
                  color: Color(colorCodeWhite),
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .01),
      ],
    );
  }

  _build80gFormCheckBoxSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * .01),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                activeColor: Colors.red,
                value: _is80gFormRequired,
                onChanged: (val) {
                  _panCardController.text = "";
                  _check80gFormRequirement();
                },
              ),
            ),
            Text(
              "Do you need 80G Form",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 12.0,
                  color: Color(colorCodeWhite),
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .01),
        Visibility(
          child: Padding(
            child: CommonTextFormField(
                hintText: "PAN Card number",
                maxLinesReceived: 1,
                maxLengthReceived: 10,
                controller: _panCardController,
                textColorReceived: Color(colorCodeWhite),
                fillColorReceived: Color(colorCoderGreyBg),
                hintColorReceived: Colors.white30,
                isFullCapsNeeded: true,
                borderColorReceived: Color(colorCoderBorderWhite),
                onChanged: (val) => _panCard = val,
                validator: _is80gFormRequired
                    ? CommonMethods().isValidPanCardNo
                    : null),
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          ),
          visible: _is80gFormRequired,
        )
      ],
    );
  }

  void _setRememberMe() {
    if (_isAnonymous == false) {
      setState(() {
        _isAnonymous = true;
      });
    } else if (_isAnonymous == true) {
      setState(() {
        _isAnonymous = false;
      });
    }
  }

  void _check80gFormRequirement() {
    if (_is80gFormRequired == false) {
      setState(() {
        _is80gFormRequired = true;
      });
    } else if (_is80gFormRequired == true) {
      setState(() {
        _is80gFormRequired = false;
      });
    }
  }
}