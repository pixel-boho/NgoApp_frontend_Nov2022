import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Blocs/CommentsBloc.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Elements/CommentItemWidget.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:ngo_app/Elements/PainationLoader.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Models/CommentItem.dart';
import 'package:ngo_app/Models/CommentsListResponse.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';

import 'ReviewItemScreen.dart';

class ViewAllCommentsScreen extends StatefulWidget {
  final fundraiserIdReceived;

  ViewAllCommentsScreen(this.fundraiserIdReceived);

  @override
  _ViewAllCommentsScreenState createState() => _ViewAllCommentsScreenState();
}

class _ViewAllCommentsScreenState extends State<ViewAllCommentsScreen>
    with LoadMoreListener {
  ScrollController _itemsScrollController;
  bool isLoadingMore = false;
  CommentsBloc _commentsBloc;

  @override
  void initState() {
    super.initState();
    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);
    _commentsBloc = new CommentsBloc(this);
    _commentsBloc.getAllComments(false, widget.fundraiserIdReceived);
  }

  void _scrollListener() {
    if (_itemsScrollController.offset >=
            _itemsScrollController.position.maxScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the bottom");
      if (_commentsBloc.hasNextPage) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          _commentsBloc.getAllComments(true, widget.fundraiserIdReceived);
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
              text: "Comments",
              buttonHandler: _backPressFunction,
            ),
          ),
          body: RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.green,
            onRefresh: () {
              return _commentsBloc.getAllComments(
                  false, widget.fundraiserIdReceived);
            },
            child: Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Column(
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
          floatingActionButton: FloatingActionButton.extended(
            label: Text('Comment'),
            icon: Icon(Icons.chat),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            onPressed: () async {
              if (CommonMethods().isAuthTokenExist()) {
                final isReviewAdded = await Get.to(() => ReviewItemScreen(14),
                    opaque: false, fullscreenDialog: true);
                print("*****");
                print("$isReviewAdded");
                if (mounted && isReviewAdded != null) {
                  if (isReviewAdded) {
                    _commentsBloc.getAllComments(
                        false, widget.fundraiserIdReceived);
                  }
                }
              } else {
                CommonWidgets().showCommonDialog(
                    "You need to login before use this feature!!",
                    AssetImage('assets/images/ic_notification_message.png'),
                    CommonMethods().alertLoginOkClickFunction,
                    false,
                    true);
              }
            },
          ),
        ),
      ),
    );
  }

  void _errorWidgetFunction() {
    if (_commentsBloc != null)
      _commentsBloc.getAllComments(false, widget.fundraiserIdReceived);
  }

  _buildUserWidget(String imageBase, List<CommentItem> commentsList) {
    if (commentsList != null) {
      if (commentsList.length > 0) {
        return ListView.separated(
          scrollDirection: Axis.vertical,
          itemCount: commentsList.length,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemBuilder: (context, index) {
            return Container(
              alignment: FractionalOffset.center,
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: CommentItemWidget(imageBase, commentsList[index]),
            );
          },
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _itemsScrollController,
          padding: EdgeInsets.fromLTRB(15, 15, 15, 65),
        );
      } else {
        return CommonApiResultsEmptyWidget("Results Empty");
      }
    } else {
      return CommonApiErrorWidget("No results found", _errorWidgetFunction);
    }
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
}
