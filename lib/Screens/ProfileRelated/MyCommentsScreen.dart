import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Blocs/CommentsBloc.dart';
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
import 'package:ngo_app/Models/CommentItem.dart';
import 'package:ngo_app/Models/CommentsListResponse.dart';
import 'package:ngo_app/Screens/Dashboard/ViewAllScreen.dart';
import 'package:ngo_app/Screens/DetailPages/ItemDetailScreen.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

class MyCommentsScreen extends StatefulWidget {
  @override
  _MyCommentsScreenState createState() => _MyCommentsScreenState();
}

class _MyCommentsScreenState extends State<MyCommentsScreen>
    with LoadMoreListener, RefreshPageListener {
  ScrollController _itemsScrollController;
  bool isLoadingMore = false;
  CommentsBloc _commentsBloc;

  @override
  void initState() {
    LoginModel().relatedItemsList.clear();
    super.initState();
    CommonMethods().setRefreshFilterPageListener(this);
    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);
    _commentsBloc = new CommentsBloc(this);
    _commentsBloc.getAllComments(false, null);
  }

  void _scrollListener() {
    if (_itemsScrollController.offset >=
            _itemsScrollController.position.maxScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the bottom");
      if (_commentsBloc.hasNextPage) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          _commentsBloc.getAllComments(true, null);
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
    _commentsBloc.dispose();
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
              text: "My Comments",
              buttonHandler: _backPressFunction,
            ),
          ),
          body: RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.green,
            onRefresh: () {
              return _commentsBloc.getAllComments(false, null);
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
                      child: StreamBuilder<ApiResponse<CommentsListResponse>>(
                          stream: _commentsBloc.commentsStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              switch (snapshot.data.status) {
                                case Status.LOADING:
                                  return CommonApiLoader();
                                  break;
                                case Status.COMPLETED:
                                  CommentsListResponse res = snapshot.data.data;
                                  return _buildUserWidget(
                                      res.baseUrl, _commentsBloc.commentsList);
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

  _buildMyCommentsList(String imageBase, List<CommentItem> commentsList) {
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
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        itemCount: commentsList.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (context, index) {
          return _buildCommentItem(imageBase, commentsList[index]);
        },
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
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
          if (_commentsBloc != null) {
            _commentsBloc.getAllComments(false, null);
          }
        }
      }
    }
  }

  _buildCommentItem(String imageBase, CommentItem commentItem) {
    return Container(
      alignment: FractionalOffset.center,
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
                  child: Container(
                    width: 70,
                    height: 60,
                    child: CachedNetworkImage(
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: getImage(imageBase, commentItem.imageUrl),
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
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                  alignment: FractionalOffset.centerLeft,
                  child: Text(
                    "${commentItem.name}",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Color(colorCoderItemTitle),
                        fontWeight: FontWeight.w600,
                        fontSize: 13.0),
                  ),
                ),
                flex: 1,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
            alignment: FractionalOffset.centerLeft,
            child: Text(
              CommonMethods().readTimestamp(commentItem.createdAt ?? ""),
              style: TextStyle(
                  color: Color(colorCoderItemSubTitle),
                  fontWeight: FontWeight.w400,
                  fontSize: 13.0),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            alignment: FractionalOffset.centerLeft,
            child: Text(
              "${commentItem.comment}",
              style: TextStyle(
                  fontWeight: FontWeight.w400, fontSize: 13.0, height: 1.8),
            ),
          ),
        ],
      ),
    );
  }

  void _errorWidgetFunction() {
    if (_commentsBloc != null) _commentsBloc.getAllComments(false, null);
  }

  _buildUserWidget(String imageBase, List<CommentItem> commentsList) {
    if (commentsList != null) {
      if (commentsList.length > 0) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildMyCommentsList(imageBase, commentsList),
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
        return CommonApiResultsEmptyWidget("Results Empty");
      }
    } else {
      return CommonApiErrorWidget("No results found", _errorWidgetFunction);
    }
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
}
