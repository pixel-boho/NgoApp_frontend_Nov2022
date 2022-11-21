class DonorOrSupporterInfo {
  String _name;
  String _email;
  int _amount;
  String _imageUrl;
  int _showDonorInformation;

  DonorOrSupporterInfo(
      {String name,
      String email,
      int amount,
      String imageUrl,
      int showDonorInformation}) {
    this._name = name;
    this._email = email;
    this._amount = amount;
    this._imageUrl = imageUrl;
    this._showDonorInformation = showDonorInformation;
  }

  String get name => _name;

  set name(String name) => _name = name;

  String get email => _email;

  set email(String email) => _email = email;

  int get amount => _amount;

  set amount(int amount) => _amount = amount;

  String get imageUrl => _imageUrl;

  set imageUrl(String imageUrl) => _imageUrl = imageUrl;


  int get showDonorInformation => _showDonorInformation;

  set showDonorInformation(int value) {
    _showDonorInformation = value;
  }

  DonorOrSupporterInfo.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _email = json['email'];
    _amount = json['amount'];
    _imageUrl = json['image_url'] ?? "";
    _showDonorInformation = json['show_donor_information'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['email'] = this._email;
    data['amount'] = this._amount;
    data['image_url'] = this._imageUrl;
    data['image_url'] = this._imageUrl;
    data['show_donor_information'] = this._showDonorInformation;
    return data;
  }
}
