import 'dart:async';

import 'package:ngo_app/Models/CommentItem.dart';
import 'package:ngo_app/Models/CommentsListResponse.dart';
import 'package:ngo_app/Repositories/CommonInfoRepository.dart';

import '../Constants/CommonMethods.dart';
import '../Interfaces/LoadMoreListener.dart';
import '../ServiceManager/ApiResponse.dart';

class CommentsBloc {
  bool hasNextPage = false;
  int pageNumber = 0;
  int perPage = 30;

  CommonInfoRepository _commonInfoRepository;

  StreamController _commentsController;

  StreamSink<ApiResponse<CommentsListResponse>> get commentsSink =>
      _commentsController.sink;

  Stream<ApiResponse<CommentsListResponse>> get commentsStream =>
      _commentsController.stream;

  List<CommentItem> commentsList = [];

  LoadMoreListener _listener;

  CommentsBloc(this._listener) {
    _commonInfoRepository = CommonInfoRepository();
    _commentsController = StreamController<ApiResponse<CommentsListResponse>>();
  }

  getAllComments(bool isPagination, int idReceived) async {
    if (isPagination) {
      _listener.refresh(true);
    } else {
      pageNumber = 0;
      commentsSink.add(ApiResponse.loading('Fetching comments'));
    }
    try {
      CommentsListResponse response;
      if (idReceived != null) {
        response = await _commonInfoRepository.getAllComments(
            pageNumber, perPage, idReceived);
      } else {
        response =
            await _commonInfoRepository.getMyComments(pageNumber, perPage);
      }

      hasNextPage = response.hasNextPage;
      pageNumber = response.page;

      if (!isPagination && commentsList.length == 0) {
        CommonMethods().getAllRelatedItems();
      }

      if (isPagination) {
        if (commentsList.length == 0) {
          commentsList = response.commentsList;
        } else {
          commentsList.addAll(response.commentsList);
        }
      } else {
        commentsList = response.commentsList;
      }
      commentsSink.add(ApiResponse.completed(response));
      if (isPagination) {
        _listener.refresh(false);
      }
    } catch (error) {
      if (isPagination) {
        _listener.refresh(false);
      } else {
        commentsSink
            .add(ApiResponse.error(CommonMethods().getNetworkError(error)));
      }
    }
  }

  dispose() {
    commentsSink?.close();
    _commentsController?.close();
  }
}
