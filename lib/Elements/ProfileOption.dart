import 'package:flutter/material.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';

class ProfileOption extends StatelessWidget {
  final Function buttonHandler;
  String image;
  String title;
  var optionType;

  ProfileOption(this.buttonHandler, this.title, this.image, this.optionType);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 160, minHeight: 120),
      child: InkWell(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: BoxDecoration(
              color: Color(colorCodeWhite),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(image),
                height: 50,
                width: 60,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "$title",
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Color(colorCodeGreyPageBg),
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
        onTap: () {
          buttonHandler(optionType);
        },
      ),
    );
  }
}
