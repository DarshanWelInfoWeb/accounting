import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gas_accounting/data/model/body/addunitmaster_body.dart';
import 'package:gas_accounting/data/model/body/supplier_body.dart';
import 'package:gas_accounting/data/model/response/base/api_response.dart';
import 'package:gas_accounting/data/model/response/supplier_response.dart';
import 'package:gas_accounting/data/model/response/unitmaster_response.dart';
import 'package:gas_accounting/data/repository/supplier_repo.dart';
import 'package:gas_accounting/helper/api_checker.dart';

class SupplierProvider with ChangeNotifier{
  final SupplierRepo? supplierRepo;

  SupplierProvider({@required this.supplierRepo});
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _success = "true";
  String? get success => _success;


  List<SupplierData> _supplierList=new List.empty(growable: true);
  List<SupplierData> get supplierList => _supplierList;
  List<SupplierInvoiceData> _supplierInvoiceList=new List.empty(growable: true);
  List<SupplierInvoiceData> get supplierInvoiceList => _supplierInvoiceList;
  List<SupplierInvoiceData1> _updateSupplierInvoice=new List.empty(growable: true);
  List<SupplierInvoiceData1> get updateSupplierInvoice => _updateSupplierInvoice;
  List<SupplierInvoiceItemData1> _supplierInvoiceItemList=new List.empty(growable: true);
  List<SupplierInvoiceItemData1> get supplierInvoiceItemList => _supplierInvoiceItemList;
  List<SupplierPaymentData> _supplierPaymentList=new List.empty(growable: true);
  List<SupplierPaymentData> get supplierPaymentList => _supplierPaymentList;
  List<SupplierSelectItemData1> _supplierSelectItemList=new List.empty(growable: true);
  List<SupplierSelectItemData1> get supplierSelectItemList => _supplierSelectItemList;
  List<SupplierCGSTData> _supplierCGST=new List.empty(growable: true);
  List<SupplierCGSTData> get supplierCGST => _supplierCGST;
  List<SupplierSGSTData> _supplierSGST=new List.empty(growable: true);
  List<SupplierSGSTData> get supplierSGST => _supplierSGST;
  List<UnitMasterData> _unitMasterList=new List.empty(growable: true);
  List<UnitMasterData> get unitMasterList => _unitMasterList;


