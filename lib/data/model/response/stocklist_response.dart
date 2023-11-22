class StockList_Response {
  List<StockListData>? data;
  String? strMsg;
  String? error;

  StockList_Response({this.data, this.strMsg, this.error});

  StockList_Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <StockListData>[];
      json['data'].forEach((v) {
        data!.add(new StockListData.fromJson(v));
      });
    }
    strMsg = json['strMsg'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['strMsg'] = this.strMsg;
    data['error'] = this.error;
    return data;
  }
}

class StockListData {
  int? intId;
  String? strDriverName;
  String? strVehicleno;
  String? strRoutedate;
  String? dtRouteDate;
  int? intDriverid;
  int? intHelperId;
  int? intStockItemId;
  int? intQuantity;
  String? itemName;
  dynamic invoiceQty;
  dynamic invoiceAmt;
  double? decSale;

  StockListData(
      {this.intId,
        this.strDriverName,
        this.strVehicleno,
        this.strRoutedate,
        this.dtRouteDate,
        this.intDriverid,
        this.intHelperId,
        this.intStockItemId,
        this.intQuantity,
        this.itemName,
        this.invoiceQty,
        this.invoiceAmt,
        this.decSale});

  StockListData.fromJson(Map<String, dynamic> json) {
    intId = json['intId'];
    strDriverName = json['strDriverName'];
    strVehicleno = json['strVehicleno'];
    strRoutedate = json['strRoutedate'];
    dtRouteDate = json['dtRouteDate'];
    intDriverid = json['intDriverid'];
    intHelperId = json['intHelperId'];
    intStockItemId = json['intStockItemId'];
    intQuantity = json['intQuantity'];
    itemName = json['ItemName'];
    invoiceQty = json['InvoiceQty'];
    invoiceAmt = json['InvoiceAmt'];
    decSale = json['decSale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intId'] = this.intId;
    data['strDriverName'] = this.strDriverName;
    data['strVehicleno'] = this.strVehicleno;
    data['strRoutedate'] = this.strRoutedate;
    data['dtRouteDate'] = this.dtRouteDate;
    data['intDriverid'] = this.intDriverid;
    data['intHelperId'] = this.intHelperId;
    data['intStockItemId'] = this.intStockItemId;
    data['intQuantity'] = this.intQuantity;
    data['ItemName'] = this.itemName;
    data['InvoiceQty'] = this.invoiceQty;
    data['InvoiceAmt'] = this.invoiceAmt;
    data['decSale'] = this.decSale;
    return data;
  }
}