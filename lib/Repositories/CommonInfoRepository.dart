import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:ngo_app/Models/BankInfo.dart';
import 'package:ngo_app/Models/CampaignTypesResponse.dart';
import 'package:ngo_app/Models/CommentsListResponse.dart';
import 'package:ngo_app/Models/CommonResponse.dart';
import 'package:ngo_app/Models/CommonViewAllResponse.dart';
import 'package:ngo_app/Models/FaqResponse.dart';
import 'package:ngo_app/Models/HomeResponse.dart';
import 'package:ngo_app/Models/ItemDetailResponse.dart';
import 'package:ngo_app/Models/MediaResponse.dart';
import 'package:ngo_app/Models/MyDonationsResponse.dart';
import 'package:ngo_app/Models/ParticipantsListResponse.dart';
import 'package:ngo_app/Models/PointsResponse.dart';
import 'package:ngo_app/Models/PricingStrategiesResponse.dart';
import 'package:ngo_app/Models/RelationsResponse.dart';
import 'package:ngo_app/Models/SearchResponse.dart';
import 'package:ngo_app/Models/TeamResponse.dart';
import 'package:ngo_app/Notification/withdraw.dart';
import 'package:ngo_app/ServiceManager/ApiProvider.dart';
import 'package:ngo_app/ServiceManager/RemoteConfig.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

String contentTitle = "";

class CommonInfoRepository {
  ApiProvider apiProvider;

  CommonInfoRepository() {
    apiProvider = new ApiProvider();
  }

  Future<HomeResponse> getHomeItems() async {
    final response =
        await apiProvider.getInstance().get(RemoteConfig.getHomeItems);
    return HomeResponse.fromJson(response.data);
  }

  Future<CampaignTypesResponse> getCampaignTypes(
      int pageNumber, int perPage) async {
    final response = await apiProvider.getInstance().get(
        RemoteConfig.getCategories +
            "?page=" +
            "${pageNumber + 1}" +
            "&per_page=" +
            "$perPage");
    return CampaignTypesResponse.fromJson(response.data);
  }

  Future<CommonViewAllResponse> getAllFundraiserItems(
      int pageNumber, int perPage, int category, String sortOption) async {
    final response = await apiProvider.getInstance().get(
        RemoteConfig.getAllFundraiserItems +
            "?page=" +
            "${pageNumber + 1}" +
            "&per_page=" +
            "$perPage" +
            "${category != null ? "&category_id=" + "$category" : ""}" +
            "${sortOption != null ? "&amount=" + "$sortOption" : ""}");
    return CommonViewAllResponse.fromJson(response.data);
  }

  Future<CommonViewAllResponse> getAllCampaignRelatedItems(
      int pageNumber, int perPage, int category, String sortOption) async {
    final response = await apiProvider
        .getInstance()
        .get(RemoteConfig.getAllCampaignRelatedItems +
            "?page=" +
            "${pageNumber + 1}"
                "&per_page=" +
            "$perPage" +
            "${category != null ? "&category_id=" + "$category" : ""}" +
            "${sortOption != null ? "&amount=" + "$sortOption" : ""}");
    return CommonViewAllResponse.fromJson(response.data);
  }

  Future<SearchResponse> getSearchResults(String keyword) async {
    final response = await apiProvider
        .getInstance()
        .get(RemoteConfig.getSearchResults + "?keyword=" + "$keyword");
    return SearchResponse.fromJson(response.data);
  }

