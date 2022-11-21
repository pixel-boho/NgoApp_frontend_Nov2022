import 'DonorOrSupporterInfo.dart';

class ParticipantsListResponse {
  bool _success;
  String _baseUrl;
  List<DonorOrSupporterInfo> _donorOrSupporterItemsList;
  int _page;
  int _perPage;
  bool _hasNextPage;
  int _totalCount;
  String _message;

  ParticipantsListResponse(
      {bool success,
      String baseUrl,
      List<DonorOrSupporterInfo> donorOrSupporterItemsList,
      int page,
      int perPage,
      bool hasNextPage,
      int totalCount,
      String message}) {
    this._success = success;
    this._baseUrl = baseUrl;
    this._donorOrSupporterItemsList = donorOrSupporterItemsList;
    this._page = page;
    this._perPage = perPage;
    this._hasNextPage = hasNextPage;
    this._totalCount = totalCount;
    this._message = message;
  }

  bool get success => _success;

  set success(bool success) => _success = success;

  String get baseUrl => _baseUrl;

  set baseUrl(String baseUrl) => _baseUrl = baseUrl;

  List<DonorOrSupporterInfo> get donorOrSupporterItemsList =>
      _donorOrSupporterItemsList;

  set donorOrSupporterItem(List<DonorOrSupporterInfo> donorOrSupporterItem) =>
      _donorOrSupporterItemsList = donorOrSupporterItemsList;

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

  ParticipantsListResponse.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _baseUrl = json['baseUrl'];
    if (json['list'] != null) {
      _donorOrSupporterItemsList = [];
      json['list'].forEach((v) {
        _donorOrSupporterItemsList.add(new DonorOrSupporterInfo.fromJson(v));
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
    data['success'] = this._success;
    data['baseUrl'] = this._baseUrl;
    if (this._donorOrSupporterItemsList != null) {
      data['list'] =
          this._donorOrSupporterItemsList.map((v) => v.toJson()).toList();
    }
    data['page'] = this._page;
    data['perPage'] = this._perPage;
    data['hasNextPage'] = this._hasNextPage;
    data['totalCount'] = this._totalCount;
    data['message'] = this._message;
    return data;
  }
}
