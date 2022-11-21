import 'package:ngo_app/Models/LendListResponse.dart';
import 'package:ngo_app/Models/LoanLendDetailsResponse.dart';
import 'package:ngo_app/Models/MyLendHistoryListResponse.dart';
import 'package:ngo_app/Models/MyLoanHistoryListResponse.dart';
import 'package:ngo_app/ServiceManager/ApiProvider.dart';

class LendRepository {
  ApiProvider apiProvider;

  LendRepository() {
    apiProvider = new ApiProvider();
  }

  Future<LendListResponse> getLendList(
      int pageNumber, int perPage, String keyword, String amount) async {
    final response = await apiProvider.getInstance().get(
        "loan/list?page=${pageNumber + 1}&per_page=$perPage&keyword=$keyword&amount=$amount");
    return LendListResponse.fromJson(response.data);
  }

  Future<MyLoanHistoryListResponse> getMyLoanList(
      int pageNumber, int perPage) async {
    final response = await apiProvider
        .getInstance()
        .get("loan/my-loans?page=${pageNumber + 1}&per_page=$perPage");
    return MyLoanHistoryListResponse.fromJson(response.data);
  }

  Future<MyLendHistoryListResponse> getMyLendList(
      int pageNumber, int perPage) async {
    final response = await apiProvider
        .getInstance()
        .get("loan/my-lends?page=${pageNumber + 1}&per_page=$perPage");
    return MyLendHistoryListResponse.fromJson(response.data);
  }

  Future<LoanLendDetailsResponse> getLoanLendDetails(int id) async {
    final response =
        await apiProvider.getInstance().get("loan/detail?loan_id=$id");
    return LoanLendDetailsResponse.fromJson(response.data);
  }
}
