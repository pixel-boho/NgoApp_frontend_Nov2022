class FundraiserItem {
  int _id;
  int _campaignId;
  String _imageUrl;
  String _title;
  int _fundRequired;
  String _closingDate;
  String _story;
  int _status;
  String _createdAt;
  String _modifiedAt;
  String _name;
  String _email;
  String _phoneNumber;
  int _countryCode;
  int _relationMasterId;
  String _patientName;
  String _healthIssue;
  String _hospital;
  String _city;
  String _beneficiaryAccountName;
  String _beneficiaryAccountNumber;
  String _beneficiaryBank;
  String _beneficiaryIfsc;
  String _beneficiaryImage;
  int _createdBy;
  int _isAmountCollected;
  int _fundRaised;
  String _virtualAccountId;
  String _virtualAccountNumber;
  String _virtualAccountIfsc;
  String _virtualAccountName;
  String _virtualAccountType;
  int _pricingId;
  int _isCampaign;
  int _isApproved;
  int _isCancelled;
  String _cancelReason;

  FundraiserItem(
      {int id,
      int campaignId,
      String imageUrl,
      String title,
      int fundRequired,
      String closingDate,
      String story,
      int status,
      String createdAt,
      String modifiedAt,
      String name,
      String email,
      String phoneNumber,
      int countryCode,
      int relationMasterId,
      String patientName,
      String healthIssue,
      String hospital,
      String city,
      String beneficiaryAccountName,
      String beneficiaryAccountNumber,
      String beneficiaryBank,
      String beneficiaryIfsc,
      String beneficiaryImage,
      int createdBy,
      int isAmountCollected,
      int fundRaised,
      String virtualAccountId,
      String virtualAccountNumber,
      String virtualAccountIfsc,
      String virtualAccountName,
      String virtualAccountType,
      int pricingId,
      int isCampaign,
      int isApproved,
      int isCancelled,
      String cancelReason}) {
    this._id = id;
    this._campaignId = campaignId;
    this._imageUrl = imageUrl;
    this._title = title;
    this._fundRequired = fundRequired;
    this._closingDate = closingDate;
    this._story = story;
    this._status = status;
    this._createdAt = createdAt;
    this._modifiedAt = modifiedAt;
    this._name = name;
    this._email = email;
    this._phoneNumber = phoneNumber;
    this._countryCode = countryCode;
    this._relationMasterId = relationMasterId;
    this._patientName = patientName;
    this._healthIssue = healthIssue;
    this._hospital = hospital;
    this._city = city;
    this._beneficiaryAccountName = beneficiaryAccountName;
    this._beneficiaryAccountNumber = beneficiaryAccountNumber;
    this._beneficiaryBank = beneficiaryBank;
    this._beneficiaryIfsc = beneficiaryIfsc;
    this._beneficiaryImage = beneficiaryImage;
    this._createdBy = createdBy;
    this._isAmountCollected = isAmountCollected;
    this._fundRaised = fundRaised;
    this._virtualAccountId = virtualAccountId;
    this._virtualAccountNumber = virtualAccountNumber;
    this._virtualAccountIfsc = virtualAccountIfsc;
    this._virtualAccountName = virtualAccountName;
    this._virtualAccountType = virtualAccountType;
    this._pricingId = pricingId;
    this._isCampaign = isCampaign;
    this._isApproved = isApproved;
    this._isCancelled = isCancelled;
    this._cancelReason = cancelReason;
  }

  int get isCancelled => _isCancelled;

  set isCancelled(int value) {
    _isCancelled = value;
  }

  String get virtualAccountType => _virtualAccountType;

  set virtualAccountType(String value) {
    _virtualAccountType = value;
  }

  String get cancelReason => _cancelReason;

  set cancelReason(String value) {
    _cancelReason = value;
  }

  String get virtualAccountName => _virtualAccountName;

  set virtualAccountName(String value) {
    _virtualAccountName = value;
  }

  String get virtualAccountIfsc => _virtualAccountIfsc;

  set virtualAccountIfsc(String value) {
    _virtualAccountIfsc = value;
  }

  String get virtualAccountNumber => _virtualAccountNumber;

  set virtualAccountNumber(String value) {
    _virtualAccountNumber = value;
  }

  String get virtualAccountId => _virtualAccountId;

  set virtualAccountId(String value) {
    _virtualAccountId = value;
  }

  int get fundRaised => _fundRaised;

  set fundRaised(int value) {
    _fundRaised = value;
  }

  int get isAmountCollected => _isAmountCollected;

  set isAmountCollected(int value) {
    _isAmountCollected = value;
  }

  int get createdBy => _createdBy;

  set createdBy(int value) {
    _createdBy = value;
  }

  String get beneficiaryImage => _beneficiaryImage;

  set beneficiaryImage(String value) {
    _beneficiaryImage = value;
  }

  String get beneficiaryIfsc => _beneficiaryIfsc;

  set beneficiaryIfsc(String value) {
    _beneficiaryIfsc = value;
  }

  String get beneficiaryBank => _beneficiaryBank;

  set beneficiaryBank(String value) {
    _beneficiaryBank = value;
  }

  String get beneficiaryAccountNumber => _beneficiaryAccountNumber;

  set beneficiaryAccountNumber(String value) {
    _beneficiaryAccountNumber = value;
  }

  String get beneficiaryAccountName => _beneficiaryAccountName;

  set beneficiaryAccountName(String value) {
    _beneficiaryAccountName = value;
  }

  String get city => _city;

  set city(String value) {
    _city = value;
  }

  String get hospital => _hospital;

  set hospital(String value) {
    _hospital = value;
  }

  String get healthIssue => _healthIssue;

  set healthIssue(String value) {
    _healthIssue = value;
  }

  String get patientName => _patientName;

  set patientName(String value) {
    _patientName = value;
  }

  int get relationMasterId => _relationMasterId;

  set relationMasterId(int value) {
    _relationMasterId = value;
  }

  int get countryCode => _countryCode;

  set countryCode(int value) {
    _countryCode = value;
  }

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get modifiedAt => _modifiedAt;

  set modifiedAt(String value) {
    _modifiedAt = value;
  }

  String get createdAt => _createdAt;

  set createdAt(String value) {
    _createdAt = value;
  }

  int get status => _status;

  set status(int value) {
    _status = value;
  }

  String get story => _story;

  set story(String value) {
    _story = value;
  }

  String get closingDate => _closingDate;

  set closingDate(String value) {
    _closingDate = value;
  }

  int get fundRequired => _fundRequired;

  set fundRequired(int value) {
    _fundRequired = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get imageUrl => _imageUrl;

  set imageUrl(String value) {
    _imageUrl = value;
  }

  int get campaignId => _campaignId;

  set campaignId(int value) {
    _campaignId = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  int get pricingId => _pricingId;

  set pricingId(int value) {
    _pricingId = value;
  }

  int get isCampaign => _isCampaign;

  set isCampaign(int value) {
    _isCampaign = value;
  }

  int get isApproved => _isApproved;

  set isApproved(int value) {
    _isApproved = value;
  }

  FundraiserItem.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _campaignId = json['campaign_id'];
    _imageUrl = json['image_url'] ?? "";
    _title = json['title'];
    _fundRequired = json['fund_required'];
    _closingDate = json['closing_date'];
    _story = json['story'] ?? "n/a";
    _status = json['status'];
    _createdAt = json['created_at'];
    _modifiedAt = json['modified_at'];
    _name = json['name'];
    _email = json['email'];
    _phoneNumber = json['phone_number'];
    _countryCode = json['country_code'];
    _relationMasterId = json['relation_master_id'];
    _patientName = json['patient_name'];
    _healthIssue = json['health_issue'];
    _hospital = json['hospital'];
    _city = json['city'];
    _beneficiaryAccountName = json['beneficiary_account_name'];
    _beneficiaryAccountNumber = json['beneficiary_account_number'];
    _beneficiaryBank = json['beneficiary_bank'];
    _beneficiaryIfsc = json['beneficiary_ifsc'];
    _beneficiaryImage = json['beneficiary_image'] ?? "";
    _createdBy = json['created_by'];
    _isAmountCollected = json['is_amount_collected'];
    _fundRaised = json['fund_raised'];
    _virtualAccountId = json['virtual_account_id'];
    _virtualAccountNumber = json['virtual_account_number'] ?? "n/a";
    _virtualAccountIfsc = json['virtual_account_ifsc'] ?? "n/a";
    _virtualAccountName = json['virtual_account_name'] ?? "n/a";
    _virtualAccountType = json['virtual_account_type'] ?? "n/a";
    _pricingId = json['pricing_id'];
    _isCampaign = json['is_campaign'];
    _isApproved = json['is_approved'];
    _isCancelled = json['is_cancelled'] ?? 0;
    _cancelReason = json['cancellation_reason'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['campaign_id'] = this._campaignId;
    data['image_url'] = this._imageUrl;
    data['title'] = this._title;
    data['fund_required'] = this._fundRequired;
    data['closing_date'] = this._closingDate;
    data['story'] = this._story;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['modified_at'] = this._modifiedAt;
    data['name'] = this._name;
    data['email'] = this._email;
    data['phone_number'] = this._phoneNumber;
    data['country_code'] = this._countryCode;
    data['relation_master_id'] = this._relationMasterId;
    data['patient_name'] = this._patientName;
    data['health_issue'] = this._healthIssue;
    data['hospital'] = this._hospital;
    data['city'] = this._city;
    data['beneficiary_account_name'] = this._beneficiaryAccountName;
    data['beneficiary_account_number'] = this._beneficiaryAccountNumber;
    data['beneficiary_bank'] = this._beneficiaryBank;
    data['beneficiary_ifsc'] = this._beneficiaryIfsc;
    data['beneficiary_image'] = this._beneficiaryImage;
    data['created_by'] = this._createdBy;
    data['is_amount_collected'] = this._isAmountCollected;
    data['fund_raised'] = this._fundRaised;
    data['virtual_account_id'] = this._virtualAccountId;
    data['virtual_account_number'] = this._virtualAccountNumber;
    data['virtual_account_ifsc'] = this._virtualAccountIfsc;
    data['virtual_account_name'] = this._virtualAccountName;
    data['virtual_account_type'] = this._virtualAccountType;
    data['pricing_id'] = this._pricingId;
    data['is_campaign'] = this._isCampaign;
    data['is_approved'] = this._isApproved;
    data['is_cancelled'] = this._isCancelled;
    data['cancellation_reason'] = this._cancelReason;
    return data;
  }
}
