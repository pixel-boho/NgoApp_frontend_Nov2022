import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:ngo_app/CustomLibraries/TextDrawable/TextDrawableWidget.dart';
import 'package:ngo_app/CustomLibraries/TextDrawable/color_generator.dart';
import 'package:ngo_app/Models/CommentItem.dart';

class CommentItemWidget extends StatelessWidget {
  final String baseUrl;
  final CommentItem _commentItem;

  CommentItemWidget(this.baseUrl, this._commentItem);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.all(Radius.elliptical(25, 25)),
                  child: Container(
                    width: 50,
                    height: 50,
                    child: CachedNetworkImage(
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: getImage(baseUrl, _commentItem.imageUrl),
                      placeholder: (context, url) => Center(
                        child: RoundedLoader(),
                      ),
                      errorWidget: (context, url, error) => TextDrawableWidget(
                          "${_commentItem.name}", ColorGenerator.materialColors,
                          (bool selected) {
                        // on tap callback
                        print("on tap callback");
                      }, true, 50.0, 50.0, BoxShape.rectangle,
                          TextStyle(color: Colors.white, fontSize: 14.0)),
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
                        "${_commentItem.name}",
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
                        CommonMethods()
                            .readTimestamp(_commentItem.createdAt ?? ""),
                        style: TextStyle(
                            color: Color(colorCoderItemSubTitle),
                            fontWeight: FontWeight.w400,
                            fontSize: 13.0),
                      ),
                    ),
                  ],
                ),
                flex: 1,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
            alignment: FractionalOffset.centerLeft,
            child: Text(
              "${_commentItem.comment}",
              style: TextStyle(
                  fontWeight: FontWeight.w400, fontSize: 13.0, height: 1.8),
            ),
          ),
        ],
      ),
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
