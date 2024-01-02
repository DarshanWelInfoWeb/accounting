import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gas_accounting/data/model/body/addexpense_body.dart';
import 'package:gas_accounting/data/model/body/addexpensetype_body.dart';
import 'package:gas_accounting/data/model/response/base/api_response.dart';
import 'package:gas_accounting/data/model/response/expenselisr_response.dart';
import 'package:gas_accounting/data/model/response/expensetype_response.dart';
import 'package:gas_accounting/data/repository/expense_repo.dart';
import 'package:gas_accounting/helper/api_checker.dart';

class ExpenseProvider with ChangeNotifier {
  final ExpenseRepo? expenseRepo;

  ExpenseProvider({@required this.expenseRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _success = "true";
  String? get success => _success;

  List<ExpenseTypeData> _selectExpenseTypeList = new List.empty(growable: true);
  List<ExpenseTypeData> get selectExpenseTypeList => _selectExpenseTypeList;
  List<ExpenseListData> _expenseList = new List.empty(growable: true);
  List<ExpenseListData> get expenseList => _expenseList;
  List<ExpenseEditData> _expenseEdit = new List.empty(growable: true);
  List<ExpenseEditData> get expenseEdit => _expenseEdit;
  List<ExpenseTypeListData> _expenseTypeList = new List.empty(growable: true);
  List<ExpenseTypeListData> get expenseTypeList => _expenseTypeList;
  List<EditExpenseTypeData> _expenseTypeEdit = new List.empty(growable: true);
  List<EditExpenseTypeData> get expenseTypeEdit => _expenseTypeEdit;

  String _mprofile_url = "";
  String get image => _mprofile_url;

  /* Expense Type List */
  Future<void> getExpenseType(BuildContext context,String id) async {
    _selectExpenseTypeList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await expenseRepo?.getSelectExpenseType(id);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
        _success = "true";
        _selectExpenseTypeList.addAll(ExpenseType_Response.fromJson(apiResponse?.response.data).data!);
      _isLoading=false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Expense List */
  Future<void> getExpenseList(BuildContext context,String id,String startDate,String endDate) async {
    _expenseList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await expenseRepo?.getExpenseList(id,startDate,endDate);
    _isLoading = false;
    if (apiResponse?.response.data["data1"] == null) {
      _isLoading = false;
    }  else {
      if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
        _success = "true";
        _expenseList.addAll(ExpensList_Response.fromJson(apiResponse?.response.data).data1!);
        _isLoading = false;
        notifyListeners();
      } else {
        ApiChecker.checkApi(context, apiResponse!);
      }
    }
  }

  /* Add Expense */
  Future<void> getAddExpense(BuildContext context,AddExpense_Body expense, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await expenseRepo?.addExpense(expense);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      _success="true";
      callback(true);
      notifyListeners();
    } else {
      _isLoading = false;
      callback(false);
      notifyListeners();
    }
    notifyListeners();
  }

  /* Update Expense */
  Future<void> getUpdateExpense(BuildContext context,UpdateExpense_Body expense, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await expenseRepo?.updateExpense(expense);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      _success="true";
      callback(true);
      notifyListeners();
    } else {
      _isLoading = false;
      callback(false);
      notifyListeners();
    }
    notifyListeners();
  }

  /* Expense Edit */
  Future<void> getExpenseEdit(BuildContext context,String id) async {
    _expenseEdit = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await expenseRepo?.getExpenseEdit(id);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "Data Get Successfully"){
        _success = "true";
        _expenseEdit.addAll(ExpenseEdit_Response.fromJson(apiResponse?.response.data).data!);
      }else{
        _success="false";
      }
      _isLoading=false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Delete Expense */
  Future<void> getDeleteExpense(BuildContext context,String id) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await expenseRepo?.getDeleteExpense(id);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      _success="true";
      notifyListeners();
    }
    else {
      _isLoading = false;
      notifyListeners();
    }
    notifyListeners();
  }


  /* Expense Type Manage */

  /* Add Expense Type */
  Future<void> getAddExpenseType(BuildContext context,AddExpenseTypeBody addExpenseTypeBody,Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await expenseRepo?.getAddExpenseType(addExpenseTypeBody);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      _success="true";
      callback(true);
      notifyListeners();
    }
    else {
      _isLoading = false;
      callback(false);
      notifyListeners();
    }
    notifyListeners();
  }

  /* Delete Expense Type */
  Future<void> getDeleteExpenseType(BuildContext context,String id,String userId) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await expenseRepo?.getDeleteExpenseType(id,userId);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      _success="true";
      notifyListeners();
    }
    else {
      _isLoading = false;
      notifyListeners();
    }
    notifyListeners();
  }

  /* Expense Type List */
  Future<void> getExpenseTypeList(BuildContext context,String companyId) async {
    _expenseTypeList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await expenseRepo?.getExpenseTypeList(companyId);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMessage'] == "Expense list get successfully."){
        _success = "true";
        _expenseTypeList.addAll(ExpenseTypeListResponse.fromJson(apiResponse?.response.data).data!);
      }else{
        _success="false";
      }
      _isLoading=false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Expense Edit */
  Future<void> getEditExpenseTypeList(BuildContext context,String id,String companyId) async {
    _expenseTypeEdit = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await expenseRepo?.getEditExpenseTypeList(id,companyId);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMessage'] == "Edit expense type list get successfully."){
        _success = "true";
        _expenseTypeEdit.addAll(EditExpenseTypeListResponse.fromJson(apiResponse?.response.data).data!);
      }else{
        _success="false";
      }
      _isLoading=false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Change Status Expense Type */
  Future<void> getStatusChangeExpenseType(BuildContext context,String id,String status,String userId) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await expenseRepo?.getExpenseStatusChange(id,status,userId);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      _success="true";
      notifyListeners();
    }
    else {
      _isLoading = false;
      notifyListeners();
    }
    notifyListeners();
  }

}