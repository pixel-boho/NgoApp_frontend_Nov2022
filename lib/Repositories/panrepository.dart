import 'package:dio/dio.dart';


import '../Models/CommonResponse.dart';
import '../ServiceManager/ApiProvider.dart';

class ProfileRepositoryUser {
 ApiProvider apiProvider;

  ProfileRepositoryUser() {
    apiProvider = new ApiProvider();
  }






  Future<CommonResponse> uploadUserRecords(
      String reportName,  reportFile) async {
    String fileName = reportFile.path.split('/').last;
    FormData formData = FormData.fromMap({
      "report_name": reportName,
      "report_file":
      await MultipartFile.fromFile(reportFile.path, filename: fileName),
    });



// Future<UpdateProfileResponse> updateProfileInfo(FormData body) async {
//   final response = await apiProvider.getMultipartInstance().post('${Apis.updateProfileInfo}',data: body);
//   return UpdateProfileResponse.fromJson(response.data);
// }
//
// Future<CommonResponse> changePassword(FormData body) async {
//   final response = await apiProvider.getJsonInstance().post('${Apis.changePassword}',data: body);
//   return CommonResponse.fromJson(response.data);
// }
}}
