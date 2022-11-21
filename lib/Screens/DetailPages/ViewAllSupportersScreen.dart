import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Blocs/ParticipantsBloc.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:ngo_app/Elements/DonorOrSupporterItem.dart';
import 'package:ngo_app/Elements/PainationLoader.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Models/DonorOrSupporterInfo.dart';
import 'package:ngo_app/Models/ParticipantsListResponse.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';

class ViewAllSupportersScreen extends StatefulWidget {
  final fundraiserIdReceived;

  ViewAllSupportersScreen(this.fundraiserIdReceived);

  @override
  _ViewAllSupportersScreenState createState() =>
      _ViewAllSupportersScreenState();
}

class _ViewAllSupportersScreenState extends State<ViewAllSupportersScreen>
    with LoadMoreListener {
  ScrollController _itemsScrollController;
  bool isLoadingMore = false;
  ParticipantsBloc _participantsBloc;

  @override
  void initState() {
    super.initState();
    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);
    _participantsBloc = new ParticipantsBloc(this);
    _participantsBloc.getAllPersonDetails(
        false, widget.fundraiserIdReceived, false);
  }

  void _scrollListener() {
    if (_itemsScrollController.offset >=
            _itemsScrollController.position.maxScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the bottom");
      if (_participantsBloc.hasNextPage) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          _participantsBloc.getAllPersonDetails(
              true, widget.fundraiserIdReceived, false);
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
    _participantsBloc.dispose();
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
              text: "Supporters",
              buttonHandler: _backPressFunction,
            ),
          ),
          body: RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.green,
            onRefresh: () {
              return _participantsBloc.getAllPersonDetails(
                  false, widget.fundraiserIdReceived, false);
            },
            child: Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child:
                          StreamBuilder<ApiResponse<ParticipantsListResponse>>(
                              stream: _participantsBloc.commonStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  switch (snapshot.data.status) {
                                    case Status.LOADING:
                                      return CommonApiLoader();
                                      break;
                                    case Status.COMPLETED:
                                      ParticipantsListResponse res =
                                          snapshot.data.data;
                                      return _buildUserWidget(res.baseUrl,
                                          _participantsBloc.itemsList);
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
        ),
      ),
    );
  }

  _buildUserWidget(String imageBase, List<DonorOrSupporterInfo> itemsList) {
    if (itemsList != null) {
      if (itemsList.length > 0) {
        return ListView.separated(
          scrollDirection: Axis.vertical,
          itemCount: itemsList.length,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemBuilder: (context, index) {
            return Container(
              alignment: FractionalOffset.center,
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: DonorOrSupporterItem(imageBase, itemsList[index]),
            );
          },
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _itemsScrollController,
          padding: EdgeInsets.fromLTRB(20, 10, 20, 65),
        );
      } else {
        return CommonApiResultsEmptyWidget("Results Empty");
      }
    } else {
      return CommonApiErrorWidget("No results found", _errorWidgetFunction);
    }
  }

  void _errorWidgetFunction() {
    if (_participantsBloc != null)
      _participantsBloc.getAllPersonDetails(
          false, widget.fundraiserIdReceived, false);
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
}
