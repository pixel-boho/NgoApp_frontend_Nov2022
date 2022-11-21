import 'dart:async';

import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/EnumValues.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Models/MyLendHistoryListResponse.dart';
import 'package:ngo_app/Models/MyLoanHistoryListResponse.dart';
import 'package:ngo_app/Repositories/LendRepository.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';

class MyLoanHistoryBloc {
  bool hasNextPage = false;
  int pageNumber = 0;
  int perPage = 20;

  LoadMoreListener _listener;
  LendRepository _lendRepository;
  StreamController _itemsController;

  StreamSink<ApiResponse<MyLoanHistoryListResponse>> get loanListItemsSink =>
      _itemsController?.sink;

  Stream<ApiResponse<MyLoanHistoryListResponse>> get loanListItemsStream =>
      _itemsController?.stream;

  List<MyLoanListItem> loanItemsList = [];

  MyLoanHistoryBloc(this._listener, HistoryType type) {
    _lendRepository = LendRepository();
    _itemsController =
        StreamController<ApiResponse<MyLoanHistoryListResponse>>();
  }

  getMyLoanList(bool isPagination) async {
    if (isPagination) {
      _listener.refresh(true);
    } else {
      pageNumber = 0;
      loanListItemsSink.add(ApiResponse.loading('Fetching items'));
    }
    try {
      MyLoanHistoryListResponse response;
      response = await _lendRepository.getMyLoanList(pageNumber, perPage);

      hasNextPage = response.hasNextPage;
      pageNumber = response.page;
      if (isPagination) {
        if (loanItemsList.length == 0) {
          loanItemsList = response.list;
        } else {
          loanItemsList.addAll(response.list);
        }
      } else {
        loanItemsList = response.list;
      }
      loanListItemsSink.add(ApiResponse.completed(response));
      if (isPagination) {
        _listener.refresh(false);
      }
    } catch (error) {
      if (isPagination) {
        _listener.refresh(false);
      } else {
        loanListItemsSink
            .add(ApiResponse.error(CommonMethods().getNetworkError(error)));
      }
    }
  }

  dispose() {
    loanListItemsSink?.close();
    _itemsController?.close();
  }
}
