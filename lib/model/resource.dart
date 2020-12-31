

import 'package:flutter/cupertino.dart';

class Resource<T> {
  final T data;
  final ResourceStatus status;
  final Exception exception;
  final int errorCode;
  final String errorMsg;

   const Resource(this.status, {this.data,this.exception, this.errorCode,this.errorMsg});

  factory Resource.loading(){
    return Resource(ResourceStatus.loading);
  }

  factory  Resource.success(T data){
    return Resource(ResourceStatus.success,data: data);
  }

  factory Resource.error([Exception e]){
    return Resource(ResourceStatus.error,exception: e);
  }

  factory Resource.failed([int errorCode,String errorMsg]){
    return Resource(ResourceStatus.failed,errorCode: errorCode,errorMsg: errorMsg);
  }

  factory Resource.empty(){
    return Resource(ResourceStatus.empty);
  }

  factory Resource.copyWith(Resource src,  {ResourceStatus state, T data, Exception exception}){
    ResourceStatus status = state??src.status;
    T d = data??src.data;
    Exception e = exception??src.exception;
    return Resource(status,data: d,exception: e);
  }

}

enum ResourceStatus { empty,loading, success, error,failed }
