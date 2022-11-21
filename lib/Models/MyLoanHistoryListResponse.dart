class MyLoanHistoryListResponse {
  int _statusCode;
  String _baseUrl;
  List<MyLoanListItem> _list;
  int _page;
  int _perPage;
  bool _hasNextPage;
  int _totalCount;
  String _message;
  bool _success;

  MyLoanHistoryListResponse(
      {int statusCode,
        String baseUrl,
        List<MyLoanListItem> list,
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
  List<MyLoanListItem> get list => _list;
  set list(List<MyLoanListItem> list) => _list = list;
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

  MyLoanHistoryListResponse.fromJson(Map<String, dynamic> json) {
    _statusCode = json['statusCode'];
    _baseUrl = json['baseUrl'];
    if (json['list'] != null) {
      _list =[];
      json['list'].forEach((v) {
        _list.add(new MyLoanListItem.fromJson(v));
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

class MyLoanListItem {
  int _id;
  String _title;
  String _purpose;
  int _amount;
  String _location;
  String _description;
  String _closingDate;
  int _createdBy;
  String _imageUrl;
  int _status;
  String _createdAt;
  String _modifiedAt;

  List(
      {int id,
        String title,
        String purpose,
        int amount,
        String location,
        String description,
        String closingDate,
        int createdBy,
        String imageUrl,
        int status,
        String createdAt,
        String modifiedAt}) {
    this._id = id;
    this._title = title;
    this._purpose = purpose;
    this._amount = amount;
    this._location = location;
    this._description = description;
    this._closingDate = closingDate;
    this._createdBy = createdBy;
    this._imageUrl = imageUrl;
    this._status = status;
    this._createdAt = createdAt;
    this._modifiedAt = modifiedAt;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get title => _title;
  set title(String title) => _title = title;
  String get purpose => _purpose;
  set purpose(String purpose) => _purpose = purpose;
  int get amount => _amount;
  set amount(int amount) => _amount = amount;
  String get location => _location;
  set location(String location) => _location = location;
  String get description => _description;
  set description(String description) => _description = description;
  String get closingDate => _closingDate;
  set closingDate(String closingDate) => _closingDate = closingDate;
  int get createdBy => _createdBy;
  set createdBy(int createdBy) => _createdBy = createdBy;
  String get imageUrl => _imageUrl;
  set imageUrl(String imageUrl) => _imageUrl = imageUrl;
  int get status => _status;
  set status(int status) => _status = status;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get modifiedAt => _modifiedAt;
  set modifiedAt(String modifiedAt) => _modifiedAt = modifiedAt;

  MyLoanListItem.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _purpose = json['purpose'];
    _amount = json['amount'];
    _location = json['location'];
    _description = json['description'];
    _closingDate = json['closing_date'];
    _createdBy = json['created_by'];
    _imageUrl = json['image_url'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _modifiedAt = json['modified_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['title'] = this._title;
    data['purpose'] = this._purpose;
    data['amount'] = this._amount;
    data['location'] = this._location;
    data['description'] = this._description;
    data['closing_date'] = this._closingDate;
    data['created_by'] = this._createdBy;
    data['image_url'] = this._imageUrl;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['modified_at'] = this._modifiedAt;
    return data;
  }
}