import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:ngo_app/Blocs/PointsInfoBloc.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Models/PointsResponse.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';

class PointsInfoScreen extends StatefulWidget {
  const PointsInfoScreen({Key key}) : super(key: key);

  @override
  _PointsInfoScreenState createState() => _PointsInfoScreenState();
}

class _PointsInfoScreenState extends State<PointsInfoScreen> {
  PointsInfoBloc _pointsInfoBloc;

  @override
  void initState() {
    super.initState();
    _pointsInfoBloc = new PointsInfoBloc();
    _pointsInfoBloc.getInfo();
  }

  @override
  void dispose() {
    _pointsInfoBloc.dispose();
    super.dispose();
  }

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
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                              alignment: FractionalOffset.centerLeft,
                              child: Text(
                                "Points scheme",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.0,
                                    color: Colors.red,
                                    height: 1.8),
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
                              size: 20,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      StreamBuilder<ApiResponse<PointsResponse>>(
                          stream: _pointsInfoBloc.infoStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              switch (snapshot.data.status) {
                                case Status.LOADING:
                                  return CircularProgressIndicator();
                                  break;
                                case Status.COMPLETED:
                                  PointsResponse res = snapshot.data.data;
                                  return _buildUserWidget(res);
                                  break;
                                case Status.ERROR:
                                  return Container(
                                    padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                    alignment: FractionalOffset.center,
                                    child: Text(
                                      "Oops!! unable to fetch info!!!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.0,
                                          color: Colors.white70,
                                          height: 1.8),
                                    ),
                                  );
                                  break;
                              }
                            }
                            return Container(
                              child: Center(
                                child: Text(""),
                              ),
                            );
                          }),
                      SizedBox(
                        height: 10,
                      )
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

  Widget _buildUserWidget(PointsResponse res) {
    if (res.list != null) {
      if (res.list.length > 0) {
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: res.list.length,
          itemBuilder: (context, index) {
            return _buildInfo(index, res.list[index]);
          },
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        );
      } else {
        return Container(
          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
          alignment: FractionalOffset.center,
          child: Text(
            "Oops!! unable to fetch info!!!",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15.0,
                color: Colors.white70,
                height: 1.8),
          ),
        );
      }
    } else {
      return Container(
        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
        alignment: FractionalOffset.center,
        child: Text(
          "Oops!! unable to fetch info!!!",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15.0,
              color: Colors.white70,
              height: 1.8),
        ),
      );
    }
  }

  Widget _buildInfo(int index, Item item) {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
      margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: FractionalOffset.centerLeft,
                  child: Text(
                    "${CommonMethods().titleCase(item.description)}",
                    textAlign: TextAlign.left,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Color(colorCodeWhite),
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.0),
                  ),
                ),
              ],
            ),
            flex: 1,
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            alignment: FractionalOffset.centerLeft,
            child: Text(
              "${item.point}",
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                  fontSize: 12.0),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Image(
            image: AssetImage('assets/images/ic_coin.png'),
            height: 20,
            width: 20,
          )
        ],
      ),
    );
  }
}
