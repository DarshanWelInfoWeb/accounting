import 'package:flutter/cupertino.dart';
import 'package:gas_accounting/data/model/body/add_customer.dart';
import 'package:gas_accounting/data/model/body/customerduereport_response.dart';
import 'package:gas_accounting/data/model/response/base/api_response.dart';
import 'package:gas_accounting/data/model/response/customerdailyreport_response.dart';
import 'package:gas_accounting/data/model/response/customerlist_response.dart';
import 'package:gas_accounting/data/model/response/editcustomerlist.dart';
import 'package:gas_accounting/data/model/response/gas_detail_response.dart';
import 'package:gas_accounting/data/repository/customer_repo.dart';
import 'package:gas_accounting/helper/api_checker.dart';

class CustomerProvider with ChangeNotifier {
  final CustomerRepo? customerRepo;

  CustomerProvider({@required this.customerRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _success="true";
  String? get success => _success;


  List<GasDetailData> _searchList=new List.empty(growable: true);
  List<GasDetailData> get searchList => _searchList;
  List<CustomerListData> _customerList=new List.empty(growable: true);
  List<CustomerListData> get customerList => _customerList;
  List<EditCustomerListData> _editCustomerList=new List.empty(growable: true);
  List<EditCustomerListData> get editCustomerList => _editCustomerList;
  List<CustomerDailyReportData> _customerDailyReportList=new List.empty(growable: true);
  List<CustomerDailyReportData> get customerDailyReportList => _customerDailyReportList;
  List<CustomerDueReportData> _customerDueReportList=new List.empty(growable: true);
  List<CustomerDueReportData> get customerDueReportList => _customerDueReportList;

  /* Get GasDetailByMobile */
  Future<void> getGasDetailByMobile(BuildContext context,String mobile,String id,Function callback) async {
    _searchList=[];
    _isLoading=true;
    notifyListeners();
    ApiResponse? apiResponse = await customerRepo?.getGasDetailByMobile(mobile,id);
    if (apiResponse?.response.data["data"] == null) {
      _isLoading = false;
    }else{
      if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
        _isLoading=false;
        print("object:::::${apiResponse?.response.data['strMsg']}");
        callback(true,apiResponse?.response.data['strMsg']);
        _searchList.addAll(GasDetailResponse.fromJson(apiResponse?.response.data).data!);
        notifyListeners();
      } else {
        callback(false,"");
        ApiChecker.checkApi(context, apiResponse!);
      }
    }
  }

  /* Add Customer */
  Future<void> getAddCustomer(BuildContext context, Add_Customer add_customer,Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await customerRepo?.getAddCustomer(add_customer);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      print("object::${apiResponse?.response.data['strMessage']}");
      _success="true";
      callback(true,apiResponse?.response.data['strMessage']);
      notifyListeners();
    }
    else {
      _isLoading = false;
      callback(false,"");
      notifyListeners();
    }
    notifyListeners();
  }

  /* Add Customer */
  Future<void> getUpdateCustomer(BuildContext context, Update_Customer add_customer,Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await customerRepo?.getCustomerUpdate(add_customer);
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

  /* Get Customer List */
  Future<void> getCustomerList(BuildContext context,String id) async {
    _customerList=[];
    _isLoading=true;
    notifyListeners();
    ApiResponse? apiResponse = await customerRepo?.getCustomerList(id);
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      _isLoading=false;
      _customerList.addAll(CustomerList_Response.fromJson(apiResponse?.response.data).data!);
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Delete Route User */
  Future<void> getDeleteCustomer(BuildContext context,String id) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await customerRepo?.getCustomerDelete(id);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMessage'] == "Customer entry deleted successfully"){
        _success = "true";
        _customerList = [];
      }else{
        _success="false";
      }
      notifyListeners();
    }
    else {
      _isLoading = false;
      notifyListeners();
    }
    notifyListeners();
  }

  /* Customer Edit */
  Future<void> getCustomerEdit(BuildContext context,String id) async {
    _editCustomerList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await customerRepo?.getCustomerEdit(id);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
        _success = "true";
        _editCustomerList.addAll(EditCustomerList_Response.fromJson(apiResponse?.response.data).data!);
      _isLoading=false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Customer Daily Report */
  Future<void> getCustomerDailyReport(BuildContext context,String companyId,String customerId,String startDate,String endDate) async {
    _customerDailyReportList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await customerRepo?.getCustomerDailyReport(companyId,customerId,startDate,endDate);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "Data Get Successfully"){
        _customerDailyReportList.addAll(CustomerDailyReport_Response.fromJson(apiResponse?.response.data).data!);
        _isLoading=false;
      }else{
        _success="false";
      }
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Customer Due Report */
  Future<void> getCustomerDueReport(BuildContext context,String companyId) async {
    _customerDueReportList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await customerRepo?.getCustomerDueReport(companyId);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "Data Get Successfully"){
        _customerDueReportList.addAll(CustomerDueReport_Response.fromJson(apiResponse?.response.data).data!);
        _isLoading=false;
      }else{
        _success="false";
      }
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Customer QR Code Generate */
  Future<void> getCustomerQRCodeGenerate(BuildContext context,String mobile,Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await customerRepo?.getCustomerQRCodeGenerate(mobile);
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

}