import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';

import 'Fragments/LegalInfoScreen.dart';
import 'Fragments/OurInfoScreen.dart';
import 'Fragments/VisionInfoScreen.dart';

class AboutUsScreen extends StatefulWidget {
  final int fragmentToShow;

  AboutUsScreen({Key key, @required this.fragmentToShow}) : super(key: key);

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen>
    with SingleTickerProviderStateMixin {
  var selectedTabPos = 0;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
    selectedTabPos = widget.fragmentToShow != null ? widget.fragmentToShow : 0;
    _tabController.animateTo(selectedTabPos);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: null,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // here the desired height
            child: CommonAppBar(
              text: "About Us",
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

  infoTabs() {
    return TabBar(
      controller: _tabController,
      onTap: tabItemClicked,
      tabs: [
        Tab(
          child: tabItem(context, 'About Us'),
        ),
        Tab(
          child: tabItem(context, 'Legal'),
        ),
        Tab(
          child: tabItem(context, 'Our Team'),
        )
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
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
            flex: 1,
          ),
        ]);
  }

  /*
    While clicking a tab item
   */
  void tabItemClicked(int index) {
    if (mounted) {
      setState(() {
        selectedTabPos = index;
      });
    }
  }

  /*
    Show appropriate fragment based on selected tabs
   */
  getSubFragment(int pos) {
    switch (pos) {
      case 0:
        return VisionInfoScreen();
        break;
      case 1:
        return LegalInfoScreen();
        break;
      case 2:
        return OurInfoScreen();
        break;

      default:
        return new Center(
          child: Text("Error"),
        );
    }
  }
}
