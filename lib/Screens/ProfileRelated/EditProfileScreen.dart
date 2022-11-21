import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:mime_type/mime_type.dart';
import 'package:ngo_app/Blocs/AuthorisationBloc.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/StringConstants.dart';
import 'package:ngo_app/CustomLibraries/ImagePickerAndCropper/image_picker_handler.dart';
import 'package:ngo_app/CustomLibraries/TextDrawable/TextDrawableWidget.dart';
import 'package:ngo_app/CustomLibraries/TextDrawable/color_generator.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Elements/CommonTextFormField.dart';
import 'package:ngo_app/Models/ProfileResponse.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';
import 'package:http_parser/http_parser.dart';
import 'package:ngo_app/Utilities/PreferenceUtils.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with TickerProviderStateMixin, ImagePickerListener {
  File _image;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  AuthorisationBloc authorisationBloc;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _phone;
  String _name;
  String _email;
  String _countryCode = "+91";
  String dobReceived;
  var customDateFormatToShow = DateFormat('dd MMM yyyy');
  var customDateFormatToPass = DateFormat('yyyy-MM-dd');
  DateTime selectedDate;

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
    authorisationBloc = new AuthorisationBloc();
    initValues();
  }

  void initValues() {
    if (LoginModel().userDetails != null) {
      _countryCode = "+${LoginModel().userDetails.countryCode}";

      _name = LoginModel().userDetails.name;
      _nameController.text = LoginModel().userDetails.name;

      _phone = LoginModel().userDetails.phoneNumber;
      _phoneController.text = LoginModel().userDetails.phoneNumber;

      _email = LoginModel().userDetails.email;
      _emailController.text = LoginModel().userDetails.email;

      dobReceived =
          "${CommonMethods().changeDateFormat(LoginModel().userDetails.dateOfBirth)}";
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              text: "Edit Profile",
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
                        _buildImageSection(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                        Padding(
                          child: CommonTextFormField(
                              hintText: "Name",
                              maxLinesReceived: 1,
                              maxLengthReceived: 150,
                              controller: _nameController,
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
                              controller: _emailController,
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
                              initialSelection:
                                  '+${LoginModel().userDetails.countryCode}',
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
                              controller: _phoneController,
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
                            height: MediaQuery.of(context).size.height * .02),
                        _buildDateSection(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .03),
                        Container(
                          height: 50.0,
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: CommonButton(
                              buttonText: "Update",
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

  _buildDateSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: double.infinity,
            maxWidth: double.infinity,
            minHeight: 50,
          ),
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            decoration: BoxDecoration(
                color: Colors.black12,
                border:
                    Border.all(color: Color(colorCoderBorderWhite), width: 1.0),
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
                            : dobReceived ?? "Select Date of birth",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: selectedDate != null
                                ? Colors.black
                                : Colors.black87,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500),
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
        ),
        SizedBox(
          height: 10,
        ),
      ],
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
      _updateFunction();
    } else {
      Fluttertoast.showToast(msg: StringConstants.formValidationMsg);
      return;
    }
  }

  void _updateFunction() async {
    var formData = new FormData();
    if (_image != null) {
      String fileName = _image.path.split('/').last;
      String mimeType = mime(fileName);
      String mimee = mimeType.split('/')[0];
      String type = mimeType.split('/')[1];
      formData.files.add(MapEntry(
        "image",
        MultipartFile.fromFileSync(_image.path,
            filename: fileName, contentType: MediaType(mimee, type)),
      ));
    }
    formData.fields..add(MapEntry("name", _name.trim()));
    formData.fields..add(MapEntry("email", _email.trim()));
    formData.fields..add(MapEntry("phone_number", _phone.trim()));
    formData.fields..add(MapEntry("country_code", _countryCode));
    formData.fields
      ..add(MapEntry(
          "date_of_birth",
          selectedDate != null
              ? customDateFormatToPass.format(selectedDate)
              : LoginModel().userDetails.dateOfBirth));

    CommonWidgets().showNetworkProcessingDialog();
    authorisationBloc.updateProfile(formData).then((value) {
      Get.back();
      ProfileResponse response = value;
      if (response.success) {
        if (response.userDetails != null) {
          LoginModel().userDetails = response.userDetails;
          LoginModel().userDetails.baseUrl = response.baseUrl;
          PreferenceUtils.setObjectToSF(
              PreferenceUtils.prefUserDetails, LoginModel().userDetails);
        }
        Fluttertoast.showToast(msg: response.message);
        Get.back(result: true);
      } else {
        Fluttertoast.showToast(
            msg: response.message ?? StringConstants.apiFailureMsg);
      }
    }).catchError((err) {
      Get.back();
      CommonWidgets().showNetworkErrorDialog(err?.toString());
    });
  }

  void _backPressFunction() {
    print("_sendOtpFunction clicked");
    Get.back(result: false);
  }

  Future<bool> onWillPop() {
    Get.back(result: false);
    return Future.value(true);
  }

  _buildImageSection() {
    return Container(
      alignment: FractionalOffset.center,
      width: double.infinity,
      height: 190,
      color: Colors.transparent,
      child: Container(
        height: 160.0,
        width: 160.0,
        child: Stack(children: <Widget>[
          Align(
            alignment: FractionalOffset.center,
            child: Container(
              width: 150,
              height: 150,
              decoration: new BoxDecoration(
                color: Colors.black26,
                borderRadius: new BorderRadius.all(new Radius.circular(75.0)),
                border: new Border.all(
                  color: Colors.red,
                  width: 6.0,
                ),
              ),
              child: ClipOval(
                child: SizedBox.expand(
                  child: showImage(),
                ),
              ),
            ),
          ),
          Positioned(
            child: Align(
              alignment: FractionalOffset.bottomRight,
              child: Container(
                child: InkWell(
                  child: Image.asset(
                    ('assets/images/ic_camera.png'),
                    height: 50,
                    width: 50,
                  ),
                  onTap: () {
                    imagePicker.showDialog(context);
                  },
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget showImage() {
    return Center(
      child: _image == null
          ? CachedNetworkImage(
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              imageUrl: CommonMethods().getImage(),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => TextDrawableWidget(
                _name ?? "?",
                ColorGenerator.materialColors,
                (bool selected) {
                  // on tap callback
                  print("on tap callback");
                },
                false,
                140.0,
                140.0,
                BoxShape.circle,
                TextStyle(color: Colors.white, fontSize: 40.0),
              ),
            )
          : Container(
              height: 140.0,
              width: 140.0,
              child: SizedBox.expand(
                child: Image.file(
                  _image,
                  fit: BoxFit.cover,
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.all(const Radius.circular(70.0)),
              ),
            ),
    );
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
}
