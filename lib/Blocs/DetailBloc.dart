import 'dart:async';

import 'package:ngo_app/Models/ItemDetailResponse.dart';
import 'package:ngo_app/Repositories/CommonInfoRepository.dart';

import '../Constants/CommonMethods.dart';
import '../ServiceManager/ApiResponse.dart';

class DetailBloc {
  CommonInfoRepository _commonInfoRepository;

  StreamController _detailController;

  StreamSink<ApiResponse<ItemDetailResponse>> get detailSink =>
      _detailController.sink;

  Stream<ApiResponse<ItemDetailResponse>> get detailStream =>
      _detailController.stream;

  DetailBloc() {
    _commonInfoRepository = CommonInfoRepository();
    _detailController = StreamController<ApiResponse<ItemDetailResponse>>();
  }

  getDetail(int id) async {
    detailSink.add(ApiResponse.loading('Fetching detail info'));

    try {
      ItemDetailResponse response =
          await _commonInfoRepository.getFundraiserDetail(id);
      if (response.success) {
        detailSink.add(ApiResponse.completed(response));
        if (response.fundraiserDetails?.campaignId != null) {
          CommonMethods().getAllRelatedItems(
              categoryId: response.fundraiserDetails?.campaignId);
        }
      } else {
        detailSink.add(ApiResponse.error("Something went wrong"));
      }
    } catch (error) {
      detailSink.add(ApiResponse.error(CommonMethods().getNetworkError(error)));
    }
  }

  dispose() {
    detailSink?.close();
    _detailController?.close();
  }
}
