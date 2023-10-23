class DonationHistoryResponse {
  int statusCode;
  String message;
  List<Donate> donate;
  int page;
  int perPage;
  bool hasNextPage;
  int totaldonationCount;

  DonationHistoryResponse(
      {this.statusCode,
        this.message,
        this.donate,
        this.page,
        this.perPage,
        this.hasNextPage,
        this.totaldonationCount});

  DonationHistoryResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['donate'] != null) {
      donate = <Donate>[];
      json['donate'].forEach((v) {
        donate.add(new Donate.fromJson(v));
      });
    }
    page = json['page'];
    perPage = json['perPage'];
    hasNextPage = json['hasNextPage'];
    totaldonationCount = json['totaldonationCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.donate != null) {
      data['donate'] = this.donate.map((v) => v.toJson()).toList();
    }
    data['page'] = this.page;
    data['perPage'] = this.perPage;
    data['hasNextPage'] = this.hasNextPage;
    data['totaldonationCount'] = this.totaldonationCount;
    return data;
  }
}

class Donate {
  int id;
  Null fundraiserId;
  int userId;
  String name;
  String email;
  int amount;
  String showDonorInformation;
  String status;
  String createdAt;
  String modifiedAt;
  String transactionId;
  Null donatedBy;
  Null agencyId;

  Donate(
      {this.id,
        this.fundraiserId,
        this.userId,
        this.name,
        this.email,
        this.amount,
        this.showDonorInformation,
        this.status,
        this.createdAt,
        this.modifiedAt,
        this.transactionId,
        this.donatedBy,
        this.agencyId});

  Donate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fundraiserId = json['fundraiser_id'];
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    amount = json['amount'];
    showDonorInformation = json['show_donor_information'];
    status = json['status'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
    transactionId = json['transaction_id'];
    donatedBy = json['donated_by'];
    agencyId = json['agency_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fundraiser_id'] = this.fundraiserId;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['amount'] = this.amount;
    data['show_donor_information'] = this.showDonorInformation;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['modified_at'] = this.modifiedAt;
    data['transaction_id'] = this.transactionId;
    data['donated_by'] = this.donatedBy;
    data['agency_id'] = this.agencyId;
    return data;
  }
}