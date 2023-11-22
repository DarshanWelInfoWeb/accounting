class Main_Payment_List_Response {
  List<MainPaymentData>? data1;
  String? strmsg;
  String? error;

  Main_Payment_List_Response({this.data1, this.strmsg, this.error});

  Main_Payment_List_Response.fromJson(Map<String, dynamic> json) {
    if (json['data1'] != null) {
      data1 = <MainPaymentData>[];
      json['data1'].forEach((v) {
        data1!.add(new MainPaymentData.fromJson(v));
      });
    }
    strmsg = json['strmsg'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data1 != null) {
      data['data1'] = this.data1!.map((v) => v.toJson()).toList();
    }
    data['strmsg'] = this.strmsg;
    data['error'] = this.error;
    return data;
  }
}

class MainPaymentData {
  int? intid;
  int? intType;
  int? intCustomerid;
  String? strInvoiceNo;
  String? dtPaymentDate;
  double? decAmount;
  double? deconlinepayment;
  double? deccashpayment;
  String? strRemarks;
  String? strUserName;
  String? strCompanyName;

  MainPaymentData(
      {this.intid,
        this.intType,
        this.intCustomerid,
        this.strInvoiceNo,
        this.dtPaymentDate,
        this.decAmount,
        this.deconlinepayment,
        this.deccashpayment,
        this.strRemarks,
        this.strUserName,
        this.strCompanyName});

  MainPaymentData.fromJson(Map<String, dynamic> json) {
    intid = json['intid'];
    intType = json['intType'];
    intCustomerid = json['intCustomerid'];
    strInvoiceNo = json['strInvoiceNo'];
    dtPaymentDate = json['dtPaymentDate'];
    decAmount = json['decAmount'];
    deconlinepayment = json['deconlinepayment'];
    deccashpayment = json['deccashpayment'];
    strRemarks = json['strRemarks'];
    strUserName = json['strUserName'];
    strCompanyName = json['strCompanyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intid'] = this.intid;
    data['intType'] = this.intType;
    data['intCustomerid'] = this.intCustomerid;
    data['strInvoiceNo'] = this.strInvoiceNo;
    data['dtPaymentDate'] = this.dtPaymentDate;
    data['decAmount'] = this.decAmount;
    data['deconlinepayment'] = this.deconlinepayment;
    data['deccashpayment'] = this.deccashpayment;
    data['strRemarks'] = this.strRemarks;
    data['strUserName'] = this.strUserName;
    data['strCompanyName'] = this.strCompanyName;
    return data;
  }
}