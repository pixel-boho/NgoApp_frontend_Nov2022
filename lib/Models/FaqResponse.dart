class FaqResponse {
  int _statusCode;
  List<FaqItem> _list;
  int _page;
  int _perPage;
  bool _hasNextPage;
  int _totalCount;
  String _message;
  bool _success;

  FaqResponse(
      {int statusCode,
      List<FaqItem> list,
      int page,
      int perPage,
      bool hasNextPage,
      int totalCount,
      String message,
      bool success}) {
    this._statusCode = statusCode;
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

  List<FaqItem> get list => _list;

  set list(List<FaqItem> list) => _list = list;

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

  FaqResponse.fromJson(Map<String, dynamic> json) {
    _statusCode = json['statusCode'];
    if (json['list'] != null) {
      _list = [];
      json['list'].forEach((v) {
        _list.add(new FaqItem.fromJson(v));
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

class FaqItem {
  int _id;
  String _question;
  String _answer;
  int _faqStatus;
  int _status;
  String _createdAt;
  String _modifiedAt;

  FaqItem(
      {int id,
      String question,
      String answer,
      int faqStatus,
      int status,
      String createdAt,
      String modifiedAt}) {
    this._id = id;
    this._question = question;
    this._answer = answer;
    this._faqStatus = faqStatus;
    this._status = status;
    this._createdAt = createdAt;
    this._modifiedAt = modifiedAt;
  }

  int get id => _id;

  set id(int id) => _id = id;

  String get question => _question;

  set question(String question) => _question = question;

  String get answer => _answer;

  set answer(String answer) => _answer = answer;

  int get faqStatus => _faqStatus;

  set faqStatus(int faqStatus) => _faqStatus = faqStatus;

  int get status => _status;

  set status(int status) => _status = status;

  String get createdAt => _createdAt;

  set createdAt(String createdAt) => _createdAt = createdAt;

  String get modifiedAt => _modifiedAt;

  set modifiedAt(String modifiedAt) => _modifiedAt = modifiedAt;

  FaqItem.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _question = json['question'];
    _answer = json['answer'];
    _faqStatus = json['faq_status'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _modifiedAt = json['modified_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['question'] = this._question;
    data['answer'] = this._answer;
    data['faq_status'] = this._faqStatus;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['modified_at'] = this._modifiedAt;
    return data;
  }
}
