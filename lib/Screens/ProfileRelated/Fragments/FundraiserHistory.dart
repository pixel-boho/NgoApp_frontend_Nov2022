import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Interfaces/RefreshPageListener.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';
import 'package:http/http.dart' as http;

class FundraiserHistory extends StatefulWidget {
  @override
  _FundraiserHistoryState createState() => _FundraiserHistoryState();
}

class _FundraiserHistoryState extends State<FundraiserHistory>
    with LoadMoreListener, RefreshPageListener {
  ScrollController _itemsScrollController;
  String authToken;
  bool isLoadingMore = false;
  //FundraiseHistoryBloc _bloc;
  List stationList = [];
  Map respo = {};
  List<dynamic> listFundraise = [];

  Future getFundraise() async {
    print("Get order");

    final response = await http.get(Uri.parse(
        'https://crowdworksindia.org/test/api/web/v1/user/fundraiser-payment-history'),
        headers:{
      "Authorization":"Bearer ${LoginModel().authToken}"
        });
    print("Response${response.body}");
    var res = json.decode(response.body);
    respo = res;
    listFundraise = respo["payment_hist"];
    print("listFundraise-${listFundraise}");
    if (response.statusCode == 200) {
      _buildUserWidget(listFundraise);
    }
    else {
      throw Exception('Failed to load post');
      print("Failed to load post");
    }
    return response;
  }

  @override
  void initState() {
    LoginModel().relatedItemsList.clear();
    super.initState();
    CommonMethods().setRefreshFilterPageListener(this);
    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);
    // _bloc = new FundraiseHistoryBloc(this);
    // _bloc.getFundraiseHistoryList(false, null);
  }

  void _scrollListener() {
    if (_itemsScrollController.offset >=
        _itemsScrollController.position.maxScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the bottom");
      // if (_bloc.hasNextPage) {
      //   Future.delayed(const Duration(milliseconds: 1000), () {
      //     _bloc.getFundraiseHistoryList(true, null);
      //   });
      // }
    }
    if (_itemsScrollController.offset <=
        _itemsScrollController.position.minScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the top");
    }
  }

  @override
  void dispose() {
    _itemsScrollController.dispose();
  //  _bloc.dispose();
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
              //return _bloc.getFundraiseHistoryList(false, null);
            },
            child: Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FutureBuilder(
                          future: getFundraise(),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else {
                              if (snapshot.hasError) {
                                return Expanded(
                                  child: CommonApiResultsEmptyWidget("Results Empty"),
                                  flex: 1,
                                );
                              } else {
                                return _buildUserWidget(listFundraise);
                              }
                            }
                          })
                      // Expanded(
                      //   child: StreamBuilder<ApiResponse<FundraiseHistoryResponse>>(
                      //     stream: _bloc.paymentinfoStream,
                      //     builder: (context, snapshot) {
                      //       if (snapshot.hasData) {
                      //         switch (snapshot.data.status) {
                      //           case Status.LOADING:
                      //             return CommonApiLoader();
                      //             break;
                      //           case Status.COMPLETED:
                      //             FundraiseHistoryResponse response =snapshot.data.data;
                      //             return _buildUserWidget(response.paymentHist);
                      //             break;
                      //           case Status.ERROR:
                      //             return CommonApiErrorWidget(
                      //                 snapshot.data.message, _errorWidgetFunction);
                      //             break;
                      //         }
                      //       }
                      //
                      //       return Container();
                      //     },
                      //   ),
                      //   flex: 1,
                      // ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
  //
  // void _errorWidgetFunction() {
  //   if (_bloc != null) _bloc.getFundraiseHistoryList(false, null);
  // }

  Widget _buildUserWidget(List paymentList) {
    if (paymentList != null) {
      if (paymentList.length > 0) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 0.0,),
          height: MediaQuery
              .of(context)
              .size
              .height,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          alignment: FractionalOffset.centerLeft,
          child: ListView.builder(
              shrinkWrap: true,
              reverse: true,
              scrollDirection: Axis.vertical,
              itemCount: paymentList.length,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
              itemBuilder: (BuildContext ctx, int index) {
                return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.5,
                      child: Card(
                        child: new Column(
                          children: <Widget>[
                             ListTile(
                           isThreeLine:true,
                              leading: CircleAvatar(
                                child: Icon(Icons.account_circle_outlined),
                              ),
                              title: new Text(
                                "Donate to ${paymentList[index]["fundraiser_id"]["title"]}", style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              subtitle:  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "${paymentList[index]["created_at"]}"
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                     ElevatedButton(onPressed: (){}, child:Text("80G")),
                                      SizedBox(width: 10,),
                                      ElevatedButton(onPressed: (){}, child:Text("Receipt"))
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Text("${paymentList[index]["amount"]}",
                                style: TextStyle(color: Colors.green),),
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
      return Column(
        children: [
          SizedBox(height: 120,),
          Center(
              child: CommonApiResultsEmptyWidget("No results found")),
        ],
      );
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

  @override
  refresh(bool isLoading) {
    if (mounted) {
      setState(() {
        isLoadingMore = isLoading;
      });
      print(isLoadingMore);
    }
  }
}
