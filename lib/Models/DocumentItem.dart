class DocumentItem {
  int _id;
  int _fundraiserSchemeId;
  String _docUrl;
  int _status;
  String _createdAt;
  String _modifiedAt;

  DocumentItem(
      {int id,
      int fundraiserSchemeId,
      String docUrl,
      int status,
      String createdAt,
      String modifiedAt}) {
    this._id = id;
    this._fundraiserSchemeId = fundraiserSchemeId;
    this._docUrl = docUrl;
    this._status = status;
    this._createdAt = createdAt;
    this._modifiedAt = modifiedAt;
  }

  int get id => _id;

  set id(int id) => _id = id;

  int get fundraiserSchemeId => _fundraiserSchemeId;

  set fundraiserSchemeId(int fundraiserSchemeId) =>
      _fundraiserSchemeId = fundraiserSchemeId;

  String get docUrl => _docUrl;

  set docUrl(String docUrl) => _docUrl = docUrl;

  int get status => _status;

  set status(int status) => _status = status;

  String get createdAt => _createdAt;

  set createdAt(String createdAt) => _createdAt = createdAt;

  String get modifiedAt => _modifiedAt;

  set modifiedAt(String modifiedAt) => _modifiedAt = modifiedAt;

  DocumentItem.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _fundraiserSchemeId = json['fundraiser_scheme_id'];
    _docUrl = json['doc_url'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _modifiedAt = json['modified_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['fundraiser_scheme_id'] = this._fundraiserSchemeId;
    data['doc_url'] = this._docUrl;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['modified_at'] = this._modifiedAt;
    return data;
  }
}
