import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Elements/app_error_widget.dart';
import 'package:ngo_app/Notification/OneSignalNotifications.dart';
import 'package:ngo_app/Screens/SplashScreen.dart';



void main() async {
  bool isDev = false;
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return AppErrorWidget(
      errorDetails: errorDetails,
      isDev: isDev,
    );
  };

  WidgetsFlutterBinding.ensureInitialized();
  OneSignalNotifications().initializeOnesignal();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(NgoApp());
  });
}

class NgoApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.red,
          fontFamily: 'Montserrat'),
      home: SplashScreen(),
    );
  }
}
