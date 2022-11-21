import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:ngo_app/Blocs/SearchBloc.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:ngo_app/Models/SearchResponse.dart';
import 'package:ngo_app/Screens/DetailPages/ItemDetailScreen.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

import 'ViewAllScreen.dart';

class AutocompleteSearch extends StatefulWidget {
  @override
  _AutocompleteSearchState createState() => _AutocompleteSearchState();
}

class _AutocompleteSearchState extends State<AutocompleteSearch> {
  bool isApiCallInProgress = false;
  TextEditingController searchController = TextEditingController();
  SearchBloc _searchBloc;
  FocusNode _searchFocus = FocusNode();
  var typedVal = "";

  @override
  void initState() {
    super.initState();
    _searchBloc = new SearchBloc();
    _searchBloc.getSearchItems("");
  }

  @override
  void dispose() {
    searchController.dispose();
    _searchBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0), // here the desired height
            child: Container(
              color: Color(colorCoderRedBg),
              alignment: FractionalOffset.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    child: Image.asset(
                      'assets/images/ic_back.png',
                      width: 35.0,
                      height: 35.0,
                    ),
                    onTap: () {
                      Get.back();
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Container(
                        alignment: FractionalOffset.center,
                        padding: EdgeInsets.fromLTRB(5.0, 5, 10, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                focusNode: _searchFocus,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                maxLength: 25,
                                controller: searchController,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (value) {
                                  _searchFocus.unfocus();
                                  if (searchController.text.isNotEmpty &&
                                      typedVal !=
                                          searchController.text.trim()) {
                                    searchKeyword();
                                  }
                                },
                                onChanged: (value) {
                                  print("****");
                                  if (typedVal != value.trim()) {
                                    if (value.length > 2 || value.length == 0) {
                                      Future.delayed(
                                          const Duration(milliseconds: 1000),
                                          () {
                                        if (_searchBloc != null) {
                                          typedVal = value.trim();
                                          _searchBloc
                                              .getSearchItems(value.trim());
                                        }
                                      });
                                    }
                                  }
                                },
                                textCapitalization: TextCapitalization.words,
                                style: TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  counterText: "",
                                  hintText: "Search here",
                                  hintStyle: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(5.0, 5, 5, 5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 0.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 0.0),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 0.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 0.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 0.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 0.0),
                                  ),
                                ),
                              ),
                              flex: 1,
                            ),
                            GestureDetector(
                              onTap: () {
                                _searchFocus.unfocus();
                                searchKeyword();
                              },
                              child: Image.asset(
                                'assets/images/ic_search.png',
                                height: 16.0,
                                width: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                  SizedBox(
                    width: 15,
                  )
                ],
              ),
            ),
          ),
          body: RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.green,
            onRefresh: () {
              return _searchBloc.getSearchItems(searchController.text.trim());
            },
            child: Container(
              color: Colors.transparent,
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: StreamBuilder<ApiResponse<SearchResponse>>(
                  stream: _searchBloc.searchStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data.status) {
                        case Status.LOADING:
                          return CommonApiLoader();
                          break;
                        case Status.COMPLETED:
                          SearchResponse res = snapshot.data.data;
                          return _buildUserWidget(res.searchList);
                          break;
                        case Status.ERROR:
                          return CommonApiErrorWidget(
                              snapshot.data.message, _errorWidgetFunction);
                          break;
                      }
                    }
                    return Container(
                      child: Center(
                        child: Text(""),
                      ),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  searchKeyword() {
    print("${searchController.text}");
    Future.delayed(const Duration(milliseconds: 800), () {
      if (_searchBloc != null) {
        typedVal = searchController.text.trim();
        _searchBloc.getSearchItems(searchController.text.trim());
      }
    });
  }

  Future<bool> onWillPop() {
    return Future.value(true);
  }

  void _errorWidgetFunction() {
    if (_searchBloc != null) {
      if (searchController.text.isNotEmpty) {
        _searchBloc.getSearchItems(searchController.text.trim());
      }
    }
  }

  _buildUserWidget(List<SearchItem> _searchList) {
    if (_searchList != null) {
      if (_searchList.length > 0) {
        return ListView.separated(
          itemCount: _searchList.length,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemBuilder: (context, index) {
            return _buildEachSearchItem(_searchList[index]);
          },
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(2, 15, 5, 20),
        );
      } else {
        return CommonApiResultsEmptyWidget("Results Empty",
            textColorReceived: Colors.black);
      }
    } else {
      return CommonApiErrorWidget("No results found", _errorWidgetFunction,
          textColorReceived: Colors.white);
    }
  }

  _buildEachSearchItem(SearchItem searchItem) {
    if (searchItem.type == "campaign") {
      return InkWell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 20,
                  icon: Icon(
                    Icons.workspaces_outline,
                    color: Colors.red,
                  ),
                ),
                Expanded(
                  child: Padding(
                    child: Text("${searchItem.title}",
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Color(colorCoderItemTitle),
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600)),
                    padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  ),
                  flex: 1,
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          CommonMethods().clearFilters();
          if (LoginModel().campaignsListSaved != null) {
            for (var data in LoginModel().campaignsListSaved) {
              print("${data.id} - ${searchItem.id}");
              if (data.id == searchItem.id) {
                data.isSelected = true;
                break;
              }
            }
          }
          Get.to(() => ViewAllScreen());
        },
      );
    } else {
      return InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 16,
              icon: Icon(
                Icons.workspaces_outline,
                color: Colors.red,
              ),
            ),
            Expanded(
              child: Padding(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      child: Text("${searchItem.title}",
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color(colorCoderItemTitle),
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600)),
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      child: Text("${searchItem.type}",
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color(colorCoderItemSubTitle),
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500)),
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    ),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
              ),
              flex: 1,
            ),
          ],
        ),
        onTap: () {
          Get.to(() => ItemDetailScreen(searchItem.id));
        },
      );
    }
  }
}
