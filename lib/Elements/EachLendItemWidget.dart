import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/EnumValues.dart';
import 'package:ngo_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Models/LendListResponse.dart';
import 'package:ngo_app/Screens/Lend/PaymentInputAmountScreen.dart';

class EachLendItemWidget extends StatefulWidget {
  final Function onTap;
  final LendListItem lendListItem;
  final String imageBase;

  EachLendItemWidget(
    this.imageBase,
    this.lendListItem,
    this.onTap,
  );

  @override
  _EachLendItemWidgetState createState() => _EachLendItemWidgetState();
}

class _EachLendItemWidgetState extends State<EachLendItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 00),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.black38,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: MediaQuery.of(context).size.height * .45,
          width: double.maxFinite,
          alignment: FractionalOffset.center,
          padding: EdgeInsets.only(bottom: 10),
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
                            '${widget.imageBase}${widget.lendListItem.imageUrl}',
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
                  '${widget.lendListItem.title}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Color(colorCoderItemTitle),
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                alignment: FractionalOffset.center,
                child: Row(
                  children: [
                    // Expanded(
                    //   child: _buildInfo("Raised"),
                    //   flex: 1,
                    // ),
                    // SizedBox(
                    //   width: 15,
                    // ),
                    Expanded(
                      child: _buildInfo("Goal"),
                      flex: 1,
                    ),
                  ],
                ),
              ),
              /*Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                alignment: FractionalOffset.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Container(
                        height: 45.0,
                        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: CommonButton(
                            buttonText: "Lend",
                            bgColorReceived: Color(colorCoderRedBg),
                            borderColorReceived: Color(colorCoderRedBg),
                            textColorReceived: Color(colorCodeWhite),
                            buttonHandler: () {
                              Get.to(() => PaymentInputAmountScreen(
                                  paymentType: PaymentType.Lend,
                                  id: widget.lendListItem.id,
                                  amount: widget.lendListItem.amount));
                            }),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 45.0,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: CommonButton(
                            buttonText: "Complete The Loan",
                            bgColorReceived: Color(colorCodeWhite),
                            borderColorReceived: Color(colorCoderRedBg),
                            textColorReceived: Color(colorCoderRedBg),
                            buttonHandler: () {
                             // Get.to(()=>LendInputAmountScreen(paymentType:PaymentType.Lend, lendId: widget.lendListItem.id,amount:0));
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
                      onTap: () {},
                    ),
                  ],
                ),
              ),*/
            ],
          ),
        ),
        onTap: widget.onTap,
      ),
    );
  }

  _buildInfo(String label) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(colorCoderTextGrey), width: 0.5),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            alignment: FractionalOffset.center,
            child: Text(
              "₹ ${CommonMethods().convertAmount(widget.lendListItem.amount)}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Color(colorCoderItemTitle),
                  fontWeight: FontWeight.w600,
                  fontSize: 13.0),
            ),
          ),
          Container(
            // alignment: FractionalOffset.center,
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
}
