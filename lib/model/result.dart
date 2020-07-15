import 'package:json_annotation/json_annotation.dart';

part 'result.g.dart';

@JsonSerializable(createToJson: false)
class Result {
   Map<String, dynamic> dataJson;
   List<dynamic> dataList;
   int errorCode;
   String errorMsg;
   Result({this.dataJson, this.errorCode, this.errorMsg,this.dataList});

  factory Result.fromJson(Map<String, dynamic> json) {
    var data = json['data'];
    Map<String, dynamic> dataJson;
    List<dynamic> dataList;
    if(data is List<dynamic>){
      dataList = data;
    }else if(data is Map<String,dynamic>){
      dataJson = data;
    }
    return Result(
      dataJson: dataJson,
      errorCode: json['errorCode'] as int,
      errorMsg: json['errorMsg'] as String,
      dataList: dataList,
    );
  }
}
