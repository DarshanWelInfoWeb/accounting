import 'package:flutter/cupertino.dart';
import 'package:gas_accounting/data/datasource/remote/dio/dio_client.dart';
import 'package:gas_accounting/data/datasource/remote/exception/api_error_handler.dart';
import 'package:gas_accounting/data/model/response/base/api_response.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  InvoiceRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> getDeleteMainInvoice(String id) async {
    try {
      final response = await dioClient?.post(AppConstants.DELETE_MAIN_INVOICE_URI,data: {'intid':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getMainInvoiceList(String id,String year,String month,String customerId) async {
    try {
      final response = await dioClient?.get("${AppConstants.MAIN_INVOICE_LIST_URI}?intComapnyId=$id&dtstartdate=$year&dtenddate=$month&intCustomerId=$customerId");
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getMainInvoiceEdit(String id) async {
    try {
      final response = await dioClient?.get(AppConstants.MAIN_INVOICE_EDIT_URI,data: {'intid':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getMainInvoiceStockList(String id) async {
    try {
      final response = await dioClient?.get(AppConstants.MAIN_INVOICE_STOCK_LIST_URI,data: {'intinvoiceid':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDeleteMainInvoiceStock(String id) async {
    try {
      final response = await dioClient?.post(AppConstants.DELETE_MAIN_INVOICE_STOCK_URI,data: {'intid':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}