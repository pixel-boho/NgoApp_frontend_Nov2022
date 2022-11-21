import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;
  final bool isDev;

  const AppErrorWidget({
    Key key,
    @required this.errorDetails,
    this.isDev = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.transparent)),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0)),
      ),
    );
  }
}
