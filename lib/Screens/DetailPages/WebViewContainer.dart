//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ngo_app/Elements/CommonAppBar.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
//
//
// class WebViewContainer extends StatefulWidget {
//   final url;
//
//   WebViewContainer(this.url);
//
//   @override
//   createState() => _WebViewContainerState(this.url);
// }
//
//
// class _WebViewContainerState extends State<WebViewContainer> {
//   var _url;
//   _WebViewContainerState(_url);
//
//   @override
//   void initState() {
//     super.initState();
//     WebView.platform = SurfaceAndroidWebView();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print("Url1-->${_url}");
//     print("Url2-->${widget.url}");
//     return Scaffold(
//               appBar: PreferredSize(
//           preferredSize: Size.fromHeight(60.0), // here the desired height
//           child: CommonAppBar(
//             text: "",
//             buttonHandler: _backPressFunction,
//           ),
//         ),
//     body: WebView(
//         initialUrl: widget.url,
//         javascriptMode: JavascriptMode.unrestricted,
//       onWebResourceError: (WebResourceError error) {
//         print("WebView error: ${error.description}");
//       },// Enable JavaScript
//       ),
//     );
//   }
//
//   void _backPressFunction() {
//     print("_sendOtpFunction clicked");
//     Get.back();
//   }
//
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final url;

  WebViewContainer(this.url);

  @override
  createState() => _WebViewContainerState(this.url);
}

class _WebViewContainerState extends State<WebViewContainer> {
  final _url;

  _WebViewContainerState(this._url);

  bool isPDF(String url) {
    return url.toLowerCase().endsWith('.pdf');
  }

  @override
  void initState() {
    super.initState();
    WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    if (isPDF(widget.url)) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0), // here the desired height
          child: CommonAppBar(
            text: "",
            buttonHandler: _backPressFunction,
          ),
        ),
        body: SafeArea(
          child: WebView(
            initialUrl:
                "https://docs.google.com/gview?embedded=true&url=${widget.url}",
            javascriptMode: JavascriptMode.unrestricted, // Enable JavaScript
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0), // here the desired height
          child: CommonAppBar(
            text: "",
            buttonHandler: _backPressFunction,
          ),
        ),
        body: SafeArea(
          child: WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted, // Enable JavaScript
          ),
        ),
      );
    }
  }

  void _backPressFunction() {
    print("_sendOtpFunction clicked");
    Get.back();
  }
}
