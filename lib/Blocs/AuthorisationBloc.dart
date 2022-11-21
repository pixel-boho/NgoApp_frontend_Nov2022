import 'package:dio/dio.dart';
import 'package:ngo_app/Models/CommonResponse.dart';
import 'package:ngo_app/Models/OtpResponse.dart';
import 'package:ngo_app/Models/ProfileResponse.dart';

import '../Constants/CommonMethods.dart';
import '../Models/LoginResponse.dart';
import '../Repositories/AuthorisationRepository.dart';

class AuthorisationBloc {
  AuthorisationRepository authorisationRepository;

  AuthorisationBloc() {
    if (authorisationRepository == null)
      authorisationRepository = AuthorisationRepository();
  }

  Future<LoginResponse> userLogin(String body) async {
    try {
      LoginResponse loginResponse =
          await authorisationRepository.authenticateUser(body);
      return loginResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonResponse> userRegistration(String body) async {
    try {
      CommonResponse commonResponse =
          await authorisationRepository.registerUser(body);
      return commonResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<OtpResponse> sendOtp(String body) async {
    try {
      OtpResponse otpResponse = await authorisationRepository.sendOtp(body);
      return otpResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<ProfileResponse> updateProfile(FormData formData) async {
    try {
      ProfileResponse response =
          await authorisationRepository.updateProfile(formData);
      return response;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }
}
