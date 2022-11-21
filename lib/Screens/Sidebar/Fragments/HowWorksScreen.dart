import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:ngo_app/Blocs/PricingBloc.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:ngo_app/Models/PricingStrategiesResponse.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';

class HowWorksScreen extends StatefulWidget {
  @override
  _HowWorksScreenState createState() => _HowWorksScreenState();
}

class _HowWorksScreenState extends State<HowWorksScreen> {
  @override
  PricingBloc _pricingBloc;

  @override
  void initState() {
    super.initState();
    _pricingBloc = new PricingBloc();
    _pricingBloc.getItems(false);
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
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              children: [
                _buildFundraiserInfo(),
                SizedBox(
                  height: 10,
                ),
                _buildDonationInfo(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: CommonWidgets().showHelpDesk(),
          ),
        ),
      ),
    );
  }


  Future<bool> onWillPop() {
    return Future.value(true);
  }

  _buildFundraiserInfo() {
    return Card(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ExpansionTile(
        title: Text(
          "How to start a fundraiser!",
          style: TextStyle(
              fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            alignment: FractionalOffset.centerLeft,
            child: Text(
              "How crowd funding works..",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.0,
                  color: Color(colorCoderItemTitle)),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            alignment: FractionalOffset.centerLeft,
            child: Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.0,
                  height: 1.8,
                  color: Color(colorCoderItemSubTitle)),
            ),
          ),
          _buildInfo("01", "Sign up or login if not", AssetImage('assets/images/ic_login_step.png')),
          _buildInfo("02", "Enter OTP", AssetImage('assets/images/ic_otp_step.png')),
          _buildInfo("03", "Click Start a Fundraiser", AssetImage('assets/images/ic_start_fundraiser_step.png')),
          _buildInfo("04", "Choose your purpose", AssetImage('assets/images/ic_choose_purpose.png')),
          _buildInfo("05", "Enter Personal Details", AssetImage('assets/images/ic_personal_details_step.png')),
          _buildInfo("06", "Enter Beneficiary Details", AssetImage('assets/images/ic_beneficiary_step.png')),
          _buildInfo("07", "Add Account Details", AssetImage('assets/images/ic_account_step.png')),
          _buildInfo("08", "Upload Image and Other Details", AssetImage('assets/images/ic_upload_step.png')),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  _buildDonationInfo() {
    return Card(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          "How to initiate a Donation!",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13.0,
              color: Color(colorCoderItemTitle)),
        ),
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            alignment: FractionalOffset.centerLeft,
            child: Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.0,
                  height: 1.8,
                  color: Color(colorCoderItemSubTitle)),
            ),
          ),
          _buildInfo("01", "Sign up or login if you wish, then follow steps else skip step 2", AssetImage('assets/images/ic_login_step.png')),
          _buildInfo("02", "Enter OTP", AssetImage('assets/images/ic_otp_step.png')),
          _buildInfo("03", "Click Donate Now Button", AssetImage('assets/images/ic_choose_purpose.png')),
          _buildInfo("04", "Choose or Type the Donation Amount", AssetImage('assets/images/ic_donation_step.png')),
          _buildInfo("05", "Choose Payment option", AssetImage('assets/images/ic_pay_step.png')),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  _buildInfo(String title, String subTitle, AssetImage assetImage) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w800, color: Colors.black45),
        ),
        subtitle: Text(
          subTitle,
          style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600, color: Color(colorCoderItemSubTitle)),
        ),
        leading: Image(
          image: assetImage,
          height: 40.0,
          width: 40.0,
        ),
      ),
    );
  }
}
