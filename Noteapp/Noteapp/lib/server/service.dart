import 'dart:convert';
import 'dart:developer';

import 'package:cs/helper/spref.dart';
import 'package:dio/dio.dart';

class Service {
  static final Service _service = Service._();

  Dio? _dio;

  factory Service() {
    return _service;
  }

  Service._();

  init() {
    _dio = Dio(BaseOptions(
        baseUrl: "https://app.hieu-noteapp.tk/", connectTimeout: 60000));
    _dio?.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      if (SPref().token.isNotEmpty) {
        options.headers = {"Authorization": SPref().token};
      }
      print("*********Response*********");
      print("API: ${options.baseUrl}${options.path}");
      print(options.data.toString());
      print("Method: ${options.method}");
      print("***Header***");
      options.headers.values.forEach((element) {
        print(element);
      });
      return handler.next(options);
    }, onResponse: (res, handler) {
      print("*********Response*********");
      log(res.data.toString());
      return handler.next(res);
    }));
  }

  Dio? get call => _dio;
}
