class MyDonationsResponse {
  int _statusCode;
  String _baseUrl;
  List<DonatedInfo> _list;
  int _page;
  int _perPage;
  bool _hasNextPage;
  int _totalCount;
  String _message;
  bool _success;

  MyDonationsResponse(
      {int statusCode,
      String baseUrl,
      List<DonatedInfo> list,
      int page,
      int perPage,
      bool hasNextPage,
      int totalCount,
      String message,
      bool success}) {
    this._statusCode = statusCode;
    this._baseUrl = baseUrl;
    this._list = list;
    this._page = page;
    this._perPage = perPage;
    this._hasNextPage = hasNextPage;
    this._totalCount = totalCount;
    this._message = message;
    this._success = success;
  }

  int get statusCode => _statusCode;

  set statusCode(int statusCode) => _statusCode = statusCode;

  String get baseUrl => _baseUrl;

  set baseUrl(String baseUrl) => _baseUrl = baseUrl;

  List<DonatedInfo> get list => _list;

  set list(List<DonatedInfo> list) => _list = list;

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

  bool get success => _success;

  set success(bool success) => _success = success;

  MyDonationsResponse.fromJson(Map<String, dynamic> json) {
    _statusCode = json['statusCode'];
    _baseUrl = json['baseUrl'];
    if (json['list'] != null) {
      _list = [];
      json['list'].forEach((v) {
        _list.add(new DonatedInfo.fromJson(v));
      });
    }
    _page = json['page'];
    _perPage = json['perPage'];
    _hasNextPage = json['hasNextPage'];
    _totalCount = json['totalCount'];
    _message = json['message'];
    _success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this._statusCode;
    data['baseUrl'] = this._baseUrl;
    if (this._list != null) {
      data['list'] = this._list.map((v) => v.toJson()).toList();
    }
    data['page'] = this._page;
    data['perPage'] = this._perPage;
    data['hasNextPage'] = this._hasNextPage;
    data['totalCount'] = this._totalCount;
    data['message'] = this._message;
    data['success'] = this._success;
    return data;
  }
}

class DonatedInfo {
  String _title;
  String _imageUrl;
  String _amount;
  bool _subscribed;
  int _subscribeId;
  int _fundraiserId;

  DonatedInfo(
      {String title,
      String imageUrl,
      String amount,
      bool subscribed,
      int subscribeId,
      int fundraiserId}) {
    this._title = title;
    this._imageUrl = imageUrl;
    this._amount = amount;
    this._subscribed = subscribed;
    this._subscribeId = subscribeId;
    this._fundraiserId = fundraiserId;
  }

  String get title => _title;

  set title(String title) => _title = title;

  String get imageUrl => _imageUrl;

  set imageUrl(String imageUrl) => _imageUrl = imageUrl;

  String get amount => _amount;

  set amount(String amount) => _amount = amount;

  bool get subscribed => _subscribed;

  set subscribed(bool subscribed) => _subscribed = subscribed;

  int get subscribeId => _subscribeId;

  set subscribeId(int value) {
    _subscribeId = value;
  }


  int get fundraiserId => _fundraiserId;

  set fundraiserId(int value) {
    _fundraiserId = value;
  }

  DonatedInfo.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _imageUrl = json['image_url'];
    _amount = json['amount'];
    _subscribed = json['subscribed'];
    _subscribeId = json['subscribe_id'];
    _fundraiserId = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this._title;
    data['image_url'] = this._imageUrl;
    data['amount'] = this._amount;
    data['subscribed'] = this._subscribed;
    data['subscribe_id'] = this._subscribeId;
    data['id'] = this._fundraiserId;
    return data;
  }
}
