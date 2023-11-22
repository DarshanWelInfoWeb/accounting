import 'package:flutter/foundation.dart';
import 'package:gas_accounting/data/datasource/remote/dio/dio_client.dart';
import 'package:gas_accounting/data/datasource/remote/exception/api_error_handler.dart';
import 'package:gas_accounting/data/model/body/add_tempinvoice.dart';
import 'package:gas_accounting/data/model/body/route.dart';
import 'package:gas_accounting/data/model/response/base/api_response.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TempInvoiceRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  TempInvoiceRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> addTempInvoice(AddTempInvoiceBody temp) async {
    try {
      final response = await dioClient?.post(AppConstants.ADD_TEMP_INVOICE_URI,data: temp.toJson());
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateTempInvoice(UpdateTempInvoiceBody temp) async {
    try {
      final response = await dioClient?.post(AppConstants.ADD_TEMP_INVOICE_URI,data: temp.toJson());
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addTempStock(TempStock_Body route) async {
    try {
      final response = await dioClient?.post(AppConstants.ADD_INVOICE_STOCK_URI,data: route.toJson());
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getTempStockList(String id,String gst,String companyId) async {
    try {
      final response = await dioClient?.get("${AppConstants.INVOICE_STOCK_LIST_URI}inttempinvoiceId=$id&GSTRate=$gst&intCompanyId=$companyId");
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDeleteTempStock(String id) async {
    try {
      final response = await dioClient?.post(AppConstants.DELETE_INVOICE_STOCK_URI,data: {'intid':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getTempInvoice(String id,String year,String month,String customerId) async {
    try {
      final response = await dioClient?.get("${AppConstants.TEMP_INVOICE_LIST_URI}?intComapnyId=$id&dtstartdate=$year&dtenddate=$month&intCustomerId=$customerId");
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getTempInvoiceEdit(String id) async {
    try {
      final response = await dioClient?.get(AppConstants.EDIT_INVOICE_LIST_URI,data: {'intid':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDeleteTempInvoice(String id) async {
    try {
      final response = await dioClient?.post(AppConstants.DELETE_TEMP_INVOICE_URI,data: {'intid':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}