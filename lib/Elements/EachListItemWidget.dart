import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/EnumValues.dart';
import 'package:ngo_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Models/FundraiserItem.dart';
import 'package:share/share.dart';

import '../Screens/Lend/PaymentInputAmountScreen.dart';

class EachListItemWidget extends StatefulWidget {
  final Function buttonHandler;
  final int itemPosition;
  final scrollType;
  final FundraiserItem _fundraiserItem;
  final String imageBase;
  final String webBase;

  EachListItemWidget(this.buttonHandler, this.itemPosition, this.scrollType,
      this._fundraiserItem, this.imageBase, this.webBase);

  @override
  _EachListItemWidgetState createState() => _EachListItemWidgetState();
}

class _EachListItemWidgetState extends State<EachListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: MediaQuery.of(context).size.height * .45,
        width: widget.scrollType == ScrollType.Horizontal
            ? MediaQuery.of(context).size.width > 600
                ? MediaQuery.of(context).size.width * .65
                : MediaQuery.of(context).size.width * .85
            : double.infinity,
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
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
                child: SizedBox.expand(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl:
                          getUrl(widget.imageBase, widget._fundraiserItem),
                      placeholder: (context, url) => Center(
                        child: RoundedLoader(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.black12,
                        child: Image(
                          image: AssetImage('assets/images/no_image.png'),
                          height: double.infinity,
                          width: double.infinity,
                        ),
                        padding: EdgeInsets.all(5),
                      ),
                    ),
                  ),
                ),
              ),
              flex: 1,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              alignment: FractionalOffset.centerLeft,
              child: Text(
                getTitle(widget._fundraiserItem),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Color(colorCoderItemTitle),
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0),
              ),
            ),
            Visibility(
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                alignment: FractionalOffset.centerLeft,
                child: Text(
                  "Donations per month(Rs)",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Color(colorCoderItemSubTitle),
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0),
                ),
              ),
              visible: false,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              alignment: FractionalOffset.center,
              child: Row(
                children: [
                  Expanded(
                    child: _buildInfo("Raised", _getRaisedFund()),
                    flex: 1,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: _buildInfo("Goal", _getRequiredFund()),
                    flex: 1,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              alignment: FractionalOffset.center,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45.0,
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: CommonButton(
                          buttonText: "Donate Now",
                          bgColorReceived: Color(colorCoderRedBg),
                          borderColorReceived: Color(colorCoderRedBg),
                          textColorReceived: Color(colorCodeWhite),
                          buttonHandler: () {
                            if (widget._fundraiserItem != null) {
                              if (widget._fundraiserItem.isAmountCollected ==
                                  1) {
                                Fluttertoast.showToast(
                                    msg:
                                        "Successfully collected the required amount, thank you");
                              } else {
                                if (CommonMethods().isAuthTokenExist()) {
                                  Get.to(() => PaymentInputAmountScreen(
                                      paymentType: PaymentType.Donation,
                                      id: widget._fundraiserItem.id,
                                      amount:
                                          widget._fundraiserItem.fundRequired -
                                              widget._fundraiserItem.fundRaised,
                                      isCampaignRelated:
                                          widget._fundraiserItem.isCampaign == 1
                                              ? true
                                              : false));
                                } else {
                                  CommonWidgets().showSignUpWarningDialog(
                                      "Do you want to sign-in or do the donation without sign-in?",
                                      AssetImage(
                                          'assets/images/ic_notification_message.png'),
                                      CommonMethods().alertLoginOkClickFunction,
                                      _redirectToDonate,
                                      false);
                                }
                              }
                            }
                          }),
                    ),
                    flex: 1,
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      width: 45,
                      height: 55,
                      child: Image.asset("assets/images/ic_share.png"),
                    ),
                    onTap: () {
                      print("share clicked");
                      if (widget.webBase != null) {
                        if (widget.webBase != "") {
                          if (widget._fundraiserItem != null) {
                            String url =
                                widget.webBase + "${widget._fundraiserItem.id}";
                            Share.share('check out this on our website $url',
                                subject: 'Look what what we have!');
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        widget.buttonHandler(widget._fundraiserItem.id);
      },
    );
  }

  _buildInfo(String label, String fund) {
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
              "₹ $fund",
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

  getUrl(String imageBase, FundraiserItem fundraiserItem) {
    String img = "";
    if (fundraiserItem != null &&
        (imageBase ?? '').isNotEmpty &&
        (fundraiserItem.imageUrl ?? '').isNotEmpty) {
      img = imageBase + fundraiserItem.imageUrl;
    }
    return img;
  }

  String getTitle(FundraiserItem fundraiserItem) {
    if (fundraiserItem != null) {
      if (fundraiserItem.title != null) {
        return fundraiserItem.title;
      }
    }

    return "";
  }

  String _getRaisedFund() {
    if (widget._fundraiserItem != null) {
      if (widget._fundraiserItem.fundRaised != null) {
        return CommonMethods().convertAmount(widget._fundraiserItem.fundRaised);
      }
    }
    return "n/a";
  }

  String _getRequiredFund() {
    if (widget._fundraiserItem != null) {
      if (widget._fundraiserItem.fundRequired != null) {
        return CommonMethods()
            .convertAmount(widget._fundraiserItem.fundRequired);
      }
    }
    return "n/a";
  }

  _redirectToDonate() {
    Get.back();
    Get.to(() => PaymentInputAmountScreen(
        paymentType: PaymentType.Donation,
        id: widget._fundraiserItem.id,
        amount: widget._fundraiserItem.fundRequired -
            widget._fundraiserItem.fundRaised,
        isCampaignRelated:
            widget._fundraiserItem.isCampaign == 1 ? true : false));
  }
}
