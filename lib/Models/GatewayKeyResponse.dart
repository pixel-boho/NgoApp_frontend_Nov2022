class GatewayKeyResponse {
  String apiKey;
  String customerId;
  int statusCode;
  String message;
  bool success;

  GatewayKeyResponse(
      {this.apiKey,
        this.customerId,
        this.statusCode,
        this.message,
        this.success});

  GatewayKeyResponse.fromJson(Map<String, dynamic> json) {
    apiKey = json['apiKey'];
    customerId = json['customerId'];
    statusCode = json['statusCode'];
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['apiKey'] = this.apiKey;
    data['customerId'] = this.customerId;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['success'] = this.success;
    return data;
  }
}