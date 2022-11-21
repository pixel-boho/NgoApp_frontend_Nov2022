import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/EnumValues.dart';
import 'package:ngo_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:ngo_app/CustomLibraries/TextDrawable/TextDrawableWidget.dart';
import 'package:ngo_app/CustomLibraries/TextDrawable/color_generator.dart';
import 'package:ngo_app/Screens/Authorization/LoginScreen.dart';
import 'package:ngo_app/Screens/Dashboard/Fragments/CampaignFragment.dart';
import 'package:ngo_app/Screens/Dashboard/Fragments/FundraiserFragment.dart';
import 'package:ngo_app/Screens/Dashboard/Fragments/HomeFragment.dart';
import 'package:ngo_app/Screens/Dashboard/Fragments/ProfileFragemnt.dart';
import 'package:ngo_app/Screens/Lend/LendListingScreen.dart';
import 'package:ngo_app/Screens/Lend/PaymentInputAmountScreen.dart';
import 'package:ngo_app/Screens/Sidebar/AboutUsScreen.dart';
import 'package:ngo_app/Screens/Sidebar/ContactUsScreen.dart';
import 'package:ngo_app/Screens/Sidebar/FaqScreen.dart';
import 'package:ngo_app/Screens/Sidebar/HowItWorksScreen.dart';
import 'package:ngo_app/Screens/Sidebar/MediaScreen.dart';
import 'package:ngo_app/Screens/Sidebar/PartnerRequestScreen.dart';
import 'package:ngo_app/Screens/Sidebar/PricingScreen.dart';
import 'package:ngo_app/Screens/Sidebar/VolunteerRequestScreen.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

