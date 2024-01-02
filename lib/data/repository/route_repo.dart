import 'package:flutter/foundation.dart';
import 'package:gas_accounting/data/datasource/remote/dio/dio_client.dart';
import 'package:gas_accounting/data/datasource/remote/exception/api_error_handler.dart';
import 'package:gas_accounting/data/model/body/route.dart';
import 'package:gas_accounting/data/model/response/base/api_response.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouteRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  RouteRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> addRoute(Add_Route route) async {
    try {
      final response = await dioClient?.post(AppConstants.ADD_ROUTE_URI,data: route.toJson());
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateRoute(UpdateRoute_Body route) async {
    try {
      final response = await dioClient?.post(AppConstants.ADD_ROUTE_URI,data: route.toJson());
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addInsertStock(InsertStock_Body route) async {
    try {
      final response = await dioClient?.post(AppConstants.InsertStockAndQty_URI,data: route.toJson());
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getStockList(String id) async {
    try {
      final response = await dioClient?.get("${AppConstants.StockAndQty_LIST_URI}$id");
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDeleteStock(String id) async {
    try {
      final response = await dioClient?.post(AppConstants.DeleteStockAndQty_URI,data: {'intId':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getItem(String companyId,String customerId,String intId) async {
    try {
      final response = await dioClient?.get(AppConstants.SELECT_ITEM_LIST_URI,data: {'intCompanyId':companyId,'intCustomerId':customerId,'intId':intId});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDriverHelper(String companyId,String userId) async {
    try {
      final response = await dioClient?.get(AppConstants.DRIVER_LIST_URI,data: {'intCompanyId':companyId,'intUserType':userId});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getRouteUser(String id,String year,String month) async {
    try {
      final response = await dioClient?.get("${AppConstants.ROUTE_LIST_URI}?intComapnyId=$id&dtyear=$year&dtmonth=$month");
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDeleteRouteUser(String id) async {
    try {
      final response = await dioClient?.post(AppConstants.DELETE_ROUTE_LIST_URI,data: {'intid':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getRouteUserDetail(String id) async {
    try {
      final response = await dioClient?.get(AppConstants.ROUTE_DETAIL_LIST_URI,data: {'intid':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSelectRoute(String id) async {
    try {
      final response = await dioClient?.get("${AppConstants.SELECT_ROUTE_URI}$id");
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}