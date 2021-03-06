import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:zucc_helper/config/storage_manager.dart';
import 'package:zucc_helper/models/login_model.dart';
import 'package:zucc_helper/models/profile_model.dart';
import 'package:zucc_helper/models/response_model.dart';
import 'package:zucc_helper/network/profile_request.dart';


class ProfileProvider extends ChangeNotifier{
  // 用户相关
  Profile _profile;

  Profile get profile => _profile;

  bool get isLogin => profile != null;


  // 初始化
  ProfileProvider(){
    var profileMap = StorageManager.sharedPreferences.getString("profile");
    _profile = profileMap != null ? Profile.fromJsonMap(jsonDecode(profileMap)) : null;
  }

  // 用户登录
  gotoLogin(Login loginForm) async {
    var res = await ProfileRequst.submitLoginData(loginForm.userName, loginForm.password)
        .then((res){
          var p = Profile.fromJsonMap(res);
          saveProfileInfo(p);
          var response = ResponseCondition.fromMap(res, isSuccess: true);
          return response;
        })
        .catchError((error){
          var response = ResponseCondition.fromMap(error, isSuccess: false);
          return response;
        });
    return res;
  }

  // 用户注册
  gotoRegister(Login loginForm) async {
    var res = await ProfileRequst.submitRegisterData(loginForm.userName, loginForm.password)
        .then((res){
          var response = ResponseCondition.fromMap(res, isSuccess: true);
          return response;
        })
        .catchError((error){
          var response = ResponseCondition.fromMap(error, isSuccess: false);
          return response;
        });
    return res;
  }


  // 更新个人信息
  getProfile() async {
    ProfileRequst.getProfileInfo(_profile.token)
        .then((res){
          var p = Profile.fromJsonMap(res);
          saveProfileInfo(p);
        }).catchError((error){

        });
  }


  // 修改个人信息
  resetProfileInfo(Profile profile) async {
    var p = await ProfileRequst.resetProfileInfo(profile, _profile.token)
        .then((res){
          var p = Profile.fromJsonMap(res);
          p.token = _profile.token;
          saveProfileInfo(p);
          return true;
        })
        .catchError((res){
          return false;
        });
    return p;
  }


  // 保存用户信息
  saveProfileInfo(Profile profile){
    print(profile.token);
    _profile = profile;
    _profile.setProfile();
    // 通知其他组件更新
    notifyListeners();
  }

  // 移除用户信息
  clearProfile() {
    _profile.clearProfile();
    _profile = null;
    notifyListeners();
  }
}