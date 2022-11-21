import 'package:flutter/material.dart';

class LegalInfoScreen extends StatefulWidget {
  @override
  _LegalInfoScreenState createState() => _LegalInfoScreenState();
}

class _LegalInfoScreenState extends State<LegalInfoScreen> {
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
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                alignment: FractionalOffset.centerLeft,
                child: Text(
                  "Legal & Financial",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13.0, height: 1.8),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                alignment: FractionalOffset.centerLeft,
                child: Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. ",
                  style: TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 13.0, height: 1.8),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .02),
            ],
          ),
        ),
      ),
    );
  }
}
