import 'dart:async';

import 'package:ngo_app/Models/MyDonationsResponse.dart';
import 'package:ngo_app/Repositories/CommonInfoRepository.dart';

import '../Constants/CommonMethods.dart';
import '../Interfaces/LoadMoreListener.dart';
import '../ServiceManager/ApiResponse.dart';

class MyDonationsBloc {
  bool hasNextPage = false;
  int pageNumber = 0;
  int perPage = 50;

  CommonInfoRepository _commonInfoRepository;

  StreamController _itemsController;

  StreamSink<ApiResponse<MyDonationsResponse>> get itemsSink =>
      _itemsController.sink;

  Stream<ApiResponse<MyDonationsResponse>> get itemsStream =>
      _itemsController.stream;

  List<DonatedInfo> itemsList = [];

  LoadMoreListener _listener;

  MyDonationsBloc(this._listener) {
    _commonInfoRepository = CommonInfoRepository();
    _itemsController = StreamController<ApiResponse<MyDonationsResponse>>();
  }

  getItems(bool isPagination) async {
    if (isPagination) {
      _listener.refresh(true);
    } else {
      pageNumber = 0;
      itemsSink.add(ApiResponse.loading('Fetching items'));
    }
    try {
      MyDonationsResponse commonViewAllResponse;

      commonViewAllResponse =
          await _commonInfoRepository.getMyDonations(pageNumber, perPage);
      hasNextPage = commonViewAllResponse.hasNextPage;
      pageNumber = commonViewAllResponse.page;

      if (!isPagination && itemsList.length == 0) {
        CommonMethods().getAllRelatedItems();
      }

      if (isPagination) {
        if (itemsList.length == 0) {
          itemsList = commonViewAllResponse.list;
        } else {
          itemsList.addAll(commonViewAllResponse.list);
        }
      } else {
        itemsList = commonViewAllResponse.list;
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
