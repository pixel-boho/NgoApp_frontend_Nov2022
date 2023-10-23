

// class PaymentInfoBloc {
//   AuthorisationRepository _repository;
//
//   StreamController _paymentinfoController;
//
//   StreamSink<ApiResponse<PaymentHistoryResponse>> get paymentinfoSink => _paymentinfoController.sink;
//
//   Stream<ApiResponse<PaymentHistoryResponse>> get paymentinfoStream => _paymentinfoController.stream;
//
//
//
//   PaymentInfoBloc() {
//     _repository = AuthorisationRepository();
//     _paymentinfoController = StreamController<ApiResponse<PaymentHistoryResponse>>();
//   }
//
//   getPaymentInfo() async {
//     paymentinfoSink.add(ApiResponse.loading('Fetching'));
//     try {
//       PaymentHistoryResponse response = await _repository.fetchUserpaymentdetails();
//       if (response != null) {
//         paymentinfoSink.add(ApiResponse.completed(response));
//         return true;
//       } else {
//         paymentinfoSink.add(ApiResponse.error("Something went wrong"));
//         return false;
//       }
//     } catch (error) {
//       paymentinfoSink.add(ApiResponse.error(CommonMethods().getNetworkError(error)));
//       return false;
//     }
//   }
//
//   dispose() {
//     paymentinfoSink?.close();
//     _paymentinfoController?.close();
//   }
// }


import 'dart:async';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Repositories/AuthorisationRepository.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';

import '../Models/DonationHistory.dart';

class DonationHistoryBloc {
  bool hasNextPage = false;
  int pageNumber = 0;
  int perPage = 20;

  LoadMoreListener _listener;
  AuthorisationRepository _repository;

  StreamController _paymentinfoController;

  StreamSink<ApiResponse<DonationHistoryResponse>> get paymentinfoSink =>
      _paymentinfoController?.sink;

  Stream<ApiResponse<DonationHistoryResponse>> get paymentinfoStream =>
      _paymentinfoController?.stream;

  List<Donate> donatList = [];


  DonationHistoryBloc(this._listener) {
    _repository = AuthorisationRepository();
    _paymentinfoController =
        StreamController<ApiResponse<DonationHistoryResponse>>();
  }

  getPaymentHistoryList(bool isPagination, int idReceived) async {
    if (isPagination) {
      _listener.refresh(true);
    } else {
      pageNumber = 0;
      paymentinfoSink.add(ApiResponse.loading('Fetching items'));
    }
    try {
      DonationHistoryResponse response;
      response = await _repository.fetchDonationHistory(pageNumber, perPage);
      hasNextPage = response.hasNextPage;
      pageNumber = response.page;
      if (isPagination) {
        if (donatList.length == 0) {
          donatList = response.donate;
        } else {
          donatList.addAll(response.donate);
        }
      } else {
        donatList = response.donate;
      }
      paymentinfoSink.add(ApiResponse.completed(response));
      if (isPagination) {
        _listener.refresh(false);
      }
    } catch (error) {
      if (isPagination) {
        _listener.refresh(false);
      } else {
        paymentinfoSink
            .add(ApiResponse.error(CommonMethods().getNetworkError(error)));
      }
    }
  }

  dispose() {
    paymentinfoSink?.close();
    _paymentinfoController?.close();
  }
}
