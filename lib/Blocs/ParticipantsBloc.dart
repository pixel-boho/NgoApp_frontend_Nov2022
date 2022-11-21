import 'dart:async';

import 'package:ngo_app/Models/DonorOrSupporterInfo.dart';
import 'package:ngo_app/Models/ParticipantsListResponse.dart';
import 'package:ngo_app/Repositories/CommonInfoRepository.dart';

import '../Constants/CommonMethods.dart';
import '../Interfaces/LoadMoreListener.dart';
import '../ServiceManager/ApiResponse.dart';

class ParticipantsBloc {
  bool hasNextPage = false;
  int pageNumber = 0;
  int perPage = 40;

  CommonInfoRepository _commonInfoRepository;

  StreamController _commonController;

  StreamSink<ApiResponse<ParticipantsListResponse>> get commonSink =>
      _commonController.sink;

  Stream<ApiResponse<ParticipantsListResponse>> get commonStream =>
      _commonController.stream;

  List<DonorOrSupporterInfo> itemsList = [];

  LoadMoreListener _listener;

  ParticipantsBloc(this._listener) {
    _commonInfoRepository = CommonInfoRepository();
    _commonController =
        StreamController<ApiResponse<ParticipantsListResponse>>();
  }

  getAllPersonDetails(
      bool isPagination, int idReceived, bool _isForDonorsInfo) async {
    if (isPagination) {
      _listener.refresh(true);
    } else {
      pageNumber = 0;
      commonSink.add(ApiResponse.loading('Fetching info'));
    }
    try {
      ParticipantsListResponse response;
      if (_isForDonorsInfo) {
        response = await _commonInfoRepository.getAllDonors(
            pageNumber, perPage, idReceived);
      } else {
        response = await _commonInfoRepository.getAllSupporters(
            pageNumber, perPage, idReceived);
      }

      hasNextPage = response.hasNextPage;
      pageNumber = response.page;
      if (isPagination) {
        if (itemsList.length == 0) {
          itemsList = response.donorOrSupporterItemsList;
        } else {
          itemsList.addAll(response.donorOrSupporterItemsList);
        }
      } else {
        itemsList = response.donorOrSupporterItemsList;
      }
      commonSink.add(ApiResponse.completed(response));
      if (isPagination) {
        _listener.refresh(false);
      }
    } catch (error) {
      print("ErrInfo***");
      print(error.toString());
      if (isPagination) {
        _listener.refresh(false);
      } else {
        commonSink
            .add(ApiResponse.error(CommonMethods().getNetworkError(error)));
      }
    }
  }

  dispose() {
    commonSink?.close();
    _commonController?.close();
  }
}
