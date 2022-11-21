import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:ngo_app/CustomLibraries/TextDrawable/TextDrawableWidget.dart';
import 'package:ngo_app/CustomLibraries/TextDrawable/color_generator.dart';
import 'package:ngo_app/Models/DonorOrSupporterInfo.dart';

class DonorOrSupporterItem extends StatelessWidget {
  final String baseUrl;
  final DonorOrSupporterInfo infoItem;

  DonorOrSupporterItem(this.baseUrl, this.infoItem);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.all(Radius.elliptical(30, 30)),
            child: Container(
              width: 60,
              height: 60,
              child: CachedNetworkImage(
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                imageUrl: getImage(baseUrl, infoItem?.imageUrl),
                placeholder: (context, url) => Center(
                  child: RoundedLoader(),
                ),
                errorWidget: (context, url, error) => TextDrawableWidget(
                    "${infoItem?.name}", ColorGenerator.materialColors,
                    (bool selected) {
                  // on tap callback
                  print("on tap callback");
                }, true, 60.0, 60.0, BoxShape.rectangle,
                    TextStyle(color: Colors.white, fontSize: 17.0)),
              ),
            )),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                alignment: FractionalOffset.centerLeft,
                child: Text(
                  infoItem.showDonorInformation == 1
                      ? "${infoItem.name}"
                      : "Unknown",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Color(colorCoderItemTitle),
                      fontWeight: FontWeight.w600,
                      fontSize: 13.0),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                alignment: FractionalOffset.centerLeft,
                child: Text(
                  "₹ ${infoItem?.amount}",
                  style: TextStyle(
                      color: Color(colorCoderItemSubTitle),
                      fontWeight: FontWeight.w500,
                      fontSize: 13.0),
                ),
              ),
            ],
          ),
          flex: 1,
        ),
      ],
    );
  }

  String getImage(String baseUrl, String imgUrl) {
    String img = "";
    if (baseUrl != null) {
      if (baseUrl != "") {
        if (imgUrl != null) {
          if (imgUrl != "") {
            img = baseUrl + imgUrl;
          }
        }
      }
    }
    return img;
  }
}
