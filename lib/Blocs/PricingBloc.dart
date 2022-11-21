import 'dart:async';

import 'package:ngo_app/Models/PricingStrategiesResponse.dart';
import 'package:ngo_app/Repositories/CommonInfoRepository.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

import '../Constants/CommonMethods.dart';
import '../ServiceManager/ApiResponse.dart';

class PricingBloc {
  CommonInfoRepository _commonRepository;

  StreamController _pricingController;

  StreamSink<ApiResponse<PricingStrategiesResponse>> get pricingSink =>
      _pricingController.sink;

  Stream<ApiResponse<PricingStrategiesResponse>> get pricingStream =>
      _pricingController.stream;

  List<PricingInfo> pricingList;

  PricingBloc() {
    _commonRepository = CommonInfoRepository();
    _pricingController =
        StreamController<ApiResponse<PricingStrategiesResponse>>();
  }

  getItems(bool isWhileFundraiser) async {
    pricingSink.add(ApiResponse.loading('Fetching Home info'));

    try {
      PricingStrategiesResponse response =
          await _commonRepository.getPricingInfo();
      if (response.statusCode == 200) {
        pricingList = response.list;
        if (isWhileFundraiser) {
          if (LoginModel().isFundraiserEditMode &&
              LoginModel().itemDetailResponseInEditMode != null) {
            for (var dat in pricingList) {
              if (dat.id ==
                  LoginModel()
                      .itemDetailResponseInEditMode
                      .fundraiserDetails
                      ?.pricingId) {
                dat.isSelected = true;
              } else {
                dat.isSelected = false;
              }
            }
          }
        }
        pricingSink.add(ApiResponse.completed(response));
      } else {
        pricingSink.add(ApiResponse.error("Something went wrong"));
      }
    } catch (error) {
      pricingSink
          .add(ApiResponse.error(CommonMethods().getNetworkError(error)));
    }
  }

  dispose() {
    pricingSink?.close();
    _pricingController?.close();
  }
}
