class Add_Main_Payment_Body {
  int? intType;
  int? intCustomerid;
  String? strInvoiceNo;
  String? dtPaymentDate;
  int? decAmount;
  String? strRemarks;
  int? deconlinepayment;
  int? deccashpayment;
  int? intCreatedBy;
  int? intCompanyId;

  Add_Main_Payment_Body(
      {this.intType,
        this.intCustomerid,
        this.strInvoiceNo,
        this.dtPaymentDate,
        this.decAmount,
        this.strRemarks,
        this.deconlinepayment,
        this.deccashpayment,
        this.intCreatedBy,
        this.intCompanyId});

  Add_Main_Payment_Body.fromJson(Map<String, dynamic> json) {
    intType = json['intType'];
    intCustomerid = json['intCustomerid'];
    strInvoiceNo = json['strInvoiceNo'];
    dtPaymentDate = json['dtPaymentDate'];
    decAmount = json['decAmount'];
    strRemarks = json['strRemarks'];
    deconlinepayment = json['deconlinepayment'];
    deccashpayment = json['deccashpayment'];
    intCreatedBy = json['intCreatedBy'];
    intCompanyId = json['intCompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intType'] = this.intType;
    data['intCustomerid'] = this.intCustomerid;
    data['strInvoiceNo'] = this.strInvoiceNo;
    data['dtPaymentDate'] = this.dtPaymentDate;
    data['decAmount'] = this.decAmount;
    data['strRemarks'] = this.strRemarks;
    data['deconlinepayment'] = this.deconlinepayment;
    data['deccashpayment'] = this.deccashpayment;
    data['intCreatedBy'] = this.intCreatedBy;
    data['intCompanyId'] = this.intCompanyId;
    return data;
  }
}

class Edit_Main_Payment_Body {
  int? intid;
  int? intType;
  int? intCustomerid;
  int? strInvoiceNo;
  String? dtPaymentDate;
  int? decAmount;
  String? strRemarks;
  int? deconlinepayment;
  int? deccashpayment;
  int? intCreatedBy;
  int? intCompanyId;

  Edit_Main_Payment_Body(
      {this.intid,
        this.intType,
        this.intCustomerid,
        this.strInvoiceNo,
        this.dtPaymentDate,
        this.decAmount,
        this.strRemarks,
        this.deconlinepayment,
        this.deccashpayment,
        this.intCreatedBy,
        this.intCompanyId});

  Edit_Main_Payment_Body.fromJson(Map<String, dynamic> json) {
    intid = json['intid'];
    intType = json['intType'];
    intCustomerid = json['intCustomerid'];
    strInvoiceNo = json['strInvoiceNo'];
    dtPaymentDate = json['dtPaymentDate'];
    decAmount = json['decAmount'];
    strRemarks = json['strRemarks'];
    deconlinepayment = json['deconlinepayment'];
    deccashpayment = json['deccashpayment'];
    intCreatedBy = json['intCreatedBy'];
    intCompanyId = json['intCompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intid'] = this.intid;
    data['intType'] = this.intType;
    data['intCustomerid'] = this.intCustomerid;
    data['strInvoiceNo'] = this.strInvoiceNo;
    data['dtPaymentDate'] = this.dtPaymentDate;
    data['decAmount'] = this.decAmount;
    data['strRemarks'] = this.strRemarks;
    data['deconlinepayment'] = this.deconlinepayment;
    data['deccashpayment'] = this.deccashpayment;
    data['intCreatedBy'] = this.intCreatedBy;
    data['intCompanyId'] = this.intCompanyId;
    return data;
  }
}