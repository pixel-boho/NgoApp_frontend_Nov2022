import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Elements/CommonButton.dart';

import 'AddDonorInfoScreen.dart';

class DonationAmountScreen extends StatefulWidget {
  @override
  _DonationAmountScreenState createState() => _DonationAmountScreenState();
}

class _DonationAmountScreenState extends State<DonationAmountScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _amount;
  bool _autoValidate = false;
  List<String> amountsInfo = [
    "₹ 1000",
    "₹ 2000",
    "₹ 3000",
    "₹ 4000",
    "₹ 5000",
    "₹ 6000",
    "₹ 7000",
    "₹ 8000",
    "₹ 9000"
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
                            "Donate",
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
                            CommonWidgets().showDonationAlertDialog();
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
                    // autovalidate: _autoValidate,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          alignment: FractionalOffset.center,
                          child: Text(
                            "Choose a donation amount",
                            style: TextStyle(
                                color: Color(colorCoderBorderWhite),
                                fontWeight: FontWeight.w600,
                                fontSize: 15.0),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                        _buildAmountTypingSection(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .04),
                        _buildAmountSuggestions(),
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

  void _nextBtnClickFunction() {
    print("_clearBtnClickFunction clicked");
    Get.to(() => AddDonorInfoScreen());
  }

  Future<bool> onWillPop() {
    CommonWidgets().showDonationAlertDialog();
    return Future.value(false);
  }

  _buildAmountTypingSection() {
    return Padding(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 200,
          maxWidth: 300,
          minHeight: 200,
        ),
        child: Container(
          alignment: FractionalOffset.center,
          padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
          decoration: BoxDecoration(
            color: Color(colorCoderGreyBg),
            border: Border.all(color: Color(colorCoderBorderWhite), width: 1),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
          child: TextFormField(
            onChanged: (val) => _amount = val,
            keyboardType: TextInputType.number,
            maxLines: 1,
            maxLength: 9,
            minLines: 1,
            style: TextStyle(
                fontSize: 20.0,
                height: 1.8,
                color: Colors.white,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              fillColor: Color(colorCoderGreyBg),
              filled: true,
              hintText: "Amount(₹)",
              hintStyle: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white30,
                  fontWeight: FontWeight.w600),
              counterText: "",
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(15.0, 12, 10.0, 12),
            ),
          ),
        ),
      ),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
    );
  }

  _buildAmountSuggestions() {
    return Container(
      child: Wrap(
          direction: Axis.horizontal,
          // alignment: WrapAlignment.center,
          spacing: 30.0,
          runAlignment: WrapAlignment.spaceAround,
          runSpacing: 30.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          // textDirection: TextDirection.rtl,
          // verticalDirection: VerticalDirection.up,
          children: [for (var data in amountsInfo) _buildAmountItem(data)]),
    );
  }

  _buildAmountItem(String data) {
    return Padding(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
              child: Container(
                decoration: new BoxDecoration(
                    border:
                        Border.all(width: 0.3, color: Color(colorCodeWhite)),
                    borderRadius: new BorderRadius.all(Radius.circular(10.0)),
                    shape: BoxShape.rectangle,
                    color: Color(colorCoderRedBg)),
                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                alignment: FractionalOffset.center,
                child: Text(
                  "$data",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(colorCodeWhite),
                  ),
                ),
              ),
              onTap: () {},
            )
          ],
        ),
      ),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
    );
  }
}
