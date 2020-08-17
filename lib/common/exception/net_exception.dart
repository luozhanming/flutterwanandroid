



class ServerException implements Exception {
  final int code;
  final String message;

  const ServerException(this.code,this.message);


}