import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:ngo_app/Blocs/PricingBloc.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:ngo_app/Models/PricingStrategiesResponse.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';

class PricingScreen extends StatefulWidget {
  @override
  _PricingScreenState createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  PricingBloc _pricingBloc;

  @override
  void initState() {
    super.initState();
    _pricingBloc = new PricingBloc();
    _pricingBloc.getItems(false);
  }

  @override
  void dispose() {
    _pricingBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.green,
            onRefresh: () {
              return _pricingBloc.getItems(false);
            },
            child: Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: StreamBuilder<ApiResponse<PricingStrategiesResponse>>(
                    stream: _pricingBloc.pricingStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data.status) {
                          case Status.LOADING:
                            return CommonApiLoader();
                            break;
                          case Status.COMPLETED:
                            PricingStrategiesResponse res = snapshot.data.data;
                            return _buildUserWidget(res);
                            break;
                          case Status.ERROR:
                            return CommonApiErrorWidget(
                                snapshot.data.message, _errorWidgetFunction,
                                textColorReceived: Colors.black);
                            break;
                        }
                      }
                      return Container(
                        child: Center(
                          child: Text(""),
                        ),
                      );
                    })),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: CommonWidgets().showHelpDesk(),
          ),
        ),
      ),
    );
  }

  void _backPressFunction() {
    print("_sendOtpFunction clicked");
    Get.back();
  }

  Future<bool> onWillPop() {
    return Future.value(true);
  }

  void _errorWidgetFunction() {
    if (_pricingBloc != null) _pricingBloc.getItems(false);
  }

  Widget _buildUserWidget(PricingStrategiesResponse res) {
    if (res.list != null) {
      if (res.list.length > 0) {
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: res.list.length,
          itemBuilder: (context, index) {
            return _buildPricingInfo(index, res.list[index]);
          },
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        );
      } else {
        return CommonApiResultsEmptyWidget("Results Empty",
            textColorReceived: Colors.black);
      }
    } else {
      return CommonApiErrorWidget("No results found", _errorWidgetFunction,
          textColorReceived: Colors.white);
    }
  }

  Widget _buildPricingInfo(int index, PricingInfo pricingInfo) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
      margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      decoration: BoxDecoration(
        color: Color(colorCoderGreyBg),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        border: Border.all(color: Colors.white, width: 0.5),
      ),
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
                    pricingInfo.title,
                    textAlign: TextAlign.left,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Color(colorCodeWhite),
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  alignment: FractionalOffset.centerLeft,
                  child: Text(
                    "${pricingInfo.description}",
                    textAlign: TextAlign.left,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white60,
                        fontWeight: FontWeight.w500,
                        fontSize: 11.0),
                  ),
                ),
              ],
            ),
            flex: 1,
          ),
          Container(
            alignment: FractionalOffset.centerLeft,
            child: Text(
              "${pricingInfo.percentage} %",
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  height: 1.5,
                  fontWeight: FontWeight.w800,
                  fontSize: 20.0),
            ),
          )
        ],
      ),
    );
  }
}
