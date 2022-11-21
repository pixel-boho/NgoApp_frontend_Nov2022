
import 'dart:async';

import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Models/LendListResponse.dart';
import 'package:ngo_app/Repositories/LendRepository.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';


class LendBloc{
  bool hasNextPage = false;
  int pageNumber = 0;
  int perPage = 20;

  LoadMoreListener _listener;
  LendRepository _lendRepository;
  StreamController _itemsController;

  StreamSink<ApiResponse<LendListResponse>> get itemsSink => _itemsController.sink;
  Stream<ApiResponse<LendListResponse>> get itemsStream => _itemsController.stream;

  List<LendListItem> itemsList = [];

  LendBloc(this._listener) {
    _lendRepository = LendRepository();
    _itemsController = StreamController<ApiResponse<LendListResponse>>();
  }

  getList(bool isPagination) async {
    if (isPagination) {
      _listener.refresh(true);
    } else {
      pageNumber = 0;
      itemsSink.add(ApiResponse.loading('Fetching items'));
    }
    try {
      LendListResponse lendListResponse;
      lendListResponse = await _lendRepository
          .getLendList(pageNumber, perPage,'','');

      hasNextPage = lendListResponse.hasNextPage;
      pageNumber = lendListResponse.page;
      if (isPagination) {
        if (itemsList.length == 0) {
          itemsList = lendListResponse.list;
        } else {
          itemsList.addAll(lendListResponse.list);
        }
      } else {
        itemsList = lendListResponse.list;
      }
      itemsSink.add(ApiResponse.completed(lendListResponse));
      if (isPagination) {
        _listener.refresh(false);
      }
    } catch (error) {
      if (isPagination) {
        _listener.refresh(false);
      } else {
        itemsSink
            .add(ApiResponse.error(CommonMethods().getNetworkError(error)));
      }
    }
  }

  getPayment (){}
  
  dispose() {
    itemsSink?.close();
    _itemsController?.close();
  }
}