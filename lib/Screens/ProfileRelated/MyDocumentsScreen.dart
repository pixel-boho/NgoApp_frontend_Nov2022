import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:ngo_app/Screens/ProfileRelated/Fragments/DocumentScreen.dart';
import 'package:ngo_app/Screens/ProfileRelated/Fragments/PancardDocument.dart';

class MyDocumentsScreen extends StatefulWidget {
  @override
  MyDocumentsScreen({Key key, this.userid, this.url}) : super(key: key);
  final userid;
  final url;
  _MyDocumentsScreenState createState() => _MyDocumentsScreenState();
}

class _MyDocumentsScreenState extends State<MyDocumentsScreen>
    with SingleTickerProviderStateMixin{
  var selectedTabPos = 0;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.animateTo(selectedTabPos);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // here the desired height
            child: CommonAppBar(
              text: "Documents",
              buttonHandler: _backPressFunction,
            ),
          ),
          body: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                constraints: BoxConstraints.expand(height: 55),
                child: BottomAppBar(
                  child: infoTabs(),
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: getSubFragment(selectedTabPos),
                flex: 1,
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: CommonWidgets().showHelpDesk(),
          ),
        ),
      ),
    );
  }

  void _backPressFunction() {
    print("_sendOtpFunction clicked");
    Get.back();
  }

  Future<bool> onWillPop() {
    return Future.value(true);
  }

  infoTabs() {
    return TabBar(
      controller: _tabController,
      onTap: tabItemClicked,
      tabs: [
        Tab(
          child: tabItem(context, 'Pan Card'),
        ),
        Tab(
          child: tabItem(context, 'All documents'),
        ),
      ],
      labelColor: Color(colorCoderRedBg),
      unselectedLabelColor: Color(colorCoderItemSubTitle),
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: Colors.red,
      indicatorWeight: 3,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Colors.red, width: 2.0),
        insets: getIndicatorPadding(),
      ),
    );
  }

  getIndicatorPadding() {
    if (selectedTabPos == 0) {
      return EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 2.0);
    } else {
      return EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 2.0);
    }
  }

  Row tabItem(BuildContext context, var title) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11,
                  fontWeight: FontWeight.w600),
            ),
            flex: 2,
          ),
        ]);
  }


  void tabItemClicked(int index) {
    if (mounted) {
      setState(() {
        selectedTabPos = index;
      });
    }
  }

  getSubFragment(int pos) {
    switch (pos) {
      case 0:
        return PanCardScreen(url:widget.url,userid:widget.userid);
        break;
      case 1:
        return DocumentScreen();
        break;
      default:
        return new Center(
          child: Text("Error"),
        );
    }
  }

}
