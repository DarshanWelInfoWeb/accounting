class TempInvoiceList_Response {
  List<TempInvoiceData>? data;
  String? strMsg;
  String? error;

  TempInvoiceList_Response({this.data, this.strMsg, this.error});

  TempInvoiceList_Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TempInvoiceData>[];
      json['data'].forEach((v) {
        data!.add(new TempInvoiceData.fromJson(v));
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

class TempInvoiceData {
  int? intid;
  String? strCustomerName;
  String? dtInvoiceDate;
  double? decGrandTotal;
  String? strItemName;
  double? decQty;
  double? decAmount;
  String? strAddress;
  int? intReferenceid;
  String? strUnitName;
  String? StrGSTIN;

  TempInvoiceData(
      {this.intid, this.strCustomerName, this.dtInvoiceDate, this.decGrandTotal, this.strItemName,this.decQty,this.decAmount,this.strAddress,this.StrGSTIN});

  TempInvoiceData.fromJson(Map<String, dynamic> json) {
    intid = json['intid'];
    strCustomerName = json['strCustomerName'];
    dtInvoiceDate = json['dtInvoiceDate'];
    decGrandTotal = json['decGrandTotal'];
    strItemName = json['strItemName'];
    decQty = json['decQty'];
    decAmount = json['decAmount'];
    strAddress = json['strAddress'];
    intReferenceid = json['intReferenceid'];
    strUnitName = json['strUnitName'];
    StrGSTIN = json['StrGSTIN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intid'] = this.intid;
    data['strCustomerName'] = this.strCustomerName;
    data['dtInvoiceDate'] = this.dtInvoiceDate;
    data['decGrandTotal'] = this.decGrandTotal;
    data['strItemName'] = this.strItemName;
    data['decQty'] = this.decQty;
    data['decAmount'] = this.decAmount;
    data['strAddress'] = this.strAddress;
    data['intReferenceid'] = this.intReferenceid;
    data['strUnitName'] = this.strUnitName;
    data['StrGSTIN'] = this.StrGSTIN;
    return data;
  }
}