import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:ngo_app/Blocs/CommonBloc.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/StringConstants.dart';
import 'package:ngo_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:ngo_app/CustomLibraries/ImagePickerAndCropper/image_picker_handler.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Elements/CommonLabelWidget.dart';
import 'package:ngo_app/Elements/CommonTextFormField.dart';
import 'package:ngo_app/Models/CommonResponse.dart';
import 'package:ngo_app/Models/LoanLendDetailsResponse.dart';

class CreateLendScreen extends StatefulWidget {
  final isEditMode;
  final LoanLendDetailsResponse infoReceived;

  CreateLendScreen({this.isEditMode, this.infoReceived});

  @override
  _CreateLendScreenState createState() => _CreateLendScreenState();
}

class _CreateLendScreenState extends State<CreateLendScreen>
    with TickerProviderStateMixin, ImagePickerListener {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _title;
  String _purpose;
  String _amount;
  String _location;
  String _minDays;
  String _description;
  File _image;

  CommonBloc _commonBloc;

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _purposeController = new TextEditingController();
  TextEditingController _amountController = new TextEditingController();
  TextEditingController _locationController = new TextEditingController();
  TextEditingController _minDaysController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  String coverImageUrl = "";
  AnimationController _controller;
  ImagePickerHandler imagePicker;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
    _commonBloc = CommonBloc();
    initFields();
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    _purposeController.dispose();
    _amountController.dispose();
    _locationController.dispose();
    _minDaysController.dispose();
    _descriptionController.dispose();
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
              preferredSize: Size.fromHeight(65.0),
              child: Container(
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
                              widget.isEditMode ? "Update Info" : "Create for Loan",
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
            body: SingleChildScrollView(
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .01),
                      _buildImageSection(),
                      Visibility(
                        child: CommonLabelWidget(
                          label: "Title",
                        ),
                        visible: widget.isEditMode,
                      ),
                      Padding(
                        child: CommonTextFormField(
                            controller: _titleController,
                            hintText: "Title",
                            maxLinesReceived: 3,
                            maxLengthReceived: 100,
                            textColorReceived: Color(colorCodeWhite),
                            fillColorReceived: Color(colorCoderGreyBg),
                            hintColorReceived: Colors.white30,
                            borderColorReceived: Color(colorCoderBorderWhite),
                            validator: CommonMethods().requiredValidator,
                            onChanged: (val) => _title = val),
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .02),
                      Visibility(
                        child: CommonLabelWidget(
                          label: "Purpose",
                        ),
                        visible: widget.isEditMode,
                      ),
                      Padding(
                        child: CommonTextFormField(
                            controller: _purposeController,
                            hintText: "Purpose",
                            maxLinesReceived: 3,
                            maxLengthReceived: 100,
                            textColorReceived: Color(colorCodeWhite),
                            fillColorReceived: Color(colorCoderGreyBg),
                            hintColorReceived: Colors.white30,
                            borderColorReceived: Color(colorCoderBorderWhite),
                            validator: CommonMethods().requiredValidator,
                            onChanged: (val) => _purpose = val),
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .02),
                      Visibility(
                        child: CommonLabelWidget(
                          label: "Amount",
                        ),
                        visible: widget.isEditMode,
                      ),
                      Padding(
                        child: CommonTextFormField(
                            controller: _amountController,
                            hintText: "Amount",
                            maxLinesReceived: 1,
                            maxLengthReceived: 7,
                            textColorReceived: Color(colorCodeWhite),
                            fillColorReceived: Color(colorCoderGreyBg),
                            hintColorReceived: Colors.white30,
                            isDigitsOnly: true,
                            borderColorReceived: Color(colorCoderBorderWhite),
                            validator: CommonMethods().requiredValidator,
                            onChanged: (val) => _amount = val),
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .02),
                      Visibility(
                        child: CommonLabelWidget(
                          label: "Location",
                        ),
                        visible: widget.isEditMode,
                      ),
                      Padding(
                        child: CommonTextFormField(
                            controller: _locationController,
                            hintText: "Location",
                            maxLinesReceived: 4,
                            maxLengthReceived: 250,
                            minLinesReceived: 2,
                            textColorReceived: Color(colorCodeWhite),
                            fillColorReceived: Color(colorCoderGreyBg),
                            hintColorReceived: Colors.white30,
                            borderColorReceived: Color(colorCoderBorderWhite),
                            validator: CommonMethods().requiredValidator,
                            onChanged: (val) => _location = val),
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .02),
                      Visibility(
                        child: CommonLabelWidget(
                          label: "Minimum number of days",
                        ),
                        visible: widget.isEditMode,
                      ),
                      Padding(
                        child: CommonTextFormField(
                            controller: _minDaysController,
                            hintText:
                                "Minimum number of days for amount collection",
                            maxLinesReceived: 1,
                            maxLengthReceived: 3,
                            textColorReceived: Color(colorCodeWhite),
                            fillColorReceived: Color(colorCoderGreyBg),
                            hintColorReceived: Colors.white30,
                            isDigitsOnly: true,
                            borderColorReceived: Color(colorCoderBorderWhite),
                            validator: CommonMethods().requiredValidator,
                            onChanged: (val) => _minDays = val),
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .02),
                      Visibility(
                        child: CommonLabelWidget(
                          label: "Description",
                        ),
                        visible: widget.isEditMode,
                      ),
                      Padding(
                        child: CommonTextFormField(
                            controller: _descriptionController,
                            hintText: "Description",
                            maxLinesReceived: 8,
                            maxLengthReceived: 600,
                            textColorReceived: Color(colorCodeWhite),
                            fillColorReceived: Color(colorCoderGreyBg),
                            hintColorReceived: Colors.white30,
                            borderColorReceived: Color(colorCoderBorderWhite),
                            minLinesReceived: 3,
                            validator: CommonMethods().requiredValidator,
                            onChanged: (val) => _description = val),
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .02),
                      Container(
                        height: 50.0,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: CommonButton(
                            buttonText: widget.isEditMode ? "Update" : "Create",
                            bgColorReceived: Color(colorCoderRedBg),
                            borderColorReceived: Color(colorCoderRedBg),
                            textColorReceived: Color(colorCodeWhite),
                            buttonHandler: _nextBtnClickFunction),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .04),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  _nextBtnClickFunction() {
    print("_nextBtnClickFunction clicked");
    if (widget.isEditMode) {
      if (_formKey.currentState.validate()) {
        FocusScope.of(context).requestFocus(FocusNode());
        callApiToUpdate();
      } else {
        Fluttertoast.showToast(msg: StringConstants.formValidationMsg);
        return;
      }
    } else {
      if (_formKey.currentState.validate()) {
        if (_image != null) {
          FocusScope.of(context).requestFocus(FocusNode());
          callApiToCreate();
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
                  height: 40,
                  width: 40,
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
    if (widget.isEditMode) {
      return Center(
        child: _image == null
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
                child: Image.file(_image, fit: BoxFit.fill, errorBuilder:
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
        child: _image == null
            ? Container(
                color: Colors.black12,
                child: Image(
                  image: AssetImage('assets/images/no_image.png'),
                  height: double.infinity,
                  width: double.infinity,
                ),
                padding: EdgeInsets.all(5),
              )
            : Container(
                height: 180.0,
                width: double.infinity,
                child: Image.file(_image, fit: BoxFit.cover, errorBuilder:
                    (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                  return Container(
                    child: Image.asset(
                      ('assets/images/no_image.png'),
                      fit: BoxFit.cover,
                    ),
                  );
                }),
                decoration: BoxDecoration(
                  color: Colors.cyan[100],
                  borderRadius:
                      new BorderRadius.all(const Radius.circular(10.0)),
                  image: new DecorationImage(
                      image: new AssetImage('assets/images/no_image.png'),
                      fit: BoxFit.cover),
                ),
              ),
      );
    }
  }

  getImageToPass(File image) {
    if (image != null) {
      String fileName = image.path.split('/').last;
      String mimeType = mime(fileName);
      String mimee = mimeType.split('/')[0];
      String type = mimeType.split('/')[1];
      return dio.MultipartFile.fromFileSync(image.path,
          filename: fileName, contentType: MediaType(mimee, type));
    }

    return null;
  }

  void callApiToCreate() {
    dio.FormData formData = dio.FormData.fromMap({
      'title': _title.trim(),
      'purpose': _purpose.trim(),
      'location': _location.trim(),
      'description': _description.trim(),
      'amount': _amount.trim(),
      'no_of_days': _minDays.trim(),
      'image_url': getImageToPass(_image)
    });

    CommonWidgets().showNetworkProcessingDialog();
    _commonBloc.createLend(formData).then((value) {
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

  @override
  userImage(File _image) {
    if (_image != null) {
      setState(() {
        this._image = _image;
      });
    } else {
      Fluttertoast.showToast(msg: "Unable to set image");
    }
  }

  void callApiToUpdate() {
    var formData = new FormData();
    if (_image != null) {
      String fileName = _image.path.split('/').last;
      String mimeType = mime(fileName);
      String mimee = mimeType.split('/')[0];
      String type = mimeType.split('/')[1];
      formData.files.add(MapEntry(
        "image_url",
        MultipartFile.fromFileSync(_image.path,
            filename: fileName, contentType: MediaType(mimee, type)),
      ));
    }
    formData.fields
      ..add(MapEntry("loan_id", "${widget.infoReceived?.loanDetails?.id}"));
    formData.fields..add(MapEntry("title", _title.trim()));
    formData.fields..add(MapEntry("purpose", _purpose.trim()));
    formData.fields..add(MapEntry("location", _location.trim()));
    formData.fields..add(MapEntry("description", _description));
    formData.fields..add(MapEntry("amount", _amount));
    formData.fields..add(MapEntry("no_of_days", _minDays));

    CommonWidgets().showNetworkProcessingDialog();
    _commonBloc.updateLend(formData).then((value) {
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

  void initFields() {
    if (widget.isEditMode) {
      if (widget.infoReceived != null) {
        LoanDetails _loanDetails = widget.infoReceived.loanDetails;
        if (_loanDetails != null) {
          _title = _loanDetails.title;
          _titleController.text = _loanDetails.title;

          _purpose = _loanDetails.purpose;
          _purposeController.text = _loanDetails.purpose;

          _amount = "${_loanDetails.amount}";
          _amountController.text = "${_loanDetails.amount}";

          _location = _loanDetails.location;
          _locationController.text = _loanDetails.location;

          _description = _loanDetails.description;
          _descriptionController.text = _loanDetails.description;

          String val = CommonMethods().getDateGap(_loanDetails.closingDate);
          _minDays = val;
          _minDaysController.text = val;

          if (widget.infoReceived.baseUrl != null &&
              _loanDetails.imageUrl != null) {
            if (widget.infoReceived.baseUrl != "" &&
                _loanDetails.imageUrl != "") {
              coverImageUrl =
                  widget.infoReceived.baseUrl + _loanDetails.imageUrl;
            }
          }
        }
      }
    }
  }
}
