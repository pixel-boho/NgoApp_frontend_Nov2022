// import 'dart:convert';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:ngo_app/Blocs/CommonBloc.dart';
// import 'package:ngo_app/Blocs/MyDonationsBloc.dart';
// import 'package:ngo_app/Blocs/DonationHistoryBloc.dart';
// import 'package:ngo_app/Constants/CommonMethods.dart';
// import 'package:ngo_app/Constants/CommonWidgets.dart';
// import 'package:ngo_app/Constants/CustomColorCodes.dart';
// import 'package:ngo_app/Constants/EnumValues.dart';
// import 'package:ngo_app/Constants/StringConstants.dart';
// import 'package:ngo_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
// import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
// import 'package:ngo_app/Elements/CommonApiLoader.dart';
// import 'package:ngo_app/Elements/CommonApiResultsEmptyWidget.dart';
// import 'package:ngo_app/Elements/CommonAppBar.dart';
// import 'package:ngo_app/Elements/EachListItemWidget.dart';
// import 'package:ngo_app/Elements/PainationLoader.dart';
// import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
// import 'package:ngo_app/Interfaces/RefreshPageListener.dart';
// import 'package:ngo_app/Models/CommonResponse.dart';
// import 'package:ngo_app/Models/MyDonationsResponse.dart';
// import 'package:ngo_app/Models/FundraiseHistory.dart';
// import 'package:ngo_app/Screens/Dashboard/Home.dart';
// import 'package:ngo_app/Screens/Dashboard/ViewAllScreen.dart';
// import 'package:ngo_app/Screens/DetailPages/ItemDetailScreen.dart';
// import 'package:ngo_app/ServiceManager/ApiResponse.dart';
// import 'package:ngo_app/Utilities/LoginModel.dart';
//
//
// class MyDonationsScreen extends StatefulWidget {
//   const MyDonationsScreen({Key key}) : super(key: key);
//
//   @override
//   State<MyDonationsScreen> createState() => _MyDonationsScreenState();
// }
//
// class _MyDonationsScreenState extends State<MyDonationsScreen> {
//   PaymentInfoBloc _paymentdetailsbloc;
//
//   @override
//   void initState() {
//     super.initState();
//     _paymentdetailsbloc = new PaymentInfoBloc();
//     _paymentdetailsbloc.getPaymentInfo();
//   }
//
//   @override
//   void dispose() {
//     _paymentdetailsbloc.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: WillPopScope(
//         onWillPop: onWillPop,
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           resizeToAvoidBottomInset: true,
//           appBar: PreferredSize(
//             preferredSize: Size.fromHeight(60.0), // here the desired height
//             child: CommonAppBar(
//               text: "My Donations",
//               buttonHandler: _backPressFunction,
//             ),
//           ),
//           body:  RefreshIndicator(
//             color: Colors.white,
//             backgroundColor: Colors.green,
//             onRefresh: () {
//               return _paymentdetailsbloc.getPaymentInfo();
//             },
//             child: Container(
//                 color: Colors.transparent,
//                 height: double.infinity,
//                 width: double.infinity,
//                 padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     Expanded(
//                       child: StreamBuilder<ApiResponse<PaymentHistoryResponse>>(
//                         stream: _paymentdetailsbloc.paymentinfoStream,
//                         builder: (context, snapshot) {
//                           print("Response-->${snapshot.data.message}");
//                           if (snapshot.hasData) {
//                             switch (snapshot.data.status) {
//                               case Status.LOADING:
//                                 return CommonApiLoader();
//                                 break;
//                               case Status.COMPLETED:
//                                 PaymentHistoryResponse response =snapshot.data.data;
//                                 return _buildUserWidget(response.donate);
//                                 break;
//                               case Status.ERROR:
//                                 return CommonApiErrorWidget(
//                                     snapshot.data.message, _errorWidgetFunction);
//                                 break;
//                             }
//                           }
//
//                           return Container();
//                         },
//                       ),
//                       flex: 1,
//                     ),
//                   ],
//                 )),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _errorWidgetFunction() {
//     if (_paymentdetailsbloc != null) _paymentdetailsbloc.getPaymentInfo();
//   }
//   Widget _buildUserWidget(List<Donate> donateList) {
//     if (donateList != null) {
//       if (donateList.length > 0) {
//         return Container(
//           padding: EdgeInsets.symmetric(horizontal: 0.0,),
//           height: MediaQuery.of(context).size.height,
//           margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
//           alignment: FractionalOffset.centerLeft,
//           child: ListView.builder(
//               shrinkWrap: true,
//               reverse: true,
//               scrollDirection: Axis.vertical,
//               itemCount: donateList.length ,
//               physics: ClampingScrollPhysics(),
//               padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
//               itemBuilder: (BuildContext ctx, int index) {
//                 return Padding(
//                     padding: const EdgeInsets.all(4.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       width: MediaQuery.of(context).size.width * 0.4,
//                       child:Card(
//                         child: new Column(
//                           children: <Widget>[
//                             new ListTile(
//                               leading: CircleAvatar(child: Icon(Icons.account_circle_outlined),
//                               ),
//                               title: new Text(
//                                 "${donateList[index].showDonorInformation}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
//                               ),
//                               subtitle: new Text(
//                                   "${donateList[index].createdAt}"
//                               ),
//                               trailing: Text("${donateList[index].amount}",style: TextStyle(color: Colors.green),),
//                             ),
//
//                           ],
//                         ),
//                       ),
//                     ));
//               }
//           ),
//         );
//       } else {
//         return Column(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Expanded(
//               child: CommonApiResultsEmptyWidget("Results Empty"),
//               flex: 1,
//             ),
//           ],
//         );
//       }
//     } else {
//       return CommonApiErrorWidget("No results found", _errorWidgetFunction);
//     }
//   }
//
//
//   Future<bool> onWillPop() {
//     return Future.value(true);
//   }
//
//   void _backPressFunction() {
//     print("_sendOtpFunction clicked");
//     Get.back();
//   }
//
// }
//



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Blocs/DonationHistoryBloc.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:ngo_app/Elements/PainationLoader.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Interfaces/RefreshPageListener.dart';
import 'package:ngo_app/Models/DonationHistory.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

