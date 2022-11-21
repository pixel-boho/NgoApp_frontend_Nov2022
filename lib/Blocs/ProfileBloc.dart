import 'dart:async';

import 'package:ngo_app/Repositories/AuthorisationRepository.dart';

import '../Constants/CommonMethods.dart';
import '../Models/ProfileResponse.dart';
import '../ServiceManager/ApiResponse.dart';
import '../Utilities/LoginModel.dart';
import '../Utilities/PreferenceUtils.dart';

class ProfileBloc {
  AuthorisationRepository authorisationRepository;
  StreamController _profileController;

  StreamSink<ApiResponse<ProfileResponse>> get profileSink =>
      _profileController.sink;

  Stream<ApiResponse<ProfileResponse>> get profileStream =>
      _profileController.stream;

  ProfileBloc() {
    _profileController = StreamController<ApiResponse<ProfileResponse>>();
    authorisationRepository = AuthorisationRepository();
  }

  getProfileInfo() async {
    profileSink.add(ApiResponse.loading('Fetching profile'));
    try {
      ProfileResponse profileResponse =
          await authorisationRepository.getProfileInfo();
      if (profileResponse.success) {
        if (profileResponse.userDetails != null) {
          LoginModel().userDetails = profileResponse.userDetails;
          LoginModel().userDetails.baseUrl = profileResponse.baseUrl;
          PreferenceUtils.setObjectToSF(
              PreferenceUtils.prefUserDetails, LoginModel().userDetails);
        }
        profileSink.add(ApiResponse.completed(profileResponse));
      } else {
        profileSink.add(ApiResponse.error(
            profileResponse.message ?? "Unable to process your request"));
      }
    } catch (error) {
      profileSink
          .add(ApiResponse.error(CommonMethods().getNetworkError(error)));
    }
  }

  dispose() {
    profileSink?.close();
    _profileController?.close();
  }
}
