class MainInvoiceStock_Response {
  List<MainInvoiceStockData>? data;
  String? strMsg;
  String? error;

  MainInvoiceStock_Response({this.data, this.strMsg, this.error});

  MainInvoiceStock_Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <MainInvoiceStockData>[];
      json['data'].forEach((v) {
        data!.add(new MainInvoiceStockData.fromJson(v));
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

class MainInvoiceStockData {
  int? intid;
  int? intinvoiceid;
  String? strItemName;
  String? strUnitName;
  String? strHsnCode;
  int? intitemid;
  double? decQty;
  double? decRate;
  double? decAmount;
  int? intcompanyid;

  MainInvoiceStockData(
      {this.intid,
        this.intinvoiceid,
        this.strItemName,
        this.strUnitName,
        this.strHsnCode,
        this.intitemid,
        this.decQty,
        this.decRate,
        this.decAmount,
        this.intcompanyid});

  MainInvoiceStockData.fromJson(Map<String, dynamic> json) {
    intid = json['intid'];
    intinvoiceid = json['intinvoiceid'];
    strItemName = json['strItemName'];
    strUnitName = json['strUnitName'];
    strHsnCode = json['strHsnCode'];
    intitemid = json['intitemid'];
    decQty = json['decQty'];
    decRate = json['decRate'];
    decAmount = json['decAmount'];
    intcompanyid = json['intcompanyid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intid'] = this.intid;
    data['intinvoiceid'] = this.intinvoiceid;
    data['strItemName'] = this.strItemName;
    data['strUnitName'] = this.strUnitName;
    data['strHsnCode'] = this.strHsnCode;
    data['intitemid'] = this.intitemid;
    data['decQty'] = this.decQty;
    data['decRate'] = this.decRate;
    data['decAmount'] = this.decAmount;
    data['intcompanyid'] = this.intcompanyid;
    return data;
  }
}