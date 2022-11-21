import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ngo_app/Blocs/TeamBloc.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:ngo_app/Elements/PainationLoader.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Models/TeamResponse.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';

class OurInfoScreen extends StatefulWidget {
  @override
  _OurInfoScreenState createState() => _OurInfoScreenState();
}

class _OurInfoScreenState extends State<OurInfoScreen> with LoadMoreListener {
  ScrollController _itemsScrollController;
  bool isLoadingMore = false;
  TeamBloc _teamBloc;

  @override
  void initState() {
    super.initState();
    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);
    _teamBloc = new TeamBloc(this);
    _teamBloc.getTeam(false);
  }

  void _scrollListener() {
    if (_itemsScrollController.offset >=
            _itemsScrollController.position.maxScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the bottom");
      if (_teamBloc.hasNextPage) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          _teamBloc.getTeam(true);
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
    _teamBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: Colors.green,
      onRefresh: () {
        return _teamBloc.getTeam(false);
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
              Expanded(
                child: StreamBuilder<ApiResponse<TeamResponse>>(
                    stream: _teamBloc.teamStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data.status) {
                          case Status.LOADING:
                            return CommonApiLoader();
                            break;
                          case Status.COMPLETED:
                            TeamResponse response = snapshot.data.data;
                            return _buildUserWidget(
                                response.baseUrl, _teamBloc.teamList);
                            break;
                          case Status.ERROR:
                            return CommonApiErrorWidget(
                                snapshot.data.message, _errorWidgetFunction,
                                textColorReceived: Colors.black);
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
    );
  }

  void _errorWidgetFunction() {
    if (_teamBloc != null) _teamBloc.getTeam(false);
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

  Widget _buildUserWidget(String baseUrl, List<TeamItem> teamList) {
    if (teamList != null) {
      if (teamList.length > 0) {
        return GridView.builder(
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 15.0,
              childAspectRatio: 1 / 1.1),
          itemBuilder: (
            BuildContext context,
            int index,
          ) {
            return _buildEachItem(teamList[index], baseUrl);
          },
          itemCount: teamList.length,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
        );
      } else {
        return CommonApiResultsEmptyWidget("Results Empty",
            textColorReceived: Colors.black);
      }
    } else {
      return CommonApiErrorWidget("No results found", _errorWidgetFunction,
          textColorReceived: Colors.black);
    }
  }

  Widget _buildEachItem(TeamItem teamItem, String baseUrl) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(colorCodeGreyPageBg)),
      padding: EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
                child: SizedBox.expand(
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: getImage(baseUrl, teamItem),
                    placeholder: (context, url) => Center(
                      child: RoundedLoader(),
                    ),
                    errorWidget: (context, url, error) => Container(
                      child: Image(
                        image: AssetImage('assets/images/no_image.png'),
                        height: double.infinity,
                        width: double.infinity,
                      ),
                      margin: EdgeInsets.all(5),
                    ),
                  ),
                ),
              ),
            ),
            flex: 1,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
            alignment: FractionalOffset.centerLeft,
            child: Text(
              teamItem.employeeName,
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Color(colorCodeWhite),
                  fontWeight: FontWeight.w600,
                  fontSize: 12.0),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 10),
            alignment: FractionalOffset.centerLeft,
            child: Text(
              teamItem.designation,
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Color(colorCodeWhite),
                  fontWeight: FontWeight.w400,
                  fontSize: 11.0),
            ),
          ),
        ],
      ),
    );
  }

  getImage(String imageBase, TeamItem teamItem) {
    String img = "";
    if (teamItem != null) {
      if (imageBase != null) {
        if (imageBase != "") {
          if (teamItem.imageUrl != null) {
            if (teamItem.imageUrl != "") {
              img = imageBase + teamItem.imageUrl;
            }
          }
        }
      }
    }
    return img;
  }
}
