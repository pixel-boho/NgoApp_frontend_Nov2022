import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Notification/OneSignalNotifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/CustomColorCodes.dart';
import '../Models/UserDetails.dart';
import '../Utilities/LoginModel.dart';
import '../Utilities/PreferenceUtils.dart';
import 'Dashboard/Home.dart';
import 'WelcomeScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  String authToken;
  UserDetails userDetails;

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/splash_logo.gif'),
                fit: BoxFit.fill)),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.9),
            FutureBuilder<String>(
                future: _getAppVersion(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  String version = '';
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData)
                    version = snapshot.data == null
                        ? ''
                        : 'Version : ${snapshot.data}';
                  return Text(
                    '$version',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.grey),
                  );
                }),
            SizedBox(
              height: 18,
            ),
          ],
        ),
      ),
    );
  }

  startTime() async {
    print("****");
    var _duration = Duration(seconds: 10);
    return Timer(_duration, navigateToStartUp);
  }

  void navigateToStartUp() {
    if (LoginModel().authToken != null && LoginModel().authToken != "") {
      Get.offAll(
          () => DashboardScreen(fragmentToShow: 0,),
          transition: Transition.fade);
    } else {
      Get.offAll(() => WelcomeScreen(), transition: Transition.fade);
    }
  }

  void getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      authToken = prefs.getString(PreferenceUtils.prefAuthToken) ?? "";
      print(authToken);
      if (authToken != "") {
        var data = prefs.getString(PreferenceUtils.prefUserDetails) ?? "";
        if (data != "") {
          userDetails = UserDetails.fromJson(json.decode(data));
          if (userDetails != null) {
            LoginModel().authToken = authToken;
            LoginModel().userDetails = userDetails;
            print("*************************");
            print(userDetails.id);
            print(userDetails.name);
            print(userDetails.email);
            print(userDetails.countryCode);
            print(userDetails.phoneNumber);
            print(userDetails.imageUrl);
            print("*************************");
            OneSignalNotifications().handleSendTags();
          } else {
            print("*******");
            print("userDetails is null");
            print("*******");
          }
        } else {
          print("*******");
          print("data is empty");
          print("*******");
        }
      } else {
        print("*******");
        print("auth is empty");
        print("*******");
      }
      startTime();
    } catch (Exception) {
      startTime();
    }
  }

  Future<String> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
