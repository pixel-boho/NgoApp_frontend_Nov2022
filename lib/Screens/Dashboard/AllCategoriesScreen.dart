import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Blocs/CampaignTypesBloc.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Elements/PainationLoader.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Models/CampaignItem.dart';
import 'package:ngo_app/Models/CampaignTypesResponse.dart';
import 'package:ngo_app/Screens/StartFundRaising/FormOne.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

import 'ViewAllScreen.dart';

class AllCategoriesScreen extends StatefulWidget {
  final bool isFromCategories;

  AllCategoriesScreen(this.isFromCategories);

  @override
  _AllCategoriesScreenState createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen>
    with LoadMoreListener {
  bool isLoadingMore = false;
  ScrollController _itemsScrollController;
  int value;
  CampaignTypesBloc _campaignTypesBloc;
  CampaignItem selectedCampaignItem;

  @override
  void initState() {
    super.initState();
    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);
    _campaignTypesBloc = new CampaignTypesBloc(this);
    _campaignTypesBloc.getCampaignTypes(false);
  }

  void _scrollListener() {
    if (_itemsScrollController.offset >=
            _itemsScrollController.position.maxScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the bottom");
      if (_campaignTypesBloc.hasNextPage) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          _campaignTypesBloc.getCampaignTypes(true);
        });
      }
    }
    if (_itemsScrollController.offset <=
            _itemsScrollController.position.minScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the top");
    }
  }

  @override
  void dispose() {
    _itemsScrollController.dispose();
    _campaignTypesBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Color(colorCodeGreyPageBg),
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(65.0), // here the desired height
            child: Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            widget.isFromCategories
                                ? "All Categories"
                                : "Start a Fundraiser",
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                height: 1.5,
                                fontWeight: FontWeight.w600,
                                fontSize: 17.0),
                          ),
                          flex: 1,
                        ),
                        IconButton(
                          iconSize: 26,
                          icon: Icon(
                            Icons.close,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ],
                    ),
                    flex: 1,
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.5,
                    color: Colors.white,
                    margin: EdgeInsets.fromLTRB(15, 2, 15, 4),
                  )
                ],
              ),
            ),
          ),
          body: RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.green,
            onRefresh: () {
              return _campaignTypesBloc.getCampaignTypes(false);
            },
            child: Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: StreamBuilder<ApiResponse<CampaignTypesResponse>>(
                          stream: _campaignTypesBloc.typesStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              switch (snapshot.data.status) {
                                case Status.LOADING:
                                  return CommonApiLoader();
                                  break;
                                case Status.COMPLETED:
                                  CampaignTypesResponse campaignTypesResponse =
                                      snapshot.data.data;
                                  return _buildUserWidget(
                                      campaignTypesResponse.baseUrl,
                                      _campaignTypesBloc.campaignTypesList);
                                  break;
                                case Status.ERROR:
                                  return CommonApiErrorWidget(
                                      snapshot.data.message,
                                      _errorWidgetFunction,
                                      textColorReceived: Colors.white);
                                  break;
                              }
                            }
                            return Container(
                              child: Center(
                                child: Text(""),
                              ),
                            );
                          }),
                      flex: 1,
                    ),
                    Visibility(
                      child: PaginationLoader(),
                      visible: isLoadingMore ? true : false,
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  void _errorWidgetFunction() {
    if (_campaignTypesBloc != null) _campaignTypesBloc.getCampaignTypes(false);
  }

  void _nextBtnClickFunction() {
    print("_nextBtnClickFunction clicked");
    if (selectedCampaignItem != null) {
      LoginModel().startFundraiserMap["campaignSelected"] = selectedCampaignItem;
      LoginModel().startFundraiserMap["campaign_id"] = selectedCampaignItem.id;
      Get.to(() => FormOneScreen());
    } else {
      Fluttertoast.showToast(
          msg: "Please select one campaign item to continue");
    }
  }

  _buildUserWidget(String imageBase, List<CampaignItem> campaignTypesList) {
    if (campaignTypesList != null) {
      if (campaignTypesList.length > 0) {
        return Stack(
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: campaignTypesList.length,
              itemBuilder: (context, index) {
                return _buildEachListItemWidget(
                    index, campaignTypesList[index], imageBase);
              },
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _itemsScrollController,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 85),
            ),
            Visibility(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: CommonButton(
                      buttonText: "Next",
                      bgColorReceived: Color(colorCoderRedBg),
                      borderColorReceived: Color(colorCoderRedBg),
                      textColorReceived: Color(colorCodeWhite),
                      buttonHandler: _nextBtnClickFunction),
                ),
              ),
              visible: widget.isFromCategories
                  ? false
                  : isLoadingMore
                      ? false
                      : true,
            ),
          ],
        );
      } else {
        return CommonApiResultsEmptyWidget("Results Empty",
            textColorReceived: Colors.white);
      }
    } else {
      return CommonApiErrorWidget("No results found", _errorWidgetFunction,
          textColorReceived: Colors.white);
    }
  }

  Future<bool> onWillPop() {
    return Future.value(true);
  }

  @override
  refresh(bool isLoading) {
    if (mounted) {
      setState(() {
        isLoadingMore = isLoading;
      });
      print(isLoadingMore);
    }
  }

  _buildEachListItemWidget(
      int index, CampaignItem campaignItem, String imageBase) {
    if (widget.isFromCategories) {
      return InkWell(
        child: Container(
          padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
          margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
          decoration: BoxDecoration(
            color: Color(colorCodeGreyPageBg),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
            border: Border.all(color: Colors.white, width: 0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
                  child: Container(
                    width: 35,
                    height: 35,
                    child: CachedNetworkImage(
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: getCategoryImage(campaignItem, imageBase),
                      placeholder: (context, url) => Center(
                        child: RoundedLoader(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.black12,
                        child: Image(
                          image: AssetImage('assets/images/no_image.png'),
                          height: double.infinity,
                          width: double.infinity,
                        ),
                        margin: EdgeInsets.all(0),
                      ),
                    ),
                  )),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Text(
                  campaignItem.title ?? "",
                  textAlign: TextAlign.left,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                      fontSize: 13.0),
                ),
                flex: 1,
              ),
            ],
          ),
        ),
        onTap: () {
          CommonMethods().clearFilters();
          if (LoginModel().campaignsListSaved != null) {
            for (var data in LoginModel().campaignsListSaved) {
              if (data.id == campaignItem.id) {
                data.isSelected = true;
                break;
              }
            }
          }
          Get.to(() => ViewAllScreen());
        },
      );
    } else {
      return Container(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        decoration: BoxDecoration(
          color: value == index ? Colors.black : Color(colorCodeGreyPageBg),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
          border: Border.all(color: Colors.white, width: 0.5),
        ),
        child: RadioListTile(
          activeColor: Colors.redAccent,
          value: index,
          groupValue: value,
          controlAffinity: ListTileControlAffinity.trailing,
          onChanged: (ind) {
            selectedCampaignItem = campaignItem;
            setState(() {
              value = ind;
            });
          },
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
                  child: Container(
                    width: 35,
                    height: 35,
                    child: CachedNetworkImage(
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: getCategoryImage(campaignItem, imageBase),
                      placeholder: (context, url) => Center(
                        child: RoundedLoader(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.black12,
                        child: Image(
                          image: AssetImage('assets/images/no_image.png'),
                          height: double.infinity,
                          width: double.infinity,
                        ),
                        margin: EdgeInsets.all(0),
                      ),
                    ),
                  )),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Text(
                  campaignItem.title ?? "",
                  textAlign: TextAlign.left,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                      fontSize: 13.0),
                ),
                flex: 1,
              ),
            ],
          ),
        ),
      );
    }
  }

  getCategoryImage(CampaignItem campaignItem, String imageBase) {
    String img = "";
    if (campaignItem != null) {
      if (imageBase != null) {
        if (imageBase != "") {
          if (campaignItem.iconUrl != null) {
            if (campaignItem.iconUrl != "") {
              img = imageBase + campaignItem.iconUrl;
            }
          }
        }
      }
    }
    return img;
  }
}
