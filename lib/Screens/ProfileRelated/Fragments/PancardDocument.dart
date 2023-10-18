import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Blocs/panbloc.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:ngo_app/CustomLibraries/ImagePickerAndCropper/image_picker_handler.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Elements/PainationLoader.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Interfaces/RefreshPageListener.dart';
import 'package:ngo_app/Models/PancardUploadResponse.dart';
import 'package:ngo_app/Models/UserPancardResponse.dart';
import 'package:ngo_app/Screens/Dashboard/Home.dart';
import 'package:ngo_app/Screens/ProfileRelated/photoview.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

class PanCardScreen extends StatefulWidget {
  PanCardScreen({Key key,this.userid, this.url}) : super(key: key);
  final userid;
  final url;

  @override
  State<PanCardScreen> createState() => _PanCardScreenState();
}

class _PanCardScreenState extends State<PanCardScreen>  with
    LoadMoreListener,
    RefreshPageListener,
    TickerProviderStateMixin,
    ImagePickerListener {

  bool isLoadingMore = false;
  TextEditingController _documentName = new TextEditingController();
  PanBloc _panbloc;
  String _imageUrl = "";
  ImagePickerHandler imagePicker;
  AnimationController _controller;
  var subscriptionId;

  @override
  File _image;

  void initState() {
    super.initState();
    _panbloc = PanBloc();
    _panbloc.getUserRecords(widget.userid.toString());
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
    // initFields();
  }

  @override
  void dispose() {
    _controller.dispose();
    _documentName.dispose();
    super.dispose();
  }

  @override
  String Response = "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: Container(
              color: Colors.transparent,
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _buildMessageSection(),
                    SizedBox(
                      height: 20,
                    ),
                    _uploadDocumentWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Your Pan Card",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    StreamBuilder<ApiResponse<dynamic>>(
                        stream: _panbloc.userRecordStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            switch (snapshot.data.status) {
                              case Status.LOADING:
                                return SizedBox(
                                  height: 100,
                                  child: CommonApiLoader(),
                                );
                              case Status.COMPLETED:
                                UserPancardResponse resp = snapshot.data.data;
                                return ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                    resp.userDetails.status.bitLength,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return _buildUserRecords(resp);
                                    });
                              case Status.ERROR:
                                return Container(
                                  color: Colors.red,
                                );
                            }
                          }
                          return SizedBox(
                            height: 100,
                            child: CommonApiLoader(),
                          );
                        }),
                    Visibility(
                      child: PaginationLoader(),
                      visible: isLoadingMore ? true : false,
                    ),
                  ],
                ),
              )),
          floatingActionButton: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: CommonWidgets().showHelpDesk(),
          ),
        ),
      ),
    );
  }

  Widget _buildUserRecords(UserPancardResponse userdetails) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Card(
          color: Colors.grey[200],
          margin: EdgeInsets.only(top: 10),
          child: InkWell(
            onTap: () {
              Get.to(() => PhotoViewer(
                image: userdetails.baseurl +
                    userdetails.userDetails.pancard_image,
                networkImage: true,
              ));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                fit: BoxFit.fitWidth,
                imageUrl:
                userdetails.baseurl + userdetails.userDetails.pancard_image,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Container(
                    margin: EdgeInsets.all(5),
                    child: Image(
                      image: AssetImage('assets/images/no_data.png'),
                    )),
              ),
            ),
          ),
        ),
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
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            alignment: FractionalOffset.center,
            child: Text(
              "Want to be the cool kind on the block?",
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.0),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            alignment: FractionalOffset.center,
            child: Text(
              "Check out our latest fundraisers",
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 11.0),
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
              Get.offAll(() => DashboardScreen(
                fragmentToShow: 1,
              ));
            },
            child: Text(
              "Browse fundraisers",
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

  @override
  userImage(File _image) {
    if (_image != null) {
      setState(() {
        this._image = _image;
      });
    } else {
      Fluttertoast.showToast(msg: "Unable to set image");
    }
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

  Widget _uploadDocumentWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            "Upload Your Pan Card",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        _buildImageSection(),
        SizedBox(
          height: 10,
        ),
        Center(
          child: Container(
            height: 50.0,
            width: 300,
            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: CommonButton(
              bgColorReceived: Color(colorCoderRedBg),
              borderColorReceived: Color(colorCoderRedBg),
              textColorReceived: Color(colorCodeWhite),
              buttonHandler: () async {
                print("image->${_image}");
                if (_image != null) {
                  return _updateDocument(
                    _image,
                  );
                }
                return Fluttertoast.showToast(msg: "Select Document Image");
              },
              buttonText: "Upload",
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Future _updateDocument(File reportFile) async {
    try {
      PancardResponse response = await _panbloc.uploadUserRecords(reportFile);
      Get.back();
      Response = response.baseUrl;
      if (response.success) {
        Fluttertoast.showToast(msg: response.message);
        await _panbloc.uploadUserRecords(reportFile);
      } else {
        Fluttertoast.showToast(msg: response.message);
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      Fluttertoast.showToast(msg: "Something went wrong. Please try again");
    }
  }

  _buildImageSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
      alignment: FractionalOffset.center,
      width: double.infinity,
      height: 200,
      color: Colors.transparent,
      child: Container(
        height: 180.0,
        width: double.infinity,
        child: Stack(children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: new BoxDecoration(
              color: Colors.black12,
              // color: Colors.transparent,
              border: Border.all(
                color: Color(colorCoderBorderWhite),
              ),
              borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
              child: SizedBox.expand(
                child: showImage(),
              ),
            ),
          ),
          Positioned(
            right: 0.0,
            bottom: 0.0,
            child: Container(
              child: InkWell(
                child: Image.asset(
                  ('assets/images/ic_camera.png'),
                  height: 45,
                  width: 45,
                ),
                onTap: () {
                  imagePicker.showDialog(context);
                },
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget showImage() {
    if (LoginModel().isFundraiserEditMode) {
      return Center(
        child: _image == null
            ? Container(
          color: Colors.black12,
          child: CachedNetworkImage(
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            imageUrl: _imageUrl,
            placeholder: (context, url) => Center(
              child: RoundedLoader(),
            ),
            errorWidget: (context, url, error) => Container(
              child: Image.asset(
                ('assets/images/no_image.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          padding: EdgeInsets.all(0),
        )
            : Container(
          height: 180.0,
          width: double.infinity,
          child: Image.file(_image, fit: BoxFit.fill, errorBuilder:
              (BuildContext context, Object exception,
              StackTrace stackTrace) {
            return Container(
              child: Image.asset(
                ('assets/images/no_image.png'),
                fit: BoxFit.fill,
              ),
            );
          }),
          decoration: BoxDecoration(
            color: Colors.cyan[100],
            borderRadius:
            new BorderRadius.all(const Radius.circular(80.0)),
            image: new DecorationImage(
                image: new AssetImage('assets/images/no_image.png'),
                fit: BoxFit.cover),
          ),
        ),
      );
    } else {
      return Center(
        child: _image == null
            ? Container(
          color: Colors.black12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Image(
                  image: AssetImage('assets/images/no_image.png'),
                  height: double.infinity,
                  width: double.infinity,
                ),
                flex: 1,
              ),
            ],
          ),
          padding: EdgeInsets.all(5),
        )
            : Container(
          height: 190.0,
          width: double.infinity,
          child: Image.file(_image, fit: BoxFit.fill, errorBuilder:
              (BuildContext context, Object exception,
              StackTrace stackTrace) {
            return Container(
              child: Image.asset(
                ('assets/images/no_image.png'),
                fit: BoxFit.fill,
              ),
            );
          }),
          decoration: BoxDecoration(
            color: Colors.cyan[100],
            borderRadius:
            new BorderRadius.all(const Radius.circular(80.0)),
            image: new DecorationImage(
                image: new AssetImage('assets/images/no_image.png'),
                fit: BoxFit.cover),
          ),
        ),
      );
    }
  }

}
