class EditTempInvoiceResponse {
  List<EditTempInvoiceData>? data;
  String? strMsg;
  String? error;

  EditTempInvoiceResponse({this.data, this.strMsg, this.error});

  EditTempInvoiceResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <EditTempInvoiceData>[];
      json['data'].forEach((v) {
        data!.add(new EditTempInvoiceData.fromJson(v));
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

class EditTempInvoiceData {
  int? intid;
  int? intRouteId;
  int? intCustomerid;
  String? dtInvoiceDate;
  int? intCompanyId;
  double? decSubTotal;
  double? decDueAmount;
  double? decGrandTotal;
  double? deconlinepayment;
  double? deccashpayment;
  double? decTotalAmount;
  String? strmsg;

  EditTempInvoiceData(
      {this.intid,
        this.intRouteId,
        this.intCustomerid,
        this.dtInvoiceDate,
        this.intCompanyId,
        this.decSubTotal,
        this.decDueAmount,
        this.decGrandTotal,
        this.deconlinepayment,
        this.deccashpayment,
        this.decTotalAmount,
        this.strmsg});

  EditTempInvoiceData.fromJson(Map<String, dynamic> json) {
    intid = json['intid'];
    intRouteId = json['intRouteId'];
    intCustomerid = json['intCustomerid'];
    dtInvoiceDate = json['dtInvoiceDate'];
    intCompanyId = json['intCompanyId'];
    decSubTotal = json['decSubTotal'];
    decDueAmount = json['decDueAmount'];
    decGrandTotal = json['decGrandTotal'];
    deconlinepayment = json['deconlinepayment'];
    deccashpayment = json['deccashpayment'];
    decTotalAmount = json['decTotalAmount'];
    strmsg = json['strmsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intid'] = this.intid;
    data['intRouteId'] = this.intRouteId;
    data['intCustomerid'] = this.intCustomerid;
    data['dtInvoiceDate'] = this.dtInvoiceDate;
    data['intCompanyId'] = this.intCompanyId;
    data['decSubTotal'] = this.decSubTotal;
    data['decDueAmount'] = this.decDueAmount;
    data['decGrandTotal'] = this.decGrandTotal;
    data['deconlinepayment'] = this.deconlinepayment;
    data['deccashpayment'] = this.deccashpayment;
    data['decTotalAmount'] = this.decTotalAmount;
    data['strmsg'] = this.strmsg;
    return data;
  }
}