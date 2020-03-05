import 'dart:convert';

import 'package:zucc_helper/network/requests.dart';

class ProfileRequst {

  static Future submitLoginData(userName, password){
    return HttpRequest.request(
        url: "/users/login",
        method: "post",
        data: {
          "userName": userName,
          "password": password
        },
    );
  }

  static Future submitRegisterData(userName, password) {
    return HttpRequest.request(
        url: "/users/register",
        method: "post",
        data: {
          "userName": userName,
          "password": password
        }
    );
  }

  // 鉴权
  static Future checkAuth(token, userName) {
    return HttpRequest.request(
        url: "/users/token",
        method: "post",
        data: {
          "token": token,
          "userName": userName
        }
    );
  }

  // 获取个人信息
  static Future getProfileInfo(token) {
    return HttpRequest.request(
        url: "/users/get_profile",
        method: "get",
        headers: {
          "Authorization": 'Basic ' + base64Encode(utf8.encode('$token:'))
        }
    );
  }
}




