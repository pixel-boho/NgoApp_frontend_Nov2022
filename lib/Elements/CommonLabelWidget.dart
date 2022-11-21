import 'package:flutter/material.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';

class CommonLabelWidget extends StatelessWidget {
  final label;

  CommonLabelWidget({this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
      alignment: FractionalOffset.centerLeft,
      child: Text(
        "$label",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: Color(colorCoderBorderWhite),
            fontWeight: FontWeight.w500,
            fontSize: 12.0),
      ),
    );
  }
}
