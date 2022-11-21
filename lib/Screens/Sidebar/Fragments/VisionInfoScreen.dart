import 'package:flutter/material.dart';
import 'package:ngo_app/Constants/StringConstants.dart';

class VisionInfoScreen extends StatefulWidget {
  @override
  _VisionInfoScreenState createState() => _VisionInfoScreenState();
}

class _VisionInfoScreenState extends State<VisionInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Container(
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
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          margin: EdgeInsets.fromLTRB(10, 15, 10, 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              /*Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                alignment: FractionalOffset.centerLeft,
                child: Text(
                  "ABOUT US",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13.0, height: 1.8),
                ),
              ),*/
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                alignment: FractionalOffset.centerLeft,
                child: Text(
                  "${StringConstants.aboutUsInfo}",
                  style: TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 13.0, height: 1.8),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                alignment: FractionalOffset.centerLeft,
                child: Text(
                  "VISION",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13.0, height: 1.8),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                alignment: FractionalOffset.centerLeft,
                child: Text(
                  "${StringConstants.visionInfo}",
                  style: TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 13.0, height: 1.8),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                alignment: FractionalOffset.centerLeft,
                child: Text(
                  "MISSION",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13.0, height: 1.8),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                alignment: FractionalOffset.centerLeft,
                child: Text(
                  "${StringConstants.missionInfo}",
                  style: TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 13.0, height: 1.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
