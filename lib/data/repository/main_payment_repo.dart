import 'package:flutter/foundation.dart';
import 'package:gas_accounting/data/datasource/remote/dio/dio_client.dart';
import 'package:gas_accounting/data/datasource/remote/exception/api_error_handler.dart';
import 'package:gas_accounting/data/model/body/addPayment_body.dart';
import 'package:gas_accounting/data/model/body/add_tempinvoice.dart';
import 'package:gas_accounting/data/model/body/main_payment_body.dart';
import 'package:gas_accounting/data/model/body/route.dart';
import 'package:gas_accounting/data/model/response/base/api_response.dart';
import 'package:gas_accounting/data/model/response/main_payment_response.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPaymentRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  MainPaymentRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> addMainPayment(Add_Main_Payment_Body payment) async {
    try {
      final response = await dioClient?.post(AppConstants.ADD_MAIN_PAYMENT_URI,data: payment.toJson());
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateMainPayment(Edit_Main_Payment_Body payment) async {
    try {
      final response = await dioClient?.post(AppConstants.UPDATE_MAIN_PAYMENT_LIST_URI,data: payment.toJson());
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getMainPayment(String? id,String year,String month,String customerId) async {
    try {
      final response = await dioClient?.get("${AppConstants.MAIN_PAYMENT_LIST_URI}?intComapnyId=$id&dtStartDate=$year&dtEndDate=$month&intCustomerid=$customerId");
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> getDeleteMainPayment(String id) async {
    try {
      final response = await dioClient?.post(AppConstants.DELETE_MAIN_PAYMENT_URI,data: {'intid':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}