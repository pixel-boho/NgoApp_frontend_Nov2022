import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:ngo_app/Models/PancardUploadResponse.dart';
import 'package:ngo_app/Repositories/CommonInfoRepository.dart';


class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({Key key, this.message, this.fundid}) : super(key: key);
  final String message;
  final int fundid;
  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  CommonInfoRepository Withd = CommonInfoRepository();

  UserDetails userDetails;

  // void sendMail(
  // ) async {
  //   // change your email here
  //   String mailmessage ="";
  //   String username = 'crowdworksindiafoundation@gmail.com';
  //   // change your password here
  //   String password = 'yztf thqt essr orfe';
  //   String recipientEmail="${userDetails.email}";
  //   final smtpServer = gmail(username, password);
  //   final message = Message()
  //     ..from = Address(username,'Crowd works India')
  //     ..recipients.add(recipientEmail)
  //     ..subject = 'Payment Invoice'
  //     ..text = '$mailmessage';
  //
  //   try {
  //     await send(message, smtpServer);
  //     print('Email sent successfully');
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e.toString());
  //     }
  //   }
  // }

  File pdf;

  // Future<File> getPdfOfReport() async {
  //   Permission permissions = await Permission.manageExternalStorage;
  //   if (permissions.status != PermissionStatus.granted) {
  //     final res = await Permission.manageExternalStorage.request();
  //     print(res);
  //   }
  //   final savePath = Platform.isAndroid
  //       ? (await getExternalStorageDirectory())?.path
  //       : (await getApplicationDocumentsDirectory()).path;
  //   print(savePath.toString());
  //   String emulted0 = savePath.split('Android').first;
  //   print(emulted0);
  //   var status = await Permission.storage.status;
  //   if (!status.isGranted) {
  //     await Permission.storage.request();
  //   }
  //   Fluttertoast.showToast(msg: "Download Started");
  //   final response = await apiProvider
  //       .getInstance().download(RemoteConfig.downloadReceipt, '${emulted0}/Download/receipt.pdf',
  //       options: Options(responseType: ResponseType.bytes, method: "get"),);
  //
  //   pdf = File('${emulted0}/Download/receipt.pdf');
  //   Fluttertoast.showToast(msg: "Download Completed");
  //   return pdf;
  // }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // here the desired height
            child: CommonAppBar(
              text: "Success",
              buttonHandler: _backPressFunction,
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30,),
              Image.asset("assets/images/tra.png"),
              SizedBox(height: 30,),
              // Text("Check your email and download your payment  "),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: new BorderRadius.circular(10.0),
              //     ),
              //     primary: Color(colorCoderRedBg),
              //     elevation: 0.0,
              //     padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              //     side: BorderSide(
              //       width: 2.0,
              //       color: Color(colorCoderRedBg),
              //     ),
              //   ),
              //   onPressed: () {
              //     sendMail();
              //
              //   },
              //   child: Text(
              //     "Download payment receipt",
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //         color: Color(colorCodeWhite),
              //         fontSize: 11,
              //         fontWeight: FontWeight.w600),
              //   ),
              // )

            ],
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    return Future.value(true);
  }

  void _backPressFunction() {
    print("_sendOtpFunction clicked");
    Get.back();
  }
}
