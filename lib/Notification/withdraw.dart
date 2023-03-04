import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ngo_app/Repositories/CommonInfoRepository.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Constants/CustomColorCodes.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({Key key, this.message, this.fundid}) : super(key: key);
final String message;final int fundid;
  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  CommonInfoRepository Withd = CommonInfoRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset("assets/images/tra.png")),);
  }

}
