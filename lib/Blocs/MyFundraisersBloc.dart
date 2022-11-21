import 'dart:async';

import 'package:ngo_app/Models/CommonViewAllResponse.dart';
import 'package:ngo_app/Models/FundraiserItem.dart';
import 'package:ngo_app/Repositories/CommonInfoRepository.dart';

import '../Constants/CommonMethods.dart';
import '../Interfaces/LoadMoreListener.dart';
import '../ServiceManager/ApiResponse.dart';

class MyFundraisersBloc {
  bool hasNextPage = false;
  int pageNumber = 0;
  int perPage = 20;

  CommonInfoRepository _commonInfoRepository;

  StreamController _itemsController;

  StreamSink<ApiResponse<CommonViewAllResponse>> get itemsSink =>
      _itemsController.sink;

  Stream<ApiResponse<CommonViewAllResponse>> get itemsStream =>
      _itemsController.stream;

  List<FundraiserItem> itemsList = [];

  LoadMoreListener _listener;

  MyFundraisersBloc(this._listener) {
    _commonInfoRepository = CommonInfoRepository();
    _itemsController = StreamController<ApiResponse<CommonViewAllResponse>>();
  }

  getItems(bool isPagination) async {
    if (isPagination) {
      _listener.refresh(true);
    } else {
      pageNumber = 0;
      itemsSink.add(ApiResponse.loading('Fetching items'));
    }
    try {
      CommonViewAllResponse commonViewAllResponse;

      commonViewAllResponse = await _commonInfoRepository
          .getMyOwnFundraiserItems(pageNumber, perPage);
      hasNextPage = commonViewAllResponse.hasNextPage;
      pageNumber = commonViewAllResponse.page;

      if (!isPagination && itemsList.length == 0) {
        CommonMethods().getAllRelatedItems();
      }

      if (isPagination) {
        if (itemsList.length == 0) {
          itemsList = commonViewAllResponse.itemsList;
        } else {
          itemsList.addAll(commonViewAllResponse.itemsList);
        }
      } else {
        itemsList = commonViewAllResponse.itemsList;
      }
      itemsSink.add(ApiResponse.completed(commonViewAllResponse));
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

  dispose() {
    itemsSink?.close();
    _itemsController?.close();
  }
}
