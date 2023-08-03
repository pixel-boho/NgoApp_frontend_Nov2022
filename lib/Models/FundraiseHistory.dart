class FundraiseHistoryResponse {
  int statusCode;
  String message;
  List<PaymentHist> paymentHist;
  int page;
  int perPage;
  bool hasNextPage;
  int totalfundraiserCount;

  FundraiseHistoryResponse(
      {this.statusCode,
        this.message,
        this.paymentHist,
        this.page,
        this.perPage,
        this.hasNextPage,
        this.totalfundraiserCount});

  FundraiseHistoryResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['payment_hist'] != null) {
      paymentHist = <PaymentHist>[];
      json['payment_hist'].forEach((v) {
        paymentHist.add(new PaymentHist.fromJson(v));
      });
    }
    page = json['page'];
    perPage = json['perPage'];
    hasNextPage = json['hasNextPage'];
    totalfundraiserCount = json['totalfundraiserCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.paymentHist != null) {
      data['payment_hist'] = this.paymentHist.map((v) => v.toJson()).toList();
    }
    data['page'] = this.page;
    data['perPage'] = this.perPage;
    data['hasNextPage'] = this.hasNextPage;
    data['totalfundraiserCount'] = this.totalfundraiserCount;
    return data;
  }
}

class PaymentHist {
  int id;
  FundraiserId fundraiserId;
  int userId;
  String name;
  String email;
  int amount;
  String showDonorInformation;
  int status;
  String createdAt;
  String modifiedAt;
  String transactionId;
  int donatedBy;
  Null agencyId;

  PaymentHist(
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

  PaymentHist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fundraiserId = json['fundraiser_id'] != null
        ? new FundraiserId.fromJson(json['fundraiser_id'])
        : null;
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
    if (this.fundraiserId != null) {
      data['fundraiser_id'] = this.fundraiserId.toJson();
    }
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

class FundraiserId {
  String title;

  FundraiserId({this.title});

  FundraiserId.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    //print("sfds=>${title}");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    print("sfds=>${this.title}");
    data['title'] = this.title;
    print("sfds=>${data['title']}");
    return data;
  }
}