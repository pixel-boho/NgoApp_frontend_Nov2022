import 'package:flutter/material.dart';
import 'package:ngo_app/Constants/StringConstants.dart';


class FundScreen extends StatefulWidget {
  @override
  _FundScreenState createState() => _FundScreenState();
}

class _FundScreenState extends State<FundScreen>  {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 15),
              padding: EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                children: [
                  Text("What is Crowdfunding?", style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 18.0),),
                  SizedBox(height: MediaQuery.of(context).size.height * .01),
                  Text("In its simplest form, Crowdfunding is a practice of giving monetary funds to overcome specific social,cultural, or economic hurdles individuals face in their daily lives.",
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,style: TextStyle(height: 1.5),
                  ),
                ],
              ),),
            Container(
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
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    alignment: FractionalOffset.centerLeft,
                    child: Text(
                      "${StringConstants.fundInfo}",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 13.0, height: 1.8),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .01),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }




}
