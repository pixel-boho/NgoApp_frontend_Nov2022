import 'dart:async';

import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Models/FundraiseHistory.dart';
import 'package:ngo_app/Repositories/AuthorisationRepository.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';


class FundraiseHistoryBloc {
  bool hasNextPage = false;
  int pageNumber = 0;
  int perPage = 20;

  LoadMoreListener _listener;
  AuthorisationRepository _repository;

  StreamController _paymentinfoController;

  StreamSink<ApiResponse<FundraiseHistoryResponse>> get paymentinfoSink =>
      _paymentinfoController?.sink;

  Stream<ApiResponse<FundraiseHistoryResponse>> get paymentinfoStream =>
      _paymentinfoController?.stream;

  List<PaymentHist> fundraiseList = [];


  FundraiseHistoryBloc(this._listener) {
    _repository = AuthorisationRepository();
    _paymentinfoController =
        StreamController<ApiResponse<FundraiseHistoryResponse>>();
    getFundraiseHistoryList(true, null);
  }

  getFundraiseHistoryList(bool isPagination, int idReceived) async {
    if (isPagination) {
      _listener.refresh(true);
    } else {
      pageNumber = 0;
      paymentinfoSink.add(ApiResponse.loading('Fetching items'));
    }
    try {
      FundraiseHistoryResponse response;
      response = await _repository.fetchFundraiseHistory(pageNumber, perPage);
      hasNextPage = response.hasNextPage;
      pageNumber = response.page;
      if (isPagination) {
        if (fundraiseList.length == 0) {

          fundraiseList = response.paymentHist;
        } else {
          fundraiseList.addAll(response.paymentHist);
        }
      } else {
        fundraiseList = response.paymentHist;
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
