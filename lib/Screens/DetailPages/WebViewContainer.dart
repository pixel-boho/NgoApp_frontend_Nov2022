import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/route_manager.dart';
import 'package:ngo_app/CustomLibraries/CustomLoader/LinearLoader.dart';
import 'package:ngo_app/CustomLibraries/CustomLoader/dot_type.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';

class WebViewContainer extends StatefulWidget {
  final url;

  WebViewContainer(this.url);

  @override
  createState() => _WebViewContainerState(this.url);
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;

  _WebViewContainerState(this._url);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebviewScaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0), // here the desired height
          child: CommonAppBar(
            text: "",
            buttonHandler: _backPressFunction,
          ),
        ),
        url: widget.url,
        withZoom: true,
        hidden: true,
        withLocalStorage: false,
        initialChild: Container(
          child: Center(
            child: Text("Loading, please wait"),
          ),
        ),
      ),
    );
  }

  void _backPressFunction() {
    print("_sendOtpFunction clicked");
    Get.back();
  }
}
