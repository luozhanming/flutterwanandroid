import 'package:json_annotation/json_annotation.dart';

part 'result.g.dart';

@JsonSerializable(createToJson: false)
class Result {
   Map<String, dynamic> data;
   int errorCode;
   String errorMsg;

   Result({this.data, this.errorCode, this.errorMsg});

  Result.fromJson(Map<String, dynamic> json) {
    _$ResultFromJson(json);
  }
}
