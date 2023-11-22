import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gas_accounting/data/model/response/base/api_response.dart';
import 'package:gas_accounting/data/model/response/items_response.dart';
import 'package:gas_accounting/data/repository/item_repo.dart';
import 'package:gas_accounting/helper/api_checker.dart';

class ItemProvider with ChangeNotifier {
  final ItemRepo? itemRepo;

  ItemProvider({@required this.itemRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _success = "true";
  String? get success => _success;

  List<ItemsEditData> _itemEdit = new List.empty(growable: true);
  List<ItemsEditData> get itemEdit => _itemEdit;
  List<UnitListData> _unitList = new List.empty(growable: true);
  List<UnitListData> get unitList => _unitList;
  List<ItemsListData> _itemsList = new List.empty(growable: true);
  List<ItemsListData> get itemsList => _itemsList;
  List<ItemPriceData> _itemPriceList = new List.empty(growable: true);
  List<ItemPriceData> get itemPriceList => _itemPriceList;


  /* Unit List */
  Future<void> getUnit(BuildContext context,String id) async {
    _unitList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await itemRepo?.getSelectUnit(id);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      _success = "true";
      _unitList.addAll(UnitList_Response.fromJson(apiResponse?.response.data).data!);
      _isLoading=false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Items List */
  Future<void> getItemsList(BuildContext context,String id) async {
    _itemsList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await itemRepo?.getItemsList(id);
    print("object:: :: ${apiResponse?.response}");
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      _success = "true";
      _itemsList.addAll(ItemsList_Response.fromJson(apiResponse?.response.data).data!);
      _isLoading=false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }
  int _currentPage = 1;

  Future<void> loadItems(String id) async {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
      final newItems = await itemRepo?.fetchItems(id);
      _itemsList.addAll(newItems!);
      _currentPage++;
      _isLoading = false;
      notifyListeners();
    }
  }


  /* Items Edit */
  Future<void> getItemsEdit(BuildContext context,String id) async {
    _itemEdit = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await itemRepo?.getItemsEdit(id);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      // if(apiResponse?.response.data['strMessage'] == "Edit User list get successfully."){
        _success = "true";
        _itemEdit.addAll(ItemsEdit_Response.fromJson(apiResponse?.response.data).data!);
      // }else{
      //   _success="false";
      // }
      _isLoading=false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Delete Items */
  Future<void> getDeleteItems(BuildContext context,String id) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await itemRepo?.getDeleteItems(id);
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

  /* Item Price */

  /* Item Price List */
  Future<void> getItemPriceList(BuildContext context,String id) async {
    _itemPriceList = [];
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await itemRepo?.getItemsPriceList(id);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse?.response.statusCode == 200) {
      _success = "true";
      _itemPriceList.addAll(ItemPriceListResponse.fromJson(apiResponse?.response.data).data!);
      _isLoading=false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse!);
    }
  }

  /* Add Item Price */
  Future<void> getAddItemPrice(BuildContext context,AddItemPriceBody route,Function callBack) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await itemRepo?.getAddItemPrice(route);
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

}