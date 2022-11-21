import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:ngo_app/Blocs/CommonBloc.dart';
import 'package:ngo_app/Blocs/DetailBloc.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/EnumValues.dart';
import 'package:ngo_app/Constants/StringConstants.dart';
import 'package:ngo_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:ngo_app/CustomLibraries/TextDrawable/TextDrawableWidget.dart';
import 'package:ngo_app/CustomLibraries/TextDrawable/color_generator.dart';
import 'package:ngo_app/Elements/CommentItemWidget.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Elements/DonorOrSupporterItem.dart';
import 'package:ngo_app/Elements/EachListItemWidget.dart';
import 'package:ngo_app/Interfaces/RefreshPageListener.dart';
import 'package:ngo_app/Models/CommonResponse.dart';
import 'package:ngo_app/Models/DocumentItem.dart';
import 'package:ngo_app/Models/ItemDetailResponse.dart';
import 'package:ngo_app/Screens/Dashboard/Home.dart';
import 'package:ngo_app/Screens/Lend/PaymentInputAmountScreen.dart';
import 'package:ngo_app/Screens/StartFundRaising/FormOne.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';
import 'package:share/share.dart';

import 'AssuranceMsgScreen.dart';
import 'ReportIssueScreen.dart';
import 'ReviewItemScreen.dart';
import 'ViewAllCommentsScreen.dart';
import 'ViewAllDonorsScreen.dart';
import 'ViewAllSupportersScreen.dart';
import 'WebViewContainer.dart';
import 'cancelRequestScreen.dart';

class ItemDetailScreen extends StatefulWidget {
  var fundraiserIdReceived;
  var fromPage;