import 'AllCategoriesScreen.dart';
import 'AutocompleteSearch.dart';
import 'PointsInfoScreen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: DashboardScreen(fragmentToShow: 0),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final int fragmentToShow;

  DashboardScreen({Key key, @required this.fragmentToShow}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  var selectedTabPos = 0;
  TabController _tabController;
  DateTime currentBackPressTime;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 4);
    selectedTabPos = widget.fragmentToShow != null ? widget.fragmentToShow : 0;
    _tabController.animateTo(selectedTabPos);
    CommonMethods().getAllCategories(false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          key: _scaffoldKey,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(colorCoderRedBg),
            centerTitle: true,
            title: Text(getTitle(),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400)),
            leading: IconButton(
              icon: Image.asset(
                'assets/images/ic_menu.png',
                width: 25.0,
                height: 25.0,
              ),
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
            ),
            actions: [
              _coinsBadge(),
              SizedBox(
                width: 5,
              )
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: Theme(
                data:
                    Theme.of(context).copyWith(accentColor: Colors.transparent),
                child: Container(
                  height: 65.0,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Card(
                          elevation: 0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.all(12.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      'Search',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    flex: 1,
                                  ),
                                  Image(
                                    image: AssetImage(
                                        'assets/images/ic_search.png'),
                                    height: 16.0,
                                    width: 16.0,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Get.to(() => AutocompleteSearch());
                            },
                          ),
                        ),
                        flex: 1,
                      ),
                      SizedBox(
                        width: 30,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          drawer: sideNav(context),
          body: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: getFragment(selectedTabPos),
                ),
                flex: 1,
              ),
              Container(
                color: Color(colorCodeGreyPageBg),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                constraints: BoxConstraints.expand(height: 70),
                child: BottomAppBar(
                  child: bottomTabs(),
                  color: Color(colorCodeGreyPageBg),
                ),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 65),
            child: CommonWidgets().showHelpDesk(),
          ),
        ),
      ),
    );
  }

  getFragment(int pos) {
    switch (pos) {
      case 0:
        return HomeFragment();
        break;
      case 1:
        return FundraiserFragment();
        break;
      case 2:
        return CampaignFragment();
        break;
      case 3:
        return ProfileFragment();
        break;

      default:
        return Center(
          child: Text("Loading error"),
        );
    }
  }

  bottomTabs() {
    return TabBar(
      controller: _tabController,
      onTap: tabItemClicked,
      tabs: [
        Tab(
          text: "Home",
          iconMargin: EdgeInsets.fromLTRB(0, 0, 0, 5),
          icon: selectedTabPos != 0
              ? Image.asset(
                  'assets/images/ic_tab_home_unselected.png',
                  width: 25,
                  height: 25,
                )
              : Image.asset(
                  'assets/images/ic_tab_home_selected.png',
                  width: 25,
                  height: 25,
                ),
        ),
        Tab(
          text: "Fundraisers",
          iconMargin: EdgeInsets.fromLTRB(0, 0, 0, 5),
          icon: selectedTabPos != 1
              ? Image.asset(
                  'assets/images/ic_tab_fundraiser_unselected.png',
                  width: 25,
                  height: 25,
                )
              : Image.asset(
                  'assets/images/ic_tab_fundraiser_selected.png',
                  width: 25,
                  height: 25,
                ),
        ),
        Tab(
          text: "Campaigns",
          iconMargin: EdgeInsets.fromLTRB(0, 0, 0, 5),
          icon: selectedTabPos != 2
              ? Image.asset(
                  'assets/images/ic_tab_campaign_unselected.png',
                  width: 25,
                  height: 25,
                )
              : Image.asset(
                  'assets/images/ic_tab_campaign_selected.png',
                  width: 25,
                  height: 25,
                ),
        ),
        Tab(
          text: "Profile",
          iconMargin: EdgeInsets.fromLTRB(0, 0, 0, 5),
          icon: selectedTabPos != 3
              ? Image.asset(
                  'assets/images/ic_tab_profile_unselected.png',
                  width: 25,
                  height: 25,
                )
              : Image.asset(
                  'assets/images/ic_tab_profile_selected.png',
                  width: 25,
                  height: 25,
                ),
        ),
      ],
      labelColor: Color(colorCoderTextGrey),
      labelStyle: TextStyle(
          fontSize: 10,
          color: Color(colorCoderTextGrey),
          fontWeight: FontWeight.w400),
      unselectedLabelColor: Color(colorCoderTextGrey),
      unselectedLabelStyle: TextStyle(
          fontSize: 10,
          color: Color(colorCoderTextGrey),
          fontWeight: FontWeight.w400),
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: Colors.transparent,
      indicatorWeight: 0,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Colors.transparent, width: 2.0),
        insets: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      ),
    );
  }

  /*
    While clicking a tab item
   */
  void tabItemClicked(int index) {
    if (mounted) {
      CommonMethods().clearFilters();
      if (index != 3) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            selectedTabPos = index;
          });
        });
      } else {
        if (CommonMethods().isAuthTokenExist()) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              selectedTabPos = index;
            });
          });
        } else {
          CommonWidgets().showCommonDialog(
              "You need to login before use this feature!!",
              AssetImage('assets/images/ic_notification_message.png'),
              CommonMethods().alertLoginOkClickFunction,
              false,
              true);
        }
      }
    }
  }

  alertLoginClickFunction() {
    print("_alertOkBtnClickFunction clicked");
    Get.offAll(() => LoginScreen());
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Please press back again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  sideNav(BuildContext context) {
    return Drawer(
      child: Container(
          color: Color(colorCodeGreyPageBg),
          child: Column(
            children: <Widget>[
              _buildUserInfo(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      drawerItem(context, 1, "Donate Now",
                          AssetImage('assets/images/ic_nav_donate_now.png')),
                      drawerItem(
                          context,
                          2,
                          "Start A Fundraiser",
                          AssetImage(
                              'assets/images/ic_nav_start_fundraiser.png')),
                      drawerItem(context, 3, "Volunteer With Us",
                          AssetImage('assets/images/ic_nav_volunteer.png')),
                      drawerItem(context, 4, "How It Works",
                          AssetImage('assets/images/ic_nav_how_it_works.png')),
                      drawerItem(context, 5, "Lend",
                          AssetImage('assets/images/ic_nav_loans.png')),
                      drawerItem(context, 6, "About Us",
                          AssetImage('assets/images/ic_nav_about_us.png')),
                      drawerItem(context, 7, "Contact Us",
                          AssetImage('assets/images/ic_nav_contact_us.png')),
                      drawerItem(context, 8, "Media",
                          AssetImage('assets/images/ic_nav_media.png')),
                      drawerItem(context, 9, "Partners",
                          AssetImage('assets/images/ic_nav_partners.png')),
                      drawerItem(context, 10, "Pricing",
                          AssetImage('assets/images/ic_nav_pricing.png')),
                      drawerItem(context, 11, "FAQ",
                          AssetImage('assets/images/ic_nav_faq.png')),
                      drawerItem(
                          context,
                          12,
                          CommonMethods().isAuthTokenExist()
                              ? "Sign Out"
                              : "Log In",
                          AssetImage('assets/images/ic_nav_logout.png')),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
                flex: 1,
              ),
            ],
          )),
    );
  }

  Widget drawerItem(
      BuildContext context, var type, var title, var assetsImage) {
    return Container(
      color: Color(colorCodeGreyPageBg),
      padding: EdgeInsets.fromLTRB(20, 25, 20, 0),
      child: InkWell(
        child: Row(children: <Widget>[
          Image(
            image: assetsImage,
            height: 35.0,
            width: 35.0,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(25.0, 0.0, 10.0, 0.0),
            child: Text(title,
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Montserrat",
                    color: Color(colorCoderTextGrey),
                    fontWeight: FontWeight.w500)),
          )
        ]),
        onTap: () {
          Get.back();
          if (type == 1) {
            //Donate now
            Get.to(() => PaymentInputAmountScreen(
                paymentType: PaymentType.Donation,
                id: null,
                isCampaignRelated: true,
                isForNgoTrust: true));
            //if (CommonMethods().isAuthTokenExist()) {
            /*Get.to(() => ViewAllScreen(
                  isCampaignRelated: true,
                ));*/
            /*} else {
              CommonWidgets().showCommonDialog(
                  "You need to login before use this feature!!",
                  AssetImage('assets/images/ic_notification_message.png'),
                  CommonMethods().alertLoginOkClickFunction,
                  false,
                  true);
            }*/
          } else if (type == 2) {
            // start a fundraiser
            if (CommonMethods().isAuthTokenExist()) {
              Get.to(() => AllCategoriesScreen(false));
            } else {
              CommonWidgets().showCommonDialog(
                  "You need to login before use this feature!!",
                  AssetImage('assets/images/ic_notification_message.png'),
                  CommonMethods().alertLoginOkClickFunction,
                  false,
                  true);
            }
          } else if (type == 3) {
            // volunteer with us
            Get.to(() => VolunteerRequestScreen());
          } else if (type == 4) {
            // how it works
            Get.to(() => HowItWorksScreen());
          } else if (type == 5) {
            // lend
            Get.to(() => LendListingScreen());
          } else if (type == 6) {
            // about us
            Get.to(() => AboutUsScreen());
          } else if (type == 7) {
            // contact us
            Get.to(() => ContactUsScreen());
          } else if (type == 8) {
            // media
            Get.to(() => MediaScreen());
          } else if (type == 9) {
            // partners
            Get.to(() => PartnerRequestScreen());
          } else if (type == 10) {
            // pricing
            Get.to(() => PricingScreen());
          } else if (type == 11) {
            // faq
            Get.to(() => FaqScreen());
          } else if (type == 12) {
            // sign out
            if (CommonMethods().isAuthTokenExist()) {
              CommonWidgets().showCommonDialog(
                  "Are you sure you want to Log out?",
                  AssetImage('assets/images/ic_notification_message.png'),
                  _alertLogoutBtnClickFunction,
                  false,
                  true);
            } else {
              CommonMethods().clearData();
            }
          }
        },
      ),
    );
  }

  void _alertLogoutBtnClickFunction() {
    print("_alertOkBtnClickFunction clicked");
    CommonMethods().clearData();
  }

  String getTitle() {
    if (selectedTabPos == 0) {
      return "Home";
    } else if (selectedTabPos == 1) {
      return "Fundraisers";
    } else if (selectedTabPos == 2) {
      return "Campaigns";
    } else if (selectedTabPos == 3) {
      return "Profile";
    } else {
      return "";
    }
  }

  _buildUserInfo() {
    if (CommonMethods().isAuthTokenExist()) {
      return Container(
        width: double.infinity,
        color: Color(colorCoderSidebarTop),
        padding: EdgeInsets.fromLTRB(12, 10, 1, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
                child: InkWell(
                  onTap: _showProfile,
                  child: AbsorbPointer(
                    child: Container(
                      width: 60,
                      height: 70,
                      child: CachedNetworkImage(
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: CommonMethods().getImage(),
                        placeholder: (context, url) => Center(
                          child: RoundedLoader(),
                        ),
                        errorWidget: (context, url, error) =>
                            TextDrawableWidget(
                                "${LoginModel().userDetails.name}",
                                ColorGenerator.materialColors, (bool selected) {
                          // on tap callback
                          print("on tap callback");
                        }, true, 60.0, 70.0, BoxShape.rectangle,
                                TextStyle(color: Colors.white, fontSize: 17.0)),
                      ),
                    ),
                  ),
                )),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: FractionalOffset.centerRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      iconSize: 24,
                      icon: Icon(
                        Icons.close,
                        color: Colors.white30,
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: _showProfile,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 2, 3, 0),
                            child: Text(
                              "${CommonMethods().titleCase(LoginModel().userDetails.name)}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 2, 3, 10),
                            child: Text(
                              "${LoginModel().userDetails.email}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              flex: 1,
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: 150,
        color: Color(colorCoderSidebarTop),
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Stack(
          children: [
            Center(
              child: IconButton(
                iconSize: 120,
                icon: Icon(
                  Icons.account_circle,
                  color: Color(colorCoderBorderWhite),
                ),
              ),
            ),
            Align(
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                iconSize: 24,
                icon: Icon(
                  Icons.close,
                  color: Colors.white30,
                ),
              ),
              alignment: FractionalOffset.topRight,
            ),
          ],
        ),
      );
    }
  }

  _coinsBadge() {
    if (LoginModel().userDetails != null) {
      if (LoginModel().userDetails.points != null) {
        if (LoginModel().userDetails.points > 0) {
          String val = LoginModel().userDetails.points > 100
              ? "99+"
              : "${LoginModel().userDetails.points}";
          return InkWell(
            onTap: () {
              Get.to(() => PointsInfoScreen(),
                  opaque: false, fullscreenDialog: true);
            },
            child: Badge(
              position: BadgePosition.topEnd(top: 3, end: 3),
              animationDuration: Duration(milliseconds: 300),
              animationType: BadgeAnimationType.scale,
              badgeColor: Colors.white,
              shape: BadgeShape.circle,
              //borderRadius: BorderRadius.circular(5),
              badgeContent: Text(
                "$val",
                style: TextStyle(color: Colors.red, fontSize: 7),
              ),
              child: Image(
                image: AssetImage('assets/images/ic_coin.png'),
                height: 35,
                width: 35,
              ),
            ),
          );
        }
      }
    }
    return SizedBox();
  }

  void _showProfile() {
    print("closeit");
    Navigator.pop(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        selectedTabPos = 3;
      });
    });
  }
}
