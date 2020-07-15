import 'dart:collection';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wanandroid/model/result.dart';

class HttpManager {

  static Map<String,HttpManager> _sCaches = HashMap();

  final String baseUrl;
  final int connectTimeout;
  final int readTimeout;
  final int writeTimeout;
  final Map<String, dynamic> headers;

  Dio _dio;
  CookieJar _cookieJar;

  HttpManager._(
      {this.baseUrl,
      this.connectTimeout = 10000,
      this.readTimeout = 10000,
      this.writeTimeout = 10000,
      this.headers}) {
    BaseOptions options = BaseOptions(
        connectTimeout: connectTimeout,
        receiveTimeout: readTimeout,
        sendTimeout: writeTimeout,
        baseUrl: baseUrl,
        headers: headers);
    _dio = Dio(options);
    _cookieJar = CookieJar();
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  factory HttpManager.getManager(String baseUrl,[Map<String,dynamic> headers]){
    if(_sCaches.containsKey(baseUrl)){
      return _sCaches[baseUrl];
    }else{
      HttpManager manager = HttpManager._(baseUrl:baseUrl,headers:headers);
      return manager;
    }
  }

  Stream<Result> get(String path, [Map<String, dynamic> queries]) async* {
    Stream<Response> stream =
        Stream.fromFuture(_dio.get(path, queryParameters: queries));
    yield* stream.flatMap((event) {
      if (event.statusCode == 200 && event.data is Map<String, dynamic>) {
        Map<String, dynamic> json = event.data as Map;
        var result = Result.fromJson(json);
        return Stream.value(result);
      } else {
        return Stream.error(
            Result(errorCode: event.statusCode, errorMsg: event.statusMessage));
      }
    });
  }

  Stream<Result> post(String path, [Map<String, dynamic> data]) async* {
    Stream<Response> stream =
        Stream.fromFuture(_dio.post(path, data: FormData.fromMap(data)));
    yield* stream.flatMap((event) {
      if (event.statusCode == 200 &&
          event.data is Map<String, dynamic> &&
          event.data["errorCode"] == 0) {
        Map<String, dynamic> json = event.data as Map;
        var result = Result.fromJson(json);
        return Stream.value(result);
      } else {
        return Stream.error(
            Result(errorCode: event.statusCode, errorMsg: event.statusMessage));
      }
    });
  }
}

class NetError {
  final int statusCode;
  final String message;

  const NetError({this.statusCode, this.message});
}
