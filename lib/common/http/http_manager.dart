import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wanandroid/model/resource.dart';
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
    _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    var addCookieJar =() async{
      if(await Permission.storage.request().isGranted){
        var directory = await getApplicationDocumentsDirectory();
        String appDocPath = directory.path;
        _cookieJar = PersistCookieJar(dir: "${appDocPath}/.cookies/");
        _dio.interceptors.add(CookieManager(_cookieJar));
      }else{
        _cookieJar = DefaultCookieJar();
        _dio.interceptors.add(CookieManager(_cookieJar));
      }
    };
   addCookieJar();
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
            Resource.error(NetError(event.statusCode, event.statusMessage)));
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
          Resource.error(NetError(event.statusCode, event.statusMessage)));
      }
    });
  }
}

class NetError implements Exception{
  final int statusCode;
  final String message;

  const NetError(this.statusCode, this.message);
}

class HttpLogInterceptor extends Interceptor{
  static const TAG = "dio_log";

  @override
  Future onRequest(RequestOptions options) {
    log("""
    ${options.method}   ${options.uri.toString()}
    contentType:${options.contentType}
    headers: ${options.headers}
    data: ${options.data}
    extra:${options.extra}
    """,name: TAG);
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    var options = response.request;
    log("""
    ${options.method}   ${options.uri.toString()}
    Response ${response.statusCode}  ${response.statusMessage}
    contentType:${options.contentType}
    headers: ${response.headers}
    data: ${response.data}
    extra:${response.extra}
    """,name: TAG);
    return super.onResponse(response);
  }
}
