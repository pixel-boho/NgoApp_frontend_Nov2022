import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/EnumValues.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/EachListItemWidget.dart';
import 'package:ngo_app/Models/GatewayKeyResponse.dart';
import 'package:ngo_app/Models/OrderResponse.dart';
import 'package:ngo_app/Screens/Dashboard/Home.dart';
import 'package:ngo_app/ServiceManager/ApiProvider.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final PaymentInfo paymentInfo;
  const PaymentScreen({Key key, this.paymentInfo}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentInfo paymentInfo;
  Razorpay _razorPay;
  PaymentSuccessResponse _paymentSuccessResponse;
  PaymentFailureResponse _paymentFailureResponse;
  ApiProvider apiProvider = ApiProvider();
  GatewayKeyResponse _gatewayKeyResponse;
  OrderResponse _orderResponse;
  bool _isAnonymous = false;
  String ApiKey = "";
  String OrderId = "";
  String Amount = "";
  String amountInPaise = '0';
  Map<String, dynamic> notes = {};

  @override
  void initState() {
    super.initState();
    paymentInfo = widget.paymentInfo;
    _razorPay = Razorpay();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initPayment();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black12.withOpacity(0.5),
      body: Center(
        child: CommonApiLoader(),
      ),
    );
  }

  Future _initPayment() async {
    if (CommonMethods().isAuthTokenExist() ? _isAnonymous : true) {
      await _getOrder(paymentInfo.id);
      startPaymentforGuest(onPaymentSuccess, onPaymentErrorFn);
      return;
    } else {
      bool isSuccess = await getGatewayKey();
      if (!isSuccess) {
        Fluttertoast.showToast(
            msg: 'Unable to get payment credentials. Please try again');
        Get.back();
        return;
      }
      await _getOrder1(paymentInfo.id);
      if (!isSuccess) {
        Fluttertoast.showToast(msg: 'Unable to create order. Please try again');
        Get.back();
        return;
      }
      startPayment(onPaymentSuccess, onPaymentErrorFn);
    }
  }

  onPaymentSuccess(PaymentSuccessResponse response) {
    Get.offAll(() => Home());
    _showSuccessDialog();
  }

  onPaymentErrorFn(PaymentFailureResponse response) {
    if (response.code == Razorpay.PAYMENT_CANCELLED) {
      Fluttertoast.showToast(msg: 'Payment Has Been Cancelled');
    } else if (response.code == Razorpay.NETWORK_ERROR) {
      Fluttertoast.showToast(msg: 'Network Issues while payment request');
    } else {
      Fluttertoast.showToast(
        msg: 'Payment Error, Try after some time',
      );
    }
    Get.back();
  }

  Future<bool> getGatewayKey() async {
    var userIdToPass;
    if (LoginModel().userDetails != null) {
      if (LoginModel().userDetails.id != null) {
        userIdToPass = LoginModel().userDetails.id;
      }
    }

    String path = '';

    if (paymentInfo?.paymentType == PaymentType.Lend) {
      notes = {
        'type': 'loan',
        'lid': '${paymentInfo.id}',
        'amt': '${paymentInfo.amount}',
        'cna': '${paymentInfo.form80G?.name ?? ''}',
        'cad': '',
        'cph': '${paymentInfo.form80G?.mobile ?? ''}',
        'cpc': '${paymentInfo.form80G?.pan ?? ''}',
        'd_by': userIdToPass ?? ''
      };
      path = 'master/get-api-key?loan_id=${paymentInfo.id}';
    } else if (paymentInfo.paymentType == PaymentType.Donation) {
      notes = {
        'type': 'donate',
        'amt': '${paymentInfo.amount}',
        'fid': paymentInfo?.id != null ? '${paymentInfo.id}' : "",
        'nam': '${paymentInfo?.name}',
        'eml': '${paymentInfo?.email}',
        'mob': '${paymentInfo?.mobile}',
        'sdi': '${CommonMethods().isAuthTokenExist() ? _isAnonymous : true}',
        'cna': '${paymentInfo?.form80G?.name ?? ''}',
        'cad': 'test',
        'cph': '${paymentInfo.form80G?.mobile ?? ''}',
        'cpc': '${paymentInfo.form80G?.pan ?? ''}',
        'sbscrb': '${paymentInfo.isSubscriptionNeeded ? 1 : 0}',
        'd_by': userIdToPass ?? ''
      };

      path = 'master/get-api-key?fundraiser_id=${paymentInfo.id}';
    } else {
      Fluttertoast.showToast(msg: 'Unknown Payment type');
      Get.back();
    }

    final response = await apiProvider.getInstance().get(path);
    _gatewayKeyResponse = GatewayKeyResponse.fromJson(response.data);
    print("Response${response.data['message']}");
    return _gatewayKeyResponse.success ?? false;
  }

  Future<bool> _getOrder(int id) async {
    String path = '';
    if (paymentInfo.paymentType == PaymentType.Lend) {
      path = 'master/get-order-id?amount=${paymentInfo.amount}&loan_id=$id';
    } else if (paymentInfo.paymentType == PaymentType.Donation) {
      path =
      'master/payment-order-id?amount=${paymentInfo.amount}&name=${paymentInfo.name}&email=${paymentInfo.email}';
      // path = 'master/get-order-id?amount=${paymentInfo.amount}';
    } else {
      Fluttertoast.showToast(msg: 'Unknown Payment type');
      Get.back();
      return false;
    }

    final response = await apiProvider.getInstance().get(path);
    _orderResponse = OrderResponse.fromJson(response.data);
    ApiKey = response.data["apiKey"];
    OrderId = response.data["orderId"];
    Amount = response.data["amount"];
    return _orderResponse.success ?? false;
  }

  Future<bool> _getOrder1(int id) async {
    String path = '';
    if (paymentInfo.paymentType == PaymentType.Lend) {
      path = 'master/get-order-id?amount=${paymentInfo.amount}&loan_id=$id';
    } else if (paymentInfo.paymentType == PaymentType.Donation) {
      if (id != null) {
        path =
        'master/get-order-id?amount=${paymentInfo.amount}&fundraiser_id=$id';
      } else {
        path =
        'master/get-order-id?amount=${paymentInfo.amount}&fundraiser_id=$id';
      }
    } else {
      Fluttertoast.showToast(msg: 'Unknown Payment type');
      Get.back();
      return false;
    }

    final response = await apiProvider.getInstance().get(path);
    _orderResponse = OrderResponse.fromJson(response.data);
    ApiKey = response.data["apiKey"];
    OrderId = response.data["order_id"];
    Amount = response.data["amount"];
    return _orderResponse.success ?? false;
  }

  Future<bool> donationPaymentSuccess() async {

    final response = await apiProvider.getInstance().post(
        'fundraiser-scheme/donate', data: ({
      'transaction_id': '${_paymentSuccessResponse.paymentId}',
      'amount': '${paymentInfo.amount}',
      'fundraiser_id': '${paymentInfo.id}',
      'name': '${paymentInfo.name}',
      'email': '${paymentInfo.email}',
      'show_donor_information': '${paymentInfo.isAnonymous?0:1}',
      'certificate_name': '${paymentInfo.form80G?.name ?? ''}',
      'certificate_address': '${paymentInfo.form80G?.address ?? ''}',
      'certificate_phone': '${paymentInfo.form80G?.mobile ?? ''}',
      'certificate_pan': '${paymentInfo.form80G?.pan ?? ''}'
    })
    );
    Map<String, dynamic> map = response.data;
    return map['success'] ?? false;
  }

  Future<bool> loginDonationPaymentSuccess() async {


    final response = await apiProvider.getInstance().post(
        'fundraiser-scheme/donate-ngo', data: ({
      'transaction_id': '${_paymentSuccessResponse.paymentId}',
      'amount': '${paymentInfo.amount}',
      'user_id': '${LoginModel().userDetails.id}',
      'name': '${paymentInfo.name}',
      'email': '${paymentInfo.email}',
      'show_donor_information': '${paymentInfo.isAnonymous ?0:1}',
      'certificate_name': '${paymentInfo.form80G?.name ?? ''}',
      'certificate_address': '${paymentInfo.form80G?.address ?? ''}',
      'certificate_phone': '${paymentInfo.form80G?.mobile ?? ''}',
      'certificate_pan': '${paymentInfo.form80G?.pan ?? ''}'
    })
    );
    Map<String, dynamic> map = response.data;
    print("map=>${response.statusCode}");
    return map['success'] ?? false;
  }

  Future<bool> guestDonationPaymentSuccess() async {


    final response = await apiProvider.getInstance().post(
        'fundraiser-scheme/donate-ngo', data: ({
      'transaction_id': '${_paymentSuccessResponse.paymentId}',
      'amount': '${paymentInfo.amount}',
      'fundraiser_id': '${paymentInfo.id}',
      'donor_type': 'Guest',
      'name': '${paymentInfo.name}',
      'email': '${paymentInfo.email}',
      'show_donor_information': '${paymentInfo.isAnonymous?0:1}',
      'certificate_name': '${paymentInfo.form80G?.name ?? ''}',
      'certificate_address': '${paymentInfo.form80G?.address ?? ''}',
      'certificate_phone': '${paymentInfo.form80G?.mobile ?? ''}',
      'certificate_pan': '${paymentInfo.form80G?.pan ?? ''}'
    })
    );
    print("response${response}");
    var map = response.data;
    print("map=>${map}");
    return map['success'] ?? false;
  }

  onExternalWalletResponse(ExternalWalletResponse response) {
    print('_onExternalWallet:${response.walletName}');
  }

  Future<bool> loginDonationPaymentCampaignSuccess() async {


    final response = await apiProvider.getInstance().post(
        'campaign/donate', data: ({
      'transaction_id': '${_paymentSuccessResponse.paymentId}',
      'amount': '${paymentInfo.amount}',
      'campaign_id': '${paymentInfo.id}',
      'user_id': '${LoginModel().userDetails.id}',
      'name': '${paymentInfo.name}',
      'email': '${paymentInfo.email}',
      'show_donor_information': '${paymentInfo.isAnonymous?0:1}',
      'certificate_name': '${paymentInfo.form80G?.name ?? ''}',
      'certificate_address': '${paymentInfo.form80G?.address ?? ''}',
      'certificate_phone': '${paymentInfo.form80G?.mobile ?? ''}',
      'certificate_pan': '${paymentInfo.form80G?.pan ?? ''}'
    })
    );

    Map<String, dynamic> map = response.data;
    print("map=>${map}");
    return map['success'] ?? false;
  }


  Future<bool> guestDonationPaymentCampaignSuccess() async  {
    final response = await apiProvider.getInstance().post(
        'campaign/donate', data: ({
      'transaction_id': '${_paymentSuccessResponse.paymentId}',
      'amount': '${paymentInfo.amount}',
      'campaign_id': '${paymentInfo.id}',
      'donor_type': 'Guest',
      'name': '${paymentInfo.name}',
      'email': '${paymentInfo.email}',
      'show_donor_information': '${paymentInfo.isAnonymous?0:1}',
      'certificate_name': '${paymentInfo.form80G?.name ?? ''}',
      'certificate_address': '${paymentInfo.form80G?.address ?? ''}',
      'certificate_phone': '${paymentInfo.form80G?.mobile ?? ''}',
      'certificate_pan': '${paymentInfo.form80G?.pan ?? ''}'
    })
    );
    print("map=>${response.data}");
    var map = response.data;
    return map['success'] ?? false;
  }

  Future<bool> lendandloanSuccess() async {


    final response = await apiProvider.getInstance().post(
        'loan/donate', data: ({
      'transaction_id': '${_paymentSuccessResponse.paymentId}',
      'loan_id': '${paymentInfo.id}',
      'amount': '${paymentInfo.amount}',
    })
    );

    Map<String, dynamic> map = response.data;
    return map['success'] ?? false;
  }

  Future<bool> LoginFetchPayment() async {
    final response = await apiProvider.getInstance().post(
        'razorpay/fetch-payment', data: ({
      'payment_id': '${_paymentSuccessResponse.paymentId}',
    })
    );
    Map<String, dynamic> map = response.data;
    return map['success'] ?? false;
  }

  Future<bool> GuestFetchPayment() async {
    final response = await apiProvider.getInstance().post(
        'razorpay/fetch-payment', data: ({
      'payment_id': '${_paymentSuccessResponse.paymentId}',
      'donor_type': 'Guest',

    })
    );
    Map<String, dynamic> map = response.data;
    return map['success'] ?? false;
  }


  bool startPayment(Function onPaymentSuccess, Function onPaymentErrorFn) {
    try {
      _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
              (PaymentSuccessResponse paymentSuccessResponse) {
            _paymentSuccessResponse = paymentSuccessResponse;
            onPaymentSuccess(_paymentSuccessResponse);
            if(paymentInfo.id==null  ){
              loginDonationPaymentSuccess();
            }
            else if(paymentInfo.id != null && IsCampaign == 1){
              loginDonationPaymentCampaignSuccess();
            }
            else if(paymentInfo.id != null && paymentInfo.paymentType == PaymentType.Lend )
            {
              lendandloanSuccess();
            }
            else {
              donationPaymentSuccess();
              LoginFetchPayment();
            }

            // if(paymentInfo.id==null && IsCampaign == 0 ){
            //   loginDonationPaymentSuccess();
            // }
            // else if(paymentInfo.id==null && IsCampaign == 1){
            //   loginDonationPaymentCampaignSuccess();
            // }
            // else if(paymentInfo.id != null && IsCampaign == 1){
            //   loginDonationPaymentCampaignSuccess();
            // }
            // else {
            //   donationPaymentSuccess();
            // }
          });
      _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR,
              (PaymentFailureResponse paymentFailureResponse) {
            _paymentFailureResponse = paymentFailureResponse;
            onPaymentErrorFn(_paymentFailureResponse);
          });

      _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWalletResponse);

      notes['customer_id'] = _gatewayKeyResponse.customerId ?? "";
      var options = {
        'key': _gatewayKeyResponse.apiKey,
        // 'customer_id':
        //     _gatewayKeyResponse.customerId ??"",
        "order_id": _orderResponse.orderId,
        'amount': _orderResponse.convertedAmount,
        'currency': "INR",
        'name': 'NGO',
        'description': 'Payment',
        'prefill':  {
          'name': '${paymentInfo.name ?? ''}',
          'contact': '${paymentInfo.mobile ?? ''}',
          'email': '${paymentInfo.email ?? ''}'
        },
        'notes': notes
      };

      debugPrint(jsonEncode(options));

      _razorPay.open(options);
      return true;
    } catch (e, s) {
      Completer().completeError(e, s);
      Fluttertoast.showToast(msg: 'Unable to start payment. Please try again');
      Get.back();
      return false;
    }
  }

  bool startPaymentforGuest(
      Function onPaymentSuccess, Function onPaymentErrorFn) {
    try {
      _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
              (PaymentSuccessResponse paymentSuccessResponse) {
            _paymentSuccessResponse = paymentSuccessResponse;
            onPaymentSuccess(_paymentSuccessResponse);
            if(paymentInfo.id==null ){
              guestDonationPaymentSuccess();
            }
            else if(paymentInfo.id != null && paymentInfo.paymentType == PaymentType.Lend )
            {
              lendandloanSuccess();
            }
            else if(paymentInfo.id !=null &&  IsCampaign ==0){
              guestDonationPaymentSuccess();
              GuestFetchPayment();
            }
            else {
              guestDonationPaymentCampaignSuccess();
            }
          });
      _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR,
              (PaymentFailureResponse paymentFailureResponse) {
            _paymentFailureResponse = paymentFailureResponse;
            onPaymentErrorFn(_paymentFailureResponse);
          });

      _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWalletResponse);

      var options = {
        'key': ApiKey,
        "order_id": OrderId,
        'amount': Amount,
        'currency': "INR",
        'name': 'NGO',
        'description': 'Payment',
        'prefill': {
          'name': '${paymentInfo.name ?? ''}',
          'contact': '${paymentInfo.mobile ?? ''}',
          'email': '${paymentInfo.email ?? ''}'
        },
        'notes': notes
      };

      debugPrint(jsonEncode(options));
      _razorPay.open(options);
      return true;
    } catch (e, s) {
      Completer().completeError(e, s);
      Fluttertoast.showToast(msg: 'Unable to start payment. Please try again');
      Get.back();
      return false;
    }
  }

  _showSuccessDialog() {
    CommonWidgets().showCommonDialog(
        'Thank you for donating the amount, receipt will be send to your Phone number / Email id',
        //todo change image
        AssetImage('assets/images/ic_notification_message.png'), () {
      Get.back();
    }, true, false);
  }

  @override
  void dispose() {
    _razorPay.clear();
    super.dispose();
  }
}

class PaymentInfo {
  PaymentType paymentType;
  int id;
  String amount;
  String name;
  String email;
  String countryCode;
  String mobile;
  String address;
  bool isAnonymous;
  Form80G form80G;
  bool isSubscriptionNeeded;

  PaymentInfo(
      {this.paymentType, this.id, this.amount, this.isSubscriptionNeeded,this.address,this.form80G});
}

class Form80G {
  String pan;
  String name;
  String address;
  String countryCode;
  String mobile;

  Form80G({this.pan, this.name, this.countryCode, this.mobile,this.address});
}
