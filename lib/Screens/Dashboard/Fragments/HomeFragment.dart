import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Blocs/HomeBloc.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/EnumValues.dart';
import 'package:ngo_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/DonateNowCardWidget.dart';
import 'package:ngo_app/Elements/EachListItemWidget.dart';
import 'package:ngo_app/Elements/StartNowCardWidget.dart';
import 'package:ngo_app/Models/CampaignItem.dart';
import 'package:ngo_app/Models/FundraiserItem.dart';
import 'package:ngo_app/Models/HomeResponse.dart';
import 'package:ngo_app/Screens/DetailPages/ItemDetailScreen.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

import '../AllCategoriesScreen.dart';
import '../ViewAllScreen.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = new HomeBloc();
    _homeBloc.getHomeItems();
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: Colors.green,
      onRefresh: () {
        return _homeBloc.getHomeItems();
      },
      child: Container(
          color: Colors.transparent,
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              DonateNowCardWidget(),
              Expanded(
                child: StreamBuilder<ApiResponse<HomeResponse>>(
                  stream: _homeBloc.homeStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data.status) {
                        case Status.LOADING:
                          return CommonApiLoader();
                          break;
                        case Status.COMPLETED:
                          return _buildUserWidget(snapshot.data.data);
                          break;
                        case Status.ERROR:
                          return CommonApiErrorWidget(
                              snapshot.data.message, _errorWidgetFunction);
                          break;
                      }
                    }

                    return Container();
                  },
                ),
                flex: 1,
              ),
            ],
          )),
    );
  }

  void _errorWidgetFunction() {
    if (_homeBloc != null) _homeBloc.getHomeItems();
  }

  Widget _buildUserWidget(HomeResponse homeResponse) {
    return CustomScrollView(slivers: <Widget>[
      SliverPadding(
        padding: EdgeInsets.fromLTRB(0.0, 10, 0, 70),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildCategoriesSection(
                    homeResponse.campaignBaseUrl, homeResponse.campaignList),
                StartNowCardWidget(),
                _buildRecommendedSection(homeResponse.fundraiserBaseUrl,
                    homeResponse.recommendedList, homeResponse.webBaseUrl),
                _buildFundraisersSection(homeResponse.fundraiserBaseUrl,
                    homeResponse.fundraiserList, homeResponse.webBaseUrl),
              ],
            ),
          ]),
        ),
      )
    ]);
  }

  Widget _buildRecommendedSection(String imageBase,
      List<FundraiserItem> recommendedList, String webBaseUrl) {
    if (recommendedList != null) {
      if (recommendedList.length > 0) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          alignment: FractionalOffset.centerLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      alignment: FractionalOffset.centerLeft,
                      child: Text(
                        "Recommended",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color(colorCodeBlack),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600),
                      ),
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    ),
                    flex: 1,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        primary: Colors.transparent,
                        elevation: 0.0,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      ),
                      onPressed: () {
                        CommonMethods().clearFilters();
                        Get.to(() => ViewAllScreen());
                      },
                      child: Text("View All",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontSize: 10.0,
                              color: Color(colorCoderRedBg),
                              fontWeight: FontWeight.w500))),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * .45,
                alignment: FractionalOffset.centerLeft,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: recommendedList.length,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                    itemBuilder: (BuildContext ctx, int index) {
                      return EachListItemWidget(
                          _passedRecommendedFunction,
                          index,
                          ScrollType.Horizontal,
                          recommendedList[index],
                          imageBase,
                          webBaseUrl);
                    }),
              ),
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

  void _passedRecommendedFunction(int itemId) async{
    print("Clicked on : $itemId");
    Map<String, bool> data = await Get.to(() => ItemDetailScreen(itemId));
    if (mounted && data != null) {
      if (data.containsKey("isFundraiserWithdrawn")) {
        if (data["isFundraiserWithdrawn"]) {
          if (_homeBloc != null) {
            _homeBloc.getHomeItems();
          }
        }
      }
    }
  }

  void _passedFundraiserFunction(int itemId) async{
    print("Clicked on : $itemId");
    Map<String, bool> data = await Get.to(() => ItemDetailScreen(itemId));
    if (mounted && data != null) {
      if (data.containsKey("isFundraiserWithdrawn")) {
        if (data["isFundraiserWithdrawn"]) {
          if (_homeBloc != null) {
            _homeBloc.getHomeItems();
          }
        }
      }
    }
  }

  Widget _buildFundraisersSection(String imageBase,
      List<FundraiserItem> fundraiserList, String webBaseUrl) {
    if (fundraiserList != null) {
      if (fundraiserList.length > 0) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      alignment: FractionalOffset.centerLeft,
                      child: Text(
                        "Our Fundraiser Scheme",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color(colorCodeBlack),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600),
                      ),
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    ),
                    flex: 1,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        primary: Colors.transparent,
                        elevation: 0.0,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      ),
                      onPressed: () {
                        Get.to(() => ViewAllScreen());
                      },
                      child: Text("View All",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontSize: 10.0,
                              color: Color(colorCoderRedBg),
                              fontWeight: FontWeight.w500))),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * .45,
                alignment: FractionalOffset.centerLeft,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: fundraiserList.length,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                    itemBuilder: (BuildContext ctx, int index) {
                      return EachListItemWidget(
                          _passedFundraiserFunction,
                          index,
                          ScrollType.Horizontal,
                          fundraiserList[index],
                          imageBase,
                          webBaseUrl);
                    }),
              ),
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

  _buildCategoriesSection(String imageBase, List<CampaignItem> campaignList) {
    if (campaignList != null) {
      if (campaignList.length > 0) {
        return Container(
          height: 60,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          alignment: FractionalOffset.centerLeft,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: campaignList.length + 1,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(0, 5, 15, 5),
              itemBuilder: (BuildContext ctx, int index) {
                if (index == 0) {
                  return _buildCategoryAllBtn();
                } else {
                  return _buildCategoryItem(campaignList[index - 1], imageBase);
                }
              }),
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  _buildCategoryAllBtn() {
    return InkWell(
      child: Container(
        width: 55,
        height: 55,
        margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
        decoration: BoxDecoration(
          color: Color(colorCodeGreyPageBg),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 2), // changes position of shadow
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
          child: SizedBox.expand(
            child: Image(
              image: AssetImage('assets/images/ic_category_all.png'),
              width: 55,
              height: 55,
            ),
          ),
        ),
      ),
      onTap: () {
        Get.to(() => AllCategoriesScreen(true));
      },
    );
  }

  _buildCategoryItem(CampaignItem campaignItem, String imageBase) {
    return InkWell(
      child: Container(
        width: 55,
        height: 55,
        margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
          color: Color(colorCodeGreyPageBg),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 2), // changes position of shadow
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
          child: SizedBox.expand(
            child: CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: getCategoryImage(campaignItem, imageBase),
              placeholder: (context, url) => Container(
                child: Center(
                  child: RoundedLoader(),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                child: Image(
                  image: AssetImage('assets/images/no_image.png'),
                ),
                margin: EdgeInsets.all(5),
              ),
            ),
          ),
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
        Get.to(() => ViewAllScreen(
              isCampaignRelated: true,
            ));
      },
    );
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
