import 'package:ngo_app/Models/UserDetails.dart';

class ProfileResponse {
  bool _success;
  UserDetails _userDetails;
  String _message;
  String _baseUrl;

  ProfileResponse(
      {bool success, UserDetails userDetails, String message, String baseUrl}) {
    this._success = success;
    this._userDetails = userDetails;
    this._message = message;
    this._baseUrl = _baseUrl;
  }

  bool get success => _success;

  set success(bool success) => _success = success;

  UserDetails get userDetails => _userDetails;

  set userDetails(UserDetails userDetails) => _userDetails = userDetails;

  String get message => _message;

  set message(String message) => _message = message;

  String get baseUrl => _baseUrl;

  set baseUrl(String value) {
    _baseUrl = value;
  }

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _userDetails = json['userDetails'] != null
        ? new UserDetails.fromJson(json['userDetails'])
        : null;
    _message = json['message'];
    _baseUrl = json['baseUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this._success;
    if (this._userDetails != null) {
      data['userDetails'] = this._userDetails.toJson();
    }
    data['message'] = this._message;
    data['baseUrl'] = this._baseUrl;
    return data;
  }
}
