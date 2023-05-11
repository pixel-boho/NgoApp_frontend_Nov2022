

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class screen extends StatefulWidget {
  const screen({Key key}) : super(key: key);

  @override
  State<screen> createState() => _screenState();
}

class _screenState extends State<screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.purple,);
  }
}
