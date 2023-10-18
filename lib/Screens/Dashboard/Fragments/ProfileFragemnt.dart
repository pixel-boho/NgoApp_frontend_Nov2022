import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Blocs/ProfileBloc.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/EnumValues.dart';
import 'package:ngo_app/CustomLibraries/TextDrawable/TextDrawableWidget.dart';
import 'package:ngo_app/CustomLibraries/TextDrawable/color_generator.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/ProfileOption.dart';
import 'package:ngo_app/Models/ProfileResponse.dart';
import 'package:ngo_app/Models/UserDetails.dart';
import 'package:ngo_app/Screens/ProfileRelated/EditProfileScreen.dart';
import 'package:ngo_app/Screens/ProfileRelated/MyTransactionScreen.dart';
import 'package:ngo_app/Screens/ProfileRelated/MyDocumentsScreen.dart';
import 'package:ngo_app/Screens/ProfileRelated/MyCommentsScreen.dart';
import 'package:ngo_app/Screens/ProfileRelated/MyDonationsScreen.dart';
import 'package:ngo_app/Screens/ProfileRelated/MyFundraisersScreen.dart';
import 'package:ngo_app/Screens/ProfileRelated/MyLoansScreen.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';

class ProfileFragment extends StatefulWidget {
  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  ProfileBloc profileBloc;
  UserDetails  userid = UserDetails();
  int userids = 0;
  String url ="";
  @override
  void initState() {
    super.initState();
    profileBloc = new ProfileBloc();
    profileBloc.getProfileInfo();
  }