class MyDonationsScreen extends StatefulWidget {
  @override
  _MyDonationsScreenState createState() => _MyDonationsScreenState();
}

class _MyDonationsScreenState extends State<MyDonationsScreen>
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
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // here the desired height
            child: CommonAppBar(
              text: "My Donations",
              buttonHandler: _backPressFunction,
            ),
          ),
          body: RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.green,
            onRefresh: () {
              return _bloc.getPaymentHistoryList(false, null);
            },
            child: Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
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
                                  DonationHistoryResponse res = snapshot.data.data;
                                  return _buildUserWidget(res.donate);
                                  break;
                                case Status.ERROR:
                                  return CommonApiErrorWidget(
                                      snapshot.data.message,
                                      _errorWidgetFunction);
                                  break;
                              }
                            }
                            return Container(
                              child: Center(
                                child: Text(""),
                              ),
                            );
                          }),
                      flex: 1,
                    ),
                    Visibility(
                      child: PaginationLoader(),
                      visible: isLoadingMore ? true : false,
                    ),
                  ],
                )),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: CommonWidgets().showHelpDesk(),
          ),
        ),
      ),
    );
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
      return CommonApiErrorWidget("No results found", _errorWidgetFunction);
    }
  }


  void _backPressFunction() {
    print("_sendOtpFunction clicked");
    Get.back();
  }

  Future<bool> onWillPop() {
    return Future.value(true);
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

  void _errorWidgetFunction() {
    if (_bloc != null) _bloc.getPaymentHistoryList(false, null);
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
