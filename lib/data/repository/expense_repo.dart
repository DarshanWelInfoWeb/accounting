import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:gas_accounting/data/datasource/remote/exception/api_error_handler.dart';
import 'package:gas_accounting/data/model/body/addexpense_body.dart';
import 'package:gas_accounting/data/model/body/addexpensetype_body.dart';
import 'package:gas_accounting/data/model/response/base/api_response.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../datasource/remote/dio/dio_client.dart';

class ExpenseRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  ExpenseRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> getSelectExpenseType(String id) async {
    try {
      final response = await dioClient?.get("${AppConstants.SELECT_EXPENSE_TYPE_LIST_URI}$id");
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getExpenseList(String id,String startDate,String endDate) async {
    try {
      final response = await dioClient?.get("${AppConstants.EXPENSE_LIST_URI}?intCompanyId=$id&dtstartdate=$startDate&dtenddate=$endDate");
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addExpense(AddExpense_Body expense) async {
    try {
      final response = await dioClient?.post(AppConstants.ADD_EXPENSE_URI,data: expense.toJson());
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateExpense(UpdateExpense_Body expense) async {
    try {
      final response = await dioClient?.post(AppConstants.ADD_EXPENSE_URI,data: expense.toJson());
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getExpenseEdit(String id) async {
    try {
      final response = await dioClient?.get(AppConstants.EDIT_EXPENSE_URI,data: {'intid':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDeleteExpense(String id) async {
    try {
      final response = await dioClient?.post(AppConstants.DELETE_EXPENSE_URI,data: {'intid':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /* Expense Type Manage */

  Future<ApiResponse> getAddExpenseType(AddExpenseTypeBody addExpenseTypeBody) async {
    try {
      final response = await dioClient?.post(AppConstants.ADD_EXPENSE_TYPE_URI,data: addExpenseTypeBody.toJson());
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDeleteExpenseType(String id,String userId) async {
    try {
      final response = await dioClient?.post(AppConstants.DELETE_EXPENSE_TYPE_URI,data: {'intid':id,'intUserId':userId});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getExpenseTypeList(String companyId) async {
    try {
      final response = await dioClient?.get(AppConstants.EXPENSE_TYPE_LIST_URI,data: {'intCompanyId':companyId});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getEditExpenseTypeList(String id,String companyId) async {
    try {
      final response = await dioClient?.get(AppConstants.EDIT_EXPENSE_TYPE_LIST_URI,data: {'intId':id,'intCompanyId':companyId});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getExpenseStatusChange(String id,String status,String companyId) async {
    print("object::$id ::$status:: $companyId");
    try {
      final response = await dioClient?.post(AppConstants.CHANGE_STATUS_EXPENSE_TYPE_URI,data: {'intId':id,'bisStatus':status,'intCompanyId':companyId});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}