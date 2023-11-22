class TempStockList_Response {
  List<TempStockData>? data;
  String? strMsg;
  String? error;

  TempStockList_Response({this.data, this.strMsg, this.error});

  TempStockList_Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TempStockData>[];
      json['data'].forEach((v) {
        data!.add(new TempStockData.fromJson(v));
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

class TempStockData {
  int? intid;
  String? strCustomerName;
  String? dtInvoiceDate;
  double? decGrandTotal;
  String? strItemName;
  double? decQty;
  double? decRate;
  double? decAmount;
  String? strAddress;
  String? strUnitName;
  String? strGSTIN;
  String? gST;
  String? ActualGST;

  TempStockData(
      {this.intid,
        this.strCustomerName,
        this.dtInvoiceDate,
        this.decGrandTotal,
        this.strItemName,
        this.decQty,
        this.decRate,
        this.decAmount,
        this.strAddress,
        this.strUnitName,
        this.strGSTIN,this.gST,this.ActualGST});

  TempStockData.fromJson(Map<String, dynamic> json) {
    intid = json['intid'];
    strCustomerName = json['strCustomerName'];
    dtInvoiceDate = json['dtInvoiceDate'];
    decGrandTotal = json['decGrandTotal'];
    strItemName = json['strItemName'];
    decQty = json['decQty'];
    decRate = json['decRate'];
    decAmount = json['decAmount'];
    strAddress = json['strAddress'];
    strUnitName = json['strUnitName'];
    strGSTIN = json['StrGSTIN'];
    gST = json['GST'];
    ActualGST = json['ActualGST'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intid'] = this.intid;
    data['strCustomerName'] = this.strCustomerName;
    data['dtInvoiceDate'] = this.dtInvoiceDate;
    data['decGrandTotal'] = this.decGrandTotal;
    data['strItemName'] = this.strItemName;
    data['decQty'] = this.decQty;
    data['decRate'] = this.decRate;
    data['decAmount'] = this.decAmount;
    data['strAddress'] = this.strAddress;
    data['strUnitName'] = this.strUnitName;
    data['StrGSTIN'] = this.strGSTIN;
    data['GST'] = this.gST;
    data['ActualGST'] = this.ActualGST;
    return data;
  }
}