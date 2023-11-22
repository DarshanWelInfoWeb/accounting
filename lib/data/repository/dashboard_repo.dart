import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_accounting/data/datasource/remote/exception/api_error_handler.dart';
import 'package:gas_accounting/data/model/body/addexpense_body.dart';
import 'package:gas_accounting/data/model/response/base/api_response.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../datasource/remote/dio/dio_client.dart';

class DashboardRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  DashboardRepo({@required this.dioClient, @required this.sharedPreferences});

  late BuildContext context;

  Future<ApiResponse> getUserAccountCount(String intId,String companyId) async {
    try {
      final response = await dioClient?.get(AppConstants.DASHBOARD_COUNT_URI,data: {'intId':intId,'intCompanyid':companyId});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      // AppConstants.getToast("${e}");
      print("object::$e");
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDailyUpdate(String date,String companyId) async {
    try {
      final response = await dioClient?.get(AppConstants.DAILY_UPDATE_URI,data: {'dtInvoiceDate':date,'intCompanyId':companyId});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDailyWiseReport(String companyId,String dtFromDate,String dtToDate) async {
    try {
      final response = await dioClient?.get(AppConstants.DAILY_WISE_REPORTE_URI,data: {'intCompanyid':companyId,'dtFromDate':dtFromDate,'dtToDate':dtToDate});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getProfitAndLoss(String companyId,String startDate,String endDate) async {
    try {
      final response = await dioClient?.get("${AppConstants.PROFIT_LOSSS_LIST_URI}intCompanyid=$companyId&startDate=$startDate&Enddate=$endDate");
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSalesChart(String companyId,String startDate,String endDate) async {
    try {
      final response = await dioClient?.get("${AppConstants.SALES_CHART_LIST_URI}intComapnyId=$companyId&dtstartdate=$startDate&dtenddate=$endDate");
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSalesPaymentChart(String companyId,String startDate,String endDate) async {
    try {
      final response = await dioClient?.get("${AppConstants.BAR_CHART_LIST_URI}intComapnyId=$companyId&dtstartdate=$startDate&dtenddate=$endDate");
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}