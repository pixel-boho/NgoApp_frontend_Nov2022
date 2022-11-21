import 'dart:convert';

import 'package:get/route_manager.dart';
import 'package:ngo_app/Constants/EnumValues.dart';
import 'package:ngo_app/Models/UserDetails.dart';
import 'package:ngo_app/Screens/DetailPages/ItemDetailScreen.dart';
import 'package:ngo_app/Utilities/PreferenceUtils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OneSignalNotifications {
  void initializeOnesignal() async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    print("***********");
    print("Initialize Onesignal");
    print("***********");
    try {
      OneSignal.shared.setAppId("e132f07e-4963-4e76-97cb-4479afdb7cfb");
      handleSendTags();
      OneSignal.shared.setNotificationWillShowInForegroundHandler(
          (OSNotificationReceivedEvent event) {
        print('FOREGROUND HANDLER CALLED WITH: $event');
      });
      OneSignal.shared.setNotificationOpenedHandler(
          (OSNotificationOpenedResult result) async {
        print('NOTIFICATION OPENED HANDLER CALLED WITH: $result');
        bool isLogged = false;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        isLogged = prefs.getBool(PreferenceUtils.prefIsLoggedIn) == null
            ? false
            : prefs.getBool(PreferenceUtils.prefIsLoggedIn);
        print("***");
        print(isLogged);
        print("***");
        if (isLogged == true) {
          print("islogged");
          checkPayload(result);
        } else {
          print("is not logged");
        }
      });
      OneSignal.shared
          .setPermissionObserver((OSPermissionStateChanges changes) {
        // will be called whenever the permission changes
        // (ie. user taps Allow on the permission prompt in iOS)
      });
      OneSignal.shared
          .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
        // will be called whenever the subscription changes
        //(ie. user gets registered with OneSignal and gets a user ID)
      });
// If you want to know if the user allowed/denied permission,
// the function returns a Future<bool>:
      OneSignal.shared
          .promptUserForPushNotificationPermission()
          .then((accepted) {
        print("Accepted permission: $accepted");
      });

      OneSignal.shared
          .promptUserForPushNotificationPermission(fallbackToSettings: true);
    } catch (exception) {}
  }

  void handleSendTags() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var data = prefs.getString(PreferenceUtils.prefUserDetails) ?? "";
      if (data != "") {
        print("Sending tags");
        UserDetails userDetails = UserDetails.fromJson(json.decode(data));
        OneSignal.shared.sendTags({
          "user_id": userDetails.id,
        }).then((response) {
          print("Successfully sent tags with response: $response");
        }).catchError((error) {
          print("Encountered an error sending tags: $error");
        });
      } else {
        print("Sending tags failed");
      }
    } catch (e) {
      print("Sending tags failed" + e.toString());
    }
  }

  void checkPayload(OSNotificationOpenedResult notificationObj) {
    OSNotification notification = notificationObj.notification;
    if (notification != null) {
      print("**************");
      print(notification);
      print("**************");
      if (notification.rawPayload != null) {
        print("**************");
        print(notification.rawPayload);
        print("Title : ");
        print(notification.rawPayload.containsKey("title"));
        print("Body : ");
        print(notification.rawPayload.containsKey("body"));
        print(notification.additionalData);
        print("**************");
        if (notification.additionalData != null) {
          var notify = notification.additionalData;
          print("**************notification additional data");
          print(notify.toString());
          if (notify.containsKey("type") && notify.containsKey("value")) {
            if (notify["type"] == "fundraiser") {
              Get.to(() => ItemDetailScreen(notify["value"],
                  fromPage: FromPage.FromPushNotification));
            }
          }
        } else {
          print("**************");
          print("Notification payload additional data is null");
          print("**************");
        }
      } else {
        print("**************");
        print("Notification payload is null");
        print("**************");
      }
    } else {
      print("**************");
      print("Notification s null");
      print("**************");
    }
  }

  void removeTags() {
    print("Removing tags");
    OneSignal.shared.deleteTags(["user_id"]).then((response) {
      print("Successfully removed tags with response: $response");
    }).catchError((error) {
      print("Encountered an error removing tags: $error");
    });
  }
}
