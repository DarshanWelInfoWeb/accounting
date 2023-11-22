import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gas_accounting/data/model/body/addexpense_body.dart';
import 'package:gas_accounting/data/model/response/base/api_response.dart';
import 'package:gas_accounting/data/model/response/dailyupdate_response.dart';
import 'package:gas_accounting/data/model/response/dailywise_response.dart';
import 'package:gas_accounting/data/model/response/dashboard_response.dart';
import 'package:gas_accounting/data/model/response/expenselisr_response.dart';
import 'package:gas_accounting/data/model/response/expensetype_response.dart';
import 'package:gas_accounting/data/repository/dashboard_repo.dart';
import 'package:gas_accounting/data/repository/expense_repo.dart';
import 'package:gas_accounting/helper/api_checker.dart';

class DashboardProvider with ChangeNotifier {
  final DashboardRepo? dashboardRepo;

  DashboardProvider({@required this.dashboardRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _success = "true";
  String? get success => _success;

  List<DashboardData> _dashboardList = new List.empty(growable: true);
  List<DashboardData> get dashboardList => _dashboardList;
  List<DailyUpdateData> _dailyUpdateList = new List.empty(growable: true);
  List<DailyUpdateData> get dailyUpdateList => _dailyUpdateList;
  List<DailyWiseReportData> _dailyWiseList = new List.empty(growable: true);
  List<DailyWiseReportData> get dailyWiseList => _dailyWiseList;
  List<ProfitLossData> _profitLossList = new List.empty(growable: true);
  List<ProfitLossData> get profitLossList => _profitLossList;
  List<SalesChartData> _salesChartList = new List.empty(growable: true);
  List<SalesChartData> get salesChartList => _salesChartList;
  List<SalesPaymentChartData> _salesPaymentChartList = new List.empty(growable: true);
  List<SalesPaymentChartData> get salesPaymentChartList => _salesPaymentChartList;


  /* Dashboard Count */
  Future<void> getUserAccountCount(BuildContext context,String id,String companyId) async {
    _dashboardList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await dashboardRepo?.getUserAccountCount(id,companyId);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      print("object:::::if");
        _success = "true";
        _dashboardList.addAll(Dashboard_Response.fromJson(apiResponse?.response.data).data!);
        _isLoading=false;
      notifyListeners();
    } else {
      print("object:::::else");
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Daily update */
  Future<void> getDailyUpdate(BuildContext context,String date,String companyId) async {
    _dailyUpdateList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await dashboardRepo?.getDailyUpdate(date,companyId);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMessage'] == "Data Get Successfully"){
        _success = "true";
        _dailyUpdateList.addAll(DailyUpdateList_Response.fromJson(apiResponse?.response.data).data!);
      }else{
        _success="false";
      }
      _isLoading=false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Daily Wise Report */
  Future<void> getDailyWiseReport(BuildContext context,String companyId,String dtFromDate,String dtToDate) async {
    _dailyWiseList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await dashboardRepo?.getDailyWiseReport(companyId,dtFromDate,dtToDate);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "Data Get Successfully"){
        _success = "true";
        _dailyWiseList.addAll(DailyWiseReport_Response.fromJson(apiResponse?.response.data).data!);
      }else{
        _success="false";
      }
      _isLoading=false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Profit and Loss Report */
  Future<void> getProfitAndLossReport(BuildContext context,String companyId,String startDate,String endDate) async {
    _profitLossList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await dashboardRepo?.getProfitAndLoss(companyId,startDate,endDate);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "Data Get Successfully"){
        _success = "true";
        _profitLossList.addAll(ProfitLossResponseList.fromJson(apiResponse?.response.data).data1!);
      }else{
        _success="false";
      }
      _isLoading=false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Sales Chart */
  Future<void> getSalesChart(BuildContext context,String companyId,String startDate,String endDate) async {
    _salesChartList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await dashboardRepo?.getSalesChart(companyId,startDate,endDate);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "Data Get Successfully"){
        _success = "true";
        _salesChartList.addAll(SalesChartResponse.fromJson(apiResponse?.response.data).data!);
      }else{
        _success="false";
      }
      _isLoading=false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Sales and Payment Chart */
  Future<void> getSalesPaymentChart(BuildContext context,String companyId,String startDate,String endDate) async {
    _salesPaymentChartList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await dashboardRepo?.getSalesPaymentChart(companyId,startDate,endDate);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "Data Get Successfully"){
        _success = "true";
        _salesPaymentChartList.addAll(SalesPaymentChartResponse.fromJson(apiResponse?.response.data).data!);
      }else{
        _success="false";
      }
      _isLoading=false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

}