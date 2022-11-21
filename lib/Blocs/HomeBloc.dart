import 'dart:async';

import 'package:ngo_app/Repositories/CommonInfoRepository.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

import '../Constants/CommonMethods.dart';
import '../Models/HomeResponse.dart';
import '../ServiceManager/ApiResponse.dart';

class HomeBloc {
  CommonInfoRepository _homeRepository;

  StreamController _homeController;

  StreamSink<ApiResponse<HomeResponse>> get homeSink => _homeController.sink;

  Stream<ApiResponse<HomeResponse>> get homeStream => _homeController.stream;

  HomeBloc() {
    _homeRepository = CommonInfoRepository();
    _homeController = StreamController<ApiResponse<HomeResponse>>();
  }

  getHomeItems() async {
    homeSink.add(ApiResponse.loading('Fetching Home info'));

    try {
      HomeResponse homeResponse = await _homeRepository.getHomeItems();
      if (homeResponse.success) {
        if (homeResponse.campaignList != null) {
          if (homeResponse.campaignList.length > 0) {
            LoginModel().campaignsListSaved = homeResponse.campaignList;
          }
        }
        homeSink.add(ApiResponse.completed(homeResponse));
      } else {
        homeSink.add(ApiResponse.error("Something went wrong"));
      }
    } catch (error) {
      homeSink.add(ApiResponse.error(CommonMethods().getNetworkError(error)));
    }
  }

  dispose() {
    homeSink?.close();
    _homeController?.close();
  }
}
