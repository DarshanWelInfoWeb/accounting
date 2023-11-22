import 'package:flutter/cupertino.dart';
import 'package:gas_accounting/data/datasource/remote/dio/dio_client.dart';
import 'package:gas_accounting/data/datasource/remote/exception/api_error_handler.dart';
import 'package:gas_accounting/data/model/body/add_customer.dart';
import 'package:gas_accounting/data/model/response/base/api_response.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/view/screen/manage_customer/add_customer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  CustomerRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> getGasDetailByMobile(String mobile,String id) async {
    try {
      final response = await dioClient?.get(AppConstants.SEARCH_CUSTOMER_URI,data: {'strMobileno':mobile,'intCompanyId':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getAddCustomer(Add_Customer add_customer) async {
    try {
      final response = await dioClient?.post(AppConstants.ADD_CUSTOMER_URI,data: add_customer.toJson());
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCustomerList(String id) async {
    try {
      final response = await dioClient?.get(AppConstants.CUSTOMER_LIST_URI,data: {'intCompanyid':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCustomerDelete(String id) async {
    try {
      final response = await dioClient?.post(AppConstants.DELETE_CUSTOMER_URI,data: {'intId':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCustomerUpdate(Update_Customer update_customer) async {
    try {
      final response = await dioClient?.post(AppConstants.UPDATE_CUSTOMER_URI,data: update_customer.toJson());
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCustomerEdit(String id) async {
    try {
      final response = await dioClient?.get(AppConstants.EDIT_CUSTOMER_URI,data: {'intId':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCustomerDailyReport(String companyId,String customerId,String startDate,String endDate) async {
    try {
      final response = await dioClient?.get(AppConstants.CUSTOMER_REPORT_DAILY_URI,data: {'intCompanyid':companyId,'intCustomerid':customerId,'strStartdate':startDate,'strEnddate':endDate});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCustomerDueReport(String companyId) async {
    try {
      final response = await dioClient?.get(AppConstants.CUSTOMER_DUE_REPORT_URI,data: {'intCompanyid':companyId});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCustomerQRCodeGenerate(String mobile) async {
    try {
      final response = await dioClient?.post(AppConstants.CUSTOMER_QR_CODE_GENERATE_URI,data: {'strMobileno':mobile});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}