class RelationsResponse {
  int _statusCode;
  List<RelationInfo> _list;
  int _page;
  int _perPage;
  bool _hasNextPage;
  int _totalCount;
  String _message;

  RelationsResponse(
      {int statusCode,
      List<RelationInfo> list,
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

  List<RelationInfo> get list => _list;

  set list(List<RelationInfo> list) => _list = list;

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

  RelationsResponse.fromJson(Map<String, dynamic> json) {
    _statusCode = json['statusCode'];
    if (json['list'] != null) {
      _list = [];
      json['list'].forEach((v) {
        _list.add(new RelationInfo.fromJson(v));
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

class RelationInfo {
  int _id;
  String _title;
  int _relationStatus;
  int _status;
  String _createdAt;
  String _modifiedAt;
  bool _isSelected = false;

  RelationInfo(
      {int id,
      String title,
      int relationStatus,
      int status,
      String createdAt,
      String modifiedAt}) {
    this._id = id;
    this._title = title;
    this._relationStatus = relationStatus;
    this._status = status;
    this._createdAt = createdAt;
    this._modifiedAt = modifiedAt;
  }

  bool get isSelected => _isSelected;

  set isSelected(bool value) {
    _isSelected = value;
  }

  int get id => _id;

  set id(int id) => _id = id;

  String get title => _title;

  set title(String title) => _title = title;

  int get relationStatus => _relationStatus;

  set relationStatus(int relationStatus) => _relationStatus = relationStatus;

  int get status => _status;

  set status(int status) => _status = status;

  String get createdAt => _createdAt;

  set createdAt(String createdAt) => _createdAt = createdAt;

  String get modifiedAt => _modifiedAt;

  set modifiedAt(String modifiedAt) => _modifiedAt = modifiedAt;

  RelationInfo.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _relationStatus = json['relation_status'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _modifiedAt = json['modified_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['title'] = this._title;
    data['relation_status'] = this._relationStatus;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['modified_at'] = this._modifiedAt;
    return data;
  }
}
