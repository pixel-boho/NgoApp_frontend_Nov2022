import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/EnumValues.dart';
import 'package:ngo_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:ngo_app/Models/MyLoanHistoryListResponse.dart';

class LoanOrLendHistoryItem extends StatelessWidget {
  final HistoryType historyType;
  final String imageBase;
  final dynamic listItem;

  const LoanOrLendHistoryItem(
      {Key key,
      @required this.historyType,
      @required this.imageBase,
      @required this.listItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: FractionalOffset.center,
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 90,
                height: 80,
                child: CachedNetworkImage(
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: '${imageBase}${listItem.imageUrl}',
                  // historyType == HistoryType.Loan
                  //     ? "https://www.socialsamosa.com/wp-content/uploads/2019/07/18-july-03.jpg"
                  //     : "https://i.ytimg.com/vi/jAYhTmptQzk/maxresdefault.jpg",
                  placeholder: (context, url) => Center(
                    child: RoundedLoader(),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.black12,
                    child: Image(
                      image: AssetImage('assets/images/no_image.png'),
                      height: double.infinity,
                      width: double.infinity,
                    ),
                    padding: EdgeInsets.all(5),
                  ),
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
                    '${listItem.title}',
                    // historyType == HistoryType.Loan
                    //     ? "Sponsoring the education of 6 childrens"
                    //     : "Child Education",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Color(colorCoderItemTitle),
                        fontWeight: FontWeight.w600,
                        fontSize: 12.0),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                //todo always showing completed. check condition
                Visibility(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 5, 5),
                    alignment: FractionalOffset.centerLeft,
                    child: Text(
                      "Completed",
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0),
                    ),
                  ),
                  visible: historyType == HistoryType.Loan ? true : false,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                  alignment: FractionalOffset.centerLeft,
                  child: Text(
                    "₹ ${CommonMethods().convertAmount(listItem.amount)}",
                    style: TextStyle(
                        color: Color(colorCoderRedBg),
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0),
                  ),
                ),
              ],
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}
