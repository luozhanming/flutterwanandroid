

class Resource<T> {
  final T data;
  final ResourceStatus status;
  final Exception exception;

  const Resource(this.status, {this.data, this.exception});

  factory Resource.loading(){
    return Resource(ResourceStatus.loading);
  }

  factory  Resource.success(T data){
    return Resource(ResourceStatus.success,data: data);
  }

  factory Resource.failed(Exception e){
    return Resource(ResourceStatus.failed,exception: e);
  }

  factory Resource.empty(){
    return Resource(ResourceStatus.idel);
  }

  factory Resource.copyWith(Resource src,  {ResourceStatus state, T data, Exception exception}){
    ResourceStatus status = state??src.status;
    T d = data??src.data;
    Exception e = exception??src.exception;
    return Resource(status,data: d,exception: e);
  }

}

enum ResourceStatus { idel,loading, success, failed }
