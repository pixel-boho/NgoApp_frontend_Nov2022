import 'dart:async';

import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Models/MyLendHistoryListResponse.dart';
import 'package:ngo_app/Repositories/LendRepository.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';

class MyLendHistoryBloc {
  bool hasNextPage = false;
  int pageNumber = 0;
  int perPage = 20;

  LoadMoreListener _listener;
  LendRepository _lendRepository;
  StreamController _itemsController;

  StreamSink<ApiResponse<MyLendHistoryListResponse>> get lendListItemsSink =>
      _itemsController?.sink;

  Stream<ApiResponse<MyLendHistoryListResponse>> get lendListItemsStream =>
      _itemsController?.stream;

  List<MyLendListItem> lendItemsList = [];

  MyLendHistoryBloc(this._listener) {
    _lendRepository = LendRepository();
    _itemsController =
        StreamController<ApiResponse<MyLendHistoryListResponse>>();
  }

  getMyLendList(bool isPagination) async {
    if (isPagination) {
      _listener.refresh(true);
    } else {
      pageNumber = 0;
      lendListItemsSink.add(ApiResponse.loading('Fetching items'));
    }
    try {
      MyLendHistoryListResponse response;
      response = await _lendRepository.getMyLendList(pageNumber, perPage);

      hasNextPage = response.hasNextPage;
      pageNumber = response.page;
      if (isPagination) {
        if (lendItemsList.length == 0) {
          lendItemsList = response.list;
        } else {
          lendItemsList.addAll(response.list);
        }
      } else {
        lendItemsList = response.list;
      }
      lendListItemsSink.add(ApiResponse.completed(response));
      if (isPagination) {
        _listener.refresh(false);
      }
    } catch (error) {
      if (isPagination) {
        _listener.refresh(false);
      } else {
        lendListItemsSink
            .add(ApiResponse.error(CommonMethods().getNetworkError(error)));
      }
    }
  }

  dispose() {
    lendListItemsSink?.close();
    _itemsController?.close();
  }
}
