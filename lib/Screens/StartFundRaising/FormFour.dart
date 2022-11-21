import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/StringConstants.dart';
import 'package:ngo_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:ngo_app/CustomLibraries/ImagePickerAndCropper/image_picker_handler.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Elements/CommonLabelWidget.dart';
import 'package:ngo_app/Elements/CommonTextFormField.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

import 'FormAccountDeails.dart';

class FormFourScreen extends StatefulWidget {
  @override
  _FormFourScreenState createState() => _FormFourScreenState();
}

class _FormFourScreenState extends State<FormFourScreen>
    with TickerProviderStateMixin, ImagePickerListener {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _amount;
  String _purpose;
  String _description;
  File _coverImage;

  AnimationController _controller;
  ImagePickerHandler imagePicker;

  TextEditingController _amountController = new TextEditingController();
  TextEditingController _purposeController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  String coverImageUrl = "";

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
    initFields();
  }

  @override
  void dispose() {
    _controller.dispose();
    _amountController.dispose();
    _purposeController.dispose();
    _descriptionController.dispose();
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
                            height: MediaQuery.of(context).size.height * .01),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          alignment: FractionalOffset.centerLeft,
                          child: Text(
                            "Beneficiary Information",
                            style: TextStyle(
                                color: Color(colorCoderBorderWhite),
                                fontWeight: FontWeight.w600,
                                fontSize: 15.0),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        _buildImageSection(),
                        Visibility(
                          child: CommonLabelWidget(
                            label: "Total amount to raise",
                          ),
                          visible: LoginModel().isFundraiserEditMode,
                        ),
                        Padding(
                          child: CommonTextFormField(
                              controller: _amountController,
                              hintText: "Total Amount to raise",
                              maxLinesReceived: 1,
                              maxLengthReceived: 8,
                              textColorReceived: Color(colorCodeWhite),
                              fillColorReceived: Color(colorCoderGreyBg),
                              hintColorReceived: Colors.white30,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              isDigitsOnly: true,
                              onChanged: (val) => _amount = val,
                              validator: CommonMethods().requiredValidator),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Visibility(
                          child: CommonLabelWidget(
                            label: "Purpose",
                          ),
                          visible: LoginModel().isFundraiserEditMode,
                        ),
                        Padding(
                          child: CommonTextFormField(
                              controller: _purposeController,
                              hintText: "Purpose",
                              maxLinesReceived: 4,
                              minLinesReceived: 2,
                              maxLengthReceived: 300,
                              textColorReceived: Color(colorCodeWhite),
                              fillColorReceived: Color(colorCoderGreyBg),
                              hintColorReceived: Colors.white30,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              onChanged: (val) => _purpose = val,
                              validator: CommonMethods().requiredValidator),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Visibility(
                          child: CommonLabelWidget(
                            label: "Description",
                          ),
                          visible: LoginModel().isFundraiserEditMode,
                        ),
                        Padding(
                          child: CommonTextFormField(
                              controller: _descriptionController,
                              hintText: "Detailed description",
                              minLinesReceived: 3,
                              maxLinesReceived: 8,
                              maxLengthReceived: 600,
                              textColorReceived: Color(colorCodeWhite),
                              fillColorReceived: Color(colorCoderGreyBg),
                              hintColorReceived: Colors.white30,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              onChanged: (val) => _description = val,
                              validator: CommonMethods().requiredValidator),
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

  _buildImageSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      alignment: FractionalOffset.center,
      width: double.infinity,
      height: 200,
      color: Colors.transparent,
      child: Container(
        height: 180.0,
        width: double.infinity,
        child: Stack(children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: new BoxDecoration(
              color: Colors.transparent,
              borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
              child: SizedBox.expand(
                child: showImage(),
              ),
            ),
          ),
          Positioned(
            right: 0.0,
            bottom: 0.0,
            child: Container(
              child: InkWell(
                child: Image.asset(
                  ('assets/images/ic_camera.png'),
                  height: 45,
                  width: 45,
                ),
                onTap: () {
                  imagePicker.showDialog(context);
                },
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget showImage() {
    if (LoginModel().isFundraiserEditMode) {
      return Center(
        child: _coverImage == null
            ? Container(
                color: Colors.black12,
                child: CachedNetworkImage(
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fill,
                  imageUrl: coverImageUrl,
                  placeholder: (context, url) => Center(
                    child: RoundedLoader(),
                  ),
                  errorWidget: (context, url, error) => Container(
                    child: Image.asset(
                      ('assets/images/no_image.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                padding: EdgeInsets.all(0),
              )
            : Container(
                height: 180.0,
                width: double.infinity,
                child: Image.file(_coverImage, fit: BoxFit.fill, errorBuilder:
                    (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                  return Container(
                    child: Image.asset(
                      ('assets/images/no_image.png'),
                      fit: BoxFit.fill,
                    ),
                  );
                }),
                decoration: BoxDecoration(
                  color: Colors.cyan[100],
                  borderRadius:
                      new BorderRadius.all(const Radius.circular(80.0)),
                  image: new DecorationImage(
                      image: new AssetImage('assets/images/no_image.png'),
                      fit: BoxFit.cover),
                ),
              ),
      );
    } else {
      return Center(
        child: _coverImage == null
            ? Container(
                color: Colors.black12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Image(
                        image: AssetImage('assets/images/no_image.png'),
                        height: double.infinity,
                        width: double.infinity,
                      ),
                      flex: 1,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Text(
                        "Upload cover image",
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.0),
                      ),
                    )
                  ],
                ),
                padding: EdgeInsets.all(5),
              )
            : Container(
                height: 180.0,
                width: double.infinity,
                child: Image.file(_coverImage, fit: BoxFit.fill, errorBuilder:
                    (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                  return Container(
                    child: Image.asset(
                      ('assets/images/no_image.png'),
                      fit: BoxFit.fill,
                    ),
                  );
                }),
                decoration: BoxDecoration(
                  color: Colors.cyan[100],
                  borderRadius:
                      new BorderRadius.all(const Radius.circular(80.0)),
                  image: new DecorationImage(
                      image: new AssetImage('assets/images/no_image.png'),
                      fit: BoxFit.cover),
                ),
              ),
      );
    }
  }

  void _nextBtnClickFunction() {
    print("_clearBtnClickFunction clicked");
    if (LoginModel().isFundraiserEditMode) {
      if (_formKey.currentState.validate()) {
        FocusScope.of(context).requestFocus(FocusNode());

        if (_coverImage != null) {
          LoginModel().startFundraiserMap["main_image"] = _coverImage;
        }
        LoginModel().startFundraiserMap["title"] = _purpose.trim();
        LoginModel().startFundraiserMap["story"] = _description.trim();
        LoginModel().startFundraiserMap["fund_required"] = _amount.trim();

        Get.to(() => FormAccountDetails());
      } else {
        Fluttertoast.showToast(msg: StringConstants.formValidationMsg);
        return;
      }
    } else {
      if (_formKey.currentState.validate()) {
        if (_coverImage != null) {
          FocusScope.of(context).requestFocus(FocusNode());

          LoginModel().startFundraiserMap["main_image"] = _coverImage;
          LoginModel().startFundraiserMap["title"] = _purpose.trim();
          LoginModel().startFundraiserMap["story"] = _description.trim();
          LoginModel().startFundraiserMap["fund_required"] = _amount.trim();

          Get.to(() => FormAccountDetails());
        } else {
          Fluttertoast.showToast(msg: "Main image is mandatory");
        }
      } else {
        Fluttertoast.showToast(msg: StringConstants.formValidationMsg);
        return;
      }
    }
  }

  Future<bool> onWillPop() {
    return Future.value(true);
  }

  @override
  userImage(File _image) {
    if (_image != null) {
      setState(() {
        this._coverImage = _image;
      });
    } else {
      Fluttertoast.showToast(msg: "Unable to set image");
    }
  }

  void initFields() {
    if (LoginModel().isFundraiserEditMode) {
      if (LoginModel().itemDetailResponseInEditMode != null) {
        if (LoginModel().itemDetailResponseInEditMode.success) {
          _amount =
              "${LoginModel().itemDetailResponseInEditMode.fundraiserDetails.fundRequired}";
          _amountController.text =
              "${LoginModel().itemDetailResponseInEditMode.fundraiserDetails.fundRequired}";

          _purpose =
              "${LoginModel().itemDetailResponseInEditMode.fundraiserDetails.title}";
          _purposeController.text =
              "${LoginModel().itemDetailResponseInEditMode.fundraiserDetails.title}";

          _description =
              "${LoginModel().itemDetailResponseInEditMode.fundraiserDetails.story}";
          _descriptionController.text =
              "${LoginModel().itemDetailResponseInEditMode.fundraiserDetails.story}";

          if (LoginModel().itemDetailResponseInEditMode.baseUrl != null) {
            if (LoginModel().itemDetailResponseInEditMode.baseUrl != "") {
              if (LoginModel().itemDetailResponseInEditMode.fundraiserDetails !=
                  null) {
                if (LoginModel()
                        .itemDetailResponseInEditMode
                        .fundraiserDetails
                        ?.imageUrl !=
                    null) {
                  if (LoginModel()
                          .itemDetailResponseInEditMode
                          .fundraiserDetails
                          ?.imageUrl !=
                      "") {
                    coverImageUrl =
                        LoginModel().itemDetailResponseInEditMode.baseUrl +
                            LoginModel()
                                .itemDetailResponseInEditMode
                                .fundraiserDetails
                                ?.imageUrl;
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
