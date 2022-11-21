import 'dart:async';

import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Models/LoanLendDetailsResponse.dart';
import 'package:ngo_app/Repositories/LendRepository.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';

class LoanLendDetailsBloc {
  LendRepository _lendRepository;
  StreamController _itemsController;

  StreamSink<ApiResponse<LoanLendDetailsResponse>> get detailSink =>
      _itemsController.sink;

  Stream<ApiResponse<LoanLendDetailsResponse>> get detailStream =>
      _itemsController.stream;

  LoanLendDetailsBloc() {
    _lendRepository = LendRepository();
    _itemsController = StreamController<ApiResponse<LoanLendDetailsResponse>>();
  }

  getDetails(int id) async {
    detailSink.add(ApiResponse.loading('Fetching detail info'));
    try {
      LoanLendDetailsResponse response =
          await _lendRepository.getLoanLendDetails(id);
      if (response.success) {
        detailSink.add(ApiResponse.completed(response));
      } else {
        detailSink.add(ApiResponse.error("Something went wrong"));
      }
    } catch (error) {
      detailSink.add(ApiResponse.error(CommonMethods().getNetworkError(error)));
    }
  }

  dispose() {
    detailSink?.close();
    _itemsController?.close();
  }
}
