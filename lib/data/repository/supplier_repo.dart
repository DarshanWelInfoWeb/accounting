import 'package:flutter/cupertino.dart';
import 'package:gas_accounting/data/datasource/remote/dio/dio_client.dart';
import 'package:gas_accounting/data/datasource/remote/exception/api_error_handler.dart';
import 'package:gas_accounting/data/model/body/addunitmaster_body.dart';
import 'package:gas_accounting/data/model/body/supplier_body.dart';
import 'package:gas_accounting/data/model/response/base/api_response.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupplierRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  SupplierRepo({@required this.dioClient, this.sharedPreferences});

  Future<ApiResponse> getAddSupplier(AddSupplierBody addSupplierBody) async {
    try {
      final response = await dioClient?.post(AppConstants.ADD_SUPPLIER_URI,data: addSupplierBody.toJson());
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getUpdateSupplier(UpdateSupplierBody updateSupplierBody) async {
    try {
      final response = await dioClient?.post(AppConstants.UPDATE_SUPPLIER_URI,data: updateSupplierBody.toJson());
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDeleteSupplier(String id) async {
    try {
      final response = await dioClient?.post(AppConstants.DELETE_SUPPLIER_URI,data: {'intid':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSupplierList(String id) async {
    try {
      final response = await dioClient?.get("${AppConstants.SUPPLIER_LIST_URI}$id");
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSupplierInvoiceItemSelectList(String itemId,String supplierId,String companyId) async {
    try {
      final response = await dioClient?.get(AppConstants.SUPPLIER_ITEM_LIST_URI,data: {'intitemid':itemId,'intSupplierid':supplierId,'intcompanyid':companyId});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSupplierInvoiceTax(String id) async {
    try {
      final response = await dioClient?.get(AppConstants.SUPPLIER_TAX_URI,data: {'intid':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  /* Supplier Invoice */

  Future<ApiResponse> getDeleteSupplierInvoice(String id) async {
    try {
      final response = await dioClient?.post(AppConstants.DELETE_SUPPLIER_INVOICE_URI,data: {'intid':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addSupplierItem(Item_Body route) async {
    try {
      final response = await dioClient?.post(AppConstants.ADD_SUPPLIER_ITEM_URI,data: route.toJson());
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSupplierInvoiceList(String companyId,String startDate,String endDate,String supplierId) async {
    try {
      final response = await dioClient?.get("${AppConstants.SUPPLIER_INVOICE_LIST_URI}intComapnyId=$companyId&dtstartdate=$startDate&dtenddate=$endDate&intSupplierId=$supplierId");
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getUpdateSupplierInvoice(String id) async {
    try {
      final response = await dioClient?.get(AppConstants.UPDATE_SUPPLIER_INVOICE_URI,data: {'intid':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSupplierInvoiceItemList(String id) async {
    try {
      final response = await dioClient?.get(AppConstants.SUPPLIER_INVOICE_ITEM_LIST_URI,data: {'intInvoiceid':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDeleteSupplierInvoiceItem(String id) async {
    try {
      final response = await dioClient?.post(AppConstants.DELETE_SUPPLIER_INVOICE_ITEM_URI,data: {'intid':id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  /* Supplier Payment */

  Future<ApiResponse> addSupplierPayment(AddSupplierPaymentBody supplierPaymentBody) async {
    try {
      final response = await dioClient?.post(AppConstants.ADD_SUPPLIER_PAYMENT_URI,data: supplierPaymentBody.toJson());
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> deleteSupplierPayment(String id) async {
    try {
      final response = await dioClient?.post(AppConstants.DELETE_SUPPLIER_PAYMENT_URI,data: {'intid': id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSupplierPaymentList(String companyId,String startDate,String endDate,String supplierId) async {
    try {
      final response = await dioClient?.get("${AppConstants.SUPPLIER_PAYMENT_LIST_URI}intCompanyid=$companyId&dtstartdate=$startDate&dtenddate=$endDate&intSupplierId=$supplierId");
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /* Unit Master */

  Future<ApiResponse> getAddUnit(AddUnitBody unitBody) async {
    try {
      final response = await dioClient?.post(AppConstants.ADD_UNIT_MASTER_URI,data: unitBody.toJson());
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> deleteUnitMaster(String id) async {
    try {
      final response = await dioClient?.post(AppConstants.DELETE_UNIT_MASTER_URI,data: {'intid': id});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getUnitMasterList(String id) async {
    try {
      final response = await dioClient?.get("${AppConstants.UNIT_MASTER_LIST_URI}$id");
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getUnitMasterStatusChange(String id,String companyId) async {
    try {
      final response = await dioClient?.get(AppConstants.CHANGE_STATUS_UNIT_MASTER_URI,data: {'intid':id,'intCompanyid':companyId});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}