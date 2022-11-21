class SearchResponse {
  bool _success;
  int _statusCode;
  List<SearchItem> _searchList;
  String _message;

  SearchResponse(
      {bool success,
      int statusCode,
      List<SearchItem> searchList,
      String message}) {
    this._success = success;
    this._statusCode = statusCode;
    this._searchList = searchList;
    this._message = message;
  }

  bool get success => _success;

  set success(bool success) => _success = success;

  int get statusCode => _statusCode;

  set statusCode(int statusCode) => _statusCode = statusCode;

  List<SearchItem> get searchList => _searchList;

  set list(List<SearchItem> searchList) => _searchList = searchList;

  String get message => _message;

  set message(String message) => _message = message;

  SearchResponse.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _statusCode = json['statusCode'];
    if (json['list'] != null) {
      _searchList = [];
      json['list'].forEach((v) {
        _searchList.add(new SearchItem.fromJson(v));
      });
    }
    _message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this._success;
    data['statusCode'] = this._statusCode;
    if (this._searchList != null) {
      data['list'] = this._searchList.map((v) => v.toJson()).toList();
    }
    data['message'] = this._message;
    data['message'] = this._message;
    return data;
  }
}

class SearchItem {
  int _id;
  String _title;
  String _type;

  SearchItem({int id, String title, String type}) {
    this._id = id;
    this._title = title;
    this._type = type;
  }

  int get id => _id;

  set id(int id) => _id = id;

  String get title => _title;

  set title(String title) => _title = title;

  String get type => _type;

  set type(String type) => _type = type;

  SearchItem.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['title'] = this._title;
    data['type'] = this._type;
    return data;
  }
}
