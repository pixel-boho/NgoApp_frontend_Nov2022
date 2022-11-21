import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:ngo_app/Blocs/MediaBloc.dart';
import 'package:ngo_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:ngo_app/Elements/PainationLoader.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Models/MediaResponse.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';
import 'package:url_launcher/url_launcher.dart';

class MediaScreen extends StatefulWidget {
  @override
  _MediaScreenState createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> with LoadMoreListener {
  bool isLoadingMore = false;
  ScrollController _itemsScrollController;
  MediaBloc _mediaBloc;

  @override
  void initState() {
    super.initState();
    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);
    _mediaBloc = new MediaBloc(this);
    _mediaBloc.getMediaItems(false);
  }

  void _scrollListener() {
    if (_itemsScrollController.offset >=
            _itemsScrollController.position.maxScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the bottom");
      if (_mediaBloc.hasNextPage) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          _mediaBloc.getMediaItems(true);
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
    _mediaBloc.dispose();
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
              text: "Media",
              buttonHandler: _backPressFunction,
            ),
          ),
          body: RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.green,
            onRefresh: () {
              return _mediaBloc.getMediaItems(false);
            },
            child: Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: StreamBuilder<ApiResponse<MediaResponse>>(
                          stream: _mediaBloc.mediaStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              switch (snapshot.data.status) {
                                case Status.LOADING:
                                  return CommonApiLoader();
                                  break;
                                case Status.COMPLETED:
                                  MediaResponse res = snapshot.data.data;
                                  return _buildUserWidget(
                                      res.baseUrl, _mediaBloc.mediaList);
                                  break;
                                case Status.ERROR:
                                  return CommonApiErrorWidget(
                                      snapshot.data.message,
                                      _errorWidgetFunction,
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
          ),
        ),
      ),
    );
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

  void _backPressFunction() {
    print("_sendOtpFunction clicked");
    Get.back();
  }

  Future<bool> onWillPop() {
    return Future.value(true);
  }

  _buildUserWidget(String baseUrl, List<MediaItem> mediaList) {
    return ListView.builder(
      itemCount: mediaList.length,
      itemBuilder: (context, index) {
        return _buildMediaItem(mediaList[index], baseUrl);
      },
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
    );
  }

  void _errorWidgetFunction() {
    if (_mediaBloc != null) _mediaBloc.getMediaItems(false);
  }

  _buildMediaItem(MediaItem mediaItem, String imageBase) {
    return Card(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ExpansionTile(
        title: Text(
          "${mediaItem.heading}",
          style: TextStyle(
              fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
                    child: Container(
                      width: 45,
                      height: 50,
                      alignment: FractionalOffset.center,
                      child: CachedNetworkImage(
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: getImage(mediaItem, imageBase),
                        placeholder: (context, url) => Center(
                          child: RoundedLoader(),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.black12,
                          alignment: FractionalOffset.center,
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
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                    alignment: FractionalOffset.centerLeft,
                    child: Text(
                      "${mediaItem.title}",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13.0,
                          height: 1.8,
                          color: Colors.black),
                    ),
                  ),
                  flex: 1,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            alignment: FractionalOffset.centerLeft,
            child: Text(
              "${mediaItem.description}",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13.0,
                  height: 1.8,
                  color: Colors.black),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            alignment: FractionalOffset.centerLeft,
            child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(children: [
                  TextSpan(
                    text: "Read more: ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                      text: "Click Here",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          var url = "${mediaItem.link}";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }),
                ])),
          ),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }

  getImage(MediaItem mediaItem, String imageBase) {
    String img = "";
    if (mediaItem != null) {
      if (imageBase != null) {
        if (imageBase != "") {
          if (mediaItem.imageUrl != null) {
            if (mediaItem.imageUrl != "") {
              img = imageBase + mediaItem.imageUrl;
            }
          }
        }
      }
    }
    return img;
  }
}
