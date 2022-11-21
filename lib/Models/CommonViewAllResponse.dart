import 'package:ngo_app/Models/FundraiserItem.dart';

class CommonViewAllResponse {
  int _statusCode;
  String _baseUrl;
  List<FundraiserItem> _itemsList;
  int _page;
  int _perPage;
  bool _hasNextPage;
  int _totalCount;
  String _message;
  String _webBaseUrl;

  CommonViewAllResponse(
      {int statusCode,
      String baseUrl,
      List<FundraiserItem> itemsList,
      int page,
      int perPage,
      bool hasNextPage,
      int totalCount,
      String message,
      String webBaseUrl}) {
    this._statusCode = statusCode;
    this._baseUrl = baseUrl;
    this._itemsList = itemsList;
    this._page = page;
    this._perPage = perPage;
    this._hasNextPage = hasNextPage;
    this._totalCount = totalCount;
    this._message = message;
    this._webBaseUrl = webBaseUrl;
  }

  int get statusCode => _statusCode;

  set statusCode(int statusCode) => _statusCode = statusCode;

  String get baseUrl => _baseUrl;

  set baseUrl(String baseUrl) => _baseUrl = baseUrl;

  List<FundraiserItem> get itemsList => _itemsList;

  set list(List<FundraiserItem> itemsList) => _itemsList = itemsList;

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


  String get webBaseUrl => _webBaseUrl;

  set webBaseUrl(String value) {
    _webBaseUrl = value;
  }

  CommonViewAllResponse.fromJson(Map<String, dynamic> json) {
    _statusCode = json['statusCode'];
    _baseUrl = json['baseUrl'];
    if (json['list'] != null) {
      _itemsList = [];
      json['list'].forEach((v) {
        _itemsList.add(new FundraiserItem.fromJson(v));
      });
    }
    _page = json['page'];
    _perPage = json['perPage'];
    _hasNextPage = json['hasNextPage'];
    _totalCount = json['totalCount'];
    _message = json['message'];
    _webBaseUrl = json.containsKey("webBaseUrl") ? json['webBaseUrl'] : "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this._statusCode;
    data['baseUrl'] = this._baseUrl;
    if (this._itemsList != null) {
      data['list'] = this._itemsList.map((v) => v.toJson()).toList();
    }
    data['page'] = this._page;
    data['perPage'] = this._perPage;
    data['hasNextPage'] = this._hasNextPage;
    data['totalCount'] = this._totalCount;
    data['message'] = this._message;
    data['webBaseUrl'] = this._webBaseUrl;
    return data;
  }
}