  ItemDetailScreen(this.fundraiserIdReceived, {this.fromPage});

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen>
    with RefreshPageListener {
  DetailBloc _detailBloc;
  CommonBloc _commonBloc;
  var documentToRemove;
  ItemDetailResponse itemInfoFetched;

  @override
  void initState() {
    LoginModel().isFundraiserEditMode = false;
    LoginModel().relatedItemsList.clear();
    super.initState();
    CommonMethods().setRefreshFilterPageListener(this);
    _detailBloc = new DetailBloc();
    _detailBloc.getDetail(widget.fundraiserIdReceived);
    _commonBloc = new CommonBloc();
  }

  @override
  void dispose() {
    _detailBloc.dispose();
    LoginModel().itemDetailResponseInEditMode = null;
    super.dispose();
  }

  void _backPressFunction() {
    print("_function clicked");
    LoginModel().isFundraiserEditMode = false;
    LoginModel().itemDetailResponseInEditMode = null;
    if (widget.fromPage != null) {
      if (widget.fromPage == FromPage.EditFundraiserPage) {
        Get.offAll(() => DashboardScreen(
              fragmentToShow: 3,
            ));
      } else if (widget.fromPage == FromPage.FromPushNotification) {
        Get.offAll(() => DashboardScreen(
              fragmentToShow: 0,
            ));
      } else {
        Get.back();
      }
    } else {
      Get.back();
    }
  }

  Future<bool> onWillPop() {
    _backPressFunction();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.green,
            onRefresh: () {
              return _detailBloc.getDetail(widget.fundraiserIdReceived);
            },
            child: Container(
              color: Colors.transparent,
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: StreamBuilder<ApiResponse<ItemDetailResponse>>(
                  stream: _detailBloc.detailStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data.status) {
                        case Status.LOADING:
                          return Column(
                            children: [
                              _buildAppBar(),
                              Expanded(
                                child: CommonApiLoader(),
                                flex: 1,
                              )
                            ],
                          );
                          break;
                        case Status.COMPLETED:
                          itemInfoFetched = snapshot.data.data;
                          return _buildUserWidget(snapshot.data.data);
                          break;
                        case Status.ERROR:
                          return Column(
                            children: [
                              _buildAppBar(),
                              Expanded(
                                child: CommonApiErrorWidget(
                                    snapshot.data.message,
                                    _errorWidgetFunction),
                                flex: 1,
                              )
                            ],
                          );
                          break;
                      }
                    }
                    return Container(
                      child: Center(
                        child: Text(""),
                      ),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  void _errorWidgetFunction() {
    if (_detailBloc != null) {
      _detailBloc.getDetail(widget.fundraiserIdReceived);
    }
  }

  _buildUserWidget(ItemDetailResponse data) {
    return CustomScrollView(slivers: <Widget>[
      SliverPadding(
        padding: EdgeInsets.fromLTRB(0.0, 0, 0, 70),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildSuccessAppBar(data),
                _buildInfoSection(data),
                _buildAccountDetails(data),
                _buildPersonDetails(true, data),
                _buildPersonDetails(false, data),
                _buildStorySection(data),
                _buildDocumentsSection(data),
                _buildDonorInfo(data),
                _buildSupporterInfo(data),
                _buildReviewSection(data),
                _buildCommentButton(data),
                _buildRecommendedSection()
              ],
            ),
          ]),
        ),
      )
    ]);
  }

  _buildInfoSection(ItemDetailResponse data) {
    return Container(
      width: double.infinity,
      alignment: FractionalOffset.center,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      margin: EdgeInsets.fromLTRB(10, 10, 10, 00),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl:
                        getImage(data.baseUrl, data.fundraiserDetails.imageUrl),
                    placeholder: (context, url) => Center(
                      child: RoundedLoader(),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.black12,
                      child: Image(
                        image: AssetImage('assets/images/no_image.png'),
                        width: double.infinity,
                        height: 200,
                      ),
                      margin: EdgeInsets.all(0),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: FractionalOffset.topRight,
                child: Padding(
                  child: InkWell(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/images/ic_group.png'),
                          height: 40,
                          width: 100,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Image(
                          image: AssetImage('assets/images/ic_info.png'),
                          height: 25,
                          width: 25,
                        )
                      ],
                    ),
                    onTap: () {
                      Get.to(() => AssuranceMsgScreen(),
                          opaque: false, fullscreenDialog: true);
                    },
                  ),
                  padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 12, 10, 5),
            alignment: FractionalOffset.centerLeft,
            child: Text(
              "${data.fundraiserDetails.title}",
              style: TextStyle(
                  color: Color(colorCoderItemTitle),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0),
            ),
          ),
          _buildShareOptions(data),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            alignment: FractionalOffset.center,
            child: Row(
              children: [
                Expanded(
                  child: _buildAmountInfo(
                      "Raised", data.fundraiserDetails.fundRaised),
                  flex: 1,
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: _buildAmountInfo(
                      "Goal", data.fundraiserDetails.fundRequired),
                  flex: 1,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
            alignment: FractionalOffset.center,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    alignment: FractionalOffset.centerLeft,
                    child: Text(
                      CommonMethods().getDateDifference(
                          data.fundraiserDetails.closingDate),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color(colorCoderItemSubTitle),
                          fontWeight: FontWeight.w500,
                          fontSize: 11.0),
                    ),
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    alignment: FractionalOffset.centerLeft,
                    child: Text(
                      data.supporters.length != 1
                          ? "${data.supporters.length} Supporters"
                          : "${data.supporters.length} Supporter",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color(colorCoderItemSubTitle),
                          fontWeight: FontWeight.w500,
                          fontSize: 11.0),
                    ),
                  ),
                  flex: 1,
                ),
              ],
            ),
          ),
          Visibility(
            child: Container(
              height: 45.0,
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: CommonButton(
                  buttonText: "Donate Now",
                  bgColorReceived: Color(colorCoderRedBg),
                  borderColorReceived: Color(colorCoderRedBg),
                  textColorReceived: Color(colorCodeWhite),
                  buttonHandler: () {
                    if (data.fundraiserDetails.isAmountCollected == 1) {
                      Fluttertoast.showToast(
                          msg:
                              "Successfully collected the required amount, thank you");
                    } else {
                      if (CommonMethods().isAuthTokenExist()) {
                        Get.to(() => PaymentInputAmountScreen(
                            paymentType: PaymentType.Donation,
                            id: widget.fundraiserIdReceived,
                            amount: data.fundraiserDetails.fundRequired -
                                data.fundraiserDetails.fundRaised,
                            isCampaignRelated:
                                data.fundraiserDetails.isCampaign == 1
                                    ? true
                                    : false));
                      } else {
                        /*CommonWidgets().showCommonDialog(
                            "You need to login before use this feature!!",
                            AssetImage(
                                'assets/images/ic_notification_message.png'),
                            CommonMethods().alertLoginOkClickFunction,
                            false,
                            true);*/

                        CommonWidgets().showSignUpWarningDialog(
                            "Do you want to sign-in or do the donation without sign-in?",
                            AssetImage(
                                'assets/images/ic_notification_message.png'),
                            CommonMethods().alertLoginOkClickFunction,
                            _redirectToDonate,
                            false);
                      }
                    }
                  }),
            ),
            visible: !CommonMethods()
                    .checkIsOwner(data.fundraiserDetails?.createdBy) &&
                data.fundraiserDetails?.isApproved == 1 &&
                data.fundraiserDetails?.isCancelled == 0,
          ),
          Visibility(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: 45.0,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: CommonButton(
                        buttonText: "Transfer Amount",
                        bgColorReceived: Color(colorCoderRedBg),
                        borderColorReceived: Color(colorCoderRedBg),
                        textColorReceived: Color(colorCodeWhite),
                        buttonHandler: () {
                          if (data.fundraiserDetails?.fundRaised != 0) {
                            CommonWidgets().showCommonDialog(
                                "Are you sure you, you want to transfer now?",
                                AssetImage(
                                    'assets/images/ic_notification_message.png'),
                                _transferFundraiserAmount,
                                false,
                                true);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Raised amount must be greater than zero");
                          }
                        }),
                  ),
                  flex: 1,
                ),
                /*Expanded(
                  child: Container(
                    height: 45.0,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(5, 10, 10, 0),
                    child: CommonButton(
                        buttonText: "Withdraw",
                        bgColorReceived: Color(colorCodeGreyPageBg),
                        borderColorReceived: Color(colorCodeGreyPageBg),
                        textColorReceived: Color(colorCodeWhite),
                        buttonHandler: () {}),
                  ),
                  flex: 1,
                )*/
              ],
            ),
            visible: CommonMethods()
                    .checkIsOwner(data.fundraiserDetails?.createdBy) &&
                data.fundraiserDetails?.isApproved == 1,
          ),
          Visibility(
            child: Container(
              height: 45.0,
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: CommonButton(
                  buttonText: "Cancel",
                  bgColorReceived: Color(colorCoderRedBg),
                  borderColorReceived: Color(colorCoderRedBg),
                  textColorReceived: Color(colorCodeWhite),
                  buttonHandler: () async {
                    final isCancelOptionAdded = await Get.to(
                        () => CancelRequestScreen(widget.fundraiserIdReceived),
                        opaque: false,
                        fullscreenDialog: true);
                    print("*****");
                    print("$isCancelOptionAdded");
                    if (mounted && isCancelOptionAdded != null) {
                      if (isCancelOptionAdded) {
                        _detailBloc.getDetail(widget.fundraiserIdReceived);
                      }
                    }
                  }),
            ),
            visible: CommonMethods()
                    .checkIsOwner(data.fundraiserDetails?.createdBy) &&
                data.fundraiserDetails?.isApproved == 1 &&
                data.fundraiserDetails?.isCancelled == 0,
          ),
          _buildReportOption(data),
          _buildCancelledAlert(data),
        ],
      ),
    );
  }

  _buildAmountInfo(String label, int fund) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(colorCoderTextGrey), width: 0.5),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            alignment: FractionalOffset.center,
            child: Text(
              "₹ ${CommonMethods().convertAmount(fund)}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Color(colorCoderItemTitle),
                  fontWeight: FontWeight.w600,
                  fontSize: 13.0),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            alignment: FractionalOffset.center,
            child: Text(
              "$label",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Color(colorCoderItemSubTitle),
                  fontWeight: FontWeight.w500,
                  fontSize: 11.0),
            ),
          ),
        ],
      ),
    );
  }

  _buildShareOptions(ItemDetailResponse data) {
    return Container(
      alignment: FractionalOffset.center,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Wrap(
        direction: Axis.horizontal,
        //alignment: WrapAlignment.center,
        spacing: 15.0,
        runAlignment: WrapAlignment.spaceBetween,
        runSpacing: 10.0,
        crossAxisAlignment: WrapCrossAlignment.center,
        // textDirection: TextDirection.rtl,
        // verticalDirection: VerticalDirection.up,
        children: <Widget>[
          InkWell(
            child: Image(
              image: AssetImage("assets/images/ic_share.png"),
              height: 40.0,
              width: 40.0,
            ),
            onTap: () {
              _shareYourInfo(data);
            },
          ),
          InkWell(
            child: Image(
              image: AssetImage("assets/images/ic_whatsapp.png"),
              height: 40.0,
              width: 40.0,
            ),
            onTap: () {
              _shareYourInfo(data);
            },
          ),
          InkWell(
            child: Image(
              image: AssetImage("assets/images/ic_facebook.png"),
              height: 40.0,
              width: 40.0,
            ),
            onTap: () {
              _shareYourInfo(data);
            },
          ),
          InkWell(
            child: Image(
              image: AssetImage("assets/images/ic_instagram.png"),
              height: 40.0,
              width: 40.0,
            ),
            onTap: () {
              _shareYourInfo(data);
            },
          ),
          InkWell(
            child: Image(
              image: AssetImage("assets/images/ic_linkedin.png"),
              height: 40.0,
              width: 40.0,
            ),
            onTap: () {
              _shareYourInfo(data);
            },
          ),
          InkWell(
            child: Image(
              image: AssetImage("assets/images/ic_twitter.png"),
              height: 40.0,
              width: 40.0,
            ),
            onTap: () {
              _shareYourInfo(data);
            },
          ),
        ],
      ),
    );
  }

  _buildAccountDetails(ItemDetailResponse data) {
    return Container(
      alignment: FractionalOffset.center,
      padding: EdgeInsets.fromLTRB(0, 20, 0, 25),
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
            margin: EdgeInsets.fromLTRB(15, 0, 10, 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRect(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Image(
                      image: AssetImage("assets/images/ic_account.png"),
                      height: 25.0,
                      width: 25.0,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    alignment: FractionalOffset.centerLeft,
                    child: Text(
                      "Transfer to this bank account",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.0),
                    ),
                  ),
                  flex: 1,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
            alignment: FractionalOffset.centerLeft,
            child: Text(
              "A/c No.  :  ${data.fundraiserDetails.virtualAccountNumber}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.0),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
            alignment: FractionalOffset.centerLeft,
            child: Text(
              "A/c Name  :  ${data.fundraiserDetails.virtualAccountName}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.0),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
            alignment: FractionalOffset.centerLeft,
            child: Text(
              "A/c Type  :  ${data.fundraiserDetails.virtualAccountType}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.0),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
            alignment: FractionalOffset.centerLeft,
            child: Text(
              "IFSC      :  ${data.fundraiserDetails.virtualAccountIfsc}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }

  _buildPersonDetails(bool isCampaigner, ItemDetailResponse data) {
    if (!isCampaigner && data.fundraiserDetails.isCampaign == 1) {
      return Container();
    } else {
      return Container(
        alignment: FractionalOffset.center,
        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              alignment: FractionalOffset.centerLeft,
              child: Text(
                isCampaigner ? "Campaigner Details" : "Beneficiary Details",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 13.0),
              ),
            ),
            Container(
              alignment: FractionalOffset.center,
              padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
                      child: Container(
                        width: 60,
                        height: 60,
                        child: CachedNetworkImage(
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          imageUrl: getImage(
                              isCampaigner
                                  ? data.campaignerBaseUrl
                                  : data.baseUrl,
                              isCampaigner
                                  ? data.campaignerDetails?.imageUrl
                                  : data.fundraiserDetails?.beneficiaryImage),
                          placeholder: (context, url) => Center(
                            child: RoundedLoader(),
                          ),
                          errorWidget: (context, url, error) =>
                              TextDrawableWidget(
                                  isCampaigner
                                      ? "${data.campaignerDetails?.name}"
                                      : "${data.fundraiserDetails?.patientName}",
                                  ColorGenerator.materialColors,
                                  (bool selected) {
                            // on tap callback
                            print("on tap callback");
                          },
                                  false,
                                  60.0,
                                  60.0,
                                  BoxShape.rectangle,
                                  TextStyle(
                                      color: Colors.white, fontSize: 17.0)),
                        ),
                      )),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                          alignment: FractionalOffset.centerLeft,
                          child: Text(
                            isCampaigner
                                ? "${data.campaignerDetails?.name}"
                                : "${data.fundraiserDetails?.patientName}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13.0),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                          alignment: FractionalOffset.centerLeft,
                          child: Text(
                            isCampaigner
                                ? "${data.campaignerDetails?.email}"
                                : "${data.fundraiserDetails?.email}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 13.0),
                          ),
                        ),
                      ],
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  _buildStorySection(ItemDetailResponse data) {
    return Card(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ExpansionTile(
        title: Text(
          "Story",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
            alignment: FractionalOffset.centerLeft,
            child: Text(
              "${data.fundraiserDetails.story}",
              style: TextStyle(
                  fontWeight: FontWeight.w400, fontSize: 13.0, height: 1.8),
            ),
          ),
        ],
      ),
    );
  }

  _buildDonorInfo(ItemDetailResponse data) {
    if (data.topDonors != null) {
      if (data.topDonors.length > 0) {
        return Card(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: ExpansionTile(
            title: Text(
              "Top Donors",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
            children: <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: data.topDonors.length,
                itemBuilder: (context, index) {
                  return Container(
                    alignment: FractionalOffset.center,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: DonorOrSupporterItem(
                        data.topDonorsBaseUrl, data.topDonors[index]),
                  );
                },
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  elevation: 0.0,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                ),
                onPressed: () {
                  Get.to(
                      () => ViewAllDonorsScreen(widget.fundraiserIdReceived));
                },
                child: Text(
                  "View All",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(colorCoderRedBg),
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  _buildSupporterInfo(ItemDetailResponse data) {
    if (data.supporters != null) {
      if (data.supporters.length > 0) {
        return Card(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: ExpansionTile(
            title: Text(
              "Supporters (${data.supportersCount})",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
            children: <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: data.supporters.length,
                itemBuilder: (context, index) {
                  return Container(
                    alignment: FractionalOffset.center,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: DonorOrSupporterItem(
                        data.supportersBaseUrl, data.supporters[index]),
                  );
                },
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  elevation: 0.0,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                ),
                onPressed: () {
                  Get.to(() =>
                      ViewAllSupportersScreen(widget.fundraiserIdReceived));
                },
                child: Text(
                  "View All",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(colorCoderRedBg),
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  _buildReviewSection(ItemDetailResponse data) {
    if (data.comments != null) {
      if (data.comments.length > 0) {
        return Card(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: ExpansionTile(
            title: Text(
              "Comments",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
            children: <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: data.comments.length,
                itemBuilder: (context, index) {
                  return Container(
                    alignment: FractionalOffset.center,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: CommentItemWidget(
                        data.commentsBaseUrl, data.comments[index]),
                  );
                },
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(),
                    flex: 1,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      elevation: 0.0,
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    ),
                    onPressed: () {
                      Get.to(() =>
                          ViewAllCommentsScreen(widget.fundraiserIdReceived));
                    },
                    child: Text(
                      "View All",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(colorCoderRedBg),
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  _buildDocumentsSection(ItemDetailResponse data) {
    if (CommonMethods().checkIsOwner(data.fundraiserDetails?.createdBy)) {
      if (data.fundraiserDocuments != null) {
        if (data.fundraiserDocuments.length > 0) {
          return _buildDocumentsWithItemsSection(data);
        } else {
          return _buildDocumentsWithOutItemsSection(data);
        }
      } else {
        return _buildDocumentsWithOutItemsSection(data);
      }
    } else {
      if (data.fundraiserDocuments != null) {
        if (data.fundraiserDocuments.length > 0) {
          return _buildDocumentsWithItemsSection(data);
        } else {
          return Container();
        }
      } else {
        return Container();
      }
    }
  }

  _buildDocumentsWithItemsSection(ItemDetailResponse data) {
    return Card(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ExpansionTile(
        title: Text(
          "Documents",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        children: <Widget>[
          Container(
            child: Wrap(
                direction: Axis.horizontal,
                // alignment: WrapAlignment.center,
                spacing: 30.0,
                runAlignment: WrapAlignment.spaceAround,
                runSpacing: 30.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                // textDirection: TextDirection.rtl,
                // verticalDirection: VerticalDirection.up,
                children: [
                  for (var docItem in data.fundraiserDocuments)
                    _buildDocumentItem(docItem, data.documentBaseUrl, data)
                ]),
          ),
          SizedBox(
            width: 5,
          ),
          Visibility(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(),
                  flex: 1,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    elevation: 0.0,
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  ),
                  onPressed: _openFileExplorer,
                  child: Text(
                    "Add New",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  width: 15,
                )
              ],
            ),
            visible:
                CommonMethods().checkIsOwner(data.fundraiserDetails?.createdBy),
          ),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }

  _buildDocumentsWithOutItemsSection(ItemDetailResponse data) {
    return Card(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ExpansionTile(
        title: Text(
          "Documents",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        children: <Widget>[
          Visibility(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(),
                  flex: 1,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    elevation: 0.0,
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  ),
                  onPressed: _openFileExplorer,
                  child: Text(
                    "Add New",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  width: 15,
                )
              ],
            ),
            visible:
                CommonMethods().checkIsOwner(data.fundraiserDetails?.createdBy),
          ),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }

  _buildDocumentItem(
      DocumentItem documentItem, String urlBase, ItemDetailResponse data) {
    return Padding(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: new BoxDecoration(
                      border: Border.all(
                          width: 0.3, color: Color(colorCoderBorderWhite)),
                      borderRadius: new BorderRadius.all(Radius.circular(10.0)),
                      shape: BoxShape.rectangle,
                      color: Colors.black12),
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  alignment: FractionalOffset.center,
                  child: InkWell(
                    onTap: () {
                      print(urlBase + documentItem.docUrl);
                      String downloadUrl = urlBase + documentItem.docUrl;
                      if (urlBase != null && documentItem.docUrl != null) {
                        if (urlBase != "" && documentItem.docUrl != "") {
                          Get.to(() => WebViewContainer(downloadUrl));
                        }
                      }
                    },
                    child: Stack(
                      children: [
                        Image(
                          image: AssetImage('assets/images/ic_file.png'),
                          height: double.infinity,
                          width: double.infinity,
                        ),
                        Center(
                          child: IconButton(
                            iconSize: 18,
                            icon: Icon(
                              Icons.remove_red_eye_outlined,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  child: Positioned(
                    top: 0.0,
                    right: 0.0,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: InkWell(
                        child: Image.asset(
                          'assets/images/ic_close_round.png',
                          width: 30.0,
                          height: 30.0,
                        ),
                        onTap: () {
                          documentToRemove = documentItem.id;
                          CommonWidgets().showCommonDialog(
                              "Are you sure you, you want to remove this document?",
                              AssetImage(
                                  'assets/images/ic_notification_message.png'),
                              _removeDocument,
                              false,
                              true);
                        },
                      ),
                    ),
                  ),
                  visible: CommonMethods()
                      .checkIsOwner(data.fundraiserDetails?.createdBy),
                ),
              ],
            )
          ],
        ),
      ),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
    );
  }

  String getImage(String baseUrl, String imgUrl) {
    String img = "";
    if (baseUrl != null) {
      if (baseUrl != "") {
        if (imgUrl != null) {
          if (imgUrl != "") {
            img = baseUrl + imgUrl;
          }
        }
      }
    }
    return img;
  }

  _buildCommentButton(ItemDetailResponse data) {
    if (CommonMethods().isAuthTokenExist() &&
        data.fundraiserDetails?.isApproved == 1) {
      return Container(
        margin: EdgeInsets.fromLTRB(5, 15, 10, 5),
        alignment: FractionalOffset.bottomRight,
        child: FloatingActionButton.extended(
          label: Text('Comment'),
          icon: Icon(Icons.chat),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          onPressed: () async {
            final isReviewAdded = await Get.to(
                () => ReviewItemScreen(widget.fundraiserIdReceived),
                opaque: false,
                fullscreenDialog: true);
            print("*****");
            print("$isReviewAdded");
            if (mounted && isReviewAdded != null) {
              if (isReviewAdded) {
                _detailBloc.getDetail(widget.fundraiserIdReceived);
              }
            }
          },
        ),
      );
    } else {
      return Container();
    }
  }

  void _removeDocument() {
    var bodyParams = {};
    bodyParams["fundraiser_id"] = widget.fundraiserIdReceived;
    bodyParams["id"] = documentToRemove;

    CommonWidgets().showNetworkProcessingDialog();
    _commonBloc.removeDocument(json.encode(bodyParams)).then((value) {
      Get.back();
      CommonResponse commonResponse = value;
      if (commonResponse.success) {
        documentToRemove = null;
        Fluttertoast.showToast(msg: commonResponse.message);
        if (_detailBloc != null) {
          _detailBloc.getDetail(widget.fundraiserIdReceived);
        }
      } else {
        Fluttertoast.showToast(
            msg: commonResponse.message ?? StringConstants.apiFailureMsg);
      }
    }).catchError((err) {
      CommonWidgets().showNetworkErrorDialog(err?.toString());
    });
  }

  _openFileExplorer() async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'pdf', 'doc'],
          allowMultiple: false);
      if (result != null) {
        File tempFile = File(result.files.single.path);
        var formData = FormData();
        formData.fields
          ..add(MapEntry("fundraiser_id", "${widget.fundraiserIdReceived}"));
        String fileName = tempFile.path.split('/').last;
        String mimeType = mime(fileName);
        String mimee = mimeType.split('/')[0];
        String type = mimeType.split('/')[1];
        formData.files.addAll([
          MapEntry(
            "upload_document",
            MultipartFile.fromFileSync(tempFile.path,
                filename: fileName, contentType: MediaType(mimee, type)),
          )
        ]);

        CommonWidgets().showNetworkProcessingDialog();
        _commonBloc.uploadDocument(formData).then((value) {
          Get.back();
          CommonResponse commonResponse = value;
          if (commonResponse.success) {
            Fluttertoast.showToast(msg: commonResponse.message);
            if (_detailBloc != null) {
              _detailBloc.getDetail(widget.fundraiserIdReceived);
            }
          } else {
            Fluttertoast.showToast(
                msg: commonResponse.message ?? StringConstants.apiFailureMsg);
          }
        }).catchError((err) {
          CommonWidgets().showNetworkErrorDialog(err?.toString());
        });
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
      Fluttertoast.showToast(msg: "Unable to add documents");
    }
  }

  Widget _buildAppBar() {
    return Container(
      color: Color(colorCoderRedBg),
      height: 60,
      child: CommonAppBar(
        text: "",
        buttonHandler: _backPressFunction,
      ),
    );
  }

  _buildSuccessAppBar(ItemDetailResponse data) {
    return Container(
      color: Color(colorCoderRedBg),
      height: 65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: CommonAppBar(
              text: "",
              buttonHandler: _backPressFunction,
            ),
            flex: 1,
          ),
          Visibility(
            child: CommonButton(
                buttonText: "Edit",
                bgColorReceived: Color(colorCoderRedBg),
                borderColorReceived: Color(colorCodeWhite),
                textColorReceived: Color(colorCodeWhite),
                buttonHandler: () {
                  if (data.success) {
                    LoginModel().isFundraiserEditMode = true;
                    LoginModel().itemDetailResponseInEditMode = data;

                    LoginModel().startFundraiserMap["campaignSelected"] =
                        data.campaignDetail;
                    LoginModel().startFundraiserMap["campaign_id"] =
                        data.campaignDetail.id;
                    Get.to(() => FormOneScreen());
                  }
                }),
            visible:
                CommonMethods().checkIsOwner(data.fundraiserDetails?.createdBy),
          ),
          SizedBox(
            width: 5,
          )
        ],
      ),
    );
  }

  _transferFundraiserAmount() {
    Get.back();
    var bodyParams = {};
    bodyParams["id"] = widget.fundraiserIdReceived;

    CommonWidgets().showNetworkProcessingDialog();
    _commonBloc.transferAmount(json.encode(bodyParams)).then((value) {
      Get.back();
      CommonResponse commonResponse = value;
      if (commonResponse.success) {
        Fluttertoast.showToast(msg: commonResponse.message);
        Get.back(result: {'isFundraiserWithdrawn': true});
      } else {
        Fluttertoast.showToast(
            msg: commonResponse.message ?? StringConstants.apiFailureMsg);
      }
    }).catchError((err) {
      CommonWidgets().showNetworkErrorDialog(err?.toString());
    });
  }

  void _shareYourInfo(ItemDetailResponse data) {
    if (data.webBaseUrl != null) {
      if (data.webBaseUrl != "") {
        if (data.fundraiserDetails != null) {
          String url = data.webBaseUrl + "${data.fundraiserDetails.id}";
          Share.share('check out this on our website $url',
              subject: 'Look what what we have!');
        }
      }
    }
  }

  _buildRecommendedSection() {
    if (LoginModel().relatedItemsList != null) {
      if (LoginModel().relatedItemsList.length > 0) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          alignment: FractionalOffset.centerLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      alignment: FractionalOffset.centerLeft,
                      child: Text(
                        "Related",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color(colorCodeBlack),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600),
                      ),
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    ),
                    flex: 1,
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * .45,
                alignment: FractionalOffset.centerLeft,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: LoginModel().relatedItemsList.length,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                    itemBuilder: (BuildContext ctx, int index) {
                      return EachListItemWidget(
                          openDetailPage,
                          index,
                          ScrollType.Horizontal,
                          LoginModel().relatedItemsList[index],
                          LoginModel().relatedItemsImageBase,
                          LoginModel().relatedItemsWebBaseUrl);
                    }),
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  openDetailPage(int itemId) async {
    print("Clicked on : $itemId");
    // Get.to(() => ItemDetailScreen(itemId));
    widget.fundraiserIdReceived = itemId;
    widget.fromPage = "";
    _detailBloc.getDetail(itemId);
  }

  @override
  void refreshPage() {
    if (mounted) {
      setState(() {
        print("${LoginModel().relatedItemsList.length}");
        print("PageRefreshed");
      });
    }
  }

  _redirectToDonate() {
    Get.back();
    if (itemInfoFetched != null) {
      if (itemInfoFetched.fundraiserDetails != null) {
        Get.to(() => PaymentInputAmountScreen(
            paymentType: PaymentType.Donation,
            id: widget.fundraiserIdReceived,
            amount: itemInfoFetched.fundraiserDetails.fundRequired -
                itemInfoFetched.fundraiserDetails.fundRaised,
            isCampaignRelated: itemInfoFetched.fundraiserDetails.isCampaign == 1
                ? true
                : false));
      } else {
        Fluttertoast.showToast(
            msg: "Sorry unable to process your request, try again later!");
      }
    } else {
      Fluttertoast.showToast(
          msg: "Sorry unable to process your request, try again later!");
    }
  }

  _buildReportOption(ItemDetailResponse data) {
    if (CommonMethods().checkIsOwner(data.fundraiserDetails?.createdBy)) {
      return Container();
    } else {
      return Container(
        padding: EdgeInsets.fromLTRB(12, 15, 12, 10),
        alignment: FractionalOffset.centerLeft,
        child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(children: [
              TextSpan(
                text:
                    "Note: If you feel anything suspicious regarding this!, feel free to  ",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                  text: "Report Here",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      print("******1");
                      Get.to(() => ReportIssueScreen(
                          CommonMethods().isAuthTokenExist(),
                          widget.fundraiserIdReceived));
                    }),
            ])),
      );
    }
  }

  _buildCancelledAlert(ItemDetailResponse data) {
    if (CommonMethods().isAuthTokenExist() &&
        data.fundraiserDetails?.isCancelled == 1) {
      return Container(
          padding: EdgeInsets.fromLTRB(12, 15, 12, 10),
          alignment: FractionalOffset.centerLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(children: [
                    TextSpan(
                      text: "Warning:  ",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: "Cancelled",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.red,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ])),
              SizedBox(
                height: 5,
              ),
              Visibility(
                child: Text(
                  "${data.fundraiserDetails?.cancelReason}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500),
                ),
                visible: data.fundraiserDetails?.cancelReason != "",
              )
            ],
          )
          /*child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(children: [
              TextSpan(
                text:
                "Warning: Currently this fundraiser has been cancelled",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ])),*/
          );
    } else {
      return Container();
    }
  }
}
