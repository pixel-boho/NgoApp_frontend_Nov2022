import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ngo_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:ngo_app/ServiceManager/ApiProvider.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({Key key}) : super(key: key);

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  ApiProvider apiProvider;
  Map respo = {};
  String pdf= "";
  String baseUrl_pdf="";
  Future getPdf() async {
    // Permission permissions = await Permission.manageExternalStorage;
    // if (permissions.status != PermissionStatus.granted) {
    //   final res = await Permission.manageExternalStorage.request();
    //   print(res);
    // }
    // final savePath = Platform.isAndroid
    //     ? (await getExternalStorageDirectory())?.path
    //     : (await getApplicationDocumentsDirectory()).path;
    // print(savePath.toString());
    // String emulted0 = savePath.split('Android').first;
    // print(emulted0);
    // var status = await Permission.storage.status;
    // if (!status.isGranted) {
    //   await Permission.storage.request();
    // }
    // Fluttertoast.showToast(msg: "Download Started");
    // print("Get order");
    // final response = await apiProvider.getInstance().download(
    //     '${RemoteConfig.baseUrl}'
    //         '${RemoteConfig.getpdfofreport}',
    //     '${emulted0}/Download/report_${dt}.pdf',
    //     options: Options(responseType: ResponseType.bytes, method: "post"),
    //     deleteOnError: true,
    //     data: formData);
    // File pdf = File('${emulted0}/Download/report_${dt}.pdf');
    // toastMessage("Download Completed");
    final response = await http.post(

      Uri.parse(
          'https://crowdworksindia.org/test/api/web/v1/user/generate-pdf'),
      body: {
        "user_id": LoginModel().userDetails.id.toString(),
      },
      headers: {
        'Accept': 'application/json',
      },
    );
    print("Response${response.body}");
    var res = json.decode(response.body);
    respo = res;
    pdf = respo["pdf_path"];
    baseUrl_pdf=respo["file_path"];
    if (response.statusCode == 200) {
      _buildUserWidget(pdf);
    }
    else {
      throw Exception('Failed to load');
    }
    return response;
  }

  // Future<void> downloadPDF() async {
  //   // final pdfUrl = 'https://crowdworksindia.org/test/api/runtime/pdf/report_1697542788.pdf';
  //   String filePath = pdf;
  //   String desiredPath = filePath.split('public_html/')[1];
  //
  //   print("${baseUrl_pdf}/${desiredPath}");
  //
  //
  //   final response = await http.get(Uri.parse("${baseUrl_pdf}/${desiredPath}"));
  //
  //   if (response.statusCode == 200) {
  //     final directory = await getApplicationDocumentsDirectory();
  //     final filePath = '${directory.path}/report_1697542788.pdf';
  //     final pdfFile = File(filePath);
  //     await pdfFile.writeAsBytes(response.bodyBytes, flush: true);
  //
  //     print('PDF downloaded to: $filePath');
  //   } else {
  //     print('Failed to download PDF. Status code: ${response.statusCode}');
  //   }
  // }

  Future<void> downloadPDF() async {
    String filePath = pdf;
    String desiredPath = filePath.split('public_html/')[1];

    print("${baseUrl_pdf}/${desiredPath}");
    final status = await Permission.storage.request();

    if (status.isGranted) {
      final response = await http.get(Uri.parse("${baseUrl_pdf}/${desiredPath}"));

      if (response.statusCode == 200) {
        final savePath = Platform.isAndroid
            ? (await getExternalStorageDirectory())?.path
            : (await getApplicationDocumentsDirectory()).path;
        print(savePath.toString());
        String emulted0 = savePath.split('Android').first;
        print(emulted0);
        Fluttertoast.showToast(msg:"Download Started");
        final filePath = '${emulted0}/Download/80G.pdf';
        final pdfFile = File(filePath);
        await pdfFile.writeAsBytes(response.bodyBytes, flush: true);

        print('PDF downloaded to: $filePath');
        Fluttertoast.showToast(msg:"Download Completed, check download folder");
      } else {
        print('Failed to download PDF. Status code: ${response.statusCode}');
      }
    } else {
      print('Permission to access storage denied');
    }
  }
  @override
  void initState() {
    super.initState();
    getPdf();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body:  RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.green,
            onRefresh: () {
            },
            child: Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 15,),
                    Text("Documents",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16 ),),
                    FutureBuilder(
                        future: getPdf(),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else {
                            if (snapshot.hasError) {
                              return Expanded(
                                child: CommonApiResultsEmptyWidget("Results Empty"),
                                flex: 1,
                              );
                            } else {
                              return _buildUserWidget(pdf);
                            }
                          }
                        }),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildUserWidget(String pdfpath) {
    if (pdfpath != null) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Icon(Icons.picture_as_pdf_outlined ),
            //   Container(
            //   height: MediaQuery.of(context).size.height * 0.58,
            //   width: MediaQuery.of(context).size.width * 0.58,
            //   decoration: BoxDecoration(
            //     border: Border.all(
            //       width: 2,
            //       color: Colors.black,
            //     ),
            //   ),
            //   child: SfPdfViewer.file(pdfFromat),
            // ),
              // Text("${pdfpath}"),
              TextButton(onPressed: (){
                downloadPDF();
              }, child: Icon(Icons.download))
            ],
          ),
        );
      }
    else {
      return Text("Error");
    }
  }

  Future<bool> onWillPop() {
    return Future.value(true);
  }
}
