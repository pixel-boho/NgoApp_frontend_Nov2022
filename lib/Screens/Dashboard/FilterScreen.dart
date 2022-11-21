import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Interfaces/RefreshPageListener.dart';
import 'package:ngo_app/Models/CampaignItem.dart';
import 'package:ngo_app/Models/SortOption.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> with RefreshPageListener {
  int categorySelectedValue;
  SortOption sortSelectedValue;
  bool isApiCallRunning = false;
  CampaignItem _selectedCategoryIfo;
  bool isFilterReset = false;

  @override
  void initState() {
    super.initState();
    CommonMethods().setRefreshFilterPageListener(this);
    callFilterOptions();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black12.withOpacity(0.5),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    color: Color(colorCodeGreyPageBg),
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      children: <Widget>[
                        SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 60),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              PreferredSize(
                                  preferredSize: Size.fromHeight(65.0),
                                  // here the desired height
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment:
                                                FractionalOffset.centerLeft,
                                            child: Text(
                                              "Apply Filters",
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  color: Color(colorCodeWhite)),
                                            ),
                                          ),
                                          flex: 1,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            if (isFilterReset &&
                                                sortSelectedValue == null &&
                                                _selectedCategoryIfo == null) {
                                              Map<String, bool> info = {
                                                'isFilterReset': true
                                              };
                                              Get.back(result: info);
                                            } else {
                                              Get.back(result: null);
                                            }
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                  )),
                              _buildSortSection(),
                              _buildCategorySection(),
                            ],
                          ),
                        ),
                        Positioned(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: _buildActions(),
                          ),
                        )
                      ],
                    ),
                  ),
                  flex: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    if (isFilterReset &&
        sortSelectedValue == null &&
        _selectedCategoryIfo == null) {
      Map<String, bool> info = {'isFilterReset': true};
      Get.back(result: info);
    } else {
      Get.back(result: null);
    }
    return Future.value(true);
  }

  @override
  void refreshPage() {
    setState(() {
      isApiCallRunning = false;
    });
  }

  void callFilterOptions() {
    if (LoginModel().campaignsListSaved != null) {
      if (LoginModel().campaignsListSaved.length == 0) {
        isApiCallRunning = true;
        CommonMethods().getAllCategories(true);
      }
    }
  }

  _buildSortSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 25, 10, 1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: FractionalOffset.centerLeft,
            child: Text(
              "Sort By",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(colorCodeWhite)),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
              padding: EdgeInsets.fromLTRB(10, 3, 5, 3),
              margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
              height: 45,
              decoration: BoxDecoration(
                  color: Color(colorCodeGreyPageBg),
                  border: Border.all(color: Colors.white, width: 0.5),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              width: double.infinity,
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  child: DropdownButton(
                    dropdownColor: Color(colorCodeGreyPageBg),
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    hint: Text(setAlreadySelectedSort(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Color(colorCodeWhite))),
                    value: sortSelectedValue,
                    onChanged: (val) {
                      setState(() {
                        sortSelectedValue = val;
                      });
                    },
                    items: LoginModel().sortOptions.map((option) {
                      return DropdownMenuItem(
                        child: Text(
                          "${option.optionName}",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: Color(colorCodeWhite)),
                        ),
                        value: option,
                      );
                    }).toList(),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  _buildCategorySection() {
    if (LoginModel().campaignsListSaved != null) {
      if (LoginModel().campaignsListSaved.length > 0) {
        return Container(
          margin: EdgeInsets.fromLTRB(15, 25, 10, 1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: FractionalOffset.centerLeft,
                child: Text(
                  "Campaigns",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(colorCodeWhite)),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(10, 3, 5, 3),
                  margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
                  height: 45,
                  decoration: BoxDecoration(
                      color: Color(colorCodeGreyPageBg),
                      border: Border.all(color: Colors.white, width: 0.5),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  width: double.infinity,
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      child: DropdownButton(
                        dropdownColor: Color(colorCodeGreyPageBg),
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        hint: Text(setAlreadySelectedCategory(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: Color(colorCodeWhite))),
                        value: _selectedCategoryIfo,
                        onChanged: (val) {
                          setState(() {
                            _selectedCategoryIfo = val;
                          });
                        },
                        items: LoginModel().campaignsListSaved.map((option) {
                          return DropdownMenuItem(
                            child: Text(
                              "${option.title}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  color: Color(colorCodeWhite)),
                            ),
                            value: option,
                          );
                        }).toList(),
                      ),
                    ),
                  ))
            ],
          ),
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  _buildActions() {
    return Container(
      width: double.infinity,
      alignment: FractionalOffset.center,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: InkWell(
              onTap: () {
                isFilterReset = true;
                CommonMethods().clearFilters();
                Fluttertoast.showToast(
                    msg: "All your selected filter options cleared");
                setState(() {
                  sortSelectedValue = null;
                  _selectedCategoryIfo = null;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12.withOpacity(0.2),
                          spreadRadius: 0.5,
                          blurRadius: 0,
                          offset: Offset(0, 0.5) // changes position of shadow
                          ),
                    ]),
                width: 45,
                height: 45,
                child: IconButton(
                  iconSize: 15,
                  icon: Image.asset(
                    'assets/images/ic_reset.png',
                    width: 15,
                    height: 15,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 45.0,
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: CommonButton(
                  buttonText: "Save",
                  bgColorReceived: Color(colorCoderRedBg),
                  borderColorReceived: Color(colorCoderRedBg),
                  textColorReceived: Color(colorCodeWhite),
                  buttonHandler: _saveBtnClickFunction),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  void _saveBtnClickFunction() {
    print("_saveBtnClickFunction clicked");
    if (_selectedCategoryIfo == null && sortSelectedValue == null) {
      callFilterOptions();
      Fluttertoast.showToast(msg: "Please select any option from above");
      return;
    } else {
      if (_selectedCategoryIfo != null &&
          LoginModel().campaignsListSaved != null) {
        for (var data in LoginModel().campaignsListSaved) {
          if (data == _selectedCategoryIfo) {
            data.isSelected = true;
          } else {
            data.isSelected = false;
          }
        }
      }

      if (sortSelectedValue != null && LoginModel().sortOptions != null) {
        for (var data in LoginModel().sortOptions) {
          if (data == sortSelectedValue) {
            data.isSelected = true;
          } else {
            data.isSelected = false;
          }
        }
      }

      Get.back(result: {'isFilterApplied': true});
    }
  }

  String setAlreadySelectedCategory() {
    String val = "~~Select~~";
    if (LoginModel().campaignsListSaved != null) {
      for (var data in LoginModel().campaignsListSaved) {
        if (data.isSelected) {
          val = data.title;
        }
      }
    }

    return val;
  }

  String setAlreadySelectedSort() {
    String val = "~~Select~~";
    if (LoginModel().sortOptions != null) {
      for (var data in LoginModel().sortOptions) {
        if (data.isSelected) {
          val = data.optionName;
        }
      }
    }

    return val;
  }
}
