import 'dart:async';

import 'package:ngo_app/Models/FaqResponse.dart';
import 'package:ngo_app/Repositories/CommonInfoRepository.dart';

import '../Constants/CommonMethods.dart';
import '../Interfaces/LoadMoreListener.dart';
import '../ServiceManager/ApiResponse.dart';

class FaqBloc {
  bool hasNextPage = false;
  int pageNumber = 0;
  int perPage = 50;

  CommonInfoRepository _commonInfoRepository;

  StreamController _faqController;

  StreamSink<ApiResponse<FaqResponse>> get faqSink => _faqController.sink;

  Stream<ApiResponse<FaqResponse>> get faqStream => _faqController.stream;

  List<FaqItem> faqList = [];

  LoadMoreListener _listener;

  FaqBloc(this._listener) {
    _commonInfoRepository = CommonInfoRepository();
    _faqController = StreamController<ApiResponse<FaqResponse>>();
  }

  getFaqs(bool isPagination) async {
    if (isPagination) {
      _listener.refresh(true);
    } else {
      pageNumber = 0;
      faqSink.add(ApiResponse.loading('Fetching faqs'));
    }
    try {
      FaqResponse response =
          await _commonInfoRepository.getFaqs(pageNumber, perPage);
      hasNextPage = response.hasNextPage;
      pageNumber = response.page;
      if (isPagination) {
        if (faqList.length == 0) {
          faqList = response.list;
        } else {
          faqList.addAll(response.list);
        }
      } else {
        faqList = response.list;
      }

      faqSink.add(ApiResponse.completed(response));
      if (isPagination) {
        _listener.refresh(false);
      }
    } catch (error) {
      if (isPagination) {
        _listener.refresh(false);
      } else {
        faqSink.add(ApiResponse.error(CommonMethods().getNetworkError(error)));
      }
    }
  }

  dispose() {
    faqSink?.close();
    _faqController?.close();
  }
}
