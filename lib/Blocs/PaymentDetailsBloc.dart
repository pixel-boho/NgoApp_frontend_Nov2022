import 'dart:async';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Models/paymentHistoryResponse.dart';
import 'package:ngo_app/Repositories/AuthorisationRepository.dart';
import '../Constants/CommonMethods.dart';
import '../ServiceManager/ApiResponse.dart';

class PaymentInfoBloc {
  AuthorisationRepository _repository;

  StreamController _paymentinfoController;

  StreamSink<ApiResponse<PaymentHistoryResponse>> get paymentinfoSink => _paymentinfoController.sink;

  Stream<ApiResponse<PaymentHistoryResponse>> get paymentinfoStream => _paymentinfoController.stream;



  PaymentInfoBloc() {
    _repository = AuthorisationRepository();
    _paymentinfoController = StreamController<ApiResponse<PaymentHistoryResponse>>();
  }

  getPaymentInfo() async {
    paymentinfoSink.add(ApiResponse.loading('Fetching'));
    try {
      PaymentHistoryResponse response = await _repository.fetchUserpaymentdetails();
      print("Listtt-->r");
      print("Listtt-->${response.donate}");
      if (response != null) {
        paymentinfoSink.add(ApiResponse.completed(response));
        return true;
      } else {
        paymentinfoSink.add(ApiResponse.error("Something went wrong"));
        return false;
      }
    } catch (error) {
      paymentinfoSink.add(ApiResponse.error(CommonMethods().getNetworkError(error)));
      return false;
    }
  }

  dispose() {
    paymentinfoSink?.close();
    _paymentinfoController?.close();
  }
}


// class PaymentInfoBloc {
//   bool hasNextPage = false;
//   int pageNumber = 0;
//   int perPage = 20;
//
//   LoadMoreListener _listener;
//   AuthorisationRepository _repository;
//
//   StreamController _paymentinfoController;
//
//   StreamSink<ApiResponse<PaymentHistoryResponse>> get paymentinfoSink =>
//       _paymentinfoController?.sink;
//
//   Stream<ApiResponse<PaymentHistoryResponse>> get paymentinfoStream =>
//       _paymentinfoController?.stream;
//
//   List<PaymentHist> lendItemsList = [];
//
//   PaymentInfoBloc(this._listener) {
//     _repository = AuthorisationRepository();
//     _paymentinfoController =
//         StreamController<ApiResponse<PaymentHistoryResponse>>();
//   }
//
//   getMyLendList(bool isPagination) async {
//     if (isPagination) {
//       _listener.refresh(true);
//     } else {
//       pageNumber = 0;
//       paymentinfoSink.add(ApiResponse.loading('Fetching items'));
//     }
//     try {
//       PaymentHistoryResponse response;
//       response = await _repository.fetchUserpaymentdetails(pageNumber, perPage);
//
//       hasNextPage = response.hasNextPage;
//       pageNumber = response.page;
//       if (isPagination) {
//         if (lendItemsList.length == 0) {
//           lendItemsList = response.paymentHist;
//         } else {
//           lendItemsList.addAll(response.paymentHist);
//         }
//       } else {
//         lendItemsList = response.paymentHist;
//       }
//       paymentinfoSink.add(ApiResponse.completed(response));
//       if (isPagination) {
//         _listener.refresh(false);
//       }
//     } catch (error) {
//       if (isPagination) {
//         _listener.refresh(false);
//       } else {
//         paymentinfoSink
//             .add(ApiResponse.error(CommonMethods().getNetworkError(error)));
//       }
//     }
//   }
//
//   dispose() {
//     paymentinfoSink?.close();
//     _paymentinfoController?.close();
//   }
// }
