import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ngo_app/Blocs/PaymentDetailsBloc.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:ngo_app/Models/paymentHistoryResponse.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

class FundraiserHistory extends StatefulWidget {
  @override
  _FundraiserHistoryState createState() => _FundraiserHistoryState();
}

class _FundraiserHistoryState extends State<FundraiserHistory> {
  PaymentInfoBloc _paymentdetailsbloc;

  @override
  void initState() {
    super.initState();
    _paymentdetailsbloc = new PaymentInfoBloc();
    _paymentdetailsbloc.getPaymentInfo();
  }

  @override
  void dispose() {
    _paymentdetailsbloc.dispose();
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
          body:  RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.green,
            onRefresh: () {
              return _paymentdetailsbloc.getPaymentInfo();
            },
            child: Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: StreamBuilder<ApiResponse<PaymentHistoryResponse>>(
                        stream: _paymentdetailsbloc.paymentinfoStream,
                        builder: (context, snapshot) {
                          print("List--> ${snapshot.data}");
                          if (snapshot.hasData) {
                            switch (snapshot.data.status) {
                              case Status.LOADING:
                                return CommonApiLoader();
                                break;
                              case Status.COMPLETED:
                                print("List--> ${snapshot.data.data}");
                                PaymentHistoryResponse response =snapshot.data.data;
                                return _buildUserWidget(response.paymentHist);
                                break;
                              case Status.ERROR:
                                return CommonApiErrorWidget(
                                    snapshot.data.message, _errorWidgetFunction);
                                break;
                            }
                          }

                          return Container();
                        },
                      ),
                      flex: 1,
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  void _errorWidgetFunction() {
    if (_paymentdetailsbloc != null) _paymentdetailsbloc.getPaymentInfo();
  }

  Widget _buildUserWidget(List<PaymentHist> paymentList) {
    if (paymentList != null) {
      if (paymentList.length > 0) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 0.0,),
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          alignment: FractionalOffset.centerLeft,
          child: ListView.builder(
              shrinkWrap: true,
              reverse: true,
              scrollDirection: Axis.vertical,
              itemCount: paymentList.length ,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
              itemBuilder: (BuildContext ctx, int index) {
                return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      width: MediaQuery.of(context).size.width * 0.4,
                      child:Card(
                        child: new Column(
                          children: <Widget>[
                            new ListTile(
                              leading: CircleAvatar(child: Icon(Icons.account_circle_outlined),
                              ),
                              title: new Text(
                                "Donate to ${paymentList[index].fundraiserId.title}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                              ),
                              subtitle: new Text(
                                  "${paymentList[index].createdAt}"
                              ),
                              trailing: Text("${paymentList[index].amount}",style: TextStyle(color: Colors.green),),
                            ),

                          ],
                        ),
                      ),
                    ));
              }
          ),
        );
      } else {
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: CommonApiResultsEmptyWidget("Results Empty"),
              flex: 1,
            ),
          ],
        );
      }
    } else {
      return CommonApiErrorWidget("No results found", _errorWidgetFunction);
    }
  }



  Future<bool> onWillPop() {
    return Future.value(true);
  }




  @override
  void refreshPage() {
    if (mounted) {
      setState(() {
        print("${LoginModel().relatedItemsList.length}");
        print("PageRefreshed");
      });
    }
  }
}
