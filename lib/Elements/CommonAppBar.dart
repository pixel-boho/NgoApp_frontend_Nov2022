import 'package:flutter/material.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';

class CommonAppBar extends StatelessWidget {
  final String text;
  final Function buttonHandler;

  CommonAppBar({this.text, this.buttonHandler});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: Color(colorCoderRedBg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 5,
          ),
          IconButton(
            icon: Image.asset(
              'assets/images/ic_back.png',
              width: 35.0,
              height: 35.0,
            ),
            onPressed: buttonHandler,
          ),
          Expanded(
            child: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                alignment: FractionalOffset.centerLeft,
                child: Text("$text",
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600))),
            flex: 1,
          )
        ],
      ),
    );
  }
}
