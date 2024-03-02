import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ngo_app/Blocs/DonationHistoryBloc.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Interfaces/RefreshPageListener.dart';
import 'package:ngo_app/Models/DonationHistory.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class DonationHistory extends StatefulWidget {
  @override
  _DonationHistoryState createState() => _DonationHistoryState();
}

class _DonationHistoryState extends State<DonationHistory>
  with LoadMoreListener, RefreshPageListener {
  ScrollController _itemsScrollController;
  bool isLoadingMore = false;
  DonationHistoryBloc _bloc;

  Map respo = {};
  String pdf = "";
  String baseUrl_pdf = "";
  String dontaion_id = "";


  Future get80GPdf(String donationId) async {
    final response = await http.post(
      Uri.parse(
          'https://crowdworksindia.org/test/api/web/v1/user/generate-pdf'),
      body: {"user_id": LoginModel().userDetails.id.toString(), "donation_id": donationId},
      headers: {
        'Accept': 'application/json',
      },
    );
    print("Response${response.body}");
    var res = json.decode(response.body);
    respo = res;
    pdf = respo["pdf_path"];
    baseUrl_pdf = respo["file_path"];
    if (response.statusCode == 200) {
      downloadPDF();
    } else {
      throw Exception('Failed to load');
    }
    return response;
  }

  Future<void> downloadPDF() async {
    String filePath =pdf;
    String desiredPath = filePath.split('public_html/')[1];
    String desiredPath1 = filePath.split('pdf/')[1];
    print("${baseUrl_pdf}/${desiredPath}");
    print("gh=>${desiredPath1}");
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final response =
      await http.get(Uri.parse("${baseUrl_pdf}/${desiredPath}"));
      if (response.statusCode == 200) {
        final savePath = Platform.isAndroid
            ? (await getExternalStorageDirectory())?.path
            : (await getApplicationDocumentsDirectory()).path;
        print(savePath.toString());
        String emulted0 = savePath.split('Android').first;
        print(emulted0);
        Fluttertoast.showToast(msg: "Download Started");
        final uniqueFilename = '80GForm_$desiredPath1';
        final filePath = '$emulted0/Download/$uniqueFilename';
        final pdfFile = File(filePath);
        await pdfFile.writeAsBytes(response.bodyBytes, flush: true);
        print('PDF downloaded to: $filePath');
        Fluttertoast.showToast(
            msg: "Download Completed, check download folder");
      } else {
        print('Failed to download PDF. Status code: ${response.statusCode}');
      }
    } else {
      print('Permission to access storage denied');
    }
  }


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
                             ListTile(
                               isThreeLine: true,
                              // leading: CircleAvatar(child: Icon(Icons.account_circle_outlined),
                              // ),
                              title:  Text(
                                "${donateList[index].showDonorInformation}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                              ),
                              subtitle:  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("₹ ${donateList[index].amount}",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500),),
                                  Text(
                                      "${donateList[index].createdAt}"
                                  ),
                                ],
                              ),
                          trailing: donateList[index].status ==
                              "Certificate Exists"
                              ? SizedBox(
                            height: 25,
                            width: 80,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color(
                                      colorCoderRedBg), // Set the background color to blue
                                ),
                                onPressed: () {
                                  dontaion_id =
                                  donateList[index].id.toString();
                                  get80GPdf(dontaion_id);
                                },
                                child: Row(
                                  children: [
                                    Text("80G"),
                                    Icon(
                                      Icons.download_outlined,
                                      size: 17,
                                    ),
                                  ],
                                )),
                          )
                              : Text("")
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
