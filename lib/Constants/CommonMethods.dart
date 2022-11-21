import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ngo_app/Blocs/CommonBloc.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Models/CampaignTypesResponse.dart';
import 'package:ngo_app/Models/CommonViewAllResponse.dart';
import 'package:ngo_app/Models/RelationsResponse.dart';
import 'package:ngo_app/Screens/Authorization/LoginScreen.dart';
import 'package:ngo_app/Screens/WelcomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Interfaces/RefreshPageListener.dart';
import '../Utilities/LoginModel.dart';
import 'StringConstants.dart';

class CommonMethods {
  static RefreshPageListener _refreshPageListener;

  void setRefreshFilterPageListener(RefreshPageListener listener) {
    print("initialized#####");
    _refreshPageListener = listener;
  }

  String getNetworkError(error) {
    String errorDescription = "";
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.cancel:
          errorDescription = StringConstants.dioErrorTypeCancel;
          break;
        case DioErrorType.connectTimeout:
          errorDescription = StringConstants.dioErrorTypeConnectTimeout;
          break;
        case DioErrorType.other:
          errorDescription = StringConstants.dioErrorTypeDefault;
          break;
        case DioErrorType.receiveTimeout:
          errorDescription = StringConstants.dioErrorTypeReceiveTimeout;
          break;
        case DioErrorType.response:
          errorDescription = StringConstants.dioErrorTypeResponse;
          break;
        case DioErrorType.sendTimeout:
          errorDescription = StringConstants.dioErrorTypeSendTimeout;
          break;
      }
    } else {
      errorDescription = StringConstants.normalErrorMessage;
    }

    return errorDescription;
  }

  Future<bool> isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// My way of capitalizing each word in a string.
  String titleCase(String text) {
    if (text == null) return "";

    if (text.isEmpty) return text;

    /// If you are careful you could use only this part of the code as shown in the second option.
    return text
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String changeDateFormat(String dateReceived) {
    String dateFormat = "";
    try {
      if (dateReceived != null && dateReceived != "") {
        dateFormat =
            DateFormat("dd MMM yyyy").format(DateTime.parse(dateReceived));
      }
      return dateFormat;
    } catch (e) {
      return "";
    }
  }

  String changeTimeFormat(String dateReceived) {
    String dateFormat = "";
    try {
      if (dateReceived != null && dateReceived != "") {
        dateFormat = DateFormat("HH:mm a").format(DateTime.parse(dateReceived));
      }
      return dateFormat;
    } catch (e) {
      return "";
    }
  }

  String getDateTime(String dateReceived) {
    String dateFormat = "";
    try {
      if (dateReceived != null && dateReceived != "") {
        dateFormat = DateFormat("dd MMM yyyy HH:mm a")
            .format(DateTime.parse(dateReceived));
      }
      return dateFormat;
    } catch (e) {
      return "";
    }
  }

  checkNetworkConnection() {
    CommonMethods().isInternetAvailable().then((onValue) {
      if (!onValue) {
        LoginModel().isNetworkAvailable = false;

        Get.snackbar("Oops!!", "${StringConstants.netFailureMsg}",
            backgroundColor: Color(colorCodeGreyPageBg),
            snackPosition: SnackPosition.TOP,
            colorText: Colors.white,
            shouldIconPulse: true,
            margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
            icon: Icon(
              Icons.wifi_off,
              color: Colors.red,
            ));
      } else {
        LoginModel().isNetworkAvailable = true;
      }
    });
  }

  clearData() async {
    LoginModel().clearInfo();
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
    Get.offAll(() => WelcomeScreen());
  }

  bool isAuthTokenExist() {
    if (LoginModel().authToken != null) {
      if (LoginModel().authToken.isNotEmpty && LoginModel().authToken != "") {
        return true;
      }
    }
    return false;
  }

  String readTimestamp(String dateReceived) {
    try {
      DateTime dateTimeCreatedAt = DateTime.parse(dateReceived);
      DateTime dateTimeNow = DateTime.now();
      var diff = dateTimeNow.difference(dateTimeCreatedAt);
      var time = '';

      if (diff.inSeconds <= 0 ||
          diff.inSeconds > 0 && diff.inMinutes == 0 ||
          diff.inMinutes > 0 && diff.inHours == 0 ||
          diff.inHours > 0 && diff.inDays == 0) {
        time = DateFormat("hh:mm:ss a").format(dateTimeCreatedAt);
      } else if (diff.inDays > 0 && diff.inDays < 7) {
        if (diff.inDays == 1) {
          time = diff.inDays.toString() + ' DAY AGO';
        } else {
          time = diff.inDays.toString() + ' DAYS AGO';
        }
      } else {
        if (diff.inDays == 7) {
          time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
        } else {
          time = DateFormat("dd MMM yyyy").format(dateTimeCreatedAt);
        }
      }

      return time;
    } catch (e) {
      return dateReceived;
    }
  }

  void getAllCategories(bool isToCallListener) async {
    CommonBloc commonInfoBloc = new CommonBloc();
    commonInfoBloc.getCampaignTypes().then((res) {
      CampaignTypesResponse response = res;
      if (response != null) {
        if (response.statusCode == 200) {
          LoginModel().campaignsListSaved = response.campaignsList;
          if (_refreshPageListener != null && isToCallListener) {
            _refreshPageListener.refreshPage();
          }
        }
      }
    });
  }

  String validateMobile(String phone) {
    String pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    RegExp regExp = new RegExp(pattern);
    if (phone == null) {
      return "Enter mobile number";
    } else if (phone.length == 0) {
      return "Enter mobile number";
    } else if (phone.length < 8) {
      return "Please provide a valid mobile number";
    } /*else if (!regExp.hasMatch(phone)) {
      return "Please provide a valid mobile number";
    }*/
    return null;
  }

  String nameValidator(String name) {
    if (name.length == 0) {
      return "Enter your name";
    } else if (name.length < 3) {
      return "Please provide a valid name";
    }
    return null;
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) return "Enter your email";
    if (!regex.hasMatch(value))
      return "Please provide a valid email";
    else
      return null;
  }

  String requiredValidator(String name) {
    if (name.length == 0) {
      return "Required field";
    }
    return null;
  }

  alertLoginOkClickFunction() async {
    print("_alertOkBtnClickFunction clicked");
    LoginModel().clearInfo();
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
    Get.offAll(() => LoginScreen());
  }

  String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  String getImage() {
    String img = "";
    if (LoginModel().userDetails != null) {
      if (LoginModel().userDetails.baseUrl != null) {
        if (LoginModel().userDetails.baseUrl != "") {
          if (LoginModel().userDetails.imageUrl != null) {
            if (LoginModel().userDetails.imageUrl != "") {
              img = LoginModel().userDetails.baseUrl +
                  LoginModel().userDetails.imageUrl;
            }
          }
        }
      }
    }
    print("$img");
    return img;
  }

  String getDateDifference(String dateReceived) {
    try {
      String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
      DateTime dateTimeCreatedAt = DateTime.parse(dateReceived);
      DateTime dateTimeNow = DateTime.parse(now);
      final differenceInDays = dateTimeCreatedAt.difference(dateTimeNow).inDays;
      print('$dateTimeCreatedAt');
      print('$dateTimeNow');
      print('$differenceInDays');
      if (differenceInDays > 1) {
        return "$differenceInDays Days left";
      } else if (differenceInDays == 0) {
        return "Last Date";
      } else if (differenceInDays == 1) {
        return "1 Day left";
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  String getDateGap(String dateReceived) {
    try {
      DateTime dateTimeCreatedAt = DateTime.parse(dateReceived);
      DateTime dateTimeNow = DateTime.now();
      final differenceInDays = dateTimeCreatedAt.difference(dateTimeNow).inDays;
      print('$differenceInDays');
      return '$differenceInDays';
    } catch (e) {
      return "";
    }
  }

  void clearFilters() {
    if (LoginModel().campaignsListSaved != null) {
      for (var catData in LoginModel().campaignsListSaved) {
        catData.isSelected = false;
      }
    }
    if (LoginModel().sortOptions != null) {
      for (var data in LoginModel().sortOptions) {
        data.isSelected = false;
      }
    }
  }

  void getAllRelatedItems({int categoryId}) async {
    if (CommonMethods().isAuthTokenExist()) {
      CommonBloc commonInfoBloc = new CommonBloc();
      commonInfoBloc.getRelatedItems(categoryId: categoryId).then((res) {
        CommonViewAllResponse response = res;
        if (response != null) {
          if (response.statusCode == 200) {
            LoginModel().relatedItemsImageBase = response.baseUrl ?? "";
            LoginModel().relatedItemsWebBaseUrl = response.webBaseUrl ?? "";
            LoginModel().relatedItemsList = response.itemsList;
            if (_refreshPageListener != null) {
              _refreshPageListener.refreshPage();
            }
          }
        }
      });
    }
  }

  void getAllRelations() async {
    CommonBloc commonInfoBloc = new CommonBloc();
    commonInfoBloc.getRelations().then((res) {
      RelationsResponse response = res;
      if (response != null) {
        if (response.statusCode == 200) {
          LoginModel().relationsList = response.list;
          if (_refreshPageListener != null) {
            _refreshPageListener.refreshPage();
          }
        }
      }
    });
  }

  bool checkIsOwner(int createdUserId) {
    if (LoginModel().userDetails != null) {
      if (LoginModel().userDetails.id != null && createdUserId != null) {
        if (LoginModel().userDetails.id == createdUserId) {
          return true;
        }
      }
    }
    return false;
  }

  /*
  It should be ten characters long.
The first five characters should be any upper case alphabets.
The next four-characters should be any number from 0 to 9.
The last(tenth) character should be any upper case alphabet.
It should not contain any white spaces.
   */
  // Function to validate the PAN Card number.
  String isValidPanCardNo(String panCardNo) {
    // Regex to check valid PAN Card number.
    String _pattern = "[A-Z]{5}[0-9]{4}[A-Z]{1}";

    RegExp regex = new RegExp(_pattern);
    if (panCardNo.isEmpty) return "Enter pan card number";
    if (!regex.hasMatch(panCardNo))
      return "Please provide a valid pan card number";
    else
      return null;
  }

  String isValidIfsc(String ifsc) {
    // Regex to check valid PAN Card number.
    String _pattern = "^[A-Z]{4}0[A-Z0-9]{6}\$";

    RegExp regex = new RegExp(_pattern);
    if (ifsc.isEmpty) return "Enter IFSC code";
    if (!regex.hasMatch(ifsc))
      return "Please provide a valid IFSC code";
    else
      return null;
  }

  String convertAmount(var amount) {
    try {
      var price = amount.runtimeType == String ? int.parse(amount) : amount;
      var comma = NumberFormat('###,###,###,###');
      String dat = comma.format(price).replaceAll(' ', '');
      return dat ?? "";
    } catch (e) {
      return amount;
    }
  }

  Size displaySize(BuildContext context) {
    debugPrint('Size = ' + MediaQuery.of(context).size.toString());
    return MediaQuery.of(context).size;
  }

  double displayHeight(BuildContext context) {
    debugPrint('Height = ' + displaySize(context).height.toString());
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    debugPrint('Width = ' + displaySize(context).width.toString());
    return displaySize(context).width;
  }
}
