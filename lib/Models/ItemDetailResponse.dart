import 'package:ngo_app/Models/CampaignItem.dart';
import 'package:ngo_app/Models/CampaignerDetail.dart';
import 'package:ngo_app/Models/CommentItem.dart';
import 'package:ngo_app/Models/DocumentItem.dart';
import 'package:ngo_app/Models/DonorOrSupporterInfo.dart';

import 'FundraiserItem.dart';

class ItemDetailResponse {
  int _statusCode;
  String _baseUrl;
  String _webBaseUrl;
  String _documentBaseUrl;
  String _campaignerBaseUrl;
  String _supportersBaseUrl;
  String _topDonorsBaseUrl;
  String _commentsBaseUrl;
  int _supportersCount;
  int _fundRaised;
  FundraiserItem _fundraiserDetails;
  CampaignerDetail _campaignerDetails;
  List<DocumentItem> _fundraiserDocuments;
  List<DonorOrSupporterInfo> _supporters;
  List<DonorOrSupporterInfo> _topDonors;
  List<CommentItem> _comments;
  String _message;
  bool _success;
  CampaignItem _campaignDetail;

  ItemDetailResponse(
      {int statusCode,
      String baseUrl,
      String webBaseUrl,
      String documentBaseUrl,
      String campaignerBaseUrl,
      String supportersBaseUrl,
      String topDonorsBaseUrl,
      String commentsBaseUrl,
      int supportersCount,
      int fundRaised,
      FundraiserItem fundraiserDetails,
      CampaignerDetail campaignerDetails,
      List<DocumentItem> fundraiserDocuments,
      List<DonorOrSupporterInfo> supporters,
      List<DonorOrSupporterInfo> topDonors,
      List<CommentItem> comments,
      String message,
      bool success,
      CampaignItem campaignDetail}) {
    this._statusCode = statusCode;
    this._baseUrl = baseUrl;
    this._webBaseUrl = webBaseUrl;
    this._documentBaseUrl = documentBaseUrl;
    this._campaignerBaseUrl = campaignerBaseUrl;
    this._supportersBaseUrl = supportersBaseUrl;
    this._topDonorsBaseUrl = topDonorsBaseUrl;
    this._commentsBaseUrl = commentsBaseUrl;
    this._supportersCount = supportersCount;
    this._fundRaised = fundRaised;
    this._fundraiserDetails = fundraiserDetails;
    this._campaignerDetails = campaignerDetails;
    this._fundraiserDocuments = fundraiserDocuments;
    this._supporters = supporters;
    this._topDonors = topDonors;
    this._comments = comments;
    this._message = message;
    this._success = success;
    this._campaignDetail = campaignDetail;
  }

  int get statusCode => _statusCode;

  set statusCode(int statusCode) => _statusCode = statusCode;

  String get baseUrl => _baseUrl;

  set baseUrl(String baseUrl) => _baseUrl = baseUrl;

  String get webBaseUrl => _webBaseUrl;

  set webBaseUrl(String webBaseUrl) => _webBaseUrl = webBaseUrl;

  String get documentBaseUrl => _documentBaseUrl;

  set documentBaseUrl(String documentBaseUrl) =>
      _documentBaseUrl = documentBaseUrl;

  String get campaignerBaseUrl => _campaignerBaseUrl;

  set campaignerBaseUrl(String campaignerBaseUrl) =>
      _campaignerBaseUrl = campaignerBaseUrl;

  String get supportersBaseUrl => _supportersBaseUrl;

  set supportersBaseUrl(String supportersBaseUrl) =>
      _supportersBaseUrl = supportersBaseUrl;

  String get topDonorsBaseUrl => _topDonorsBaseUrl;

  set topDonorsBaseUrl(String topDonorsBaseUrl) =>
      _topDonorsBaseUrl = topDonorsBaseUrl;

  String get commentsBaseUrl => _commentsBaseUrl;

  set commentsBaseUrl(String commentsBaseUrl) =>
      _commentsBaseUrl = commentsBaseUrl;

  int get supportersCount => _supportersCount;

  set supportersCount(int supportersCount) =>
      _supportersCount = supportersCount;

  int get fundRaised => _fundRaised;

  set fundRaised(int fundRaised) => _fundRaised = fundRaised;

  FundraiserItem get fundraiserDetails => _fundraiserDetails;

  set fundraiserDetails(FundraiserItem fundraiserDetails) =>
      _fundraiserDetails = fundraiserDetails;

  CampaignerDetail get campaignerDetails => _campaignerDetails;

  set campaignerDetails(CampaignerDetail campaignerDetails) =>
      _campaignerDetails = campaignerDetails;

