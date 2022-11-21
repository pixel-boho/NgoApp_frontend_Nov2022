import 'UserDetails.dart';

class LoginResponse {
  String _message;
  int _userId;
  UserDetails _userDetails;
  String _apiToken;
  bool _success;

  LoginResponse(
      {String message,
      int userId,
      UserDetails userDetails,
      String apiToken,
      bool success}) {
    this._message = message;
    this._userId = userId;
    this._userDetails = userDetails;
    this._apiToken = apiToken;
    this._success = success;
  }

  String get message => _message;

  set message(String message) => _message = message;

  int get userId => _userId;

  set userId(int userId) => _userId = userId;

  UserDetails get userDetails => _userDetails;

  set userDetails(UserDetails userDetails) => _userDetails = userDetails;

  String get apiToken => _apiToken;

  set apiToken(String apiToken) => _apiToken = apiToken;

  bool get success => _success;

  set success(bool success) => _success = success;

  LoginResponse.fromJson(Map<String, dynamic> json) {
    _message = json['message'];
    _userId = json['userId'];
    _userDetails = json['userDetails'] != null
        ? new UserDetails.fromJson(json['userDetails'])
        : null;
    _apiToken = json['apiToken'];
    _success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this._message;
    data['userId'] = this._userId;
    if (this._userDetails != null) {
      data['userDetails'] = this._userDetails.toJson();
    }
    data['apiToken'] = this._apiToken;
    data['success'] = this._success;
    return data;
  }
}
