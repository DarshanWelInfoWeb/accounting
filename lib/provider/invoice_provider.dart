import 'package:flutter/cupertino.dart';
import 'package:gas_accounting/data/model/response/base/api_response.dart';
import 'package:gas_accounting/data/model/response/editmaininvoice_response.dart';
import 'package:gas_accounting/data/model/response/maininvoicelist_response.dart';
import 'package:gas_accounting/data/model/response/maininvopciestock_response.dart';
import 'package:gas_accounting/data/repository/invoice_repo.dart';
import 'package:gas_accounting/helper/api_checker.dart';

class InvoiceProvider with ChangeNotifier {
  final InvoiceRepo? invoiceRepo;

  InvoiceProvider({@required this.invoiceRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _success = "true";

  String? get success => _success;
  int? _invoiceId = 0;

  int? get invoiceId => _invoiceId;

  List<MainInvoiceListData> _mainInvoiceList = new List.empty(growable: true);
  List<MainInvoiceListData> get mainInvoiceList => _mainInvoiceList;
  List<EditMainInvoiceData> _editMainInvoiceList = new List.empty(growable: true);
  List<EditMainInvoiceData> get editMainInvoiceList => _editMainInvoiceList;
  List<MainInvoiceStockData> _mainInvoiceStockList = new List.empty(growable: true);
  List<MainInvoiceStockData> get mainInvoiceStockList => _mainInvoiceStockList;


  /* Delete Main Invoice */
  Future<void> getDeleteMainInvoice(BuildContext context,String id) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await invoiceRepo?.getDeleteMainInvoice(id);
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

  /* Temp Main List */
  Future<void> getMainInvoiceList(BuildContext context,String id,String year,String month,String customerId) async {
    _mainInvoiceList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await invoiceRepo?.getMainInvoiceList(id,year,month,customerId);
    _isLoading = false;
    if(apiResponse?.response.data["data"] == null){
      _isLoading = false;
    }else{
      if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
        if (apiResponse?.response.data['strMsg'] == "Data Get Successfully") {
          _success = "true";
          _mainInvoiceList.addAll(MainInvoiceList_Reponse.fromJson(apiResponse?.response.data).data!);
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

  /* Main Invoice Edit */
  Future<void> getMainInvoiceEdit(BuildContext context,String id) async {
    _editMainInvoiceList = [];
    _isLoading = true;
    // notifyListeners();
    ApiResponse? apiResponse = await invoiceRepo?.getMainInvoiceEdit(id);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "Data Get Successfully"){
        _success = "true";
        _editMainInvoiceList.addAll(EditMainInvoice_Reponse.fromJson(apiResponse?.response.data).data!);
      }else{
        _success="false";
      }
      _isLoading=false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Main Invoice Stock List */
  Future<void> getMainInvoiceStockList(BuildContext context,String id) async {
    _mainInvoiceStockList = [];
    _isLoading = true;
    // notifyListeners();
    ApiResponse? apiResponse = await invoiceRepo?.getMainInvoiceStockList(id);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "Data Get Successfully"){
        _success = "true";
        _mainInvoiceStockList.addAll(MainInvoiceStock_Response.fromJson(apiResponse?.response.data).data!);
      }else{
        _success="false";
      }
      _isLoading=false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Delete Main Invoice Stock */
  Future<void> getDeleteMainInvoiceStock(BuildContext context,String id) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await invoiceRepo?.getDeleteMainInvoiceStock(id);
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