import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Blocs/ViewAllItemsBloc.dart';
import 'package:ngo_app/Constants/EnumValues.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:ngo_app/Elements/DonateNowCardWidget.dart';
import 'package:ngo_app/Elements/EachListItemWidget.dart';
import 'package:ngo_app/Elements/PainationLoader.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Models/CommonViewAllResponse.dart';
import 'package:ngo_app/Models/FundraiserItem.dart';
import 'package:ngo_app/Screens/DetailPages/ItemDetailScreen.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';

import '../FilterScreen.dart';

class CampaignFragment extends StatefulWidget {
  @override
  _CampaignFragmentState createState() => _CampaignFragmentState();
}

class _CampaignFragmentState extends State<CampaignFragment>
    with LoadMoreListener {
  ScrollController _itemsScrollController;
  bool isLoadingMore = false;
  ViewAllItemsBloc _viewAllItemsBloc;

  @override
  void initState() {
    super.initState();
    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);
    _viewAllItemsBloc = new ViewAllItemsBloc(this);
    _viewAllItemsBloc.getItems(false, false);
  }

  void _scrollListener() {
    if (_itemsScrollController.offset >=
            _itemsScrollController.position.maxScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the bottom");
      if (_viewAllItemsBloc.hasNextPage) {
        _viewAllItemsBloc.getItems(true, false);
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
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: Colors.green,
      onRefresh: () {
        return _viewAllItemsBloc.getItems(false, false);
      },
      child: Container(
          color: Colors.transparent,
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: DonateNowCardWidget(),
                    flex: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 5, 5),
                    child: IconButton(
                      iconSize: 30,
                      icon: Icon(
                        Icons.tune,
                        color: Colors.black,
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
                          } else if (data.containsKey("isFilterReset")) {
                            print("*****isFilterReset");
                          }

                          _viewAllItemsBloc.getItems(false, false);
                        }
                      },
                    ),
                  ),
                ],
              ),
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
                            CommonViewAllResponse response = snapshot.data.data;
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
          )),
    );
  }

  void _errorWidgetFunction() {
    if (_viewAllItemsBloc != null) _viewAllItemsBloc.getItems(false, false);
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
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _itemsScrollController,
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
            padding: EdgeInsets.fromLTRB(5, 10, 5, 65),
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
            _viewAllItemsBloc.getItems(false, false);
          }
        }
      }
    }
  }
}
