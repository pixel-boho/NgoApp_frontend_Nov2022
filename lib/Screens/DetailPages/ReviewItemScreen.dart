import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:ngo_app/Blocs/CommonBloc.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/StringConstants.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Models/CommonResponse.dart';

import '../../Constants/CustomColorCodes.dart';

class ReviewItemScreen extends StatefulWidget {
  final fundraiserIdReceived;

  ReviewItemScreen(this.fundraiserIdReceived);

  @override
  _ReviewItemScreenState createState() => _ReviewItemScreenState();
}

class _ReviewItemScreenState extends State<ReviewItemScreen> {
  String _userTypedRemark = "";
  bool isReviewSubmitted = false;
  CommonBloc _commonBloc;

  @override
  void initState() {
    super.initState();
    _commonBloc = new CommonBloc();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Get.back(result: isReviewSubmitted);
          return Future.value(true);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.black12.withOpacity(0.5),
          body: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.transparent,
                ),
                flex: 1,
              ),
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  alignment: FractionalOffset.center,
                  decoration: BoxDecoration(
                    color: Color(colorCodeGreyPageBg),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                    ),
                  ),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                  alignment: FractionalOffset.centerLeft,
                                  margin: EdgeInsets.fromLTRB(15, 20, 15, 10),
                                  child: Text("We would like to here from you!",
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: Colors.white))),
                              flex: 1,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(0)),
                              child: InkWell(
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  color: Colors.black12.withOpacity(0.1),
                                  alignment: FractionalOffset.center,
                                  child: IconButton(
                                    iconSize: 20,
                                    icon: Icon(
                                      Icons.close,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Get.back(result: isReviewSubmitted);
                                },
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        _buildRemarks(),
                        SizedBox(
                          height: 10,
                        ),
                        _buildActions(),
                        SizedBox(
                          height: 10,
                        ),
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      width: double.infinity,
      alignment: FractionalOffset.center,
      height: 60,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 5,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: InkWell(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12.withOpacity(0.2),
                          spreadRadius: 0.5,
                          blurRadius: 0,
                          offset: Offset(0, 0.5) // changes position of shadow
                          ),
                    ]),
                width: 50,
                height: 50,
                child: IconButton(
                  iconSize: 15,
                  icon: Image.asset(
                    'assets/images/ic_reset.png',
                    width: 15,
                    height: 15,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 50.0,
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
              child: CommonButton(
                  buttonText: "Submit",
                  bgColorReceived: Color(colorCoderRedBg),
                  borderColorReceived: Color(colorCoderRedBg),
                  textColorReceived: Color(colorCodeWhite),
                  buttonHandler: () {
                    if (_userTypedRemark.isNotEmpty) {
                      _addCommentFunction();
                    } else {
                      Fluttertoast.showToast(
                          msg: "Please provide your valuable comments!!");
                    }
                  }),
            ),
            flex: 1,
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildRemarks() {
    return Padding(
      child: TextFormField(
          maxLines: 5,
          minLines: 4,
          keyboardType: TextInputType.multiline,
          maxLength: 500,
          textCapitalization: TextCapitalization.sentences,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 13.0,
              height: 1.8),
          decoration: getDecoration(),
          validator: CommonMethods().requiredValidator,
          onChanged: (val) => _userTypedRemark = val),
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
    );
  }

  getDecoration() {
    return InputDecoration(
      fillColor: Colors.black,
      filled: true,
      hintText: "Write something(min 10 characters)",
      hintStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
          color: Colors.white30,
          fontSize: 11.0,
          height: 1.8),
      counterText: "",
      isDense: true,
      contentPadding: const EdgeInsets.fromLTRB(15.0, 20, 10.0, 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
      ),
    );
  }

  void _addCommentFunction() {
    var bodyParams = {};
    bodyParams["fundraiser_id"] = widget.fundraiserIdReceived;
    bodyParams["comment"] = _userTypedRemark.trim();

    CommonWidgets().showNetworkProcessingDialog();
    _commonBloc.addComment(json.encode(bodyParams)).then((value) {
      Get.back();
      CommonResponse commonResponse = value;
      if (commonResponse.success) {
        Fluttertoast.showToast(msg: commonResponse.message);
        isReviewSubmitted = true;
        Get.back(result: true);
      } else {
        Fluttertoast.showToast(
            msg: commonResponse.message ?? StringConstants.apiFailureMsg);
      }
    }).catchError((err) {
      CommonWidgets().showNetworkErrorDialog(err?.toString());
    });
  }
}
