import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Blocs/LendBloc.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:ngo_app/Elements/EachLendItemWidget.dart';
import 'package:ngo_app/Elements/PainationLoader.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Models/LendListResponse.dart';
import 'package:ngo_app/Screens/Lend/CreateLendScreen.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';

import 'LendDetailScreen.dart';

class LendListingScreen extends StatefulWidget {
  @override
  _LendListingScreenState createState() => _LendListingScreenState();
}

class _LendListingScreenState extends State<LendListingScreen>
    with LoadMoreListener {
  ScrollController _itemsScrollController;
  bool isLoadingMore = false;
  LendBloc _lendBloc;

  @override
  void initState() {
    super.initState();

    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);
    _lendBloc = LendBloc(this);
    _lendBloc.getList(false);
  }

  void _scrollListener() {
    if (_itemsScrollController.offset >=
            _itemsScrollController.position.maxScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the bottom");
      if (_lendBloc.hasNextPage) {
        _lendBloc.getList(true);
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
    _lendBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // child: WillPopScope(
      //   onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0), // here the desired height
          child: CommonAppBar(
            text: "",
            buttonHandler: () {
              Get.back();
            },
          ),
        ),
        body: RefreshIndicator(
          color: Colors.white,
          backgroundColor: Colors.green,
          onRefresh: () {
            return _lendBloc.getList(false);
          },
          child: Container(
            color: Colors.transparent,
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 15, 10, 10),
                        alignment: FractionalOffset.centerLeft,
                        child: Text(
                          "You can help a family fundraise for a better life. Make a loan",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0),
                        ),
                      ),
                      flex: 1,
                    ),
                  ],
                ),
                Expanded(
                  child: StreamBuilder<ApiResponse<LendListResponse>>(
                      stream: _lendBloc.itemsStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data.status) {
                            case Status.LOADING:
                              return CommonApiLoader();
                              break;
                            case Status.COMPLETED:
                              LendListResponse response = snapshot.data.data;
                              return _buildList(
                                  response.baseUrl, _lendBloc.itemsList);
                              break;
                            case Status.ERROR:
                              return CommonApiErrorWidget(
                                  snapshot.data.message, _errorWidgetFunction,
                                  textColorReceived: Colors.black);
                              break;
                          }
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CommonApiLoader();
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: PaginationLoader(),
                  ),
                  visible: isLoadingMore ? true : false,
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _buildCreateButton(),
      ),
      // ),
    );
  }

  _buildList(String imageBase, List<LendListItem> itemsList) {
    if (itemsList != null) {
      if (itemsList.length > 0) {
        return ListView.builder(
          shrinkWrap: true,
          controller: _itemsScrollController,
          padding: EdgeInsets.fromLTRB(5, 10, 5, 72),
          itemCount: itemsList.length,
          itemBuilder: (context, index) {
            return EachLendItemWidget(imageBase, itemsList[index], () {
              Get.to(() => LendDetailScreen(id: itemsList[index].id));
            });
          },
        );
      } else {
        return CommonApiResultsEmptyWidget("Results Empty",
            textColorReceived: Colors.black);
      }
    } else {
      return CommonApiErrorWidget("No results found", _errorWidgetFunction,
          textColorReceived: Colors.black);
    }
  }

  void _errorWidgetFunction() {
    if (_lendBloc != null) _lendBloc.getList(true);
  }

  @override
  refresh(bool isLoading) {
    if (mounted) {
      setState(() {
        isLoadingMore = isLoading;
      });
    }
  }

  _buildCreateButton() {
    return InkWell(
      child: Container(
        width: 150,
        height: 50,
        decoration: BoxDecoration(
          color: Color(colorCodeGreyPageBg),
          borderRadius: BorderRadius.circular(25),
        ),
        margin: EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Expanded(
              child: Container(
                alignment: FractionalOffset.center,
                child: Text(
                  "Create",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.0),
                ),
              ),
              flex: 1,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                width: 50,
                height: 50,
                color: Colors.black,
                // decoration: BoxDecoration(color: Colors.black,
                // boxShadow: [
                // BoxShadow(
                //   color: Colors.white.withOpacity(0.4),
                //   spreadRadius: 3,
                //   blurRadius: 4,
                //   offset: Offset(0, 2), // changes position of shadow
                // ),
                // ]
                //   ),
                child: Center(
                  child:
                      // IconButton(
                      //   iconSize: 24,
                      //   icon:
                      Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  // ),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Get.to(() => CreateLendScreen(
              isEditMode: false,
            ));
      },
    );
  }
}
