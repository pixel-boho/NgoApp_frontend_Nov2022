import 'dart:async';

import 'package:ngo_app/Models/BankInfo.dart';
import 'package:ngo_app/Models/PricingStrategiesResponse.dart';
import 'package:ngo_app/Repositories/CommonInfoRepository.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

import '../Constants/CommonMethods.dart';
import '../ServiceManager/ApiResponse.dart';

class VerifyIfscBloc {
  CommonInfoRepository _commonRepository;

  StreamController _verifyController;

  StreamSink<ApiResponse<BankInfo>> get verifySink => _verifyController.sink;

  Stream<ApiResponse<BankInfo>> get verifyStream => _verifyController.stream;

  VerifyIfscBloc() {
    _commonRepository = CommonInfoRepository();
    _verifyController = StreamController<ApiResponse<BankInfo>>();
  }

  getBankInfo(String ifsc) async {
    verifySink.add(ApiResponse.loading('Fetching'));
    try {
      BankInfo response = await _commonRepository.getBankDetails(ifsc);
      if (response != null) {
        verifySink.add(ApiResponse.completed(response));
        return true;
      } else {
        verifySink.add(ApiResponse.error("Something went wrong"));
        return false;
      }
    } catch (error) {
      verifySink.add(ApiResponse.error(CommonMethods().getNetworkError(error)));
      return false;
    }
  }

  dispose() {
    verifySink?.close();
    _verifyController?.close();
  }
}
