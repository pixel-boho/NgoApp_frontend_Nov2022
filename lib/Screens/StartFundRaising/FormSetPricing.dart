import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:mime_type/mime_type.dart';
import 'package:ngo_app/Blocs/CommonBloc.dart';
import 'package:ngo_app/Blocs/PricingBloc.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/EnumValues.dart';
import 'package:ngo_app/Constants/StringConstants.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Models/CampaignItem.dart';
import 'package:ngo_app/Models/CommonResponse.dart';
import 'package:ngo_app/Models/PricingStrategiesResponse.dart';
import 'package:ngo_app/Screens/Dashboard/Home.dart';
import 'package:ngo_app/Screens/DetailPages/ItemDetailScreen.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';
import 'package:http_parser/http_parser.dart';

class FormSetPricing extends StatefulWidget {
  const FormSetPricing({Key key}) : super(key: key);

  @override
  _FormSetPricingState createState() => _FormSetPricingState();
}

class _FormSetPricingState extends State<FormSetPricing> {
  PricingBloc _pricingBloc;
  int value;
  PricingInfo selectedPricingInfo;
  CommonBloc _commonBloc;

  @override
  void initState() {
    super.initState();
    _pricingBloc = new PricingBloc();
    _pricingBloc.getItems(true);
    _commonBloc = new CommonBloc();
  }