  Future<CommonResponse> postContactUs(String body) async {
    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.postContactUs, data: body);
    return CommonResponse.fromJson(response.data);
  }

  Future<CommonResponse> addPartner(String body) async {
    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.addPartner, data: body);
    return CommonResponse.fromJson(response.data);
  }

  Future<CommonResponse> createVolunteer(String body) async {
    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.createVolunteer, data: body);
    return CommonResponse.fromJson(response.data);
  }

  Future<CommonResponse> createLend(FormData body) async {
    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.createLend, data: body);
    return CommonResponse.fromJson(response.data);
  }

  Future<ItemDetailResponse> getFundraiserDetail(int fundraiserId) async {
    final response = await apiProvider.getInstance().get(
        RemoteConfig.getFundraiserDetail + "?fundraiser_id=" + "$fundraiserId");
    contentTitle = response.data["fundraiserDetails"]["content_title"];
    return ItemDetailResponse.fromJson(response.data);
  }

  Future<CommentsListResponse> getAllComments(
      int pageNumber, int perPage, int fundraiserId) async {
    final response = await apiProvider.getInstance().get(
        RemoteConfig.getAllComments +
            "?fundraiser_id=" +
            "$fundraiserId" +
            "&page=" +
            "${pageNumber + 1}" +
            "&per_page=" +
            "$perPage");
    return CommentsListResponse.fromJson(response.data);
  }

  Future<ParticipantsListResponse> getAllDonors(
      int pageNumber, int perPage, int fundraiserId) async {
    final response = await apiProvider.getInstance().get(
        RemoteConfig.getAllDonors +
            "?fundraiser_id=" +
            "$fundraiserId" +
            "&page=" +
            "${pageNumber + 1}" +
            "&per_page=" +
            "$perPage");
    return ParticipantsListResponse.fromJson(response.data);
  }

  Future<ParticipantsListResponse> getAllSupporters(
      int pageNumber, int perPage, int fundraiserId) async {
    final response = await apiProvider.getInstance().get(
        RemoteConfig.getAllSupporters +
            "?fundraiser_id=" +
            "$fundraiserId" +
            "&page=" +
            "${pageNumber + 1}" +
            "&per_page=" +
            "$perPage");
    return ParticipantsListResponse.fromJson(response.data);
  }

  Future<CommonResponse> addComment(String body) async {
    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.addComment, data: body);
    return CommonResponse.fromJson(response.data);
  }

  Future<CommentsListResponse> getMyComments(
      int pageNumber, int perPage) async {
    final response = await apiProvider.getInstance().get(
        RemoteConfig.getMyComments +
            "?page=" +
            "${pageNumber + 1}" +
            "&per_page=" +
            "$perPage");
    return CommentsListResponse.fromJson(response.data);
  }

  Future<CommonViewAllResponse> getMyOwnFundraiserItems(
      int pageNumber, int perPage) async {
    final response = await apiProvider.getInstance().get(
        RemoteConfig.getMyFundraisers +
            "?page=" +
            "${pageNumber + 1}" +
            "&per_page=" +
            "$perPage");
    return CommonViewAllResponse.fromJson(response.data);
  }

  Future<MyDonationsResponse> getMyDonations(
      int pageNumber, int perPage) async {
    final response = await apiProvider.getInstance().get(
        RemoteConfig.getMyDonations +
            "?page=" +
            "${pageNumber + 1}" +
            "&per_page=" +
            "$perPage");
    return MyDonationsResponse.fromJson(response.data);
  }

  Future<CommonResponse> uploadDocument(FormData formData) async {
    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.uploadDocument, data: formData);
    return CommonResponse.fromJson(response.data);
  }

  Future<CommonResponse> removeDocument(String body) async {
    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.removeDocument, data: body);
    return CommonResponse.fromJson(response.data);
  }

  Future<RelationsResponse> getRelations() async {
    final response =
        await apiProvider.getInstance().get(RemoteConfig.getRelations);
    return RelationsResponse.fromJson(response.data);
  }

  Future<CommonResponse> createFundraiser(FormData formData) async {
    final response = await apiProvider
        .getMultipartInstance()
        .post(RemoteConfig.createFundraiser, data: formData);
    return CommonResponse.fromJson(response.data);
  }

  Future<PricingStrategiesResponse> getPricingInfo() async {
    final response =
        await apiProvider.getInstance().post(RemoteConfig.getPricingStrategies);
    return PricingStrategiesResponse.fromJson(response.data);
  }

  Future<CommonResponse> withdrawFundraiser(String body) async {
    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.withdrawFundraiser, data: body);
    return CommonResponse.fromJson(response.data);
  }

  Future<CommonResponse> updateFundraiser(FormData formData) async {
    final response = await apiProvider
        .getMultipartInstance()
        .post(RemoteConfig.updateFundraiser, data: formData);
    return CommonResponse.fromJson(response.data);
  }

  Future<FaqResponse> getFaqs(int pageNumber, int perPage) async {
    final response = await apiProvider.getInstance().get(
        RemoteConfig.getFaqItems +
            "?page=" +
            "${pageNumber + 1}" +
            "&per_page=" +
            "$perPage");
    return FaqResponse.fromJson(response.data);
  }

  Future<MediaResponse> getMediaItems(int pageNumber, int perPage) async {
    final response = await apiProvider.getInstance().get(
        RemoteConfig.getMediaItems +
            "?page=" +
            "${pageNumber + 1}" +
            "&per_page=" +
            "$perPage");
    return MediaResponse.fromJson(response.data);
  }

  Future<TeamResponse> getOurTeam(int pageNumber, int perPage) async {
    final response = await apiProvider.getInstance().get(
        RemoteConfig.getOurTeam +
            "?page=" +
            "${pageNumber + 1}" +
            "&per_page=" +
            "$perPage");
    return TeamResponse.fromJson(response.data);
  }

  Future<CommonResponse> updateLend(FormData body) async {
    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.updateLend, data: body);
    return CommonResponse.fromJson(response.data);
  }

  Future<BankInfo> getBankDetails(String ifsc) async {
    final response = await apiProvider
        .getInstanceForExternalApi()
        .get("https://ifsc.razorpay.com/$ifsc");
    Map<String, dynamic> map = jsonDecode(response?.toString());
    return map != null ? BankInfo.fromJson(map) : null;
  }

  Future<PointsResponse> getPointsInfo() async {
    final response =
        await apiProvider.getInstance().post(RemoteConfig.getPointsInfo);
    return PointsResponse.fromJson(response.data);
  }

  Future<CommonResponse> transfer(String body, String acccountName,
      accountNum, accountIfsc, int fundid, int amount, context) async {
    final response =
        await apiProvider.getInstance().post(RemoteConfig.transferFisrt,
            data: ({
              "id": fundid.toString(),
              "amount":amount.toString()
            }));
    double transferred_amount = response.data['transfer_data']['transferred_amount'];
    String TransferAmount=transferred_amount.toStringAsFixed(2).toString();
    if (response.statusCode==200){
      final transferamount= await apiProvider
          .getInstance()
          .post(RemoteConfig.transferAmount, data: body);
      if (transferamount.data["entity"] == "contact") {
        final responseforfundaccount = await apiProvider.getInstance().post(
            "https://crowdworksindia.org/test/api/web/v1/razorpay/fund-account",
            data: ({
              "contact_id": transferamount.data["id"],
              "name": acccountName,
              "ifsc": accountIfsc,
              "account_number": accountNum
            }));
        String Contactid = responseforfundaccount.data["id"];
        if (response.statusCode == 200) {
          final responseforpayout = await apiProvider.getInstance().post(
              "https://crowdworksindia.org/test/api/web/v1/razorpay/pay-out",
              data: ({
                "amount": TransferAmount,
                "fund_account_id": Contactid,
                "account_no": accountNum
              }));
          if (responseforpayout.data["notes"]["notes_key_1"] ==
              "Amount Transffered Successfully.") {
            String message = responseforpayout.data["notes"]["notes_key_1"];
            print("Suceess");
            Withdraw(fundid, context, message);
          }
          return CommonResponse.fromJson(responseforpayout.data);
        }
        return CommonResponse.fromJson(responseforfundaccount.data);
      }
      return CommonResponse.fromJson(transferamount.data);

    }
    return CommonResponse.fromJson(response.data);
  }

  // Future<CommonResponse> transferAmounts(String body, String acccountName,
  //     accountNum, accountIfsc, int fundid, int amount, context) async {
  //   final response = await apiProvider
  //       .getInstance()
  //       .post(RemoteConfig.transferAmount, data: body);
  //   if (response.data["entity"] == "contact") {
  //     final responseforfundaccount = await apiProvider.getInstance().post(
  //         "https://crowdworksindia.org/test/api/web/v1/razorpay/fund-account",
  //         data: ({
  //           "contact_id": response.data["id"],
  //           "name": acccountName,
  //           "ifsc": accountIfsc,
  //           "account_number": accountNum
  //         }));
  //     String Contactid = responseforfundaccount.data["id"];
  //     print("response->${responseforfundaccount.data["id"]}");
  //     if (response.statusCode == 200) {
  //       final responseforpayout = await apiProvider.getInstance().post(
  //           "https://crowdworksindia.org/test/api/web/v1/razorpay/pay-out",
  //           data: ({
  //             "amount": amount,
  //             "fund_account_id": Contactid,
  //             "account_no": accountNum
  //           }));
  //       if (responseforpayout.data["notes"]["notes_key_1"] ==
  //           "Amount Transffered Successfully.") {
  //         String message = responseforpayout.data["notes"]["notes_key_1"];
  //         print("Suceess");
  //         Withdraw(fundid, context, message);
  //       }
  //
  //       //   final responseforwithdraw= await apiProvider.getInstance()
  //       //       .post("https://www.cocoalabs.in/ngo/api/web/v1/fundraiser-scheme/withdraw",
  //       //       data:({
  //       //         "token":LoginModel().authToken,
  //       //         "fundraiser_id":fundid,
  //       //       }) );
  //
  //       //   return responseforwithdraw.data;
  //       //
  //       // }
  //       // else {
  //       //   Fluttertoast.showToast(msg:"Something Wrong");
  //       // }
  //       return CommonResponse.fromJson(responseforpayout.data);
  //     }
  //     return CommonResponse.fromJson(responseforfundaccount.data);
  //   }
  //   return CommonResponse.fromJson(response.data);
  // }

  Future<CommonResponse> removeSubscription(String body) async {
    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.removeSubscription, data: body);
    return CommonResponse.fromJson(response.data);
  }

  Future<CommonResponse> postReportIssue(String body) async {
    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.reportIssue, data: body);
    return CommonResponse.fromJson(response.data);
  }

  Future<CommonResponse> cancelFundraiser(String body) async {
    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.cancelFundraiser, data: body);
    return CommonResponse.fromJson(response.data);
  }

  Future<CommonResponse> Withdraw(int id, context, String message) async {
    final response = await apiProvider.getInstance().post(
        "https://crowdworksindia.org/NGO/api/web/v1/fundraiser-scheme/withdraw",
        data: ({
          "token": LoginModel().authToken,
          "fundraiser_id": id,
        }));
    print("Response-->${response}");
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Amount Transferred Successfully");
      Get.to(() => WithdrawScreen(message: message, fundid: id));
      // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
      //     WithdrawScreen(message: message,fundid: id,)));
    } else {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
    return CommonResponse.fromJson(response.data);
  }
}
