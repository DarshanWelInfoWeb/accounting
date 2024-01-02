class RouteUserDetailResponse {
  RouteUserDetailResponse({
    required this.data,
    required this.strMsg,
    required this.error,
  });
  late final DetailData data;
  late final String strMsg;
  String? error;

  RouteUserDetailResponse.fromJson(Map<String, dynamic> json){
    data = DetailData.fromJson(json['data']);
    strMsg = json['strMsg'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.toJson();
    _data['strMsg'] = strMsg;
    _data['error'] = error;
    return _data;
  }
}

class DetailData {
  DetailData({
    required this.intType,
    required this.intid,
    required this.strRoutedate,
    required this.strvehicleno,
    required this.strRouteName,
    required this.intDriverid,
    required this.intHelperid,
    required this.strDriverName,
    required this.strHelperName,
    required this.intCompanyId,
    required this.intCreatedby,
    required this.dtcreateddate,
    required this.decOnlinePayment,
    required this.decCashPayment,
    required this.decTotalAmount,
    required this.ExpensedecOnlinepayment,
    required this.ExpensedecCashpayment,
    required this.ExpenseTotalAmount,
    required this.strmsg,
    required this.driverStockModel,
  });
  late final int intType;
  late final int intid;
  late final String? strRoutedate;
  late final String strvehicleno;
  late final String strRouteName;
  late final dynamic intDriverid;
  late final dynamic intHelperid;
  late final String strDriverName;
  late final String strHelperName;
  late final int intCompanyId;
  late final int intCreatedby;
  late final String dtcreateddate;
  late final double decOnlinePayment;
  late final double decCashPayment;
  late final double decTotalAmount;
  late final double ExpensedecOnlinepayment;
  late final double ExpensedecCashpayment;
  late final double ExpenseTotalAmount;
  late final String strmsg;
  late final List<DriverStockModel> driverStockModel;

  DetailData.fromJson(Map<String, dynamic> json){
    intType = json['intType'];
    intid = json['intid'];
    strRoutedate = json['strRoutedate'];
    strvehicleno = json['strvehicleno'];
    strRouteName = json['strRouteName'];
    intDriverid = json['intDriverid']??'';
    intHelperid = json['intHelperid'];
    strDriverName = json['strDriverName']??'';
    strHelperName = json['strHelperName']??'';
    intCompanyId = json['intCompanyId'];
    intCreatedby = json['intCreatedby'];
    dtcreateddate = json['dtcreateddate'];
    decOnlinePayment = json['decOnlinePayment'];
    decCashPayment = json['decCashPayment'];
    decTotalAmount = json['decTotalAmount'];
    ExpensedecOnlinepayment = json['ExpensedecOnlinepayment'];
    ExpensedecCashpayment = json['ExpensedecCashpayment'];
    ExpenseTotalAmount = json['ExpenseTotalAmount'];
    strmsg = json['strmsg'] ?? '';
    driverStockModel = List.from(json['driverStockModel']??[]).map((e)=>DriverStockModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['intType'] = intType;
    _data['intid'] = intid;
    _data['strRoutedate'] = strRoutedate;
    _data['strvehicleno'] = strvehicleno;
    _data['strRouteName'] = strRouteName;
    _data['intDriverid'] = intDriverid;
    _data['intHelperid'] = intHelperid;
    _data['strDriverName'] = strDriverName;
    _data['strHelperName'] = strHelperName;
    _data['intCompanyId'] = intCompanyId;
    _data['intCreatedby'] = intCreatedby;
    _data['dtcreateddate'] = dtcreateddate;
    _data['decOnlinePayment'] = decOnlinePayment;
    _data['decCashPayment'] = decCashPayment;
    _data['decTotalAmount'] = decTotalAmount;
    _data['ExpensedecOnlinepayment'] = ExpensedecOnlinepayment;
    _data['ExpensedecCashpayment'] = ExpensedecCashpayment;
    _data['ExpenseTotalAmount'] = ExpenseTotalAmount;
    _data['strmsg'] = strmsg;
    _data['driverStockModel'] = driverStockModel.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class DriverStockModel {
  DriverStockModel({
    required this.lstData,
    required this.Type,
    required this.intId,
    required this.intRouteId,
    required this.intStockItemId,
    required this.StrItemName,
    required this.intQuantity,
    required this.decSale,
    required this.strmsg,
  });
  late final String? lstData;
  late final int Type;
  late final int intId;
  late final int intRouteId;
  late final int intStockItemId;
  late final String StrItemName;
  late final int intQuantity;
  late final double decSale;
  late final String? strmsg;

  DriverStockModel.fromJson(Map<String, dynamic> json){
    lstData = json['lstData'];
    Type = json['Type'];
    intId = json['intId'];
    intRouteId = json['intRouteId'];
    intStockItemId = json['intStockItemId'];
    StrItemName = json['StrItemName'];
    intQuantity = json['intQuantity'];
    decSale = json['DecSale'];
    strmsg = json['strmsg'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['lstData'] = lstData;
    _data['Type'] = Type;
    _data['intId'] = intId;
    _data['intRouteId'] = intRouteId;
    _data['intStockItemId'] = intStockItemId;
    _data['StrItemName'] = StrItemName;
    _data['intQuantity'] = intQuantity;
    _data['DecSale'] = decSale;
    _data['strmsg'] = strmsg;
    return _data;
  }
}