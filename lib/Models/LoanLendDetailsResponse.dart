class LoanLendDetailsResponse {
  int statusCode;
  String baseUrl;
  String webBaseUrl;
  LoanDetails loanDetails;
  int fundRaised;
  String message;
  bool success;

  LoanLendDetailsResponse(
      {this.statusCode,
        this.baseUrl,
        this.webBaseUrl,
        this.loanDetails,
        this.fundRaised,
        this.message,
        this.success});

  LoanLendDetailsResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    baseUrl = json['baseUrl'];
    webBaseUrl = json.containsKey("webBaseUrl") ? json['webBaseUrl'] : "";
    loanDetails = json['loanDetails'] != null
        ? new LoanDetails.fromJson(json['loanDetails'])
        : null;
    fundRaised = json['fund_raised'];
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['baseUrl'] = this.baseUrl;
    if (this.loanDetails != null) {
      data['loanDetails'] = this.loanDetails.toJson();
    }
    data['fund_raised'] = this.fundRaised;
    data['message'] = this.message;
    data['success'] = this.success;
    return data;
  }
}

class LoanDetails {
  int id;
  String title;
  String purpose;
  int amount;
  String location;
  String description;
  String closingDate;
  int createdBy;
  String imageUrl;
  int status;
  String createdAt;
  String modifiedAt;

  LoanDetails(
      {this.id,
        this.title,
        this.purpose,
        this.amount,
        this.location,
        this.description,
        this.closingDate,
        this.createdBy,
        this.imageUrl,
        this.status,
        this.createdAt,
        this.modifiedAt});

  LoanDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    purpose = json['purpose'];
    amount = json['amount'];
    location = json['location'];
    description = json['description'];
    closingDate = json['closing_date'];
    createdBy = json['created_by'];
    imageUrl = json['image_url'];
    status = json['status'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['purpose'] = this.purpose;
    data['amount'] = this.amount;
    data['location'] = this.location;
    data['description'] = this.description;
    data['closing_date'] = this.closingDate;
    data['created_by'] = this.createdBy;
    data['image_url'] = this.imageUrl;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['modified_at'] = this.modifiedAt;
    return data;
  }
}