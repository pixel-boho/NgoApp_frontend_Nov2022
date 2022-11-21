import 'dart:async';

import 'package:ngo_app/Models/CampaignItem.dart';
import 'package:ngo_app/Models/CampaignTypesResponse.dart';
import 'package:ngo_app/Repositories/CommonInfoRepository.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

import '../Constants/CommonMethods.dart';
import '../Interfaces/LoadMoreListener.dart';
import '../ServiceManager/ApiResponse.dart';

class CampaignTypesBloc {
  bool hasNextPage = false;
  int pageNumber = 0;
  int perPage = 50;

  CommonInfoRepository _commonInfoRepository;

  StreamController _typesController;

  StreamSink<ApiResponse<CampaignTypesResponse>> get typesSink =>
      _typesController.sink;

  Stream<ApiResponse<CampaignTypesResponse>> get typesStream =>
      _typesController.stream;

  List<CampaignItem> campaignTypesList = [];

  LoadMoreListener _listener;

  CampaignTypesBloc(this._listener) {
    _commonInfoRepository = CommonInfoRepository();
    _typesController = StreamController<ApiResponse<CampaignTypesResponse>>();
  }

  getCampaignTypes(bool isPagination) async {
    if (isPagination) {
      _listener.refresh(true);
    } else {
      pageNumber = 0;
      typesSink.add(ApiResponse.loading('Fetching types'));
    }
    try {
      CampaignTypesResponse campaignTypesResponse =
          await _commonInfoRepository.getCampaignTypes(pageNumber, perPage);
      hasNextPage = campaignTypesResponse.hasNextPage;
      pageNumber = campaignTypesResponse.page;
      if (isPagination) {
        if (campaignTypesList.length == 0) {
          campaignTypesList = campaignTypesResponse.campaignsList;
        } else {
          campaignTypesList.addAll(campaignTypesResponse.campaignsList);
        }
      } else {
        campaignTypesList = campaignTypesResponse.campaignsList;
      }

      if (campaignTypesList != null) {
        if (campaignTypesList.length > 0) {
          LoginModel().campaignsListSaved = campaignTypesResponse.campaignsList;
        }
      }
      typesSink.add(ApiResponse.completed(campaignTypesResponse));
      if (isPagination) {
        _listener.refresh(false);
      }
    } catch (error) {
      if (isPagination) {
        _listener.refresh(false);
      } else {
        typesSink
            .add(ApiResponse.error(CommonMethods().getNetworkError(error)));
      }
    }
  }

  dispose() {
    typesSink?.close();
    _typesController?.close();
  }
}
