import 'dart:async';

import 'package:ngo_app/Models/MediaResponse.dart';
import 'package:ngo_app/Repositories/CommonInfoRepository.dart';

import '../Constants/CommonMethods.dart';
import '../Interfaces/LoadMoreListener.dart';
import '../ServiceManager/ApiResponse.dart';

class MediaBloc {
  bool hasNextPage = false;
  int pageNumber = 0;
  int perPage = 50;

  CommonInfoRepository _commonInfoRepository;

  StreamController _mediaController;

  StreamSink<ApiResponse<MediaResponse>> get mediaSink => _mediaController.sink;

  Stream<ApiResponse<MediaResponse>> get mediaStream => _mediaController.stream;

  List<MediaItem> mediaList = [];

  LoadMoreListener _listener;

  MediaBloc(this._listener) {
    _commonInfoRepository = CommonInfoRepository();
    _mediaController = StreamController<ApiResponse<MediaResponse>>();
  }

  getMediaItems(bool isPagination) async {
    if (isPagination) {
      _listener.refresh(true);
    } else {
      pageNumber = 0;
      mediaSink.add(ApiResponse.loading('Fetching faqs'));
    }
    try {
      MediaResponse response =
          await _commonInfoRepository.getMediaItems(pageNumber, perPage);
      hasNextPage = response.hasNextPage;
      pageNumber = response.page;
      if (isPagination) {
        if (mediaList.length == 0) {
          mediaList = response.list;
        } else {
          mediaList.addAll(response.list);
        }
      } else {
        mediaList = response.list;
      }

      mediaSink.add(ApiResponse.completed(response));
      if (isPagination) {
        _listener.refresh(false);
      }
    } catch (error) {
      if (isPagination) {
        _listener.refresh(false);
      } else {
        mediaSink
            .add(ApiResponse.error(CommonMethods().getNetworkError(error)));
      }
    }
  }

  dispose() {
    mediaSink?.close();
    _mediaController?.close();
  }
}
