class UserDetails {
  int _id;
  String _role;
  String _phoneNumber;
  String _name;
  String _email;
  String _dateOfBirth;
  String _imageUrl;
  String _baseUrl;
  int _countryCode;
  int _points;
  String _pancard_image;

  UserDetails(
      {int id,
        String role,
        String phoneNumber,
        String name,
        String email,
        String dateOfBirth,
        String imageUrl,
        String baseUrl,
        int countryCode,
        String pancard_image,
        int points}) {
    this._id = id;
    this._role = role;
    this._phoneNumber = phoneNumber;
    this._name = name;
    this._email = email;
    this._dateOfBirth = dateOfBirth;
    this._imageUrl = imageUrl;
    this._baseUrl = _baseUrl;
    this._countryCode = countryCode;
    this._pancard_image=pancard_image;
    this._points = points;
  }

  int get id => _id;

  set id(int id) => _id = id;

  String get role => _role;

  set role(String role) => _role = role;

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String phoneNumber) => _phoneNumber = phoneNumber;

  String get name => _name;

  set name(String name) => _name = name;

  String get email => _email;

  set email(String email) => _email = email;

  String get dateOfBirth => _dateOfBirth;

  set dateOfBirth(String dateOfBirth) => _dateOfBirth = dateOfBirth;

  String get imageUrl => _imageUrl;

  set imageUrl(String imageUrl) => _imageUrl = imageUrl;

  int get countryCode => _countryCode;

  set countryCode(int countryCode) => _countryCode = countryCode;

  String get pancardimage =>_pancard_image;

  set pancardimage(String pancard_image)=> pancard_image= pancardimage;

  int get points => _points;

  set points(int points) => _points = points;

  String get baseUrl => _baseUrl;

  set baseUrl(String value) {
    _baseUrl = value;
  }

  UserDetails.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _role = json['role'];
    _phoneNumber = json['phone_number'];
    _name = json['name'];
    _email = json['email'];
    _dateOfBirth = json['date_of_birth'];
    _imageUrl = json['image_url'] ?? "";
    _baseUrl = json['baseUrl'] ?? "";
    _countryCode = json['country_code'];
    _pancard_image= json['pancard_image'];
    _points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['role'] = this._role;
    data['phone_number'] = this._phoneNumber;
    data['name'] = this._name;
    data['email'] = this._email;
    data['date_of_birth'] = this._dateOfBirth;
    data['image_url'] = this._imageUrl;
    data['baseUrl'] = this._baseUrl;
    data['country_code'] = this._countryCode;
    data['pancard_image']= this._pancard_image;
    data['points'] = this._points;
    return data;
  }
}
