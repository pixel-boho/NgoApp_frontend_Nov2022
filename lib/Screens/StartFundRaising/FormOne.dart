
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/StringConstants.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Elements/CommonLabelWidget.dart';
import 'package:ngo_app/Elements/CommonTextFormField.dart';
import 'package:ngo_app/Interfaces/RefreshPageListener.dart';
import 'package:ngo_app/Models/CampaignItem.dart';
import 'package:ngo_app/Models/RelationsResponse.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

import 'FormThree.dart';
import 'FormTwo.dart';

class FormOneScreen extends StatefulWidget {
  @override
  _FormOneScreenState createState() => _FormOneScreenState();
}

class _FormOneScreenState extends State<FormOneScreen>
    with RefreshPageListener {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _phone;
  String _name;
  String _email;
  RelationInfo _selectedRelationIfo;
  String _countryCode = "+91";

  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    CommonMethods().setRefreshFilterPageListener(this);
    CommonMethods().getAllRelations();
    initValues();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _emailController.dispose();
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
                            LoginModel().isFundraiserEditMode
                                ? "Update Fundraiser"
                                : "Start a Fundraiser",
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
                            "Personal Details",
                            style: TextStyle(
                                color: Color(colorCoderBorderWhite),
                                fontWeight: FontWeight.w600,
                                fontSize: 15.0),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                        Visibility(
                          child: CommonLabelWidget(
                            label: "Name",
                          ),
                          visible: LoginModel().isFundraiserEditMode,
                        ),
                        Padding(
                          child: CommonTextFormField(
                              controller: _nameController,
                              hintText: "Name",
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
                        Visibility(
                          child: CommonLabelWidget(
                            label: "Email",
                          ),
                          visible: LoginModel().isFundraiserEditMode,
                        ),
                        Padding(
                          child: CommonTextFormField(
                              controller: _emailController,
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
                        Visibility(
                          child: CommonLabelWidget(
                            label: "Country code",
                          ),
                          visible: LoginModel().isFundraiserEditMode,
                        ),
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
                                initialSelection: '$_countryCode',
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
                        Visibility(
                          child: CommonLabelWidget(
                            label: "Mobile",
                          ),
                          visible: LoginModel().isFundraiserEditMode,
                        ),
                        Padding(
                          child: CommonTextFormField(
                              controller: _phoneController,
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
                        Visibility(
                          child: CommonLabelWidget(
                            label: "Relation",
                          ),
                          visible: LoginModel().isFundraiserEditMode,
                        ),
                        _buildRelationSection(),
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
                buttonText: "Next",
                bgColorReceived: Color(colorCoderRedBg),
                borderColorReceived: Color(colorCoderRedBg),
                textColorReceived: Color(colorCodeWhite),
                buttonHandler: _nextBtnClickFunction),
          ),
        ),
      ),
    );
  }

  void _nextBtnClickFunction() {
    print("_clearBtnClickFunction clicked");
    if (_formKey.currentState.validate()) {
      if (_selectedRelationIfo != null) {
        FocusScope.of(context).requestFocus(FocusNode());

        LoginModel().startFundraiserMap["name"] = _name.trim();
        LoginModel().startFundraiserMap["email"] = _email.trim();
        LoginModel().startFundraiserMap["phone_number"] = _phone.trim();
        LoginModel().startFundraiserMap["country_code"] = _countryCode;
        LoginModel().startFundraiserMap["relation_master_id"] =
            _selectedRelationIfo.id;

        if (LoginModel().startFundraiserMap != null) {
          if (LoginModel().startFundraiserMap.containsKey("campaignSelected")) {
            CampaignItem campaignItem =
                LoginModel().startFundraiserMap["campaignSelected"];
            if (campaignItem.isHealthCase == 1) {
              Get.to(() => FormThreeScreen());
            } else {
              Get.to(() => FormTwoScreen());
            }
          }
        }
      } else {
        if (LoginModel().relationsList.length == 0) {
          CommonMethods().getAllRelations();
          Fluttertoast.showToast(
              msg: "Please wait we are fetching the relations info");
        } else {
          Fluttertoast.showToast(msg: "Relation is mandatory");
        }

        return;
      }
    } else {
      Fluttertoast.showToast(msg: StringConstants.formValidationMsg);
      return;
    }
  }

  Future<bool> onWillPop() {
    return Future.value(true);
  }

  _buildRelationSection() {
    if (LoginModel().relationsList != null) {
      if (LoginModel().relationsList.length > 0) {
        return Container(
            padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
            margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
            height: 50,
            decoration: BoxDecoration(
                color: Color(colorCoderGreyBg),
                border:
                    Border.all(color: Color(colorCoderBorderWhite), width: 1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            width: double.infinity,
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                child: DropdownButton(
                  dropdownColor: Color(colorCoderGreyBg),
                  isExpanded: true,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  hint: Text(getRelationInfo(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: Color(colorCodeWhite))),
                  value: _selectedRelationIfo,
                  onChanged: (val) {
                    for (var data in LoginModel().relationsList) {
                      if (data.id == val.id) {
                        data.isSelected = true;
                      } else {
                        data.isSelected = false;
                      }
                    }
                    setState(() {
                      _selectedRelationIfo = val;
                    });
                  },
                  items: LoginModel().relationsList.map((option) {
                    return DropdownMenuItem(
                      child: Text(
                        "${option.title}",
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
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  @override
  void refreshPage() {
    if (mounted) {
      if (LoginModel().relationsList != null) {
        if (LoginModel().isFundraiserEditMode) {
          if (LoginModel().itemDetailResponseInEditMode != null) {
            for (var data in LoginModel().relationsList) {
              if (LoginModel()
                      .itemDetailResponseInEditMode
                      .fundraiserDetails
                      .relationMasterId ==
                  data.id) {
                data.isSelected = true;
              } else {
                data.isSelected = false;
              }
            }
          }
        }
      }
      setState(() {});
    }
  }

  void initValues() {
    if (LoginModel().isFundraiserEditMode) {
      if (LoginModel().itemDetailResponseInEditMode != null) {
        if (LoginModel().itemDetailResponseInEditMode.success) {
          _name =
              LoginModel().itemDetailResponseInEditMode.fundraiserDetails.name;
          _nameController.text =
              LoginModel().itemDetailResponseInEditMode.fundraiserDetails.name;

          _email =
              LoginModel().itemDetailResponseInEditMode.fundraiserDetails.email;
          _emailController.text =
              LoginModel().itemDetailResponseInEditMode.fundraiserDetails.email;

          _phone = LoginModel()
              .itemDetailResponseInEditMode
              .fundraiserDetails
              .phoneNumber;
          _phoneController.text = LoginModel()
              .itemDetailResponseInEditMode
              .fundraiserDetails
              .phoneNumber;

          _countryCode =
              "+${LoginModel().itemDetailResponseInEditMode.fundraiserDetails.countryCode}";
        }
      }
    }
  }

  String getRelationInfo() {
    String val = "~~Select Relation~~";
    if (LoginModel().isFundraiserEditMode &&
        LoginModel().itemDetailResponseInEditMode != null) {
      if (LoginModel().relationsList != null) {
        for (var data in LoginModel().relationsList) {
          if (data.isSelected) {
            val = data.title;
            _selectedRelationIfo = data;
            break;
          }
        }
      }
    }

    return val;
  }
}
