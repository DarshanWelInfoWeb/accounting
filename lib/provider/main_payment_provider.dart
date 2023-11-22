import 'package:flutter/material.dart';
import 'package:gas_accounting/data/model/body/main_payment_body.dart';
import 'package:gas_accounting/data/model/response/base/api_response.dart';
import 'package:gas_accounting/data/model/response/main_payment_response.dart';
import 'package:gas_accounting/data/repository/main_payment_repo.dart';
import 'package:gas_accounting/helper/api_checker.dart';

class MainPaymentProvider with ChangeNotifier {
  final MainPaymentRepo? mainPaymentRepo;

  MainPaymentProvider({@required this.mainPaymentRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _success="true";
  String? get success => _success;

  List<MainPaymentData> _paymentList = new List.empty(growable: true);
  List<MainPaymentData> get paymentList => _paymentList;


  /* Add Main Payment */
  Future<void> getAddMainPayment(BuildContext context,Add_Main_Payment_Body payment, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await mainPaymentRepo?.addMainPayment(payment);
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

  /* Update Main Payment */
  Future<void> getUpdateMainPayment(BuildContext context,Edit_Main_Payment_Body payment, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await mainPaymentRepo?.updateMainPayment(payment);
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

  /* Main Payment List */
  Future<void> getMainPaymentList(BuildContext context,String? id,String year,String month,String customerId) async {
    _paymentList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await mainPaymentRepo?.getMainPayment(id,year,month,customerId);
    _isLoading = false;
    if(apiResponse?.response.data["data1"] == null){
      _isLoading = false;
    }{
      if (apiResponse?.response != null &&
          apiResponse?.response.statusCode == 200) {
        if (apiResponse?.response.data['strmsg'] == "Data Get Successfully") {
          _success = "true";
          _paymentList.addAll(Main_Payment_List_Response.fromJson(apiResponse?.response.data).data1!);
        } else {
          _success = "false";
        }
        _isLoading = false;
        notifyListeners();
      } else {
        ApiChecker.checkApi(context, apiResponse!);
      }
    }
  }


  /* Delete Main Payment */
  Future<void> getDeleteMainPayment(BuildContext context,String id) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await mainPaymentRepo?.getDeleteMainPayment(id);
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