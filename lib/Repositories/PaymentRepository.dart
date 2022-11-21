
import 'package:ngo_app/Models/GatewayKeyResponse.dart';
import 'package:ngo_app/ServiceManager/ApiProvider.dart';

class PaymentRepository{
  ApiProvider apiProvider;

  LendRepository(){
    apiProvider = new ApiProvider();
  }

  Future<GatewayKeyResponse> getGatewayKey() async {
    final response = await apiProvider.getInstance().get('master/get-api-key');
    return GatewayKeyResponse.fromJson(response.data);
  }

}