  /* Add Supplier */
  Future<void> getAddSupplier(BuildContext context, AddSupplierBody addSupplierBody,Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await supplierRepo?.getAddSupplier(addSupplierBody);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      print("object::${apiResponse?.response.data['strMsg']}");
      _success="true";
      callback(true);
      notifyListeners();
    }
    else {
      _isLoading = false;
      callback(false,);
      notifyListeners();
    }
    notifyListeners();
  }

  /* Update Supplier */
  Future<void> getUpdateSupplier(BuildContext context, UpdateSupplierBody updateSupplierBody,Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await supplierRepo?.getUpdateSupplier(updateSupplierBody);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      print("object::${apiResponse?.response.data['strMsg']}");
      _success="true";
      callback(true);
      notifyListeners();
    }
    else {
      _isLoading = false;
      callback(false,);
      notifyListeners();
    }
    notifyListeners();
  }

  /* Delete Supplier */
  Future<void> getDeleteSupplier(BuildContext context,String id) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await supplierRepo?.getDeleteSupplier(id);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "Data Has Been Deleted Successfully"){
        _success = "true";
        _supplierList = [];
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

  /* Supplier List */
  Future<void> getSupplierList(BuildContext context,String id) async {
    _supplierList=[];
    _isLoading=true;
    notifyListeners();
    ApiResponse? apiResponse = await supplierRepo?.getSupplierList(id);
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      _isLoading=false;
      _supplierList.addAll(SupplierListResponse.fromJson(apiResponse?.response.data).data!);
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Supplier Invoice */

  /* Supplier Item Select List */
  Future<void> getSupplierItemSelectList(BuildContext context,String itemId,String supplierId,String companyId) async {
    _supplierSelectItemList=[];
    _isLoading=true;
    // notifyListeners();
    ApiResponse? apiResponse = await supplierRepo?.getSupplierInvoiceItemSelectList(itemId,supplierId,companyId);
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      _isLoading=false;
      _supplierSelectItemList.addAll(SupplierSelectItemListResponse.fromJson(apiResponse?.response.data).data1!);
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Supplier Tax */
  Future<void> getSupplierTax(BuildContext context,String itemId,) async {
    _supplierSGST=[];
    _isLoading=true;
    // notifyListeners();
    ApiResponse? apiResponse = await supplierRepo?.getSupplierInvoiceTax(itemId);
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      _isLoading=false;
      print("sgst :: ${apiResponse?.response.data['data'][0]['strValue']}");
      _supplierSGST.addAll(SupplierSGSTResponse.fromJson(apiResponse?.response.data).data!);
      _supplierCGST.addAll(SupplierCGSTResponse.fromJson(apiResponse?.response.data).data!);
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Delete Supplier Invoice */
  Future<void> getDeleteSupplierInvoice(BuildContext context,String id) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await supplierRepo?.getDeleteSupplierInvoice(id);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "Data Has Been Deleted Successfully"){
        _success = "true";
        _supplierList = [];
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

  /* Add Temp Stock */
  Future<void> getAddSupplierItem(BuildContext context,Item_Body route) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await supplierRepo?.addSupplierItem(route);
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

  /* Supplier Invoice List */
  Future<void> getSupplierInvoiceList(BuildContext context,String companyId,String startDate,String endDate,String supplierId) async {
    _supplierInvoiceList=[];
    _isLoading=true;
    notifyListeners();
    ApiResponse? apiResponse = await supplierRepo?.getSupplierInvoiceList(companyId,startDate,endDate,supplierId);
    if (apiResponse?.response.data["data"] == null) {
      _isLoading=false;
    }else{
      if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
        _isLoading=false;
        _supplierInvoiceList.addAll(SupplierInvoiceList_Response.fromJson(apiResponse?.response.data).data!);
        notifyListeners();
      } else {
        ApiChecker.checkApi(context, apiResponse!);
      }
    }
  }

  /* Update Supplier Invoice */
  Future<void> getUpdateSupplierInvoice(BuildContext context,String id) async {
    _updateSupplierInvoice=[];
    _isLoading=true;
    notifyListeners();
    ApiResponse? apiResponse = await supplierRepo?.getUpdateSupplierInvoice(id);
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      _isLoading=false;
      _updateSupplierInvoice.addAll(EditSupplierInvoiceResponse.fromJson(apiResponse?.response.data).data1!);
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Supplier Invoice Item List */
  Future<void> getSupplierInvoiceItemList(BuildContext context,String id) async {
    _supplierInvoiceItemList=[];
    _isLoading=true;
    notifyListeners();
    ApiResponse? apiResponse = await supplierRepo?.getSupplierInvoiceItemList(id);
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      _isLoading=false;
      _supplierInvoiceItemList.addAll(SupplierInvoiceItemResponse.fromJson(apiResponse?.response.data).data1!);
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Delete Supplier Invoice Item */
  Future<void> getDeleteSupplierInvoiceItem(BuildContext context,String id) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await supplierRepo?.getDeleteSupplierInvoiceItem(id);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "Data Has Been Deleted Successfully"){
        _success = "true";
        _supplierList = [];
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

  /* Supplier Payment */

  /* Add Supplier Payment */
  Future<void> getAddSupplierPayment(BuildContext context,AddSupplierPaymentBody route,Function callBack) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await supplierRepo?.addSupplierPayment(route);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      _success="true";
      callBack(true);
      notifyListeners();
    }
    else {
      _isLoading = false;
      callBack(false);
      notifyListeners();
    }
    notifyListeners();
  }

  /* Delete Supplier Invoice Item */
  Future<void> getDeleteSupplierPayment(BuildContext context,String id) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await supplierRepo?.deleteSupplierPayment(id);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "Data Has Been Deleted Successfully"){
        _success = "true";
        _supplierList = [];
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

  /* Supplier Payment List */
  Future<void> getSupplierPaymentList(BuildContext context,String companyId,String startDate,String endDate,String supplierId) async {
    _supplierPaymentList=[];
    _isLoading=true;
    notifyListeners();
    ApiResponse? apiResponse = await supplierRepo?.getSupplierPaymentList(companyId,startDate,endDate,supplierId);
    if(apiResponse?.response.data["data"] == null){
      _isLoading = false;
    }else{
      if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
        _isLoading=false;
        _supplierPaymentList.addAll(SupplierPaymentListResponse.fromJson(apiResponse?.response.data).data!);
        notifyListeners();
      } else {
        ApiChecker.checkApi(context, apiResponse!);
      }
    }
  }

  /* Unit Master */

  /* Add Unit Master */
  Future<void> getAddUnitMaster(BuildContext context,AddUnitBody unitBody,Function callBack) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await supplierRepo?.getAddUnit(unitBody);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      _success="true";
      callBack(true);
      notifyListeners();
    }
    else {
      _isLoading = false;
      callBack(false);
      notifyListeners();
    }
    notifyListeners();
  }

  /* Delete Unit Master */
  Future<void> getDeleteUnitMaster(BuildContext context,String id) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await supplierRepo?.deleteUnitMaster(id);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "Data Has Been Deleted Successfully"){
        _success = "true";
        _supplierList = [];
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

  /* Unit Master List */
  Future<void> getUnitMasterList(BuildContext context,String id) async {
    _unitMasterList=[];
    _isLoading=true;
    notifyListeners();
    ApiResponse? apiResponse = await supplierRepo?.getUnitMasterList(id);
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      _isLoading=false;
      _unitMasterList.addAll(UnitMasterListResponse.fromJson(apiResponse?.response.data).data!);
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Unit Master Status Change */
  Future<void> getStatusChangeUnitMaster(BuildContext context,String id,String companyId) async {
    _isLoading=true;
    notifyListeners();
    ApiResponse? apiResponse = await supplierRepo?.getUnitMasterStatusChange(id,companyId);
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      _isLoading=false;
      // _unitMasterList.addAll(UnitMasterListResponse.fromJson(apiResponse?.response.data).data!);
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

}