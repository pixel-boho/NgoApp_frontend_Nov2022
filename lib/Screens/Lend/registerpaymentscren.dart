//
// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_openmoney/flutter_openmoney.dart';
// import 'package:flutter_openmoney/payment_options.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:ngo_app/Blocs/paymentchecksum.dart';
// import 'package:ngo_app/Blocs/paytmBloc.dart';
// import 'package:ngo_app/Elements/CommonApiLoader.dart';
// import 'package:ngo_app/Models/CommonResponse.dart';
// import 'package:ngo_app/Models/paytmModel.dart';
// import 'package:ngo_app/Screens/Dashboard/Home.dart';
//
// import 'package:ngo_app/ServiceManager/ApiProvider.dart';
// import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
//
//
// import '../../Blocs/paymentokenbloc.dart';
// import '../../Models/paymenttokenmodel.dart';
// import 'PaymentScreen.dart';
//
//
// class RegisterPaymentScrenn extends StatefulWidget {
//
//
//   RegisterPaymentScrenn({Key key,  this.id, this.amount, this.paymentInfo,this.name,this.email,this.phone}) : super(key: key);
//   final PaymentInfo paymentInfo;
//   final name;
//   final email;
//   final phone;
//   final amount;
//   final id;
//
//   String amountInPaise = '0';
//   @override
//   State<RegisterPaymentScrenn> createState() => _RegisterPaymentScrennState();
// }
//
// class _RegisterPaymentScrennState extends State<RegisterPaymentScrenn> {
//   BookingsBlocUser _bookingsBlocUser;
//   // Paymentbloc _paytoken;
//   PaymentInfo paymentInfo;
//   FlutterOpenmoney flutterOpenmoney;
//   String result;
//   @override
//   void initState() {
//     super.initState();
//     paymentInfo = paymentInfo;
//     _bookingsBlocUser = BookingsBlocUser();
//     flutterOpenmoney = FlutterOpenmoney();
//     flutterOpenmoney.on(
//       FlutterOpenmoney.eventPaymentSuccess,
//       _handlePaymentSuccess,
//     );
//     flutterOpenmoney.on(
//       FlutterOpenmoney.eventPaymentError,
//       _handlePaymentError,
//     );
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       _initPayment();
//     });
//
//
//   }
//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     Fluttertoast.showToast(
//       msg: 'SUCCESS: ${response.paymentId}',
//       toastLength: Toast.LENGTH_LONG,
//     );
//   }
//
//   void _handlePaymentError(PaymentFailureResponse response) {
//     Fluttertoast.showToast(
//       msg: 'ERROR: ${response.code} - ${response.message}',
//       toastLength: Toast.LENGTH_LONG,
//     );
//   }
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black12.withOpacity(0.5),
//       body: Center(
//         child: CommonApiLoader(),
//       ),
//     );
//   }
//   Future _initPayment() async {
//
//     try {
//       TestPaymentModel response = await  _bookingsBlocUser.bookAppointment(widget.name, widget.email,"7878787878", "CrowdWorksIndia");
//
//       if (response.status == 200) {
//         PaymentToken response1 = await _bookingsBlocUser.Payment(
//             widget.name, widget.email, "7878787878", "CrowdWorksIndia", 1);
//
//         print("StartTransaction->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//         await _startTransaction(
//             response1.id,
//             response1.access_key
//
//         );
//         print("mid->>>>>>>>>>>${ response1.id}");
//       }
//       else(){
//         Get.back();
//         Fluttertoast.showToast(msg: "Could not create contact.Contact Already exists.");
//       };
//     } catch (e, s) {
//       Completer().completeError(e, s);
//       Get.back();
//       Fluttertoast.showToast(msg:'Something went wrong. Please try again');
//     }
//   }
//
//   Future _startTransaction(String paymenttoken,String accesskey) async {
//
//     String accessKey = accesskey;
//
//     /// Generated using openmoney create token api in server
//     /// refer https://docs.bankopen.com/reference/generate-token
//     String paymentToken = paymenttoken;
//     final options = PaymentOptions(accessKey, paymentToken);
//
//
//     try {
//       flutterOpenmoney.initPayment(options);
//     } catch (e) {
//       debugPrint('Error: e');
//     }
//   }
//
//   PaymentBlocUser _paymentBlocUser = PaymentBlocUser();
//   Future _validateCheckSum(String OrderId) async {
//     try {
//       final response = await _paymentBlocUser.validateCheckSum(widget.name,widget.email,widget.phone,OrderId);
//       return response;
//     } catch (e, s) {
//       Completer().completeError(e, s);
//       Get.back();
//       Fluttertoast.showToast(msg:'Something went wrong. Please try again');
//     }
//   }
// }