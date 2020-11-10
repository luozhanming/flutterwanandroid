import 'package:wanandroid/common/config/config.dart';
import 'package:wanandroid/common/http/http_manager.dart';
import 'package:wanandroid/common/http/url.dart';
import 'package:wanandroid/model/resource.dart';
import 'package:wanandroid/model/user.dart';

abstract class IUserRepository {
  Stream<Resource<User>> login(String username, String password);

  Stream<Resource<bool>> logout();

  Stream<Resource<User>> register(
      String username, String password, String repassword);
}

class RemoteUserRepository implements IUserRepository {
  HttpManager _httpManager;

  RemoteUserRepository() {
    _httpManager = HttpManager.getManager(Config.ENV.baseUrl);
  }

  @override
  Stream<Resource<User>> login(String username, String password) async* {
    var params = {"username": username, "password": password};
    yield* _httpManager.post(WanandroidUrl.login, params).map((event) {
      var data = event.dataJson;
      if (data is Map<String, dynamic>) {
        var user = User.fromJson(data);
        return Resource.success(user);
      } else {
        return Resource.failed();
      }
    });
  }

  @override
  Stream<Resource<bool>> logout() async* {
    yield* _httpManager.get(WanandroidUrl.logout).map((event) {
      if (event.errorCode == 0) {
        return Resource.success(true);
      } else {
        return Resource.failed();
      }
    });
  }

  @override
  Stream<Resource<User>> register(
      String username, String password, String repassword) async* {
    var params = {
      "username": username,
      "password": password,
      "repassword": repassword
    };
    yield* _httpManager.post(WanandroidUrl.register, params).map((event) {
      var data = event.dataJson;
      if (data is Map<String, dynamic>) {
        var user = User.fromJson(data);
        return Resource.success(user);
      } else {
        return Resource.failed();
      }
    });
  }
}
