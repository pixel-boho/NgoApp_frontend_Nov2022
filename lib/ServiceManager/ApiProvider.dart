import 'package:dio/dio.dart';

import 'ServiceManagerInterceptors.dart';

class ApiProvider {
  Dio _dio;

  ApiProvider() {
    BaseOptions options;
    options = new BaseOptions(
      //baseUrl: "http://45.79.120.216/ngo/api/web/v1/",
      baseUrl: "https://www.cocoalabs.in/ngo/api/web/v1/",
      receiveTimeout: 30000, //30s
      connectTimeout: 30000,
    );

    _dio = Dio(options);
    _dio.interceptors.add(ServiceMangerInterceptors());
  }

  Dio getInstance() {
    _dio.options.headers.addAll({"Content-Type": "application/json"});
    return _dio;
  }

  Dio getMultipartInstance() {
    _dio.options.headers.addAll({"Content-Type": "multipart/form-data"});
    return _dio;
  }

  Dio getInstanceForExternalApi() {
    BaseOptions options;
    options = new BaseOptions(
        receiveTimeout: 30000, //30s
        connectTimeout: 30000,
        headers: {"Content-Type": "application/json"});

    _dio = Dio(options);
    _dio.interceptors.add(ServiceMangerInterceptors());
    return _dio;
  }
}
