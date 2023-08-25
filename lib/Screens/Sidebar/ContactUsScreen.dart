import 'dart:convert';
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
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // String number = "7560911122";
  String number = "9946031111";
  String mail = "info@crowdworksindia.org";
  String _comment;
  String _name;
  String _email;
  var pickedDate;
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
              text: "Contact Us",
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
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                        _buildCompanyEmailDetails(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                        _buildCompanyPhoneDetails(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                        _buildCompanyAddressDetails(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 195, 10),
                          child: Column(mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Fill up the form",style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
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
                          child: CommonTextFormField(
                              hintText: "Comments",
                              maxLinesReceived: 8,
                              minLinesReceived: 3,
                              maxLengthReceived: 600,
                              textColorReceived: Color(colorCodeBlack),
                              fillColorReceived: Colors.black12,
                              hintColorReceived: Colors.black87,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              onChanged: (val) => _comment = val,
                              validator: CommonMethods().requiredValidator),
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
                        SizedBox(height: MediaQuery.of(context).size.height * .02),
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

  void _backPressFunction() {
    print("_sendOtpFunction clicked");
    Get.back();
  }

  Future<bool> onWillPop() {
    return Future.value(true);
  }

  _buildCompanyEmailDetails() {
    return Container(
      alignment: FractionalOffset.center,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      decoration: BoxDecoration(
          color: Color(colorCodeGreyPageBg),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage("assets/images/ic_red_email.png"),
                  height: 30.0,
                  width: 40.0,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    alignment: FractionalOffset.centerLeft,
                    child: InkWell(
                      onTap: () => launch("mailto:$mail"),
                      child: Text(
                        mail,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.0),
                      ),
                    ),
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildCompanyPhoneDetails() {
    return Container(
      alignment: FractionalOffset.center,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      decoration: BoxDecoration(
          color: Color(colorCodeGreyPageBg),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage("assets/images/ic_red_phone.png"),
                  height: 30.0,
                  width: 40.0,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    alignment: FractionalOffset.centerLeft,
                    child: InkWell(
                      onTap: () => launch("tel:+91 $number"),
                      child: Text(
                        number,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.0),
                      ),
                    ),
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildCompanyAddressDetails() {
    return Container(
      alignment: FractionalOffset.center,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      decoration: BoxDecoration(
          color: Color(colorCodeGreyPageBg),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage("assets/images/ic_red_location.png"),
                  height: 30.0,
                  width: 40.0,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    alignment: FractionalOffset.centerLeft,
                    child: Text(
                      "CROWD WORKS INDIA FOUNDATION,ALAMPARAMBIL BUILDING, 13/1013-5,2ND FLOOR, TK ROAD, THIRUVALLA,KERALA, 689101.TOLL FREE: 1800 890 1811TIME: MON - FRI (9:00 - 19:00)",
                      // "330 Bay street, 6th floor, Red cross, United kingdom",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 11.5),
                    ),
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitFunction() {
    var bodyParams = {};
    bodyParams["name"] = _name.trim();
    bodyParams["email"] = _email.trim();
    bodyParams["message"] = _comment.trim();

    CommonWidgets().showNetworkProcessingDialog();
    _commonBloc.postContactUs(json.encode(bodyParams)).then((value) {
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

  launchDialer(String number) async {
    String url = 'tel:' + number;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Application unable to open dialer.';
    }
  }
}


// class CallsAndMessagesService {
//   void call(String number) => launch("tel:$number");
//   void sendSms(String number) => launch("sms:$number");
//   void sendEmail(String email) => launch("mailto:$email");
// }