  @override
  void dispose() {
    _pricingBloc.dispose();
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
            preferredSize: Size.fromHeight(65.0), // here the desired height
            child: CommonAppBar(
              text: "Start a Fundraiser",
              buttonHandler: _backPressFunction,
            ),
          ),
          body: Container(
            color: Colors.transparent,
            height: double.infinity,
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .02),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: FractionalOffset.centerLeft,
                  child: Text(
                    "Pricing Strategies",
                    style: TextStyle(
                        color: Color(colorCoderBorderWhite),
                        fontWeight: FontWeight.w600,
                        fontSize: 15.0),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .02),
                Expanded(
                  child: StreamBuilder<ApiResponse<PricingStrategiesResponse>>(
                    stream: _pricingBloc.pricingStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data.status) {
                          case Status.LOADING:
                            return CommonApiLoader();
                            break;
                          case Status.COMPLETED:
                            return Column(
                              children: [
                                _buildPricingStrategies(_pricingBloc.pricingList),
                              ],
                            );
                            break;
                          case Status.ERROR:
                            return CommonApiErrorWidget(
                                snapshot.data.message, _errorWidgetFunction,
                                textColorReceived: Colors.white);
                            break;
                        }
                      }
                      return Container();
                    },
                  ),
                  flex: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * .06),
                    Icon(Icons.warning_amber_rounded,color: Colors.yellow,size: 20,),
                    SizedBox(width: MediaQuery.of(context).size.width * .03),
                    Text("Bank charges deducted",style: TextStyle(color: Colors.white,fontSize: 10,
                        fontWeight: FontWeight.w500),),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .04),

              ],
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

  void _backPressFunction() {
    print("_sendOtpFunction clicked");
    Get.back();
  }

  Widget _buildPricingStrategies(List<PricingInfo> pricingList) {
    if (pricingList != null) {
      if (pricingList.length > 0) {
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: pricingList.length,
          itemBuilder: (context, index) {
            return
              _buildPricingInfo(index, pricingList[index]);
          },
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 70),
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  Widget _buildPricingInfo(int index, PricingInfo pricingInfo) {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
      margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      decoration: BoxDecoration(
        color:
        pricingInfo.isSelected ? Colors.black : Color(colorCodeGreyPageBg),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15)),
        border: Border.all(color: Colors.white, width: 0.5),
      ),
      child: RadioListTile(
        activeColor: Colors.redAccent,
        value: index,
        groupValue: getGroupValue(),
        controlAffinity: ListTileControlAffinity.trailing,
        onChanged: (ind) {
          selectedPricingInfo = pricingInfo;
          for (var dat in _pricingBloc.pricingList) {
            if (dat.id == pricingInfo.id) {
              dat.isSelected = true;
            } else {
              dat.isSelected = false;
            }
          }
          setState(() {
            value = ind;
          });
        },
        title: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: FractionalOffset.centerLeft,
              child: Text(
                pricingInfo.title,
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.0),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              alignment: FractionalOffset.centerLeft,
              child: Text(
                "${pricingInfo.percentage} %",
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.0),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              alignment: FractionalOffset.centerLeft,
              child: Text(
                "${pricingInfo.description}",
                textAlign: TextAlign.left,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 11.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getGroupValue() {
    int val = -1;
    for (int i = 0; i < _pricingBloc.pricingList.length; i++) {
      if (_pricingBloc.pricingList[i].isSelected) {
        val = i;
        break;
      }
    }
    return val;
  }

  Future<bool> onWillPop() {
    return Future.value(true);
  }

  void _errorWidgetFunction() {
    if (_pricingBloc != null) _pricingBloc.getItems(false);
  }

  void _nextBtnClickFunction() {
    print("_clearBtnClickFunction clicked");
    if (LoginModel().isFundraiserEditMode) {
      if (LoginModel().startFundraiserMap != null) {
        if (LoginModel().startFundraiserMap.containsKey("campaignSelected")) {
          CampaignItem campaignItem =
          LoginModel().startFundraiserMap["campaignSelected"];
          callApiToUpdateFundraiser(campaignItem);
        }
      }
    } else {
      if (selectedPricingInfo != null) {
        LoginModel().startFundraiserMap["pricing_id"] = selectedPricingInfo.id;
        if (LoginModel().startFundraiserMap != null) {
          if (LoginModel().startFundraiserMap.containsKey("campaignSelected")) {
            CampaignItem campaignItem =
            LoginModel().startFundraiserMap["campaignSelected"];
            callApiToCreateFundraiser(campaignItem);
          }
        }
      } else {}
    }
  }

  void callApiToUpdateFundraiser(CampaignItem campaignItem) {
    var formData = FormData();

    formData.fields
      ..add(MapEntry("fundraiser_id",
          "${LoginModel().itemDetailResponseInEditMode.fundraiserDetails.id}"));

    if (LoginModel().startFundraiserMap.containsKey("campaign_id")) {
      formData.fields
        ..add(MapEntry("campaign_id",
            "${LoginModel().startFundraiserMap["campaign_id"]}"));
    }

    if (LoginModel().startFundraiserMap.containsKey("name")) {
      formData.fields
        ..add(MapEntry("name", "${LoginModel().startFundraiserMap["name"]}"));
    }

    if (LoginModel().startFundraiserMap.containsKey("email")) {
      formData.fields
        ..add(MapEntry("email", "${LoginModel().startFundraiserMap["email"]}"));
    }

    if (LoginModel().startFundraiserMap.containsKey("phone_number")) {
      formData.fields
        ..add(MapEntry("phone_number",
            "${LoginModel().startFundraiserMap["phone_number"]}"));
    }

    if (LoginModel().startFundraiserMap.containsKey("country_code")) {
      formData.fields
        ..add(MapEntry("country_code",
            "${LoginModel().startFundraiserMap["country_code"]}"));
    }

    if (LoginModel().startFundraiserMap.containsKey("relation_master_id")) {
      formData.fields
        ..add(MapEntry("relation_master_id",
            "${LoginModel().startFundraiserMap["relation_master_id"]}"));
    }

    if (LoginModel().startFundraiserMap.containsKey("patient_name")) {
      formData.fields
        ..add(MapEntry("patient_name",
            "${LoginModel().startFundraiserMap["patient_name"]}"));
    }

    if (LoginModel().startFundraiserMap.containsKey("no_of_days")) {
      formData.fields
        ..add(MapEntry(
            "no_of_days", "${LoginModel().startFundraiserMap["no_of_days"]}"));
    }

    if (campaignItem.isHealthCase == 1) {
      if (LoginModel().startFundraiserMap.containsKey("health_issue")) {
        formData.fields
          ..add(MapEntry("health_issue",
              "${LoginModel().startFundraiserMap["health_issue"]}"));
      }

      if (LoginModel().startFundraiserMap.containsKey("hospital")) {
        formData.fields
          ..add(MapEntry(
              "hospital", "${LoginModel().startFundraiserMap["hospital"]}"));
      }

      if (LoginModel().startFundraiserMap.containsKey("city")) {
        formData.fields
          ..add(MapEntry("city", "${LoginModel().startFundraiserMap["city"]}"));
      }
    }

    if (LoginModel().startFundraiserMap.containsKey("beneficiary_image")) {
      File _beneficiaryImage =
      LoginModel().startFundraiserMap["beneficiary_image"];
      if (_beneficiaryImage != null) {
        formData.files.add(MapEntry(
          "beneficiary_image",
          getImageToPass(_beneficiaryImage),
        ));
      }
    }

    if (LoginModel().startFundraiserMap.containsKey("title")) {
      formData.fields
        ..add(MapEntry("title", LoginModel().startFundraiserMap["title"]));
    }

    if (LoginModel().startFundraiserMap.containsKey("story")) {
      formData.fields
        ..add(MapEntry("story", LoginModel().startFundraiserMap["story"]));
    }

    if (LoginModel().startFundraiserMap.containsKey("fund_required")) {
      formData.fields
        ..add(MapEntry(
            "fund_required", LoginModel().startFundraiserMap["fund_required"]));
    }

    if (LoginModel().startFundraiserMap.containsKey("main_image")) {
      File _mainImage =
      LoginModel().startFundraiserMap.containsKey("main_image")
          ? LoginModel().startFundraiserMap["main_image"]
          : null;
      if (_mainImage != null) {
        formData.files.add(MapEntry(
          "main_image",
          getImageToPass(_mainImage),
        ));
      }
    }

    formData.fields
      ..add(MapEntry("beneficiary_account_name",
          LoginModel().startFundraiserMap["beneficiary_account_name"]));
    formData.fields
      ..add(MapEntry("beneficiary_account_number",
          LoginModel().startFundraiserMap["beneficiary_account_number"]));
    formData.fields
      ..add(MapEntry("beneficiary_bank",
          LoginModel().startFundraiserMap["beneficiary_bank"]));
    formData.fields
      ..add(MapEntry("beneficiary_ifsc",
          LoginModel().startFundraiserMap["beneficiary_ifsc"]));
    if (selectedPricingInfo != null) {
      formData.fields..add(MapEntry("pricing_id", "${selectedPricingInfo.id}"));
    }

    CommonWidgets().showNetworkProcessingDialog();
    _commonBloc.updateFundraiser(formData).then((value) {
      Get.back();
      CommonResponse response = value;
      if (response.success) {
        LoginModel().isFundraiserEditMode = false;
        Fluttertoast.showToast(msg: response.message);
        Get.to(() => ItemDetailScreen(
          LoginModel().itemDetailResponseInEditMode?.fundraiserDetails?.id,
          fromPage: FromPage.EditFundraiserPage,
        ));
      } else {
        Fluttertoast.showToast(
            msg: response.message ?? StringConstants.apiFailureMsg);
      }
    }).catchError((err) {
      Get.back();
      CommonWidgets().showNetworkErrorDialog(err?.toString());
    });
  }

  void callApiToCreateFundraiser(CampaignItem campaignItem) {
    var formData = FormData();
    formData.fields
      ..add(MapEntry(
          "campaign_id",
          LoginModel().startFundraiserMap.containsKey("campaign_id")
              ? "${LoginModel().startFundraiserMap["campaign_id"]}"
              : null));
    formData.fields
      ..add(MapEntry(
          "name",
          LoginModel().startFundraiserMap.containsKey("name")
              ? LoginModel().startFundraiserMap["name"]
              : null));
    formData.fields
      ..add(MapEntry(
          "email",
          LoginModel().startFundraiserMap.containsKey("email")
              ? LoginModel().startFundraiserMap["email"]
              : null));
    formData.fields
      ..add(MapEntry(
          "phone_number",
          LoginModel().startFundraiserMap.containsKey("phone_number")
              ? LoginModel().startFundraiserMap["phone_number"]
              : null));
    formData.fields
      ..add(MapEntry(
          "country_code",
          LoginModel().startFundraiserMap.containsKey("country_code")
              ? LoginModel().startFundraiserMap["country_code"]
              : null));
    formData.fields
      ..add(MapEntry(
          "relation_master_id",
          LoginModel().startFundraiserMap.containsKey("relation_master_id")
              ? "${LoginModel().startFundraiserMap["relation_master_id"]}"
              : null));
    if (campaignItem.isHealthCase == 1) {
      formData.fields
        ..add(MapEntry(
            "patient_name",
            LoginModel().startFundraiserMap.containsKey("patient_name")
                ? LoginModel().startFundraiserMap["patient_name"]
                : null));
      formData.fields
        ..add(MapEntry(
            "no_of_days",
            LoginModel().startFundraiserMap.containsKey("no_of_days")
                ? LoginModel().startFundraiserMap["no_of_days"]
                : null));
      formData.fields
        ..add(MapEntry(
            "health_issue",
            LoginModel().startFundraiserMap.containsKey("health_issue")
                ? LoginModel().startFundraiserMap["health_issue"]
                : null));
      formData.fields
        ..add(MapEntry(
            "hospital",
            LoginModel().startFundraiserMap.containsKey("hospital")
                ? LoginModel().startFundraiserMap["hospital"]
                : null));
      formData.fields
        ..add(MapEntry(
            "city",
            LoginModel().startFundraiserMap.containsKey("city")
                ? LoginModel().startFundraiserMap["city"]
                : null));
    } else {
      formData.fields
        ..add(MapEntry(
            "patient_name",
            LoginModel().startFundraiserMap.containsKey("patient_name")
                ? LoginModel().startFundraiserMap["patient_name"]
                : null));
      formData.fields
        ..add(MapEntry(
            "no_of_days",
            LoginModel().startFundraiserMap.containsKey("no_of_days")
                ? LoginModel().startFundraiserMap["no_of_days"]
                : null));
    }

    File _beneficiaryImage =
    LoginModel().startFundraiserMap.containsKey("beneficiary_image")
        ? LoginModel().startFundraiserMap["beneficiary_image"]
        : null;
    if (_beneficiaryImage != null) {
      formData.files.add(MapEntry(
        "beneficiary_image",
        getImageToPass(_beneficiaryImage),
      ));
    }

    List<File> _documentPaths =
    LoginModel().startFundraiserMap.containsKey("upload_documents")
        ? LoginModel().startFundraiserMap["upload_documents"]
        : null;
    if (_documentPaths != null) {
      for (var imageFile in _documentPaths) {
        String fileName = imageFile.path.split('/').last;
        String mimeType = mime(fileName);
        String mimee = mimeType.split('/')[0];
        String type = mimeType.split('/')[1];
        formData.files.addAll([
          MapEntry(
            "upload_documents[]",
            MultipartFile.fromFileSync(imageFile.path,
                filename: fileName, contentType: MediaType(mimee, type)),
          )
        ]);
      }
    }

    formData.fields
      ..add(MapEntry(
          "title",
          LoginModel().startFundraiserMap.containsKey("title")
              ? LoginModel().startFundraiserMap["title"]
              : null));
    formData.fields
      ..add(MapEntry(
          "story",
          LoginModel().startFundraiserMap.containsKey("story")
              ? LoginModel().startFundraiserMap["story"]
              : null));
    formData.fields
      ..add(MapEntry(
          "fund_required",
          LoginModel().startFundraiserMap.containsKey("fund_required")
              ? LoginModel().startFundraiserMap["fund_required"]
              : null));

    File _mainImage = LoginModel().startFundraiserMap.containsKey("main_image")
        ? LoginModel().startFundraiserMap["main_image"]
        : null;
    if (_mainImage != null) {
      formData.files.add(MapEntry(
        "main_image",
        getImageToPass(_mainImage),
      ));
    }

    formData.fields
      ..add(MapEntry("beneficiary_account_name",
          LoginModel().startFundraiserMap["beneficiary_account_name"]));
    formData.fields
      ..add(MapEntry("beneficiary_account_number",
          LoginModel().startFundraiserMap["beneficiary_account_number"]));
    formData.fields
      ..add(MapEntry("beneficiary_bank",
          LoginModel().startFundraiserMap["beneficiary_bank"]));
    formData.fields
      ..add(MapEntry("beneficiary_ifsc",
          LoginModel().startFundraiserMap["beneficiary_ifsc"]));
    formData.fields..add(MapEntry("pricing_id", "${selectedPricingInfo.id}"));

    CommonWidgets().showNetworkProcessingDialog();
    _commonBloc.createFundraiser(formData).then((value) {
      Get.back();
      CommonResponse response = value;
      if (response.success) {
        CommonWidgets().showCommonDialog(
            "FundRaiser scheme added successfully. Please wait until we verify your documents.",
            AssetImage('assets/images/ic_notification_message.png'),
            _alertOkBtnClickFunction,
            false,
            false);
      } else {
        Fluttertoast.showToast(
            msg: response.message ?? StringConstants.apiFailureMsg);
      }
    }).catchError((err) {
      Get.back();
      CommonWidgets().showNetworkErrorDialog(err?.toString());
    });
  }

  getImageToPass(File image) {
    if (image != null) {
      String fileName = image.path.split('/').last;
      String mimeType = mime(fileName);
      String mimee = mimeType.split('/')[0];
      String type = mimeType.split('/')[1];
      return MultipartFile.fromFileSync(image.path,
          filename: fileName, contentType: MediaType(mimee, type));
    }

    return null;
  }

  void _alertOkBtnClickFunction() {
    print("_alertOkBtnClickFunction clicked");
    Get.offAll(() => DashboardScreen(
      fragmentToShow: 0,
    ));
  }
}