  @override
  void dispose() {
    profileBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.green,
        onRefresh: () {
          return profileBloc.getProfileInfo();
        },
        child: StreamBuilder<ApiResponse<ProfileResponse>>(
          stream: profileBloc.profileStream,
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
      ),
    );
  }

  void _errorWidgetFunction() {
    if (profileBloc != null) profileBloc.getProfileInfo();
  }

  _buildUserWidget(ProfileResponse response) {
    return CustomScrollView(slivers: <Widget>[
      SliverPadding(
        padding: EdgeInsets.all(0.0),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildInfoSection(response.baseUrl, response.userDetails),
                SizedBox(
                  height: 25,
                ),
                _buildOptionsSection(response.userDetails.id,response.baseUrl),
                SizedBox(
                  height: 75,
                ),
              ],
            ),
          ]),
        ),
      )
    ]);
  }

  _buildInfoSection(String baseUrl, UserDetails userDetails) {
    print("Points---${userDetails.points}");
    return Container(
      alignment: FractionalOffset.center,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
      decoration: BoxDecoration(
          color: Color(colorCodeGreyPageBg),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25)),
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
          _buildImageSection(baseUrl, userDetails),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            alignment: FractionalOffset.center,
            child: Text(
              "${userDetails.name}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Color(colorCodeWhite),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            alignment: FractionalOffset.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Total ",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0),
                ), Image(
                  image: AssetImage('assets/images/ic_coin.png'),
                  height: 20,
                  width: 20,
                ),
                Text(
                  " ${userDetails.points}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 15, 20, 5),
            width: double.infinity,
            height: 0.5,
            color: Colors.white38,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            alignment: FractionalOffset.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 26,
                  icon: Icon(
                    Icons.mail_outline,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Text(
                    "${userDetails.email}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Color(colorCodeWhite),
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0),
                  ),
                  flex: 1,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            alignment: FractionalOffset.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 26,
                  icon: Icon(
                    Icons.phone_in_talk,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Text(
                    "${userDetails.countryCode}-${userDetails.phoneNumber}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Color(colorCodeWhite),
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0),
                  ),
                  flex: 1,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            alignment: FractionalOffset.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 26,
                  icon: Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Text(
                    "Dob: ${CommonMethods().changeDateFormat(
                        userDetails.dateOfBirth)}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Color(colorCodeWhite),
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0),
                  ),
                  flex: 1,
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
              ),
              primary: Colors.transparent,
              elevation: 0.0,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              side: BorderSide(
                width: 2.0,
                color: Colors.transparent,
              ),
            ),
            onPressed: () async {
              final isProfileUpdated = await Get.to(() => EditProfileScreen());
              print("*****");
              print("$isProfileUpdated");
              if (isProfileUpdated && profileBloc != null) {
                profileBloc.getProfileInfo();
              }
            },
            child: Text(
              "Edit",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(colorCoderRedBg),
                  fontSize: 15,
                  fontFamily: 'roboto',
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  _buildImageSection(String baseUrl, UserDetails userDetails) {
    userids = userDetails.id;
    url = userDetails.baseUrl;
    return Container(
      alignment: FractionalOffset.center,
      width: double.infinity,
      height: 160,
      color: Colors.transparent,
      child: Container(
        width: 140,
        height: 140,
        decoration: new BoxDecoration(
          color: Colors.black26,
          borderRadius: new BorderRadius.all(new Radius.circular(70.0)),
          border: new Border.all(
            color: Color(colorCoderRedBg),
            width: 6.0,
          ),
        ),
        child: ClipOval(
          child: SizedBox.expand(
            child: CachedNetworkImage(
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
              imageUrl: getImage(baseUrl, userDetails),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  TextDrawableWidget(
                    "${userDetails.name}",
                    ColorGenerator.materialColors,
                        (bool selected) {
                      // on tap callback
                      print("on tap callback");
                    },
                    false,
                    130.0,
                    130.0,
                    BoxShape.circle,
                    TextStyle(color: Colors.white, fontSize: 40.0),
                  ),
            ),
          ),
        ),
      ),
    );
  }

  String getImage(String baseUrl, UserDetails userDetails) {
    String img = "";
    if (userDetails != null) {
      if (baseUrl != null) {
        if (baseUrl != "") {
          if (userDetails.imageUrl != null) {
            if (userDetails.imageUrl != "") {
              img = baseUrl + userDetails.imageUrl;
            }
          }
        }
      }
    }
    return img;
  }

  _buildOptionsSection( baseurl,userid ) {
    return Padding(
      padding: const EdgeInsets.only(left:5 ,right: 5),
      child: Wrap(
        direction: Axis.horizontal,
        // alignment: WrapAlignment.center,
        spacing: 20.0,
        runAlignment: WrapAlignment.spaceAround,
        runSpacing: 30.0,
        crossAxisAlignment: WrapCrossAlignment.center,
        // textDirection: TextDirection.rtl,
        // verticalDirection: VerticalDirection.up,
        children: <Widget>[
          ProfileOption(_profileOptionSelected, " My Donations ",
              "assets/images/ic_my_donation.png", ProfileOptionsType.MyDonation),
          ProfileOption(
              _profileOptionSelected,
              "My Fundraisers",
              "assets/images/ic_my_fundraisers.png",
              ProfileOptionsType.MyFundraiser),
          ProfileOption(_profileOptionSelected, " My Comments ",
              "assets/images/ic_my_comment.png", ProfileOptionsType.MyComments),
          ProfileOption(_profileOptionSelected, "  My Loans   ",
              "assets/images/ic_my_loans.png", ProfileOptionsType.MyLoans),
          ProfileOption(_profileOptionSelected, " My Documents ",
              "assets/images/ic_my_documents.png", ProfileOptionsType.MyDocuments),
          ProfileOption(_profileOptionSelected, " My Transactions ",
              "assets/images/paymenthistory.png", ProfileOptionsType.MyPayment),
        ],
      ),
    );
  }

  void _profileOptionSelected(var optionSelected) {
    print("$optionSelected");
    if (optionSelected == ProfileOptionsType.MyDonation) {
      Get.to(() => MyDonationsScreen());
    } else if (optionSelected == ProfileOptionsType.MyFundraiser) {
      Get.to(() => MyFundraisersScreen());
    } else if (optionSelected == ProfileOptionsType.MyComments) {
      Get.to(() => MyCommentsScreen());
    } else if (optionSelected == ProfileOptionsType.MyLoans) {
      Get.to(() => MyLoansScreen());
    }
    else if (optionSelected == ProfileOptionsType.MyDocuments) {
      Get.to(() => MyDocumentsScreen(userid:userids,url:url));
    }
    else if (optionSelected == ProfileOptionsType.MyPayment) {
      Get.to(() => MyTransactionScreen(userid:userids,url:url));
    }
  }
}
