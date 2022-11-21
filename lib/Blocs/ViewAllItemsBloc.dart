import 'dart:async';

import 'package:ngo_app/Models/CommonViewAllResponse.dart';
import 'package:ngo_app/Models/FundraiserItem.dart';
import 'package:ngo_app/Repositories/CommonInfoRepository.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

import '../Constants/CommonMethods.dart';
import '../Interfaces/LoadMoreListener.dart';
import '../ServiceManager/ApiResponse.dart';

class ViewAllItemsBloc {
  bool hasNextPage = false;
  int pageNumber = 0;
  int perPage = 30;

  CommonInfoRepository _commonInfoRepository;

  StreamController _itemsController;

  StreamSink<ApiResponse<CommonViewAllResponse>> get itemsSink =>
      _itemsController.sink;

  Stream<ApiResponse<CommonViewAllResponse>> get itemsStream =>
      _itemsController.stream;

  List<FundraiserItem> itemsList = [];

  LoadMoreListener _listener;

  ViewAllItemsBloc(this._listener) {
    _itemsController =
        StreamController<ApiResponse<CommonViewAllResponse>>();
    _commonInfoRepository = CommonInfoRepository();
  }

  getItems(bool isPagination, bool isFundraisers) async {
    if (isPagination) {
      _listener.refresh(true);
    } else {
      pageNumber = 0;
      itemsSink.add(ApiResponse.loading("Fetching"));
    }
    try {
      CommonViewAllResponse commonViewAllResponse;
      if (isFundraisers) {
        commonViewAllResponse =
            await _commonInfoRepository.getAllFundraiserItems(
                pageNumber, perPage, getCategorySelected(), getSortOption());
      } else {
        commonViewAllResponse =
            await _commonInfoRepository.getAllCampaignRelatedItems(
                pageNumber, perPage, getCategorySelected(), getSortOption());
      }
      hasNextPage = commonViewAllResponse.hasNextPage;
      pageNumber = commonViewAllResponse.page;
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
      print("****");
      print(error.toString());
      print("****");
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

  dynamic getCategorySelected() {
    int categorySelected;
    if (LoginModel().campaignsListSaved != null) {
      for (var data in LoginModel().campaignsListSaved) {
        if (data.isSelected) {
          categorySelected = data.id;
          break;
        }
      }
    }
    if (categorySelected != null) {
      return categorySelected;
    } else {
      return null;
    }
  }

  dynamic getSortOption() {
    String sort;
    if (LoginModel().sortOptions != null) {
      for (var data in LoginModel().sortOptions) {
        if (data.isSelected) {
          sort = data.optionValue;
          break;
        }
      }
    }
    if (sort != null) {
      return sort;
    } else {
      return null;
    }
  }
}
