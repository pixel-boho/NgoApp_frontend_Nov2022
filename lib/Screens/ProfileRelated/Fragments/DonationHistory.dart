import 'package:flutter/material.dart';
import 'package:ngo_app/Blocs/DonationHistoryBloc.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Interfaces/RefreshPageListener.dart';
import 'package:ngo_app/Models/DonationHistory.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

class DonationHistory extends StatefulWidget {
  @override
  _DonationHistoryState createState() => _DonationHistoryState();
}

class _DonationHistoryState extends State<DonationHistory>
  with LoadMoreListener, RefreshPageListener {
  ScrollController _itemsScrollController;
  bool isLoadingMore = false;
  DonationHistoryBloc _bloc;

  @override
  void initState() {
    LoginModel().relatedItemsList.clear();
    super.initState();
    CommonMethods().setRefreshFilterPageListener(this);
    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);
    _bloc = new DonationHistoryBloc(this);
    _bloc.getPaymentHistoryList(false, null);
  }

  void _scrollListener() {
    if (_itemsScrollController.offset >=
        _itemsScrollController.position.maxScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the bottom");
      if (_bloc.hasNextPage) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          _bloc.getPaymentHistoryList(true, null);
        });
      }
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
    _bloc.dispose();
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
              return _bloc.getPaymentHistoryList(false, null);
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
                      child: StreamBuilder<ApiResponse<DonationHistoryResponse>>(
                        stream: _bloc.paymentinfoStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            switch (snapshot.data.status) {
                              case Status.LOADING:
                                return CommonApiLoader();
                                break;
                              case Status.COMPLETED:
                                DonationHistoryResponse response =snapshot.data.data;
                                return _buildUserWidget(response.donate);
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
       if (_bloc != null) _bloc.getPaymentHistoryList(false, null);
  }
  Widget _buildUserWidget(List<Donate> donateList) {
    if (donateList != null) {
      if (donateList.length > 0) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 0.0,),
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          alignment: FractionalOffset.centerLeft,
          child: ListView.builder(
              shrinkWrap: true,
              reverse: true,
              scrollDirection: Axis.vertical,
              itemCount: donateList.length ,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
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
                                "${donateList[index].showDonorInformation}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                              ),
                              subtitle: new Text(
                                  "${donateList[index].createdAt}"
                              ),
                              trailing: Text("${donateList[index].amount}",style: TextStyle(color: Colors.green),),
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
