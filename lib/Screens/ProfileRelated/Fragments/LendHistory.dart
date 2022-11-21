import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Blocs/MyLendHistoryBloc.dart';
import 'package:ngo_app/Constants/EnumValues.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:ngo_app/Elements/LoanOrLendHistoryItem.dart';
import 'package:ngo_app/Elements/PainationLoader.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Models/MyLendHistoryListResponse.dart';
import 'package:ngo_app/Screens/Lend/LendDetailScreen.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';

class LendHistory extends StatefulWidget {
  @override
  _LendHistoryState createState() => _LendHistoryState();
}

class _LendHistoryState extends State<LendHistory> with LoadMoreListener {
  ScrollController _itemsScrollController;
  bool isLoadingMore = false;
  MyLendHistoryBloc _bloc;

  @override
  void initState() {
    super.initState();
    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);
    _bloc = MyLendHistoryBloc(this);
    _bloc.getMyLendList(false);
  }

  void _scrollListener() {
    if (_itemsScrollController.offset >=
            _itemsScrollController.position.maxScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the bottom");
      if (_bloc.hasNextPage) {
        _bloc.getMyLendList(true);
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
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: Colors.green,
      onRefresh: () {
        return _bloc.getMyLendList(false);
      },
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<ApiResponse<MyLendHistoryListResponse>>(
                  stream: _bloc.lendListItemsStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data.status) {
                        case Status.LOADING:
                          return CommonApiLoader();
                          break;
                        case Status.COMPLETED:
                          MyLendHistoryListResponse response =
                              snapshot.data.data;
                          return _buildList(
                              response.baseUrl, _bloc.lendItemsList);
                          break;
                        case Status.ERROR:
                          return CommonApiErrorWidget(
                              snapshot.data.message, _errorWidgetFunction,
                              textColorReceived: Colors.black);
                          break;
                      }
                    }
                    return Container();
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
    );
  }

  _buildList(String imageBase, List<MyLendListItem> itemsList) {
    if (itemsList != null) {
      if (itemsList.length > 0) {
        return ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _itemsScrollController,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 65),
            itemCount: itemsList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: LoanOrLendHistoryItem(
                    historyType: HistoryType.Lend,
                    imageBase: imageBase,
                    listItem: itemsList[index]),
                onTap: () {
                  Get.to(() => LendDetailScreen(
                        id: itemsList[index].id,
                      ));
                },
              );
            });
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
    if (_bloc != null) _bloc.getMyLendList(true);
  }

  @override
  refresh(bool isLoading) {
    if (mounted) {
      setState(() {
        isLoadingMore = isLoading;
      });
    }
  }
}
