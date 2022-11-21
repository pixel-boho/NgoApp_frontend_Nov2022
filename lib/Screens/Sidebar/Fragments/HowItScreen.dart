import 'package:flutter/material.dart';
import 'package:ngo_app/Blocs/FaqBloc.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Models/FaqResponse.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';
import 'package:ngo_app/Elements/PainationLoader.dart';

class HowItScreen extends StatefulWidget {
  @override
  _HowItScreenState createState() => _HowItScreenState();
}

class _HowItScreenState extends State<HowItScreen> with LoadMoreListener {
  bool isLoadingMore = false;
  ScrollController _itemsScrollController;
  FaqBloc _faqBloc;

  @override
  void initState() {
    super.initState();
    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);
    _faqBloc = new FaqBloc(this);
    _faqBloc.getFaqs(false);
  }

  void _scrollListener() {
    if (_itemsScrollController.offset >=
        _itemsScrollController.position.maxScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the bottom");
      if (_faqBloc.hasNextPage) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          _faqBloc.getFaqs(true);
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
    _faqBloc.dispose();
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
          body: RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.green,
            onRefresh: () {
              return _faqBloc.getFaqs(false);
            },
            child: Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: StreamBuilder<ApiResponse<FaqResponse>>(
                          stream: _faqBloc.faqStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              switch (snapshot.data.status) {
                                case Status.LOADING:
                                  return CommonApiLoader();
                                  break;
                                case Status.COMPLETED:
                                  return _buildUserWidget(_faqBloc.faqList);
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


  Future<bool> onWillPop() {
    return Future.value(true);
  }

  _buildUserWidget(List<FaqItem> faqList) {
    return ListView.builder(
      itemCount: faqList.length,
      itemBuilder: (context, index) {
        return _buildFaqItem(faqList[index]);
      },
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
    );
  }

  void _errorWidgetFunction() {
    if (_faqBloc != null) _faqBloc.getFaqs(false);
  }

  _buildFaqItem(FaqItem faqItem) {
    return Card(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ExpansionTile(
        title: Text(
          "${faqItem.question}",
          style: TextStyle(
              fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
            alignment: FractionalOffset.centerLeft,
            child: Text(
              "${faqItem.answer}",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13.0,
                  height: 1.8,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
