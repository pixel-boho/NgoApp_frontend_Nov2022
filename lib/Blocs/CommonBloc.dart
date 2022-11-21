import 'package:dio/dio.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Models/CampaignTypesResponse.dart';
import 'package:ngo_app/Models/CommonResponse.dart';
import 'package:ngo_app/Models/CommonViewAllResponse.dart';
import 'package:ngo_app/Models/RelationsResponse.dart';
import 'package:ngo_app/Repositories/CommonInfoRepository.dart';

class CommonBloc {
  CommonInfoRepository _commonInfoRepository;

  CommonBloc() {
    if (_commonInfoRepository == null)
      _commonInfoRepository = CommonInfoRepository();
  }

  Future<CommonResponse> postContactUs(String body) async {
    try {
      CommonResponse commonResponse =
          await _commonInfoRepository.postContactUs(body);
      return commonResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonResponse> addPartner(String body) async {
    try {
      CommonResponse commonResponse =
          await _commonInfoRepository.addPartner(body);
      return commonResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonResponse> createVolunteer(String body) async {
    try {
      CommonResponse commonResponse =
          await _commonInfoRepository.createVolunteer(body);
      return commonResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonResponse> createLend(FormData body) async {
    try {
      CommonResponse commonResponse =
          await _commonInfoRepository.createLend(body);
      return commonResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonResponse> addComment(String body) async {
    try {
      CommonResponse commonResponse =
          await _commonInfoRepository.addComment(body);
      return commonResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CampaignTypesResponse> getCampaignTypes() async {
    try {
      CampaignTypesResponse campaignTypesResponse =
          await _commonInfoRepository.getCampaignTypes(0, 50);
      return campaignTypesResponse;
    } catch (error) {
      print(error.toString());
      return null;
      //throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonViewAllResponse> getRelatedItems({int categoryId}) async {
    try {
      CommonViewAllResponse response = await _commonInfoRepository
          .getAllFundraiserItems(0, 10, categoryId, null);
      return response;
    } catch (error) {
      print(error.toString());
      return null;
      //throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonResponse> uploadDocument(FormData formData) async {
    try {
      CommonResponse commonResponse =
          await _commonInfoRepository.uploadDocument(formData);
      return commonResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonResponse> removeDocument(String body) async {
    try {
      CommonResponse commonResponse =
          await _commonInfoRepository.removeDocument(body);
      return commonResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<RelationsResponse> getRelations() async {
    try {
      RelationsResponse response = await _commonInfoRepository.getRelations();
      return response;
    } catch (error) {
      print(error.toString());
      return null;
      //throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonResponse> createFundraiser(FormData formData) async {
    try {
      CommonResponse response =
          await _commonInfoRepository.createFundraiser(formData);
      return response;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonResponse> withdrawFundraiser(String body) async {
    try {
      CommonResponse commonResponse =
          await _commonInfoRepository.withdrawFundraiser(body);
      return commonResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonResponse> updateFundraiser(FormData formData) async {
    try {
      CommonResponse response =
          await _commonInfoRepository.updateFundraiser(formData);
      return response;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonResponse> updateLend(FormData body) async {
    try {
      CommonResponse commonResponse =
          await _commonInfoRepository.updateLend(body);
      return commonResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonResponse> transferAmount(String body) async {
    try {
      CommonResponse commonResponse =
          await _commonInfoRepository.transferAmount(body);
      return commonResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonResponse> unSubscribe(String body) async {
    try {
      CommonResponse commonResponse =
          await _commonInfoRepository.removeSubscription(body);
      return commonResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonResponse> postReportIssue(String body) async {
    try {
      CommonResponse commonResponse =
          await _commonInfoRepository.postReportIssue(body);
      return commonResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonResponse> cancelFundraiser(String body) async {
    try {
      CommonResponse commonResponse =
          await _commonInfoRepository.cancelFundraiser(body);
      return commonResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }
}
