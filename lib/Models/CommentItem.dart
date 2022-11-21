class CommentItem {
  String _comment;
  String _createdAt;
  String _name;
  String _imageUrl;

  CommentItem(
      {String comment, String createdAt, String name, String imageUrl}) {
    this._comment = comment;
    this._createdAt = createdAt;
    this._name = name;
    this._imageUrl = imageUrl;
  }

  String get comment => _comment;

  set comment(String comment) => _comment = comment;

  String get createdAt => _createdAt;

  set createdAt(String createdAt) => _createdAt = createdAt;

  String get name => _name;

  set name(String name) => _name = name;

  String get imageUrl => _imageUrl;

  set imageUrl(String imageUrl) => _imageUrl = imageUrl;

  CommentItem.fromJson(Map<String, dynamic> json) {
    _comment = json['comment'];
    _createdAt = json['created_at'];
    _name = json['name'];
    _imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this._comment;
    data['created_at'] = this._createdAt;
    data['name'] = this._name;
    data['image_url'] = this._imageUrl;
    return data;
  }
}
