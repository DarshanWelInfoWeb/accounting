/*class Add_Route {
  Add_Route({
    required this.strRoutedate,
    required this.strvehicleno,
    required this.strRouteName,
    required this.intDriverid,
    required this.intHelperid,
    required this.intCompanyId,
    this.intCreatedby,
    required this.driverStockModels,
  });
  late final String strRoutedate;
  late final String strvehicleno;
  late final String strRouteName;
  late final int intDriverid;
  late final int intHelperid;
  late final int intCompanyId;
  int? intCreatedby;
  late final List<DriverStockModels> driverStockModels;

  Add_Route.fromJson(Map<String, dynamic> json){
    strRoutedate = json['strRoutedate'];
    strvehicleno = json['strvehicleno'];
    strRouteName = json['strRouteName'];
    intDriverid = json['intDriverid'];
    intHelperid = json['intHelperid'];
    intCompanyId = json['intCompanyId'];
    intCreatedby = json['intCreatedby'];
    driverStockModels = List.from(json['driverStockModels']).map((e)=>DriverStockModels.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['strRoutedate'] = strRoutedate;
    _data['strvehicleno'] = strvehicleno;
    _data['strRouteName'] = strRouteName;
    _data['intDriverid'] = intDriverid;
    _data['intHelperid'] = intHelperid;
    _data['intCompanyId'] = intCompanyId;
    _data['intCreatedby'] = intCreatedby;
    _data['driverStockModels'] = driverStockModels.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class DriverStockModels {
  DriverStockModels({this.id, this.fruitName, this.quantity});

  int? id;
  String? fruitName;
  String? quantity;

  DriverStockModels.fromJson(Map<String, dynamic> json){
    id = json['id'];
    fruitName = json['fruitName'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['fruitName'] = fruitName;
    _data['quantity'] = quantity;
    return _data;
  }
}*/

class Add_Route {
  String? dtRouteDate;
  String? strvehicleno;
  String? strRouteName;
  int? intDriverid;
  int? intHelperid;
  int? intCompanyId;
  int? intCreatedby;

  Add_Route(
      {this.dtRouteDate,
        this.strvehicleno,
        this.strRouteName,
        this.intDriverid,
        this.intHelperid,
        this.intCompanyId,
        this.intCreatedby});

  Add_Route.fromJson(Map<String, dynamic> json) {
    dtRouteDate = json['dtRouteDate'];
    strvehicleno = json['strvehicleno'];
    strRouteName = json['strRouteName'];
    intDriverid = json['intDriverid'];
    intHelperid = json['intHelperid'];
    intCompanyId = json['intCompanyId'];
    intCreatedby = json['intCreatedby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dtRouteDate'] = this.dtRouteDate;
    data['strvehicleno'] = this.strvehicleno;
    data['strRouteName'] = this.strRouteName;
    data['intDriverid'] = this.intDriverid;
    data['intHelperid'] = this.intHelperid;
    data['intCompanyId'] = this.intCompanyId;
    data['intCreatedby'] = this.intCreatedby;
    return data;
  }
}

class UpdateRoute_Body {
  int? intId;
  String? dtRouteDate;
  String? strvehicleno;
  String? strRouteName;
  int? intDriverid;
  int? intHelperid;
  int? intCompanyId;
  int? intCreatedby;

  UpdateRoute_Body(
      {this.intId,
        this.dtRouteDate,
        this.strvehicleno,
        this.strRouteName,
        this.intDriverid,
        this.intHelperid,
        this.intCompanyId,
        this.intCreatedby});

  UpdateRoute_Body.fromJson(Map<String, dynamic> json) {
    intId = json['intId'];
    dtRouteDate = json['dtRouteDate'];
    strvehicleno = json['strvehicleno'];
    strRouteName = json['strRouteName'];
    intDriverid = json['intDriverid'];
    intHelperid = json['intHelperid'];
    intCompanyId = json['intCompanyId'];
    intCreatedby = json['intCreatedby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intId'] = this.intId;
    data['dtRouteDate'] = this.dtRouteDate;
    data['strvehicleno'] = this.strvehicleno;
    data['strRouteName'] = this.strRouteName;
    data['intDriverid'] = this.intDriverid;
    data['intHelperid'] = this.intHelperid;
    data['intCompanyId'] = this.intCompanyId;
    data['intCreatedby'] = this.intCreatedby;
    return data;
  }
}


class InsertStock_Body {
  int? id;
  int? intRouteId;
  int? intStockItemId;
  String? itemName;
  String? strName;
  int? intQuantity;

  InsertStock_Body(
      {this.id,this.intRouteId, this.intStockItemId, this.itemName, this.strName,this.intQuantity});

  InsertStock_Body.fromJson(Map<dynamic, dynamic> map) {
    id = map['id'];
    intRouteId = map['intRouteId'];
    intStockItemId = map['intStockItemId'];
    itemName = map['itemName'];
    strName = map['strName'];
    intQuantity = map['intQuantity'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'id': id,
      'intRouteId': intRouteId,
      'intStockItemId': intStockItemId,
      'itemName': itemName,
      'strName': strName,
      'intQuantity': intQuantity,
    };
    return map;
  }
}

