class CampaignerDetail {
  String _name;
  String _email;
  String _phoneNumber;
  int _countryCode;
  String _imageUrl;
  String _dateOfBirth;

  CampaignerDetail(
      {String name,
      String email,
      String phoneNumber,
      int countryCode,
      String imageUrl,
      String dateOfBirth}) {
    this._name = name;
    this._email = email;
    this._phoneNumber = phoneNumber;
    this._countryCode = countryCode;
    this._imageUrl = imageUrl;
    this._dateOfBirth = dateOfBirth;
  }

  String get name => _name;

  set name(String name) => _name = name;

  String get email => _email;

  set email(String email) => _email = email;

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String phoneNumber) => _phoneNumber = phoneNumber;

  int get countryCode => _countryCode;

  set countryCode(int countryCode) => _countryCode = countryCode;

  String get imageUrl => _imageUrl;

  set imageUrl(String imageUrl) => _imageUrl = imageUrl;

  String get dateOfBirth => _dateOfBirth;

  set dateOfBirth(String dateOfBirth) => _dateOfBirth = dateOfBirth;

  CampaignerDetail.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _email = json['email'];
    _phoneNumber = json['phone_number'];
    _countryCode = json['country_code'];
    _imageUrl = json['image_url'] ?? "";
    _dateOfBirth = json['date_of_birth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['email'] = this._email;
    data['phone_number'] = this._phoneNumber;
    data['country_code'] = this._countryCode;
    data['image_url'] = this._imageUrl;
    data['date_of_birth'] = this._dateOfBirth;
    return data;
  }
}
