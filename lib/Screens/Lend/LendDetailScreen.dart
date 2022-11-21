
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Blocs/LoanLendDetailsBloc.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/EnumValues.dart';
import 'package:ngo_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Models/LoanLendDetailsResponse.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';
import 'package:ngo_app/Utilities/DateHelper.dart';
import 'package:share/share.dart';

import 'CreateLendScreen.dart';
import 'PaymentInputAmountScreen.dart';

class LendDetailScreen extends StatefulWidget {
  final int id;

  const LendDetailScreen({Key key, @required this.id}) : super(key: key);

  @override
  _LendDetailScreenState createState() => _LendDetailScreenState();
}

class _LendDetailScreenState extends State<LendDetailScreen> {
  LoanLendDetailsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = LoanLendDetailsBloc();
    _bloc.getDetails(widget.id);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
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
              return _bloc.getDetails(widget.id);
            },
            child: Container(
              color: Colors.transparent,
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: StreamBuilder<ApiResponse<LoanLendDetailsResponse>>(
                  stream: _bloc.detailStream,
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
                    return Container();
                  }),
            ),
          ),
        ),
      ),
    );
  }

  void _backPressFunction() {
    print("_function clicked");
    Get.back();
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

  _buildUserWidget(LoanLendDetailsResponse response) {
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
                _buildSuccessAppBar(response),
                _buildInfoSection(response),
                _buildDescription(response.loanDetails.description),
              ],
            ),
          ]),
        ),
      )
    ]);
  }

  _buildSuccessAppBar(LoanLendDetailsResponse data) {
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
                    Get.to(() => CreateLendScreen(
                          isEditMode: true,
                          infoReceived: data,
                        ));
                  }
                }),
            visible: CommonMethods().checkIsOwner(data.loanDetails.createdBy),
          ),
          SizedBox(
            width: 5,
          )
        ],
      ),
    );
  }

  _buildInfoSection(LoanLendDetailsResponse response) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 10),
      margin: EdgeInsets.fromLTRB(10, 10, 10, 00),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
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
                    '${response.baseUrl}${response.loanDetails?.imageUrl}',
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
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            alignment: FractionalOffset.centerLeft,
            child: Text(
              '${response.loanDetails?.title ?? ''}',
              style: TextStyle(
                  color: Color(colorCoderItemTitle),
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            alignment: FractionalOffset.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_pin,
                  color: Colors.blueGrey,
                  size: 18,
                ),
                Expanded(
                  child: Text(
                    '${response.loanDetails.location}',
                    style: TextStyle(
                        color: Color(colorCoderItemSubTitle),
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0),
                  ),
                  flex: 1,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
            alignment: FractionalOffset.centerLeft,
            child: Text(
              'Purpose: ${response.loanDetails.purpose}',
              style: TextStyle(
                  color: Color(colorCoderItemSubTitle),
                  fontWeight: FontWeight.w500,
                  fontSize: 12.0),
            ),
          ),
          _buildShareOptions(response),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            alignment: FractionalOffset.center,
            child: Row(
              children: [
                Expanded(
                  child: _buildAmountInfo("Raised", response.fundRaised),
                  flex: 1,
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: _buildAmountInfo("Goal", response.loanDetails.amount),
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
                      _closingDate(response.loanDetails.closingDate),
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
          /*Row(
            children: [
              Expanded(
                child: Container(
                  height: 45.0,
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(10, 10, 5, 0),
                  child: CommonButton(
                      buttonText: "Lend",
                      bgColorReceived: Color(colorCoderRedBg),
                      borderColorReceived: Color(colorCoderRedBg),
                      textColorReceived: Color(colorCodeWhite),
                      buttonHandler: () {
                        initPayment(0);
                      }),
                ),
                flex: 1,
              ),
              Expanded(
                child: Container(
                  height: 45.0,
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(5, 10, 10, 0),
                  child: CommonButton(
                      buttonText: "Complete Loan",
                      bgColorReceived: Color(colorCodeWhite),
                      borderColorReceived: Color(colorCoderRedBg),
                      textColorReceived: Color(colorCoderRedBg),
                      buttonHandler: () {
                        if (response.loanDetails.amount <=
                            response.fundRaised) {
                          return;
                        }
                        initPayment(
                            response.loanDetails.amount - response.fundRaised);
                      }),
                ),
                flex: 1,
              ),
            ],
          )*/
        ],
      ),
    );
  }

  _closingDate(String date) {
    DateTime closingDate = DateHelper.parseDateTime(date, 'yyyy-MM-dd');

    return closingDate.isBefore(DateTime.now())
        ? 'Date: ${DateHelper.getFormattedDateTimeString(closingDate, 'dd-MMM-yyyy')}'
        : "${closingDate.difference(DateTime.now()).inDays} Days left";
  }

  initPayment(int amount) async {
    bool b = await Get.to(() => PaymentInputAmountScreen(
        paymentType: PaymentType.Lend, id: widget.id, amount: amount));

    if (b ?? false) {
      _bloc.getDetails(widget.id);
    }
  }

  _buildAmountInfo(String label, int amount) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color(colorCoderTextGrey), width: 0.5),
          borderRadius: BorderRadius.circular(10)),
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 5),
            alignment: FractionalOffset.center,
            child: Text(
              "₹ ${CommonMethods().convertAmount(amount)}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Color(colorCoderItemTitle),
                  fontWeight: FontWeight.w600,
                  fontSize: 13.0),
            ),
          ),
          Container(
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

  _buildShareOptions(LoanLendDetailsResponse data) {
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
            onTap: () async {
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
            onTap: () async {
              _shareYourInfo(data);
            },
          ),
        ],
      ),
    );
  }

  void _shareYourInfo(LoanLendDetailsResponse data) {
    if (data.webBaseUrl != null) {
      if (data.webBaseUrl != "") {
        if (data.loanDetails != null) {
          String url = data.webBaseUrl + "${data.loanDetails.id}";
          Share.share('check out this on our website $url',
              subject: 'Look what what we have!');
        }
      }
    }
  }

  _buildDescription(String description) {
    return Container(
      alignment: FractionalOffset.center,
      padding: EdgeInsets.fromLTRB(10, 20, 10, 25),
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Text(
              "Description",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.0),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Text(
              '$description',
              style: TextStyle(
                  fontWeight: FontWeight.w400, fontSize: 13.0, height: 1.8),
            ),
          ),
        ],
      ),
    );
  }

  void _errorWidgetFunction() {
    if (_bloc != null) _bloc.getDetails(widget.id);
  }
}
