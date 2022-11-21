import 'package:ngo_app/Models/CommentItem.dart';

class CommentsListResponse {
  int _statusCode;
  String _baseUrl;
  List<CommentItem> _commentsList;
  int _page;
  int _perPage;
  bool _hasNextPage;
  int _totalCount;
  String _message;

  CommentsListResponse(
      {int statusCode,
      String baseUrl,
      List<CommentItem> commentsList,
      int page,
      int perPage,
      bool hasNextPage,
      int totalCount,
      String message}) {
    this._statusCode = statusCode;
    this._baseUrl = baseUrl;
    this._commentsList = commentsList;
    this._page = page;
    this._perPage = perPage;
    this._hasNextPage = hasNextPage;
    this._totalCount = totalCount;
    this._message = message;
  }

  int get statusCode => _statusCode;

  set statusCode(int statusCode) => _statusCode = statusCode;

  String get baseUrl => _baseUrl;

  set baseUrl(String baseUrl) => _baseUrl = baseUrl;

  List<CommentItem> get commentsList => _commentsList;

  set list(List<CommentItem> commentsList) => _commentsList = commentsList;

  int get page => _page;

  set page(int page) => _page = page;

  int get perPage => _perPage;

  set perPage(int perPage) => _perPage = perPage;

  bool get hasNextPage => _hasNextPage;

  set hasNextPage(bool hasNextPage) => _hasNextPage = hasNextPage;

  int get totalCount => _totalCount;

  set totalCount(int totalCount) => _totalCount = totalCount;

  String get message => _message;

  set message(String message) => _message = message;

  CommentsListResponse.fromJson(Map<String, dynamic> json) {
    _statusCode = json['statusCode'];
    _baseUrl = json['baseUrl'];
    if (json['list'] != null) {
      _commentsList = [];
      json['list'].forEach((v) {
        _commentsList.add(new CommentItem.fromJson(v));
      });
    }
    _page = json['page'];
    _perPage = json['perPage'];
    _hasNextPage = json['hasNextPage'];
    _totalCount = json['totalCount'];
    _message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this._statusCode;
    data['baseUrl'] = this._baseUrl;
    if (this._commentsList != null) {
      data['list'] = this._commentsList.map((v) => v.toJson()).toList();
    }
    data['page'] = this._page;
    data['perPage'] = this._perPage;
    data['hasNextPage'] = this._hasNextPage;
    data['totalCount'] = this._totalCount;
    data['message'] = this._message;
    return data;
  }
}
