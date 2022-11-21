import 'dart:async';

import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Models/GatewayKeyResponse.dart';
import 'package:ngo_app/Repositories/PaymentRepository.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';

class PaymentBloc{
PaymentRepository _repository =PaymentRepository();
  StreamController _gatewayKeyController = StreamController<ApiResponse<GatewayKeyResponse>>.broadcast();
  // StreamController _itemsController = StreamController<ApiResponse<ApiKeyResponse>>.broadcast();

  StreamSink<ApiResponse<GatewayKeyResponse>> get detailSink => _gatewayKeyController.sink;
  Stream<ApiResponse<GatewayKeyResponse>> get detailStream => _gatewayKeyController.stream;

  getGatewayKey(String amount) async {
  try {
    GatewayKeyResponse response = await _repository.getGatewayKey();

    detailSink.add(ApiResponse.completed(response));
  } catch (error) {
    detailSink.add(ApiResponse.error(CommonMethods().getNetworkError(error)));
  }
}

dispose() {
  detailSink?.close();
  _gatewayKeyController?.close();
}
}