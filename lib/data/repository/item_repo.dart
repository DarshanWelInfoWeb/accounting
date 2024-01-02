import 'package:flutter/cupertino.dart';
import 'package:gas_accounting/data/datasource/remote/exception/api_error_handler.dart';
import 'package:gas_accounting/data/model/response/base/api_response.dart';
import 'package:gas_accounting/data/model/response/items_response.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../datasource/remote/dio/dio_client.dart';

class ItemRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  ItemRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> getSelectUnit(String id) async {
    try {
      final response = await dioClient?.get(AppConstants.UNIT_SELECT_URI,data: {'intCompanyId':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getItemsList(String id) async {
    try {
      final response = await dioClient?.get(AppConstants.ITEM_LIST_URI,data: {'intCompanyId':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<List<ItemsListData>> fetchItems(String id) async {
    try {
      final response = await dioClient?.get(AppConstants.ITEM_LIST_URI,data: {'intCompanyId':id});
      if (response?.statusCode == 200) {
        final List<dynamic> data = response?.data['data'];
        return data.map((item) => ItemsListData.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<ApiResponse> getItemsEdit(String id) async {
    try {
      final response = await dioClient?.get(AppConstants.EDIT_ITEM_URI,data: {'intId':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDeleteItems(String id) async {
    try {
      final response = await dioClient?.post(AppConstants.DELETE_ITEM_URI,data: {'intId':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /* Item Price */

  Future<ApiResponse> getItemsPriceList(String id) async {
    try {
      final response = await dioClient?.get(AppConstants.ITEM_PRICE_LIST_URI,data: {'intCompanyId':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getAddItemPrice(AddItemPriceBody addItemPriceBody) async {
    try {
      final response = await dioClient?.post(AppConstants.ADD_ITEM_PRICE_URI,data: addItemPriceBody.toJson());
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}