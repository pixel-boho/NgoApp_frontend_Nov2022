import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:ngo_app/Blocs/CommonBloc.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/StringConstants.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Models/CancelOption.dart';
import 'package:ngo_app/Models/CommonResponse.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

import '../../Constants/CustomColorCodes.dart';

class CancelRequestScreen extends StatefulWidget {
  final fundraiserIdReceived;

  CancelRequestScreen(this.fundraiserIdReceived);

  @override
  _CancelRequestScreenState createState() => _CancelRequestScreenState();
}

class _CancelRequestScreenState extends State<CancelRequestScreen> {
  String _userTypedRemark = "";
  bool iscancelOptionSubmitted = false;
  CommonBloc _commonBloc;
  CancelOption cancelOptionSelectedValue;

  @override
  void initState() {
    super.initState();
    _commonBloc = new CommonBloc();
    for (var data in LoginModel().cancelOptions) {
      data.isSelected = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Get.back(result: iscancelOptionSubmitted);
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
                                  child: Text(
                                      "Please tell us why you are cancelling this, we would like to here from you!",
                                      textAlign: TextAlign.left,
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
                                  Get.back(result: iscancelOptionSubmitted);
                                },
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        _buildOptions(),
                        SizedBox(
                          height: 15,
                        ),
                        _buildRemarks(),
                        SizedBox(
                          height: 20,
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
            width: 15,
          ),
          Expanded(
            child: Container(
              height: 50.0,
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: CommonButton(
                  buttonText: "Submit",
                  bgColorReceived: Color(colorCoderRedBg),
                  borderColorReceived: Color(colorCoderRedBg),
                  textColorReceived: Color(colorCodeWhite),
                  buttonHandler: () {
                    if (cancelOptionSelectedValue != null) {
                      if (cancelOptionSelectedValue.optionValue == 2) {
                        if (_userTypedRemark.isNotEmpty) {
                          _cancelFunction();
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please provide your valuable comments!!");
                        }
                      } else {
                        _cancelFunction();
                      }
                    } else {
                      Fluttertoast.showToast(msg: "Please select any option!!");
                    }
                  }),
            ),
            flex: 1,
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }

  Widget _buildRemarks() {
    if (checkOthersSelected()) {
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
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      );
    } else {
      return Container();
    }
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

  void _cancelFunction() {
    var bodyParams = {};
    bodyParams["fundraiser_scheme_id"] = widget.fundraiserIdReceived;
    if (cancelOptionSelectedValue.optionValue == 2) {
      bodyParams["reason"] = _userTypedRemark.trim();
    } else {
      bodyParams["reason"] = cancelOptionSelectedValue.optionDescription;
    }

    CommonWidgets().showNetworkProcessingDialog();
    _commonBloc.cancelFundraiser(json.encode(bodyParams)).then((value) {
      Get.back();
      CommonResponse commonResponse = value;
      if (commonResponse.success) {
        Fluttertoast.showToast(
            msg: commonResponse.message ??
                "Admin will contact for further steps in payment and admin will give you balance");
        iscancelOptionSubmitted = true;
        Get.back(result: true);
      } else {
        Fluttertoast.showToast(
            msg: commonResponse.message ?? StringConstants.apiFailureMsg);
      }
    }).catchError((err) {
      CommonWidgets().showNetworkErrorDialog(err?.toString());
    });
  }

  _buildOptions() {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 3, 5, 3),
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        height: 45,
        decoration: BoxDecoration(
            color: Color(colorCodeGreyPageBg),
            border: Border.all(color: Colors.white, width: 0.5),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        width: double.infinity,
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            child: DropdownButton(
              dropdownColor: Color(colorCodeGreyPageBg),
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
              ),
              hint: Text(setAlreadySelectedCancelOption(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Color(colorCodeWhite))),
              value: cancelOptionSelectedValue,
              onChanged: (val) {
                cancelOptionSelectedValue = val;
                cancelOptionSelectedValue.isSelected = true;
                for (var data in LoginModel().cancelOptions) {
                  if (data != val) {
                    data.isSelected = false;
                  } else {
                    data.isSelected = true;
                  }
                }
                setState(() {});
              },
              items: LoginModel().cancelOptions.map((option) {
                return DropdownMenuItem(
                  child: Text(
                    "${option.optionName}",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: Color(colorCodeWhite)),
                  ),
                  value: option,
                );
              }).toList(),
            ),
          ),
        ));
  }

  String setAlreadySelectedCancelOption() {
    String val = "~~Select Any~~";
    if (LoginModel().cancelOptions != null) {
      for (var data in LoginModel().cancelOptions) {
        if (data.isSelected) {
          val = data.optionName;
        }
      }
    }

    return val;
  }

  bool checkOthersSelected() {
    if (cancelOptionSelectedValue != null) {
      if (cancelOptionSelectedValue.isSelected &&
          cancelOptionSelectedValue.optionValue == 2) {
        return true;
      }
    }
    return false;
  }
}
