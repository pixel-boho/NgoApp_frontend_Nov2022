class PricingStrategiesResponse {
  int _statusCode;
  List<PricingInfo> _list;
  int _page;
  int _perPage;
  bool _hasNextPage;
  int _totalCount;
  String _message;

  PricingStrategiesResponse(
      {int statusCode,
      List<PricingInfo> list,
      int page,
      int perPage,
      bool hasNextPage,
      int totalCount,
      String message}) {
    this._statusCode = statusCode;
    this._list = list;
    this._page = page;
    this._perPage = perPage;
    this._hasNextPage = hasNextPage;
    this._totalCount = totalCount;
    this._message = message;
  }

  int get statusCode => _statusCode;

  set statusCode(int statusCode) => _statusCode = statusCode;

  List<PricingInfo> get list => _list;

  set list(List<PricingInfo> list) => _list = list;

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

  PricingStrategiesResponse.fromJson(Map<String, dynamic> json) {
    _statusCode = json['statusCode'];
    if (json['list'] != null) {
      _list = [];
      json['list'].forEach((v) {
        _list.add(new PricingInfo.fromJson(v));
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
    if (this._list != null) {
      data['list'] = this._list.map((v) => v.toJson()).toList();
    }
    data['page'] = this._page;
    data['perPage'] = this._perPage;
    data['hasNextPage'] = this._hasNextPage;
    data['totalCount'] = this._totalCount;
    data['message'] = this._message;
    return data;
  }
}

class PricingInfo {
  int _id;
  String _title;
  String _description;
  dynamic _percentage;
  int _status;
  String _createdAt;
  String _modifiedAt;
  bool isSelected = false;

  PricingInfo(
      {int id,
      String title,
      String description,
      dynamic percentage,
      int status,
      String createdAt,
      String modifiedAt}) {
    this._id = id;
    this._title = title;
    this._description = description;
    this._percentage = percentage;
    this._status = status;
    this._createdAt = createdAt;
    this._modifiedAt = modifiedAt;
    this.isSelected = false;
  }

  int get id => _id;

  set id(int id) => _id = id;

  String get title => _title;

  set title(String title) => _title = title;

  dynamic get percentage => _percentage;

  set percentage(dynamic percentage) => _percentage = percentage;

  int get status => _status;

  set status(int status) => _status = status;

  String get createdAt => _createdAt;

  set createdAt(String createdAt) => _createdAt = createdAt;

  String get modifiedAt => _modifiedAt;

  set modifiedAt(String modifiedAt) => _modifiedAt = modifiedAt;

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  PricingInfo.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _description = json['description'] ?? "";
    _percentage = json['percentage'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _modifiedAt = json['modified_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['title'] = this._title;
    data['description'] = this._description;
    data['percentage'] = this._percentage;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['modified_at'] = this._modifiedAt;
    return data;
  }
}
