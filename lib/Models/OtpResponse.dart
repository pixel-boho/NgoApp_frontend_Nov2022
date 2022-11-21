class OtpResponse {
  bool _success;
  String _message;
  String _phone;
  String _countryCode;
  String _userToken;
  String _apiToken;

  OtpResponse(
      {bool success,
      String message,
      String phone,
      String countryCode,
      String userToken,
      String apiToken}) {
    this._success = success;
    this._message = message;
    this._phone = phone;
    this._countryCode = countryCode;
    this._userToken = userToken;
    this._apiToken = apiToken;
  }

  bool get success => _success;

  set success(bool success) => _success = success;

  String get message => _message;

  set message(String message) => _message = message;

  String get phone => _phone;

  set phone(String phone) => _phone = phone;

  String get userToken => _userToken;

  set userToken(String userToken) => _userToken = userToken;

  String get apiToken => _apiToken;

  String get countryCode => _countryCode;

  set countryCode(String value) {
    _countryCode = value;
  }

  set apiToken(String apiToken) => _apiToken = apiToken;

  OtpResponse.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _message = json['message'];
    _phone = json['phone'];
    _countryCode = json['countryCode'];
    _userToken = json['userToken'];
    _apiToken = json['apiToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this._success;
    data['message'] = this._message;
    data['phone'] = this._phone;
    data['countryCode'] = this._countryCode;
    data['userToken'] = this._userToken;
    data['apiToken'] = this._apiToken;
    return data;
  }
}
