import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Blocs/MyFundraisersBloc.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/EnumValues.dart';
import 'package:ngo_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:ngo_app/Elements/EachListItemWidget.dart';
import 'package:ngo_app/Elements/PainationLoader.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Interfaces/RefreshPageListener.dart';
import 'package:ngo_app/Models/CommonViewAllResponse.dart';
import 'package:ngo_app/Models/FundraiserItem.dart';
import 'package:ngo_app/Screens/Dashboard/AllCategoriesScreen.dart';
import 'package:ngo_app/Screens/Dashboard/ViewAllScreen.dart';
import 'package:ngo_app/Screens/DetailPages/ItemDetailScreen.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

class MyFundraisersScreen extends StatefulWidget {
  @override
  _MyFundraisersScreenState createState() => _MyFundraisersScreenState();
}

class _MyFundraisersScreenState extends State<MyFundraisersScreen>
    with LoadMoreListener, RefreshPageListener {
  bool isLoadingMore = false;
  ScrollController _itemsScrollController;
  MyFundraisersBloc _myFundraisersBloc;

  @override
  void initState() {
    LoginModel().relatedItemsList.clear();
    super.initState();
    CommonMethods().setRefreshFilterPageListener(this);
    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);
    _myFundraisersBloc = new MyFundraisersBloc(this);
    _myFundraisersBloc.getItems(false);
  }

  void _scrollListener() {
    if (_itemsScrollController.offset >=
            _itemsScrollController.position.maxScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the bottom");
      if (_myFundraisersBloc.hasNextPage) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          _myFundraisersBloc.getItems(true);
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
    _myFundraisersBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // here the desired height
            child: CommonAppBar(
              text: "My Fundraisers",
              buttonHandler: _backPressFunction,
            ),
          ),
          body: RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.green,
            onRefresh: () {
              return _myFundraisersBloc.getItems(false);
            },
            child: Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: StreamBuilder<ApiResponse<CommonViewAllResponse>>(
                          stream: _myFundraisersBloc.itemsStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              switch (snapshot.data.status) {
                                case Status.LOADING:
                                  return CommonApiLoader();
                                  break;
                                case Status.COMPLETED:
                                  CommonViewAllResponse response =
                                      snapshot.data.data;
                                  return _buildUserWidget(response.baseUrl,
                                      _myFundraisersBloc.itemsList);
                                  break;
                                case Status.ERROR:
                                  return CommonApiErrorWidget(
                                      snapshot.data.message,
                                      _errorWidgetFunction);
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
          floatingActionButton: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: CommonWidgets().showHelpDesk(),
          ),
        ),
      ),
    );
  }

  void _errorWidgetFunction() {
    if (_myFundraisersBloc != null) _myFundraisersBloc.getItems(false);
  }

  _buildItemsList(String imageBase, List<FundraiserItem> itemsList) {
    return Container(
      alignment: FractionalOffset.center,
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      margin: EdgeInsets.fromLTRB(10, 15, 10, 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ]),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: itemsList.length,
        itemBuilder: (context, index) {
          return _buildItem(imageBase, itemsList[index]);
        },
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      ),
    );
  }

  void _backPressFunction() {
    print("_sendOtpFunction clicked");
    Get.back();
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

  _buildMessageSection() {
    return Container(
      alignment: FractionalOffset.center,
      padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
          color: Color(colorCoderRedBg),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            alignment: FractionalOffset.center,
            child: Text(
              "Hey havent found a fundraiser that speaks to your heart yet?",
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.0),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
              ),
              primary: Colors.white,
              elevation: 0.0,
              padding: EdgeInsets.fromLTRB(15, 3, 15, 3),
              side: BorderSide(
                width: 2.0,
                color: Colors.transparent,
              ),
            ),
            onPressed: () {
              Get.to(() => AllCategoriesScreen(false));
            },
            child: Text(
              "Start a fundraiser",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(colorCoderRedBg),
                  fontSize: 14,
                  fontFamily: 'roboto',
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  _buildRecommendedSection() {
    if (LoginModel().relatedItemsList != null) {
      if (LoginModel().relatedItemsList.length > 0) {
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
                        "Related",
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
                    itemCount: LoginModel().relatedItemsList.length,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                    itemBuilder: (BuildContext ctx, int index) {
                      return EachListItemWidget(
                          _passedRecommendedFunction,
                          index,
                          ScrollType.Horizontal,
                          LoginModel().relatedItemsList[index],
                          LoginModel().relatedItemsImageBase,
                          LoginModel().relatedItemsWebBaseUrl);
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

  void _passedRecommendedFunction(int itemId) async {
    print("Clicked on : $itemId");
    Map<String, bool> data = await Get.to(() => ItemDetailScreen(itemId));
    if (mounted && data != null) {
      if (data.containsKey("isFundraiserWithdrawn")) {
        if (data["isFundraiserWithdrawn"]) {
          if (_myFundraisersBloc != null) {
            _myFundraisersBloc.getItems(false);
          }
        }
      }
    }
  }

  _buildUserWidget(String imageBase, List<FundraiserItem> itemsList) {
    if (itemsList != null) {
      if (itemsList.length > 0) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildMessageSection(),
              _buildItemsList(imageBase, itemsList),
              Visibility(
                child: _buildRecommendedSection(),
                visible: isLoadingMore ? false : true,
              ),
              Visibility(
                child: SizedBox(
                  height: 15,
                ),
                visible: isLoadingMore ? false : true,
              ),
            ],
          ),
          controller: _itemsScrollController,
        );
      } else {
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildMessageSection(),
            Expanded(
              child: CommonApiResultsEmptyWidget("Results Empty"),
              flex: 1,
            ),
          ],
        );
      }
    } else {
      return CommonApiErrorWidget("No results found", _errorWidgetFunction);
    }
  }

  _buildItem(String imageBase, FundraiserItem fundraiserItem) {
    return InkWell(
      onTap: () async {
        Map<String, bool> data =
            await Get.to(() => ItemDetailScreen(fundraiserItem.id));
        if (mounted && data != null) {
          if (data.containsKey("isFundraiserWithdrawn")) {
            if (data["isFundraiserWithdrawn"]) {
              if (_myFundraisersBloc != null) {
                _myFundraisersBloc.getItems(false);
              }
            }
          }
        }
      },
      child: Container(
        alignment: FractionalOffset.center,
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
                child: Container(
                  width: 80,
                  height: 80,
                  child: CachedNetworkImage(
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: getImage(imageBase, fundraiserItem.imageUrl),
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
                      padding: EdgeInsets.all(5),
                    ),
                  ),
                )),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                    alignment: FractionalOffset.centerLeft,
                    child: Text(
                      "${fundraiserItem.title}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color(colorCoderItemTitle),
                          fontWeight: FontWeight.w600,
                          fontSize: 13.0),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                    alignment: FractionalOffset.centerLeft,
                    child: Text(
                      "₹ ${CommonMethods().convertAmount(fundraiserItem.fundRequired)}",
                      style: TextStyle(
                          color: Color(colorCoderItemSubTitle),
                          fontWeight: FontWeight.w500,
                          fontSize: 13.0),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                    alignment: FractionalOffset.centerLeft,
                    child: Text(
                      getApprovalStatus(fundraiserItem),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: getColor(fundraiserItem),
                          fontWeight: FontWeight.w600,
                          fontSize: 11.0),
                    ),
                  ),
                ],
              ),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }

  String getImage(String baseUrl, String imgUrl) {
    String img = "";
    if (baseUrl != null) {
      if (baseUrl != "") {
        if (imgUrl != null) {
          if (imgUrl != "") {
            img = baseUrl + imgUrl;
          }
        }
      }
    }
    return img;
  }

  @override
  void refreshPage() {
    if (mounted) {
      setState(() {
        print("${LoginModel().relatedItemsList.length}");
        print("PageRefreshed");
      });
    }
  }

  String getApprovalStatus(FundraiserItem fundraiserItem) {
    if (fundraiserItem.isApproved == 1) {
      return "Approved";
    } else if (fundraiserItem.isApproved == 0) {
      return "Pending Approval";
    } else {
      return "Rejected";
    }
  }

  getColor(FundraiserItem fundraiserItem) {
    if (fundraiserItem.isApproved == 1) {
      return Colors.green;
    } else if (fundraiserItem.isApproved == 0) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
