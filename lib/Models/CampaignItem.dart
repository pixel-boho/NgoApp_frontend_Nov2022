class CampaignItem {
  int _id;
  String _title;
  String _iconUrl;
  int _isHealthCase;
  int _campaignStatus;
  int _status;
  String _createdAt;
  String _modifiedAt;
  bool isSelected = false;

  CampaignItem(
      {int id,
      String title,
      String iconUrl,
      int isHealthCase,
      int campaignStatus,
      int status,
      String createdAt,
      String modifiedAt}) {
    this._id = id;
    this._title = title;
    this._iconUrl = iconUrl;
    this._isHealthCase = isHealthCase;
    this._campaignStatus = campaignStatus;
    this._status = status;
    this._createdAt = createdAt;
    this._modifiedAt = modifiedAt;
  }

  int get id => _id;

  set id(int id) => _id = id;

  String get title => _title;

  set title(String title) => _title = title;

  String get iconUrl => _iconUrl;

  set iconUrl(String iconUrl) => _iconUrl = iconUrl;

  int get isHealthCase => _isHealthCase;

  set isHealthCase(int isHealthCase) => _isHealthCase = isHealthCase;

  int get campaignStatus => _campaignStatus;

  set campaignStatus(int campaignStatus) => _campaignStatus = campaignStatus;

  int get status => _status;

  set status(int status) => _status = status;

  String get createdAt => _createdAt;

  set createdAt(String createdAt) => _createdAt = createdAt;

  String get modifiedAt => _modifiedAt;

  set modifiedAt(String modifiedAt) => _modifiedAt = modifiedAt;

  CampaignItem.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _iconUrl = json['icon_url'] ?? "";
    _isHealthCase = json['is_health_case'];
    _campaignStatus = json['campaign_status'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _modifiedAt = json['modified_at'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['title'] = this._title;
    data['icon_url'] = this._iconUrl;
    data['is_health_case'] = this._isHealthCase;
    data['campaign_status'] = this._campaignStatus;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['modified_at'] = this._modifiedAt;
    return data;
  }
}
