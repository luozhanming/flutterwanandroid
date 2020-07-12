

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wanandroid/model/result.dart';

class HttpManager{
  final String baseUrl;
  final int connectTimeout;
  final int readTimeout;
  final int writeTimeout;
  final Map<String,dynamic> headers;

   Dio _dio;

   HttpManager({this.baseUrl,this.connectTimeout,this.readTimeout,this.writeTimeout,this.headers}){
     BaseOptions options = BaseOptions(connectTimeout: connectTimeout,receiveTimeout: readTimeout,
     sendTimeout: writeTimeout,baseUrl: baseUrl,headers: headers);
     _dio = Dio(options);
   }

//
//   Stream<Result> get<T>(String path,[Map<String,dynamic> queries]) async*{
//     Stream<Response<T>> stream = Stream.fromFuture(_dio.get(path,queryParameters: queries));
//     stream.where((event) => {
//       event.
//     })
//   }




}