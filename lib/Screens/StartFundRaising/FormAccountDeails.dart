import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:ngo_app/Blocs/VerifyIfscBloc.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/StringConstants.dart';
import 'package:ngo_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Elements/CommonLabelWidget.dart';
import 'package:ngo_app/Elements/CommonTextFormField.dart';
import 'package:ngo_app/Models/BankInfo.dart';
import 'package:ngo_app/Models/PricingStrategiesResponse.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

import 'FormSetPricing.dart';

class FormAccountDetails extends StatefulWidget {
  @override
  _FormAccountDetailsState createState() => _FormAccountDetailsState();
}

class _FormAccountDetailsState extends State<FormAccountDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _code;
  String _accName;
  String _accNumber;
  String _bank;
  VerifyIfscBloc _ifscBloc;

  int value;
  PricingInfo selectedPricingInfo;

  TextEditingController _codeController = new TextEditingController();
  TextEditingController _accNameController = new TextEditingController();
  TextEditingController _accNumberController = new TextEditingController();
  TextEditingController _bankController = new TextEditingController();
  BankInfo _bankInfoReceived;

  @override
  void initState() {
    super.initState();
    _ifscBloc = new VerifyIfscBloc();
    initFields();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _accNameController.dispose();
    _accNumberController.dispose();
    _bankController.dispose();
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
                            "Start a Fundraiser",
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
                            "Account Details",
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
                            label: "Account Name",
                          ),
                          visible: LoginModel().isFundraiserEditMode,
                        ),
                        Padding(
                          child: CommonTextFormField(
                              controller: _accNameController,
                              hintText: "Account Name",
                              maxLinesReceived: 1,
                              maxLengthReceived: 60,
                              textColorReceived: Color(colorCodeWhite),
                              fillColorReceived: Color(colorCoderGreyBg),
                              hintColorReceived: Colors.white30,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              onChanged: (val) => _accName = val,
                              validator: CommonMethods().requiredValidator),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Visibility(
                          child: CommonLabelWidget(
                            label: "Account Number",
                          ),
                          visible: LoginModel().isFundraiserEditMode,
                        ),
                        Padding(
                          child: CommonTextFormField(
                              controller: _accNumberController,
                              hintText: "Account Number",
                              maxLinesReceived: 1,
                              maxLengthReceived: 16,
                              textColorReceived: Color(colorCodeWhite),
                              fillColorReceived: Color(colorCoderGreyBg),
                              hintColorReceived: Colors.white30,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              isDigitsOnly: true,
                              onChanged: (val) => _accNumber = val,
                              validator: CommonMethods().requiredValidator),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Visibility(
                          child: CommonLabelWidget(
                            label: "Bank",
                          ),
                          visible: LoginModel().isFundraiserEditMode,
                        ),
                        Padding(
                          child: CommonTextFormField(
                              controller: _bankController,
                              hintText: "Bank",
                              maxLinesReceived: 2,
                              maxLengthReceived: 80,
                              textColorReceived: Color(colorCodeWhite),
                              fillColorReceived: Color(colorCoderGreyBg),
                              hintColorReceived: Colors.white30,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              onChanged: (val) => _bank = val,
                              validator: CommonMethods().requiredValidator),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Visibility(
                          child: CommonLabelWidget(
                            label: "IFSC",
                          ),
                          visible: LoginModel().isFundraiserEditMode,
                        ),
                        Padding(
                          child: CommonTextFormField(
                              controller: _codeController,
                              hintText: "IFSC",
                              maxLinesReceived: 1,
                              maxLengthReceived: 11,
                              textColorReceived: Color(colorCodeWhite),
                              fillColorReceived: Color(colorCoderGreyBg),
                              hintColorReceived: Colors.white30,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              isFullCapsNeeded: true,
                              onChanged: (val) => _code = val,
                              validator: CommonMethods().isValidIfsc),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        StreamBuilder<ApiResponse<BankInfo>>(
                          stream: _ifscBloc.verifyStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              switch (snapshot.data.status) {
                                case Status.LOADING:
                                  return _buildLoadingWidget();
                                  break;
                                case Status.COMPLETED:
                                  _bankInfoReceived = snapshot.data.data;
                                  return _buildBankInfo(_bankInfoReceived);
                                  break;
                                case Status.ERROR:
                                  return _buildErrorWidget(
                                      snapshot.data.message);
                                  break;
                              }
                            }

                            return Container();
                          },
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .05),
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
      FocusScope.of(context).requestFocus(FocusNode());
      if (LoginModel().isFundraiserEditMode) {
        if (LoginModel()
                .itemDetailResponseInEditMode
                ?.fundraiserDetails
                ?.beneficiaryIfsc !=
            _code.trim()) {
          checkIfsc();
        } else {
          LoginModel().startFundraiserMap["beneficiary_account_name"] =
              _accName.trim();
          LoginModel().startFundraiserMap["beneficiary_account_number"] =
              _accNumber.trim();
          LoginModel().startFundraiserMap["beneficiary_bank"] = _bank.trim();
          LoginModel().startFundraiserMap["beneficiary_ifsc"] = _code.trim();
          Get.to(() => FormSetPricing());
        }
      } else {
        checkIfsc();
      }
    } else {
      Fluttertoast.showToast(msg: StringConstants.formValidationMsg);
      return;
    }
  }

  Future<bool> onWillPop() {
    return Future.value(true);
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      width: double.infinity,
      child: Container(
        alignment: FractionalOffset.center,
        child: Text(
          "Unable to verify provided IFSC!!!",
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 12.0,
              color: Colors.white,
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: FractionalOffset.centerLeft,
            child: Text(
              "Verifying your IFSC code to get bank info",
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                  fontWeight: FontWeight.normal),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          RoundedLoader()
        ],
      ),
    );
  }

  void initFields() {
    if (LoginModel().isFundraiserEditMode) {
      if (LoginModel().itemDetailResponseInEditMode != null) {
        if (LoginModel().itemDetailResponseInEditMode.success) {
          _code = LoginModel()
              .itemDetailResponseInEditMode
              .fundraiserDetails
              .beneficiaryIfsc;
          _codeController.text = LoginModel()
              .itemDetailResponseInEditMode
              .fundraiserDetails
              .beneficiaryIfsc
              .toUpperCase();

          _accNumber = LoginModel()
              .itemDetailResponseInEditMode
              .fundraiserDetails
              .beneficiaryAccountNumber;
          _accNumberController.text = LoginModel()
              .itemDetailResponseInEditMode
              .fundraiserDetails
              .beneficiaryAccountNumber;

          _accName = LoginModel()
              .itemDetailResponseInEditMode
              .fundraiserDetails
              .beneficiaryAccountName;
          _accNameController.text = LoginModel()
              .itemDetailResponseInEditMode
              .fundraiserDetails
              .beneficiaryAccountName;

          _bank = LoginModel()
              .itemDetailResponseInEditMode
              .fundraiserDetails
              .beneficiaryBank;
          _bankController.text = LoginModel()
              .itemDetailResponseInEditMode
              .fundraiserDetails
              .beneficiaryBank;
        }
      }
    }
  }

  Widget _buildBankInfo(BankInfo bankInfo) {
    if (bankInfo != null) {
      return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 25),
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildBankDetail("Bank", "${bankInfo.bANK}"),
            _buildBankDetail("Branch", "${bankInfo.bRANCH}"),
            _buildBankDetail("District", "${bankInfo.dISTRICT}"),
            _buildBankDetail("Address", "${bankInfo.aDDRESS}"),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  _buildBankDetail(String label, String val) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
      alignment: FractionalOffset.centerLeft,
      child: Text(
        "$label  :  $val",
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 12.0,
            height: 1.2),
      ),
    );
  }

  void checkIfsc() async {
    var isDataFetched = await _ifscBloc.getBankInfo(_code.trim().toUpperCase());
    if (isDataFetched != null) {
      if (isDataFetched) {

        if (_bankInfoReceived != null) {
          _bankController.text = _bankInfoReceived.bANK;
          _bank = _bankInfoReceived.bANK;
        }

        LoginModel().startFundraiserMap["beneficiary_account_name"] =
            _accName.trim();
        LoginModel().startFundraiserMap["beneficiary_account_number"] =
            _accNumber.trim();
        LoginModel().startFundraiserMap["beneficiary_bank"] =
            _bankInfoReceived.bANK;
        LoginModel().startFundraiserMap["beneficiary_ifsc"] = _code.trim();

        Get.to(() => FormSetPricing());
      } else {
        Fluttertoast.showToast(msg: "Please check your IFSC code");
      }
    } else {
      Fluttertoast.showToast(msg: "Please check your IFSC code");
    }
  }
}
