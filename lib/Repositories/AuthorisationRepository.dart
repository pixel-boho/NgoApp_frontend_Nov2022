 import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ngo_app/Models/CommonResponse.dart';
import 'package:ngo_app/Models/OtpResponse.dart';
import 'package:ngo_app/Models/PancardUploadResponse.dart';
import 'package:ngo_app/Models/ProfileResponse.dart';
import 'package:ngo_app/Models/UserPancardResponse.dart';
import '../Models/LoginResponse.dart';
import '../ServiceManager/ApiProvider.dart';
import '../ServiceManager/RemoteConfig.dart';

class AuthorisationRepository {
  ApiProvider apiProvider;

  AuthorisationRepository() {
    if (apiProvider == null) apiProvider = new ApiProvider();
  }

  Future<LoginResponse> authenticateUser(String body) async {
    Response response = await apiProvider
        .getInstance()
        .post(RemoteConfig.loginUser, data: body);
    return LoginResponse.fromJson(response.data);
  }

  Future<CommonResponse> registerUser(String body) async {
    Response response = await apiProvider
        .getInstance()
        .post(RemoteConfig.registerUser, data: body);
    return CommonResponse.fromJson(response.data);
  }

  Future<OtpResponse> sendOtp(String body) async {
    final response =
        await apiProvider.getInstance().post(RemoteConfig.sendOtp, data: body);
    return OtpResponse.fromJson(response.data);
  }

  Future<ProfileResponse> getProfileInfo() async {
    final response =
        await apiProvider.getInstance().get(RemoteConfig.getProfile);
    return ProfileResponse.fromJson(response.data);
  }

  Future<ProfileResponse> updateProfile(FormData formData) async {
    final response = await apiProvider
        .getMultipartInstance()
        .post(RemoteConfig.updateProfile, data: formData);
    return ProfileResponse.fromJson(response.data);
  }

  Future<PancardResponse> pancardupload(File reportFile) async {
    String fileName = reportFile.path.split('/').last;
    print("->>${fileName}");
    print("->${reportFile.path}");
    FormData formData = FormData.fromMap({
      "pancard_image":
          await MultipartFile.fromFile(reportFile.path, filename: fileName),
    });
    final response = await apiProvider
        .getMultipartInstance()
        .post('${RemoteConfig.pancardupload}', data: formData);
    return PancardResponse.fromJson(response.data);
  }

  Future<UserPancardResponse> fetchUserRecords(String userId) async {
    final response = await apiProvider
        .getInstance()
        .post('${RemoteConfig.fetchpancard}', data: {"user_id": userId});
    return UserPancardResponse.fromJson(response.data);
  }
}
