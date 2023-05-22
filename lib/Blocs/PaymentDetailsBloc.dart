import 'dart:async';
import 'package:ngo_app/Models/paymentHistoryResponse.dart';
import 'package:ngo_app/Repositories/AuthorisationRepository.dart';
import '../Constants/CommonMethods.dart';
import '../ServiceManager/ApiResponse.dart';

class PaymentInfoBloc {
  AuthorisationRepository _repository;

  StreamController _paymentinfoController;

  StreamSink<ApiResponse<PaymentHistoryResponse>> get paymentinfoSink => _paymentinfoController.sink;

  Stream<ApiResponse<PaymentHistoryResponse>> get paymentinfoStream => _paymentinfoController.stream;



  PaymentInfoBloc() {
    _repository = AuthorisationRepository();
    _paymentinfoController = StreamController<ApiResponse<PaymentHistoryResponse>>();
  }

  getPaymentInfo() async {
    paymentinfoSink.add(ApiResponse.loading('Fetching'));
    try {
      PaymentHistoryResponse response = await _repository.fetchUserpaymentdetails();
      if (response != null) {
        paymentinfoSink.add(ApiResponse.completed(response));
        return true;
      } else {
        paymentinfoSink.add(ApiResponse.error("Something went wrong"));
        return false;
      }
    } catch (error) {
      paymentinfoSink.add(ApiResponse.error(CommonMethods().getNetworkError(error)));
      return false;
    }
  }

  dispose() {
    paymentinfoSink?.close();
    _paymentinfoController?.close();
  }
}
