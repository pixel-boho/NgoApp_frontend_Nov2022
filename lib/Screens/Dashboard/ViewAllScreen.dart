import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Blocs/ViewAllItemsBloc.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/EnumValues.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:ngo_app/Elements/EachListItemWidget.dart';
import 'package:ngo_app/Elements/PainationLoader.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Models/CommonViewAllResponse.dart';
import 'package:ngo_app/Models/FundraiserItem.dart';
import 'package:ngo_app/Screens/DetailPages/ItemDetailScreen.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

import 'AutocompleteSearch.dart';
import 'FilterScreen.dart';

class ViewAllScreen extends StatefulWidget {
  final bool isCampaignRelated;

  ViewAllScreen({this.isCampaignRelated = false});

  @override
  _ViewAllScreenState createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> with LoadMoreListener {
  ScrollController _itemsScrollController;
  bool isLoadingMore = false;
  ViewAllItemsBloc _viewAllItemsBloc;

  @override
  void initState() {
    super.initState();
    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);
    _viewAllItemsBloc = new ViewAllItemsBloc(this);
    _viewAllItemsBloc.getItems(false, widget.isCampaignRelated ? false : true);
  }

  void _scrollListener() {
    if (_itemsScrollController.offset >=
            _itemsScrollController.position.maxScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the bottom");
      if (_viewAllItemsBloc.hasNextPage) {
        _viewAllItemsBloc.getItems(
            true, widget.isCampaignRelated ? false : true);
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
    _viewAllItemsBloc.dispose();
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
            child: Container(
              color: Color(colorCoderRedBg),
              alignment: FractionalOffset.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: CommonAppBar(
                      text: getTitle(),
                      buttonHandler: _backPressFunction,
                    ),
                    flex: 1,
                  ),
                  IconButton(
                    iconSize: 25,
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Get.off(() => AutocompleteSearch());
                    },
                  ),
                  IconButton(
                    iconSize: 25,
                    icon: Icon(
                      Icons.tune,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      Map<String, bool> data = await Get.to(
                          () => FilterScreen(),
                          opaque: false,
                          fullscreenDialog: true);
                      print("*****");
                      if (data != null && mounted) {
                        if (data.containsKey("isFilterApplied")) {
                          print("*****isFilterApplied");
                          setState(() {
                          });
                        } else if (data.containsKey("isFilterReset")) {
                          print("*****isFilterReset");
                        }

                        _viewAllItemsBloc.getItems(
                            false, widget.isCampaignRelated ? false : true);
                      }
                    },
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),
          ),
          body: RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.green,
            onRefresh: () {
              return _viewAllItemsBloc.getItems(
                  false, widget.isCampaignRelated ? false : true);
            },
            child: Column(
              children: <Widget>[
                Expanded(
                  child: StreamBuilder<ApiResponse<CommonViewAllResponse>>(
                      stream: _viewAllItemsBloc.itemsStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data.status) {
                            case Status.LOADING:
                              return CommonApiLoader();
                              break;
                            case Status.COMPLETED:
                              CommonViewAllResponse response =
                                  snapshot.data.data;
                              return _buildUserWidget(
                                  response.baseUrl,
                                  _viewAllItemsBloc.itemsList,
                                  response.webBaseUrl);
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
                      }),
                  flex: 1,
                ),
                Visibility(
                  child: PaginationLoader(),
                  visible: isLoadingMore ? true : false,
                ),
              ],
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: CommonWidgets().showHelpDesk(),
          ),
        ),
      ),
    );
  }

  void _errorWidgetFunction() {
    if (_viewAllItemsBloc != null)
      _viewAllItemsBloc.getItems(
          false, widget.isCampaignRelated ? false : true);
  }

  _buildUserWidget(
      String imageBase, List<FundraiserItem> itemsList, String webBaseUrl) {
    if (itemsList != null) {
      if (itemsList.length > 0) {
        if(MediaQuery.of(context).size.width > 600){
          return GridView.builder(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 0.5,
                childAspectRatio: 1 / 1.1),
            itemBuilder: (
                BuildContext context,
                int index,
                ) {
              return EachListItemWidget(_passedFunction, index,
                  ScrollType.Vertical, itemsList[index], imageBase, webBaseUrl);
            },
            itemCount: itemsList.length,
            shrinkWrap: true,
            controller: _itemsScrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(5, 10, 5, 65),
          );
        } else {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: itemsList.length,
            itemBuilder: (context, index) {
              return EachListItemWidget(_passedFunction, index,
                  ScrollType.Vertical, itemsList[index], imageBase, webBaseUrl);
            },
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _itemsScrollController,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 65),
          );
        }

      } else {
        return CommonApiResultsEmptyWidget("Results Empty",
            textColorReceived: Colors.black);
      }
    } else {
      return CommonApiErrorWidget("No results found", _errorWidgetFunction,
          textColorReceived: Colors.black);
    }
  }

  void _passedFunction(int itemId) async {
    print("Clicked on : $itemId");
    Map<String, bool> data = await Get.to(() => ItemDetailScreen(itemId));
    if (mounted && data != null) {
      if (data.containsKey("isFundraiserWithdrawn")) {
        if (data["isFundraiserWithdrawn"]) {
          if (_viewAllItemsBloc != null) {
            _viewAllItemsBloc.getItems(
                false, widget.isCampaignRelated ? false : true);
          }
        }
      }
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

  getTitle() {
    String _title = "";
    if (LoginModel().campaignsListSaved != null) {
      for (var data in LoginModel().campaignsListSaved) {
        if (data.isSelected) {
          _title = data.title;
          break;
        }
      }
    }
    return _title;
  }
}
