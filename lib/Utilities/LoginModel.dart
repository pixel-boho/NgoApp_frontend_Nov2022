import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ngo_app/Models/CampaignItem.dart';
import 'package:ngo_app/Models/CancelOption.dart';
import 'package:ngo_app/Models/FundraiserItem.dart';
import 'package:ngo_app/Models/ItemDetailResponse.dart';
import 'package:ngo_app/Models/RelationsResponse.dart';
import 'package:ngo_app/Models/SortOption.dart';
import 'package:ngo_app/Models/UserDetails.dart';

class LoginModel {
  static final LoginModel _singleton = LoginModel._internal();

  factory LoginModel() => _singleton;

  LoginModel._internal(); // private constructor
  var authToken = "";
  bool isNetworkAvailable = true;
  UserDetails userDetails = new UserDetails();
  List<CampaignItem> campaignsListSaved = [];
  List<SortOption> sortOptions = [
    SortOption(
        optionName: "Low To High", optionValue: "asc", isSelected: false),
    SortOption(
        optionName: "High To Low", optionValue: "desc", isSelected: false)
  ];
  List<FundraiserItem> relatedItemsList = [];
  var relatedItemsImageBase = "";
  var relatedItemsWebBaseUrl = "";
  Map startFundraiserMap = new Map<String, dynamic>();
  List<RelationInfo> relationsList = [];
  ItemDetailResponse itemDetailResponseInEditMode;
  bool isFundraiserEditMode = false;
  List<CancelOption> cancelOptions = [
    CancelOption(
        optionName: "Collection of the amount not fast", optionValue: 0, isSelected: false, optionDescription: "Collection of the amount not fast"),
    CancelOption(
        optionName: "Cash already collected from other resources", optionValue: 1, isSelected: false, optionDescription: "Cash already collected from other resources"),
    CancelOption(
        optionName: "Others", optionValue: 2, isSelected: false, optionDescription: "")
  ];

  void clearInfo() {
    authToken = "";
    userDetails = null;
    campaignsListSaved = [];
    relatedItemsList = [];
    relatedItemsImageBase = "";
    relatedItemsWebBaseUrl = "";
    relationsList = [];
    isFundraiserEditMode = false;
  }
}
