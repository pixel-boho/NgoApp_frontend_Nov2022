import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/StringConstants.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Elements/CommonTextFormField.dart';
import 'package:ngo_app/Screens/Lend/PaymentScreen.dart';

class AdditionalInfoScreen extends StatefulWidget {
  final PaymentInfo paymentInfo;

  const AdditionalInfoScreen({Key key, this.paymentInfo}) : super(key: key);

  @override
  _AdditionalInfoScreenState createState() => _AdditionalInfoScreenState();
}

class _AdditionalInfoScreenState extends State<AdditionalInfoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _phone;
  String _name;
  String _panCard;
  String _countryCode = '+91';

  PaymentInfo paymentInfo;

  @override
  void initState() {
    super.initState();
    paymentInfo = widget.paymentInfo;

//     _phone = paymentInfo.mobile;
//     _name=paymentInfo.name;
// _countryCode = paymentInfo.countryCode;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _blankFocusNode = new FocusNode();
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Color(colorCodeGreyPageBg),
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(65.0), // here the desired height
            child: Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            "80G Form",
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                height: 1.5,
                                fontWeight: FontWeight.w600,
                                fontSize: 17.0),
                          ),
                          flex: 1,
                        ),
                        IconButton(
                          iconSize: 26,
                          icon: Icon(
                            Icons.close,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ],
                    ),
                    flex: 1,
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.5,
                    color: Colors.white,
                    margin: EdgeInsets.fromLTRB(15, 2, 15, 4),
                  )
                ],
              ),
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
                            "PAN Card Details",
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
                              hintText: "PAN Card number",
                              maxLinesReceived: 1,
                              maxLengthReceived: 10,
                              textColorReceived: Color(colorCodeWhite),
                              fillColorReceived: Color(colorCoderGreyBg),
                              hintColorReceived: Colors.white30,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              isFullCapsNeeded: true,
                              onChanged: (val) => _panCard = val,
                              validator: CommonMethods().isValidPanCardNo),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
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
                buttonText: "Submit",
                bgColorReceived: Color(colorCoderRedBg),
                borderColorReceived: Color(colorCoderRedBg),
                textColorReceived: Color(colorCodeWhite),
                buttonHandler: _nextBtnClickFunction),
          ),
        ),
      ),
    );
  }

  Future<void> _nextBtnClickFunction() async {
    print("_clearBtnClickFunction clicked");
    if (_formKey.currentState.validate()) {
      paymentInfo.form80G = Form80G(
          name: _name.trim(),
          pan: _panCard.trim(),
          countryCode: _countryCode,
          mobile: _phone.trim());

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
    return Future.value(true);
  }
}
