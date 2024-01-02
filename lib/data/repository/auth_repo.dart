import 'package:dio/dio.dart';
import 'package:gas_accounting/data/datasource/remote/dio/dio_client.dart';
import 'package:gas_accounting/data/datasource/remote/exception/api_error_handler.dart';
import 'package:gas_accounting/data/model/body/login_body.dart';
import 'package:gas_accounting/data/model/response/base/api_response.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  AuthRepo({required this.dioClient, required this.sharedPreferences});


  Future<void> saveUserToken(String token) async {
    print('token:::::::::${token}');
    PreferenceUtils.init();
    PreferenceUtils.setString(AppConstants.TOKEN, token);
  }

  String getUserToken() {
    return sharedPreferences?.getString(AppConstants.TOKEN) ?? "";
  }

  Future<ApiResponse> login(LoginBody loginBody) async {
    try {
      print("register : ${loginBody.toJson()}");
      Response? response = await dioClient?.post(
        AppConstants.LOGIN_URI,
        data: loginBody.toJson(),
      );
      print("response : ${response}");
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      print("no");
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for  user token
  Future<void> saveAuthToken(String token) async {
    dioClient?.token = token;
    dioClient?.dio.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      await sharedPreferences?.setString(AppConstants.TOKEN, token);
    } catch (e) {
      throw e;
    }
  }

  String getAuthToken() {
    return sharedPreferences?.getString(AppConstants.TOKEN) ?? "";
  }

  bool? isLoggedIn() {
    return sharedPreferences?.containsKey(AppConstants.TOKEN);
  }

  Future<bool> clearSharedData() async {
    sharedPreferences?.remove(AppConstants.TOKEN);
    return true;
  }

}