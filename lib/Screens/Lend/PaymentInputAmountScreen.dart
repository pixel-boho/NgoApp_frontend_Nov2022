import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/EnumValues.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Screens/MakeDonation/AddDonorInfoScreen.dart';
import 'PaymentScreen.dart';

class PaymentInputAmountScreen extends StatefulWidget {
  final PaymentType paymentType;
  final int id;
  final int amount;
  final bool isCampaignRelated;
  final bool isForNgoTrust;

  const PaymentInputAmountScreen(
      {Key key,
      @required this.paymentType,
      @required this.id,
      this.amount = 0,
      this.isCampaignRelated = false,
      this.isForNgoTrust = false})
      : super(key: key);

  @override
  _PaymentInputAmountScreenState createState() =>
      _PaymentInputAmountScreenState('$amount');
}

class _PaymentInputAmountScreenState extends State<PaymentInputAmountScreen> {
  _PaymentInputAmountScreenState(this._amount);

  String _amount;


  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  bool _isSubscriptionAvailable = false;

  @override
  void initState() {
    super.initState();
    _textEditingController.text = "0";
    if (_amount == '0') {
      _textEditingController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: 1,
      );
    } else if (widget.paymentType == PaymentType.Lend) {
      _textEditingController.selection =
          TextSelection.fromPosition(TextPosition(offset: _amount.length));
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        FocusScope.of(context).requestFocus(FocusNode());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _blankFocusNode = new FocusNode();
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(colorCodeGreyPageBg),
      resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // here the desired height
            child: CommonAppBar(
              text: "Donate",
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
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * .02),
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
                  SizedBox(height: MediaQuery.of(context).size.height * .01),
                  _buildAmountTypingSection(),
                  SizedBox(height: MediaQuery.of(context).size.height * .01),
                  Visibility(
                    child: _buildSubscribeSection(),
                    visible: widget.isCampaignRelated &&
                        CommonMethods().isAuthTokenExist(),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .04),
                ],
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
    ));
  }

  Future<void> _nextBtnClickFunction() async {
    _amount = _textEditingController.text;

    if (_amount.isNotEmpty && int.parse(_amount) > 0) {
      if (widget.paymentType == PaymentType.Donation && !widget.isForNgoTrust) {
        if (widget.amount < int.parse(_amount)) {
          _textEditingController.text = "${widget.amount}";
          Fluttertoast.showToast(
              msg:
                  'Please note just Rs.${widget.amount} more needed, Thank you');
          return;
        }
      }

      PaymentInfo paymentInfo = PaymentInfo(
          paymentType: widget.paymentType,
          id: widget?.id ?? null,
          amount: _amount,
          isSubscriptionNeeded: _isSubscriptionAvailable);

      if (widget.paymentType == PaymentType.Lend) {
        CommonWidgets().show80GFormAlertDialog(context, paymentInfo);
        // Navigator.of(context).push(PageRouteBuilder(opaque: false, pageBuilder: (_, __, ___) => PaymentScreen(paymentInfo: paymentInfo,)));
      } else if (widget.paymentType == PaymentType.Donation) {
        Get.to(() => AddDonorInfoScreen(paymentInfo: paymentInfo));
      } else {
        //neglect
      }
    } else {
      Fluttertoast.showToast(msg: 'Please provide a valid amount');
    }
  }

  Future<bool> onWillPop() {
    CommonWidgets().showDonationAlertDialog();
    return Future.value(false);
  }

  void _backPressFunction() {
    print("_sendOtpFunction clicked");
    Get.back();
  }

  _buildAmountTypingSection() {
    return GestureDetector(
      child: Container(
        alignment: FractionalOffset.center,
        height: 180,
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 25),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Color(colorCoderGreyBg),
          border: Border.all(color: Color(colorCoderBorderWhite), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: IntrinsicWidth(
          child: TextField(
            autofocus: true,
            focusNode: _focusNode,
            controller: _textEditingController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.numberWithOptions(
              decimal: false,
              signed: true,
            ),
            maxLines: 1,
            minLines: 1,
            maxLength: 7,
            onChanged: (val) => _amount = val,
            style: TextStyle(
                fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              counterText: '',
              prefix: Text(
                '₹ ',
                style: TextStyle(
                    fontSize: 30,
                    // height: 1.8,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
    );
  }




  _buildSubscribeSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                activeColor: Colors.red,
                value: _isSubscriptionAvailable,
                onChanged: (val) {
                  _setSubscription();
                },
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Do you want to subscribe?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Color(colorCodeWhite),
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Subscribe will auto deduct the amount monthly!!!",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11.0,
                        color: Color(colorCodeWhite),
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              flex: 1,
            )
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .02),
      ],
    );
  }

  void _setSubscription() {
    if (_isSubscriptionAvailable == false) {
      setState(() {
        _isSubscriptionAvailable = true;
      });
    } else if (_isSubscriptionAvailable == true) {
      setState(() {
        _isSubscriptionAvailable = false;
      });
    }
  }
}
