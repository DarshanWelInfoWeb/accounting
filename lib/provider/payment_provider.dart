import 'package:flutter/material.dart';
import 'package:gas_accounting/data/model/body/addPayment_body.dart';
import 'package:gas_accounting/data/model/response/base/api_response.dart';
import 'package:gas_accounting/data/model/response/editpayment_response.dart';
import 'package:gas_accounting/data/model/response/paymentlist_response.dart';
import 'package:gas_accounting/data/repository/payment_repo.dart';
import 'package:gas_accounting/helper/api_checker.dart';

class PaymentProvider with ChangeNotifier {
  final PaymentRepo? paymentRepo;

  PaymentProvider({@required this.paymentRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _success="true";
  String? get success => _success;

  List<PaymentListData> _paymentList = new List.empty(growable: true);
  List<PaymentListData> get paymentList => _paymentList;
  List<EditData> _editPaymentList = new List.empty(growable: true);
  List<EditData> get editPaymentList => _editPaymentList;


  /* Add Temp Payment */
  Future<void> getAddPayment(BuildContext context,AddPayment_Body payment, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await paymentRepo?.addPayment(payment);
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

  /* Update Temp Payment */
  Future<void> getUpdatePayment(BuildContext context,PaymentUpdate_Body payment, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await paymentRepo?.updatePayment(payment);
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

  /* Temp Payment List */
  Future<void> getPaymentList(BuildContext context,String? id,String year,String month,String customerId) async {
    _paymentList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await paymentRepo?.getPayment(id,year,month,customerId);
    _isLoading = false;
    if(apiResponse?.response.data["data"] == null){
      _isLoading = false;
    }{
      if (apiResponse?.response != null &&
          apiResponse?.response.statusCode == 200) {
        if (apiResponse?.response.data['strMsg'] == "Data Get Successfully") {
          _success = "true";
          _paymentList.addAll(
              PaymentList_Response.fromJson(apiResponse?.response.data).data!);
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

  /* Temp Payment Edit */
  Future<void> getPaymentEdit(BuildContext context,String id) async {
    _editPaymentList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await paymentRepo?.getPaymentEdit(id);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "Data Get Successfully"){
        _success = "true";
        _editPaymentList.addAll(EditPayment.fromJson(apiResponse?.response.data).data!);
      }else{
        _success="false";
      }
      _isLoading=false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Delete Temp Payment */
  Future<void> getDeletePayment(BuildContext context,String id) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await paymentRepo?.getDeletePayment(id);
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