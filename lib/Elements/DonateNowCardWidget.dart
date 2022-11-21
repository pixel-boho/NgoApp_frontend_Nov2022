import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/EnumValues.dart';
import 'package:ngo_app/Screens/Dashboard/ViewAllScreen.dart';
import 'package:ngo_app/Screens/Lend/PaymentInputAmountScreen.dart';
import 'package:ngo_app/Screens/MakeDonation/DonationAmountScreen.dart';

class DonateNowCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
      decoration: BoxDecoration(
          color: Color(colorCodeWhite),
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
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/images/ic_heart.png'),
            height: 45.0,
            width: 40.0,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Text("Make a\nDifference",
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 13,
                      color: Color(colorCodeGreyPageBg),
                      fontWeight: FontWeight.w600)),
            ),
            flex: 1,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
              ),
              primary: Color(colorCoderRedBg),
              elevation: 0.0,
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              side: BorderSide(
                width: 2.0,
                color: Color(colorCoderRedBg),
              ),
            ),
            onPressed: () {
              Get.to(() => PaymentInputAmountScreen(
                  paymentType: PaymentType.Donation,
                  id: null,
                  isCampaignRelated: true,
                  isForNgoTrust: true));
              //if (CommonMethods().isAuthTokenExist()) {
              /*Get.to(() => ViewAllScreen(
                    isCampaignRelated: true,
                  ));*/
              /*} else {
                CommonWidgets().showCommonDialog(
                    "You need to login before use this feature!!",
                    AssetImage('assets/images/ic_notification_message.png'),
                    CommonMethods().alertLoginOkClickFunction,
                    false,
                    true);
              }*/
            },
            child: Text(
              "Donate Now",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(colorCodeWhite),
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
