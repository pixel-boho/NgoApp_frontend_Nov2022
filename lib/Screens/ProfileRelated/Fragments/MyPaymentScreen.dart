import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Blocs/PaymentDetailsBloc.dart';
import 'package:ngo_app/Blocs/panbloc.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:ngo_app/CustomLibraries/ImagePickerAndCropper/image_picker_handler.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Elements/PainationLoader.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Interfaces/RefreshPageListener.dart';
import 'package:ngo_app/Models/MyDonationsResponse.dart';
import 'package:ngo_app/Models/PancardUploadResponse.dart';
import 'package:ngo_app/Models/UserPancardResponse.dart';
import 'package:ngo_app/Models/paymentHistoryResponse.dart';
import 'package:ngo_app/Screens/Dashboard/Home.dart';
import 'package:ngo_app/Screens/ProfileRelated/photoview.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

class MyPaymentHistory extends StatefulWidget {
  @override
  MyPaymentHistory({Key key, this.userid, this.url}) : super(key: key);
  final userid;
  final url;
  _MyPaymentHistoryState createState() => _MyPaymentHistoryState();
}

class _MyPaymentHistoryState extends State<MyPaymentHistory>
    with LoadMoreListener,
        RefreshPageListener,
        TickerProviderStateMixin,
        ImagePickerListener {
  bool isLoadingMore = false;
  PaymentInfoBloc _paymentdetailsbloc;
  String _imageUrl = "";
  ImagePickerHandler imagePicker;
  AnimationController _controller;
  var subscriptionId;

  @override
  File _image;

  void initState() {
    super.initState();
    _paymentdetailsbloc = PaymentInfoBloc();
    _paymentdetailsbloc.getPaymentInfo();
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
    // initFields();
  }

  @override
  void dispose() {
    _controller.dispose();
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
              text: "Transactions",
              buttonHandler: _backPressFunction,
            ),
          ),
          body: RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.green,
            onRefresh: () {
              return _paymentdetailsbloc.getPaymentInfo();
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
                      child: StreamBuilder<ApiResponse<PaymentHistoryResponse>>(
                          stream: _paymentdetailsbloc.paymentinfoStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              switch (snapshot.data.status) {
                                case Status.LOADING:
                                  return CommonApiLoader();
                                  break;
                                case Status.COMPLETED:
                                  PaymentHistoryResponse response =
                                      snapshot.data.data;
                                  return _buildUserWidget(response.message,
                                      _paymentdetailsbloc.paymentInfo,_paymentdetailsbloc.donateInfo);
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
  _buildUserWidget(String message, List<PaymentHist> paymentInfo,List<Donate> donateInfo) {
    if (paymentInfo != null) {
      if (paymentInfo.length > 0) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0.0,),
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: paymentInfo.length,
                    itemBuilder: (context, index) {
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
                                      "Money Sent to Mr jith Jose",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                                    ),
                                    subtitle: new Text(
                                        "yesterday, 06:09 Am"
                                    ),
                                    trailing: Text("${paymentInfo[index].amount}",style: TextStyle(color: Colors.green),),
                                  ),

                                ],
                              ),
                            ),
                          ));
                    }),
              ),
              Visibility(
                child: SizedBox(
                  height: 15,
                ),
                visible: isLoadingMore ? false : true,
              ),
            ],
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


  void _errorWidgetFunction() {
    if (_paymentdetailsbloc != null) _paymentdetailsbloc.getPaymentInfo();
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


  @override
  userImage(File _image) {
    if (_image != null) {
      setState(() {
        this._image = _image;
      });
    } else {
      Fluttertoast.showToast(msg: "Unable to set image");
    }
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
