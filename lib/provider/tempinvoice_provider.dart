import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gas_accounting/data/model/body/add_tempinvoice.dart';
import 'package:gas_accounting/data/model/body/route.dart';
import 'package:gas_accounting/data/model/response/base/api_response.dart';
import 'package:gas_accounting/data/model/response/edittempinvoice_response.dart';
import 'package:gas_accounting/data/model/response/tempinvoicelist_response.dart';
import 'package:gas_accounting/data/model/response/tempstock_response.dart';
import 'package:gas_accounting/data/repository/tempinvoice_repo.dart';
import 'package:gas_accounting/helper/api_checker.dart';

class TempInvoiceProvider with ChangeNotifier {
  final TempInvoiceRepo? tempInvoiceRepo;

  TempInvoiceProvider({@required this.tempInvoiceRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadings = false;
  bool get isLoadings => _isLoadings;

  int _currentPage = 1;

  String? _success = "true";
  String? get success => _success;

  int? _invoiceId = 0;
  int? get invoiceId => _invoiceId;

  List<TempInvoiceData> _tempInvoiceList = new List.empty(growable: true);
  List<TempInvoiceData> get tempInvoiceList => _tempInvoiceList;

  List<EditTempInvoiceData> _editTempInvoiceList = new List.empty(growable: true);
  List<EditTempInvoiceData> get editTempInvoiceList => _editTempInvoiceList;

  List<TempStockData> _tempStockList = new List.empty(growable: true);
  List<TempStockData> get tempStockList => _tempStockList;


  /* Add Temp Invoice */
  Future<void> getAddTempInvoice(BuildContext context,AddTempInvoiceBody temp, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await tempInvoiceRepo?.addTempInvoice(temp);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      _invoiceId = apiResponse?.response.data['data']['intid'];
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

  /* Add Temp Invoice */
  Future<void> getUpdateTempInvoice(BuildContext context,UpdateTempInvoiceBody temp, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await tempInvoiceRepo?.updateTempInvoice(temp);
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

  /* Add Temp Stock */
  Future<void> getAddItem(BuildContext context,TempStock_Body route) async {
    _tempInvoiceList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await tempInvoiceRepo?.addTempStock(route);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      _success="true";
      // callback(true);
      notifyListeners();
    }
    else {
      _isLoading = false;
      // callback(false);
      notifyListeners();
    }
    notifyListeners();
  }

  /* Temp Stock List */
  Future<void> getTempStockList(BuildContext context,String id,String gst,String companyId) async {
    _tempStockList = [];
    _isLoading = true;
    // notifyListeners();
    ApiResponse? apiResponse = await tempInvoiceRepo?.getTempStockList(id,gst,companyId);
    _isLoading = false;
    if(apiResponse?.response.data["data"] == null){
      _isLoading = false;
    }else{
      if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
        // if(apiResponse?.response.data['strMsg'] == "Data Get Successfully"){
        _success = "true";
        _tempStockList.addAll(TempStockList_Response.fromJson(apiResponse?.response.data).data!);
        // }else{
        //   _success="false";
        // }
        _isLoading=false;
        notifyListeners();
      } else {
        ApiChecker.checkApi(context, apiResponse!);
      }
    }
  }

  void updateList(int index) {
    print("index::::$index");
    tempStockList.removeAt(index);
    print("updateList:::${tempStockList.length}");
    notifyListeners();
  }

  /* Delete Temp Stock */
  Future<void> getDeleteTempStock(BuildContext context,String id) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await tempInvoiceRepo?.getDeleteTempStock(id);
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

  /* Temp Invoice List */
  Future<void> getTempInvoiceList(BuildContext context,String id,String year,String month,String customerId) async {
    _tempInvoiceList = [];
    _isLoading = true;
    ApiResponse? apiResponse = await tempInvoiceRepo?.getTempInvoice(id,year,month,customerId);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "Data Get Successfully"){
        _success = "true";
        _tempInvoiceList.addAll(TempInvoiceList_Response.fromJson(apiResponse?.response.data).data!);
      }else{
        _success="false";
      }
      _isLoading=false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Temp Invoice Edit */
  Future<void> getTempInvoiceEdit(BuildContext context,String id) async {
    _editTempInvoiceList = [];
    _isLoading = true;
    // notifyListeners();
    ApiResponse? apiResponse = await tempInvoiceRepo?.getTempInvoiceEdit(id);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "Data Get Successfully"){
        _success = "true";
        _editTempInvoiceList.addAll(EditTempInvoiceResponse.fromJson(apiResponse?.response.data).data!);
      }else{
        _success="false";
      }
      _isLoading=false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Delete Temp Invoice */
  Future<void> getDeleteTempInvoice(BuildContext context,String id) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await tempInvoiceRepo?.getDeleteTempInvoice(id);
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