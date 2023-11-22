import 'package:flutter/foundation.dart';
import 'package:gas_accounting/data/datasource/remote/dio/dio_client.dart';
import 'package:gas_accounting/data/datasource/remote/exception/api_error_handler.dart';
import 'package:gas_accounting/data/model/body/addPayment_body.dart';
import 'package:gas_accounting/data/model/body/add_tempinvoice.dart';
import 'package:gas_accounting/data/model/body/route.dart';
import 'package:gas_accounting/data/model/response/base/api_response.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  PaymentRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> addPayment(AddPayment_Body payment) async {
    try {
      final response = await dioClient?.post(AppConstants.ADD_PAYMENT_URI,data: payment.toJson());
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updatePayment(PaymentUpdate_Body payment) async {
    try {
      final response = await dioClient?.post(AppConstants.UPDATE_PAYMENT_LIST_URI,data: payment.toJson());
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getPayment(String? id,String year,String month,String customerId) async {
    try {
      final response = await dioClient?.get("${AppConstants.PAYMENT_LIST_URI}?intCompanyId=$id&dtstartdate=$year&dtenddate=$month&intCustomerId=$customerId");
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getPaymentEdit(String id) async {
    try {
      final response = await dioClient?.get(AppConstants.EDIT_PAYMENT_LIST_URI,data: {'intid':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDeletePayment(String id) async {
    try {
      final response = await dioClient?.post(AppConstants.DELETE_PAYMENT_URI,data: {'intid':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}