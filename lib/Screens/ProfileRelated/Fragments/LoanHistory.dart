import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Blocs/LendBloc.dart';
import 'package:ngo_app/Blocs/MyLoanHistoryBloc.dart';
import 'package:ngo_app/Constants/EnumValues.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:ngo_app/Elements/DonorOrSupporterItem.dart';
import 'package:ngo_app/Elements/LoanOrLendHistoryItem.dart';
import 'package:ngo_app/Elements/PainationLoader.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Models/MyLoanHistoryListResponse.dart';
import 'package:ngo_app/Screens/Lend/LendDetailScreen.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';

class LoanHistory extends StatefulWidget {
  @override
  _LoanHistoryState createState() => _LoanHistoryState();
}

class _LoanHistoryState extends State<LoanHistory> with LoadMoreListener {
  ScrollController _itemsScrollController;
  bool isLoadingMore = false;
  MyLoanHistoryBloc _bloc;

  @override
  void initState() {
    super.initState();

    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);
    _bloc = MyLoanHistoryBloc(this, HistoryType.Loan);
    _bloc.getMyLoanList(false);
  }

  void _scrollListener() {
    if (_itemsScrollController.offset >=
            _itemsScrollController.position.maxScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the bottom");
      if (_bloc.hasNextPage) {
        _bloc.getMyLoanList(true);
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
        return _bloc.getMyLoanList(false);
      },
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<ApiResponse<MyLoanHistoryListResponse>>(
                  stream: _bloc.loanListItemsStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data.status) {
                        case Status.LOADING:
                          return CommonApiLoader();
                          break;
                        case Status.COMPLETED:
                          MyLoanHistoryListResponse response =
                              snapshot.data.data;
                          return _buildList(
                              response.baseUrl, _bloc.loanItemsList);
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

  _buildList(String imageBase, List<MyLoanListItem> itemsList) {
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
                    historyType: HistoryType.Loan,
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
    if (_bloc != null) _bloc.getMyLoanList(true);
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
