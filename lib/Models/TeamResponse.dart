class TeamResponse {
  int _statusCode;
  String _baseUrl;
  List<TeamItem> _list;
  int _page;
  int _perPage;
  bool _hasNextPage;
  int _totalCount;
  String _message;
  bool _success;

  TeamResponse(
      {int statusCode,
      String baseUrl,
      List<TeamItem> list,
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

  List<TeamItem> get list => _list;

  set list(List<TeamItem> list) => _list = list;

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

  TeamResponse.fromJson(Map<String, dynamic> json) {
    _statusCode = json['statusCode'];
    _baseUrl = json['baseUrl'];
    if (json['list'] != null) {
      _list = [];
      json['list'].forEach((v) {
        _list.add(new TeamItem.fromJson(v));
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

class TeamItem {
  int _id;
  String _employeeName;
  String _designation;
  String _imageUrl;
  int _status;
  String _createdAt;
  String _modifiedAt;

  TeamItem(
      {int id,
      String employeeName,
      String designation,
      String imageUrl,
      int status,
      String createdAt,
      String modifiedAt}) {
    this._id = id;
    this._employeeName = employeeName;
    this._designation = designation;
    this._imageUrl = imageUrl;
    this._status = status;
    this._createdAt = createdAt;
    this._modifiedAt = modifiedAt;
  }

  int get id => _id;

  set id(int id) => _id = id;

  String get employeeName => _employeeName;

  set employeeName(String employeeName) => _employeeName = employeeName;

  String get designation => _designation;

  set designation(String designation) => _designation = designation;

  String get imageUrl => _imageUrl;

  set imageUrl(String imageUrl) => _imageUrl = imageUrl;

  int get status => _status;

  set status(int status) => _status = status;

  String get createdAt => _createdAt;

  set createdAt(String createdAt) => _createdAt = createdAt;

  String get modifiedAt => _modifiedAt;

  set modifiedAt(String modifiedAt) => _modifiedAt = modifiedAt;

  TeamItem.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _employeeName = json['employee_name'];
    _designation = json['designation'];
    _imageUrl = json['image_url'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _modifiedAt = json['modified_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['employee_name'] = this._employeeName;
    data['designation'] = this._designation;
    data['image_url'] = this._imageUrl;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['modified_at'] = this._modifiedAt;
    return data;
  }
}
