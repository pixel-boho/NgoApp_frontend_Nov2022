class PointsResponse {
  int _statusCode;
  List<Item> _list;
  String _message;
  bool _success;

  PointsResponse(
      {int statusCode, List<Item> list, String message, bool success}) {
    this._statusCode = statusCode;
    this._list = list;
    this._message = message;
    this._success = success;
  }

  int get statusCode => _statusCode;

  set statusCode(int statusCode) => _statusCode = statusCode;

  List<Item> get list => _list;

  set list(List<Item> list) => _list = list;

  String get message => _message;

  set message(String message) => _message = message;

  bool get success => _success;

  set success(bool success) => _success = success;

  PointsResponse.fromJson(Map<String, dynamic> json) {
    _statusCode = json['statusCode'];
    if (json['list'] != null) {
      _list = [];
      json['list'].forEach((v) {
        _list.add(new Item.fromJson(v));
      });
    }
    _message = json['message'];
    _success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this._statusCode;
    if (this._list != null) {
      data['list'] = this._list.map((v) => v.toJson()).toList();
    }
    data['message'] = this._message;
    data['success'] = this._success;
    return data;
  }
}

class Item {
  int _id;
  String _title;
  String _description;
  int _point;
  int _status;
  String _createdAt;
  String _modifiedAt;

  Item(
      {int id,
      String title,
      String description,
      int point,
      int status,
      String createdAt,
      String modifiedAt}) {
    this._id = id;
    this._title = title;
    this._description = description;
    this._point = point;
    this._status = status;
    this._createdAt = createdAt;
    this._modifiedAt = modifiedAt;
  }

  int get id => _id;

  set id(int id) => _id = id;

  String get title => _title;

  set title(String title) => _title = title;

  int get point => _point;

  set point(int point) => _point = point;

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

  Item.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _description = json['description'];
    _point = json['point'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _modifiedAt = json['modified_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['title'] = this._title;
    data['description'] = this._description;
    data['point'] = this._point;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['modified_at'] = this._modifiedAt;
    return data;
  }
}
