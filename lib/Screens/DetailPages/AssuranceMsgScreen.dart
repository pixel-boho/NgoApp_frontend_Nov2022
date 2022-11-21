import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';

class AssuranceMsgScreen extends StatefulWidget {
  @override
  _AssuranceMsgScreenState createState() => _AssuranceMsgScreenState();
}

class _AssuranceMsgScreenState extends State<AssuranceMsgScreen> {
  String msg1 =
      "Our promise that this NGO can be trusted with your donations and utilize the funds raised to provide benefits to the right people";

  String msg2 = "Our Due Deligence process includes the following: ";

  String title1 = "Legal";
  String subTitle1 = "NGO is verified as valid Tax exempted organisation";

  String title2 = "Compliance";
  String subTitle2 =
      "NGO has submitted audited financial files, tax returns and meets statuatory norms";

  String title3 = "Monitoring & Evaluation";
  String subTitle3 = "NGO is verified as valid Tax exempted organisation";

  String title4 = "Costing Validation";
  String subTitle4 =
      "Crowd Works India Foundation has validated that the donation ask is based on actual expenses";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: null,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.black12.withOpacity(0.5),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
            padding: EdgeInsets.fromLTRB(25, 40, 25, 40),
            child: Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color(colorCodeGreyPageBg),
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
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: FractionalOffset.topLeft,
                              padding: EdgeInsets.fromLTRB(5, 5, 2, 15),
                              child: Image(
                                image: AssetImage('assets/images/ic_group.png'),
                                height: 50,
                                width: 150,
                              ),
                            ),
                            flex: 1,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(
                              Icons.close,
                              size: 25,
                              color: Colors.white30,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        alignment: FractionalOffset.centerLeft,
                        child: Text(
                          "$msg1",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13.0,
                              color: Colors.white70,
                              height: 1.8),
                        ),
                      ),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.white30,
                        margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        alignment: FractionalOffset.centerLeft,
                        child: Text(
                          "$msg2",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13.0,
                              color: Colors.white70,
                              height: 1.8),
                        ),
                      ),
                      _buildInfo("$title1", "$subTitle1",
                          AssetImage('assets/images/ic_legal.png')),
                      _buildInfo("$title2", "$subTitle2",
                          AssetImage('assets/images/ic_compliance.png')),
                      _buildInfo("$title3", "$subTitle3",
                          AssetImage('assets/images/ic_monitoring.png')),
                      _buildInfo("$title4", "$subTitle4",
                          AssetImage('assets/images/ic_costing.png')),
                      SizedBox(height: 20,)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildInfo(String title, String subTitle, AssetImage assetImage) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        subtitle: Text(
          subTitle,
          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: Colors.white70),
        ),
        leading: Image(
          image: assetImage,
          height: 35.0,
          width: 35.0,
        ),
      ),
    );
  }
}
