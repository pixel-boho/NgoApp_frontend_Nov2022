import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';

import 'Fragments/LendHistory.dart';
import 'Fragments/LoanHistory.dart';

class MyLoansScreen extends StatefulWidget {
  // final int fragmentToShow;
  // MyLoansScreen({Key key, @required this.fragmentToShow}) : super(key: key);

  @override
  _MyLoansScreenState createState() => _MyLoansScreenState();
}

class _MyLoansScreenState extends State<MyLoansScreen>
    with SingleTickerProviderStateMixin {
  var selectedTabPos = 0;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    // selectedTabPos = widget.fragmentToShow != null ? widget.fragmentToShow : 0;
    // _tabController.animateTo(selectedTabPos);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0), // here the desired height
          child: CommonAppBar(
            text: selectedTabPos == 0 ? "My Loans History" : "My Lend History",
            buttonHandler: () {
              Get.back();
            },
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              constraints: BoxConstraints.expand(height: 55),
              child: BottomAppBar(
                child: _tabs(),
                color: Colors.white,
              ),
            ),
            Expanded(
              child: selectedTabPos == 0 ? LoanHistory() : LendHistory(),
              flex: 1,
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: CommonWidgets().showHelpDesk(),
        ),
      ),
    );
  }

  Widget _tabs() {
    return TabBar(
      controller: _tabController,
      onTap: (int index) {
        if (mounted) {
          setState(() {
            selectedTabPos = index;
          });
        }
      },
      tabs: [
        Tab(
          child: _tabItem('Loans'),
        ),
        Tab(
          child: _tabItem('Lend'),
        )
      ],
      labelColor: Color(colorCoderRedBg),
      unselectedLabelColor: Color(colorCoderItemSubTitle),
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: Colors.red,
      indicatorWeight: 3,
      indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
          insets: selectedTabPos == 0
              ? EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 2.0)
              : EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 2.0)),
    );
  }

  Row _tabItem(String title) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 13,
                fontWeight: FontWeight.w600),
          ),
        ]);
  }
}