  List<DocumentItem> get fundraiserDocuments => _fundraiserDocuments;

  set fundraiserDocuments(List<DocumentItem> fundraiserDocuments) =>
      _fundraiserDocuments = fundraiserDocuments;

  List<DonorOrSupporterInfo> get supporters => _supporters;

  set supporters(List<DonorOrSupporterInfo> supporters) =>
      _supporters = supporters;

  List<DonorOrSupporterInfo> get topDonors => _topDonors;

  set topDonors(List<DonorOrSupporterInfo> topDonors) => _topDonors = topDonors;

  List<CommentItem> get comments => _comments;

  set comments(List<CommentItem> comments) => _comments = comments;

  String get message => _message;

  set message(String message) => _message = message;

  bool get success => _success;

  set success(bool success) => _success = success;

  CampaignItem get campaignDetail => _campaignDetail;

  set campaignDetail(CampaignItem value) {
    _campaignDetail = value;
  }

  ItemDetailResponse.fromJson(Map<String, dynamic> json) {
    _statusCode = json['statusCode'];
    _baseUrl = json['baseUrl'] ?? "";
    _webBaseUrl = json.containsKey("webBaseUrl") ? json['webBaseUrl'] : "";
    _documentBaseUrl = json['documentBaseUrl'] ?? "";
    _campaignerBaseUrl = json['campaignerBaseUrl'] ?? "";
    _supportersBaseUrl = json['supportersBaseUrl'] ?? "";
    _topDonorsBaseUrl = json['topDonorsBaseUrl'] ?? "";
    _commentsBaseUrl = json['commentsBaseUrl'] ?? "";
    _supportersCount = json['supportersCount'] ?? 0;
    _fundRaised = json['fund_raised'] ?? 0;
    _fundraiserDetails = json['fundraiserDetails'] != null
        ? new FundraiserItem.fromJson(json['fundraiserDetails'])
        : null;
    _campaignerDetails = json['campaignerDetails'] != null
        ? new CampaignerDetail.fromJson(json['campaignerDetails'])
        : null;
    if (json['fundraiserDocuments'] != null) {
      _fundraiserDocuments = [];
      json['fundraiserDocuments'].forEach((v) {
        _fundraiserDocuments.add(new DocumentItem.fromJson(v));
      });
    }
    if (json['supporters'] != null) {
      _supporters = [];
      json['supporters'].forEach((v) {
        _supporters.add(new DonorOrSupporterInfo.fromJson(v));
      });
    }
    if (json['topDonors'] != null) {
      _topDonors = [];
      json['topDonors'].forEach((v) {
        _topDonors.add(new DonorOrSupporterInfo.fromJson(v));
      });
    }
    if (json['comments'] != null) {
      _comments = [];
      json['comments'].forEach((v) {
        _comments.add(new CommentItem.fromJson(v));
      });
    }
    _message = json['message'];
    _success = json['success'];

    _campaignDetail = json['campaignDetail'] != null
        ? new CampaignItem.fromJson(json['campaignDetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this._statusCode;
    data['baseUrl'] = this._baseUrl;
    data['webBaseUrl'] = this._webBaseUrl;
    data['documentBaseUrl'] = this._documentBaseUrl;
    data['campaignerBaseUrl'] = this._campaignerBaseUrl;
    data['supportersBaseUrl'] = this._supportersBaseUrl;
    data['topDonorsBaseUrl'] = this._topDonorsBaseUrl;
    data['commentsBaseUrl'] = this._commentsBaseUrl;
    data['supportersCount'] = this._supportersCount;
    data['fund_raised'] = this._fundRaised;
    if (this._fundraiserDetails != null) {
      data['fundraiserDetails'] = this._fundraiserDetails.toJson();
    }
    if (this._campaignerDetails != null) {
      data['campaignerDetails'] = this._campaignerDetails.toJson();
    }
    if (this._fundraiserDocuments != null) {
      data['fundraiserDocuments'] =
          this._fundraiserDocuments.map((v) => v.toJson()).toList();
    }
    if (this._supporters != null) {
      data['supporters'] = this._supporters.map((v) => v.toJson()).toList();
    }
    if (this._topDonors != null) {
      data['topDonors'] = this._topDonors.map((v) => v.toJson()).toList();
    }
    if (this._comments != null) {
      data['comments'] = this._comments.map((v) => v.toJson()).toList();
    }
    data['message'] = this._message;
    data['success'] = this._success;
    if (this._campaignDetail != null) {
      data['campaignDetail'] = this._campaignDetail.toJson();
    }
    return data;
  }
}
