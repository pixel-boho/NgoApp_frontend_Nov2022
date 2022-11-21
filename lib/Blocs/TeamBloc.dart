import 'dart:async';

import 'package:ngo_app/Models/TeamResponse.dart';
import 'package:ngo_app/Repositories/CommonInfoRepository.dart';

import '../Constants/CommonMethods.dart';
import '../Interfaces/LoadMoreListener.dart';
import '../ServiceManager/ApiResponse.dart';

class TeamBloc {
  bool hasNextPage = false;
  int pageNumber = 0;
  int perPage = 50;

  CommonInfoRepository _commonInfoRepository;

  StreamController _teamController;

  StreamSink<ApiResponse<TeamResponse>> get teamSink => _teamController.sink;

  Stream<ApiResponse<TeamResponse>> get teamStream => _teamController.stream;

  List<TeamItem> teamList = [];

  LoadMoreListener _listener;

  TeamBloc(this._listener) {
    _commonInfoRepository = CommonInfoRepository();
    _teamController = StreamController<ApiResponse<TeamResponse>>();
  }

  getTeam(bool isPagination) async {
    if (isPagination) {
      _listener.refresh(true);
    } else {
      pageNumber = 0;
      teamSink.add(ApiResponse.loading('Fetching team'));
    }
    try {
      TeamResponse teamResponse =
          await _commonInfoRepository.getOurTeam(pageNumber, perPage);
      hasNextPage = teamResponse.hasNextPage;
      pageNumber = teamResponse.page;
      if (isPagination) {
        if (teamList.length == 0) {
          teamList = teamResponse.list;
        } else {
          teamList.addAll(teamResponse.list);
        }
      } else {
        teamList = teamResponse.list;
      }

      teamSink.add(ApiResponse.completed(teamResponse));
      if (isPagination) {
        _listener.refresh(false);
      }
    } catch (error) {
      if (isPagination) {
        _listener.refresh(false);
      } else {
        teamSink.add(ApiResponse.error(CommonMethods().getNetworkError(error)));
      }
    }
  }

  dispose() {
    teamSink?.close();
    _teamController?.close();
  }
}
