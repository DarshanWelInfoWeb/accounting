import 'package:flutter/material.dart';
import 'package:gas_accounting/data/model/body/route.dart';
import 'package:gas_accounting/data/model/response/base/api_response.dart';
import 'package:gas_accounting/data/model/response/driver_response.dart';
import 'package:gas_accounting/data/model/response/helper_response.dart';
import 'package:gas_accounting/data/model/response/routedeetail_response.dart';
import 'package:gas_accounting/data/model/response/routeuserlist_response.dart';
import 'package:gas_accounting/data/model/response/selectroute.dart';
import 'package:gas_accounting/data/model/response/stocklist_response.dart';
import 'package:gas_accounting/data/repository/route_repo.dart';
import 'package:gas_accounting/helper/api_checker.dart';

class RouteProvider with ChangeNotifier {
  final RouteRepo? routeRepo;

  RouteProvider({@required this.routeRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _success="true";
  String? get success => _success;
  int? _routeId=0;
  int? get routeId => _routeId;

  List<DriverData> _driverList = new List.empty(growable: true);
  List<DriverData> get driverList => _driverList;
  List<ItemData> _itemList = new List.empty(growable: true);
  List<ItemData> get itemList => _itemList;
  List<RouteUserData> _routeList = new List.empty(growable: true);
  List<RouteUserData> get routeList => _routeList;
  List<SelectRouteData> _selectrouteList = new List.empty(growable: true);
  List<SelectRouteData> get selectrouteList => _selectrouteList;
  List<StockListData> _stockList = new List.empty(growable: true);
  List<StockListData> get stockList => _stockList;
  RouteUserDetailResponse? _routeDetail;
  RouteUserDetailResponse? get routeDetail => _routeDetail;

  /* Add Rote */
  Future<void> getAddRoute(BuildContext context,Add_Route route, Function callback) async {
    _routeList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await routeRepo?.addRoute(route);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      print('id::::::${apiResponse?.response.data['data']['intid']}');
      _routeId = apiResponse?.response.data['data']['intid'];
      _success="true";
      callback(true);
      notifyListeners();
    }
    else {
      _isLoading = false;
      callback(false,0);
      notifyListeners();
    }
    notifyListeners();
  }

  /* Update Rote */
  Future<void> getUpdateRoute(BuildContext context,UpdateRoute_Body route, Function callback) async {
    _routeList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await routeRepo?.updateRoute(route);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      print('id::::::${apiResponse?.response.data['data']['intid']}');
      _routeId = apiResponse?.response.data['data']['intid'];
      _success="true";
      callback(true);
      notifyListeners();
    }
    else {
      _isLoading = false;
      callback(false,0);
      notifyListeners();
    }
    notifyListeners();
  }

  /* Add Item */
  Future<void> getAddItem(BuildContext context,InsertStock_Body route) async {
    _routeList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await routeRepo?.addInsertStock(route);
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

  /* Route List */
  Future<void> getStockList(BuildContext context,String id) async {
    _stockList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await routeRepo?.getStockList(id);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      // if(apiResponse?.response.data['strMsg'] == "Data Get Successfully"){
      if(apiResponse?.response.data["data"] == null){

      }else{
          _success = "true";
          _stockList.addAll(StockList_Response.fromJson(apiResponse?.response.data).data!);
      }
      // }else{
      //   _success="false";
      // }
      _isLoading=false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Delete Stock */
  Future<void> getDeleteStock(BuildContext context,String id) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await routeRepo?.getDeleteStock(id);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "Data Has Been Deleted Successfully"){
        _success = "true";
        _routeList = [];
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

  /* Driver Helper List */
  Future<void> getDriverHelper(BuildContext context,String companyId,String userId) async {
    _driverList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await routeRepo?.getDriverHelper(companyId,userId);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "Data Get Successfully"){
        _success = "true";
        _driverList.addAll(DriverList_Response.fromJson(apiResponse?.response.data).data!);
      }else{
        _success="false";
      }
      _isLoading=false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Item List */
  Future<void> getItemList(BuildContext context,String companyId,String customerId,String intId) async {
    _itemList = [];
    _isLoading = true;
    ApiResponse? apiResponse = await routeRepo?.getItem(companyId,customerId,intId);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "Data Get Successfully"){
        _success = "true";
        _itemList.addAll(ItemList_Response.fromJson(apiResponse?.response.data).data!);
      }else{
        _success="false";
      }
      notifyListeners();
    } else {
      _isLoading = false;
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Route User List */
  Future<void> getRouteUserList(BuildContext context,String id,String year,String month) async {
    _routeList = [];
    _isLoading = true;
    // notifyListeners();
    ApiResponse? apiResponse = await routeRepo?.getRouteUser(id,year,month);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "Data Get Successfully"){
        _success = "true";
        _routeList.addAll(RouteUserList_Response.fromJson(apiResponse?.response.data).data!);
      }else{
        _success="false";
      }
      _isLoading=false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Delete Route User */
  Future<void> getDeleteRoute(BuildContext context,String id,Function callBack) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await routeRepo?.getDeleteRouteUser(id);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "1"){
        _success = "true";
        print("object::1${apiResponse?.response.data['strMsg']}");
        callBack(true,"Deleted Successfully");
        _routeList = [];
      }else{
        print("object::2${apiResponse?.response.data['strMsg']}");
        callBack(false,"Route can not delete. \n It has use in invoice or payment.");
        _success="false";
      }
      notifyListeners();
    }
    else {
      callBack(false,apiResponse?.response.data['strMsg']);
      _isLoading = false;
      notifyListeners();
    }
    notifyListeners();
  }

  /* Route User Detail */
  Future<void> getRouteUserDetail(BuildContext context,String id) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await routeRepo?.getRouteUserDetail(id);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "Data Get Successfully" || apiResponse?.response.data['strMsg'] == "Data Not Found"){
        _success = "true";
        _routeDetail = RouteUserDetailResponse.fromJson(apiResponse?.response.data);
        print("njckcbbs::::${_routeDetail!.data.driverStockModel.length}");
      }else{
        _success="false";
      }
      _isLoading=false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Select Route */
  Future<void> getSelectRoute(BuildContext context,String id) async {
    _selectrouteList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await routeRepo?.getSelectRoute(id);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      if(apiResponse?.response.data['strMsg'] == "Data Get Successfully"){
        _success = "true";
        _selectrouteList.addAll(SelectRouteList_Response.fromJson(apiResponse?.response.data).data!);
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