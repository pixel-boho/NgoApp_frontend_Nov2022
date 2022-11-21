import 'CampaignItem.dart';
import 'FundraiserItem.dart';

class HomeResponse {
  int _statusCode;
  bool _success;
  String _fundraiserBaseUrl;
  String _campaignBaseUrl;
  List<CampaignItem> _campaignList;
  List<FundraiserItem> _fundraiserList;
  List<FundraiserItem> _recommendedList;
  String _message;
  String _webBaseUrl;

  HomeResponse(
      {int statusCode,
      bool success,
      String fundraiserBaseUrl,
      String campaignBaseUrl,
      List<CampaignItem> campaignList,
      List<FundraiserItem> fundraiserList,
      List<FundraiserItem> recommendedList,
      String message,
      String webBaseUrl}) {
    this._statusCode = statusCode;
    this._success = success;
    this._fundraiserBaseUrl = fundraiserBaseUrl;
    this._campaignBaseUrl = campaignBaseUrl;
    this._campaignList = campaignList;
    this._fundraiserList = fundraiserList;
    this._recommendedList = recommendedList;
    this._message = message;
    this._webBaseUrl = webBaseUrl;
  }

  int get statusCode => _statusCode;

  set statusCode(int statusCode) => _statusCode = statusCode;

  bool get success => _success;

  set success(bool success) => _success = success;

  String get fundraiserBaseUrl => _fundraiserBaseUrl;

  set fundraiserBaseUrl(String fundraiserBaseUrl) =>
      _fundraiserBaseUrl = fundraiserBaseUrl;

  String get campaignBaseUrl => _campaignBaseUrl;

  set campaignBaseUrl(String campaignBaseUrl) =>
      _campaignBaseUrl = campaignBaseUrl;

  List<CampaignItem> get campaignList => _campaignList;

  set campaignList(List<CampaignItem> campaignList) =>
      _campaignList = campaignList;

  List<FundraiserItem> get fundraiserList => _fundraiserList;

  set fundraiserList(List<FundraiserItem> fundraiserList) =>
      _fundraiserList = fundraiserList;

  List<FundraiserItem> get recommendedList => _recommendedList;

  set recommendedList(List<FundraiserItem> recommendedList) =>
      _recommendedList = recommendedList;

  String get message => _message;

  set message(String message) => _message = message;


  String get webBaseUrl => _webBaseUrl;

  set webBaseUrl(String value) {
    _webBaseUrl = value;
  }

  HomeResponse.fromJson(Map<String, dynamic> json) {
    _statusCode = json['statusCode'];
    _success = json['success'];
    _fundraiserBaseUrl = json['fundraiserBaseUrl'];
    _campaignBaseUrl = json['campaignBaseUrl'];
    if (json['campaignList'] != null) {
      _campaignList = [];
      json['campaignList'].forEach((v) {
        _campaignList.add(new CampaignItem.fromJson(v));
      });
    }
    if (json['fundraiserList'] != null) {
      _fundraiserList = [];
      json['fundraiserList'].forEach((v) {
        _fundraiserList.add(new FundraiserItem.fromJson(v));
      });
    }
    if (json['recommendedList'] != null) {
      _recommendedList = [];
      json['recommendedList'].forEach((v) {
        _recommendedList.add(new FundraiserItem.fromJson(v));
      });
    }
    _message = json['message'];
    _webBaseUrl = json.containsKey("webBaseUrl") ? json['webBaseUrl'] : "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this._statusCode;
    data['success'] = this._success;
    data['fundraiserBaseUrl'] = this._fundraiserBaseUrl;
    data['campaignBaseUrl'] = this._campaignBaseUrl;
    if (this._campaignList != null) {
      data['campaignList'] = this._campaignList.map((v) => v.toJson()).toList();
    }
    if (this._fundraiserList != null) {
      data['fundraiserList'] =
          this._fundraiserList.map((v) => v.toJson()).toList();
    }
    if (this._recommendedList != null) {
      data['recommendedList'] =
          this._recommendedList.map((v) => v.toJson()).toList();
    }
    data['message'] = this._message;
    data['webBaseUrl'] = this._message;
    return data;
  }
}
