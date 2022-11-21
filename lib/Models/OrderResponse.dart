class OrderResponse {
  String orderId;
  int convertedAmount;
  int statusCode;
  String message;
  bool success;

  OrderResponse(
      {this.orderId,
        this.convertedAmount,
        this.statusCode,
        this.message,
        this.success});

  OrderResponse.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    convertedAmount = json['convertedAmount'];
    statusCode = json['statusCode'];
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['convertedAmount'] = this.convertedAmount;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['success'] = this.success;
    return data;
  }
}