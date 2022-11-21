import 'dart:async';

import 'package:ngo_app/Models/BankInfo.dart';
import 'package:ngo_app/Models/PointsResponse.dart';
import 'package:ngo_app/Repositories/CommonInfoRepository.dart';

import '../Constants/CommonMethods.dart';
import '../ServiceManager/ApiResponse.dart';

class PointsInfoBloc {
  CommonInfoRepository _commonRepository;

  StreamController _infoController;

  StreamSink<ApiResponse<PointsResponse>> get infoSink => _infoController.sink;

  Stream<ApiResponse<PointsResponse>> get infoStream => _infoController.stream;

  PointsInfoBloc() {
    _commonRepository = CommonInfoRepository();
    _infoController = StreamController<ApiResponse<PointsResponse>>();
  }

  getInfo() async {
    infoSink.add(ApiResponse.loading('Fetching'));
    try {
      PointsResponse response = await _commonRepository.getPointsInfo();
      if (response != null) {
        infoSink.add(ApiResponse.completed(response));
        return true;
      } else {
        infoSink.add(ApiResponse.error("Something went wrong"));
        return false;
      }
    } catch (error) {
      infoSink.add(ApiResponse.error(CommonMethods().getNetworkError(error)));
      return false;
    }
  }

  dispose() {
    infoSink?.close();
    _infoController?.close();
  }
}
