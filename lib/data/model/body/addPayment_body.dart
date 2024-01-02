class AddPayment_Body {
  int? intCustomerid;
  int? intcompanyid;
  int? intRouteid;
  String? dtPaymentDate;
  int? decGrandTotal;
  int? deconlinepayment;
  int? deccashpayment;
  int? intTranscationType;
  String? strRemarks;

  AddPayment_Body(
      {this.intCustomerid,
        this.intcompanyid,
        this.intRouteid,
        this.dtPaymentDate,
        this.decGrandTotal,
        this.deconlinepayment,
        this.deccashpayment,
        this.intTranscationType,
        this.strRemarks});

  AddPayment_Body.fromJson(Map<String, dynamic> json) {
    intCustomerid = json['intCustomerid'];
    intcompanyid = json['intcompanyid'];
    intRouteid = json['intRouteid'];
    dtPaymentDate = json['dtPaymentDate'];
    decGrandTotal = json['decGrandTotal'];
    deconlinepayment = json['deconlinepayment'];
    deccashpayment = json['deccashpayment'];
    intTranscationType = json['intTranscationType'];
    strRemarks = json['strRemarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intCustomerid'] = this.intCustomerid;
    data['intcompanyid'] = this.intcompanyid;
    data['intRouteid'] = this.intRouteid;
    data['dtPaymentDate'] = this.dtPaymentDate;
    data['decGrandTotal'] = this.decGrandTotal;
    data['deconlinepayment'] = this.deconlinepayment;
    data['deccashpayment'] = this.deccashpayment;
    data['intTranscationType'] = this.intTranscationType;
    data['strRemarks'] = this.strRemarks;
    return data;
  }
}

class PaymentUpdate_Body {
  int? intid;
  int? intCustomerid;
  int? intcompanyid;
  int? intRouteid;
  String? dtPaymentDate;
  int? decGrandTotal;
  int? deconlinepayment;
  int? deccashpayment;
  String? strRemarks;

  PaymentUpdate_Body(
      {this.intid,
        this.intCustomerid,
        this.intcompanyid,
        this.intRouteid,
        this.dtPaymentDate,
        this.decGrandTotal,
        this.deconlinepayment,
        this.deccashpayment,
        this.strRemarks});

  PaymentUpdate_Body.fromJson(Map<String, dynamic> json) {
    intid = json['intid'];
    intCustomerid = json['intCustomerid'];
    intcompanyid = json['intcompanyid'];
    intRouteid = json['intRouteid'];
    dtPaymentDate = json['dtPaymentDate'];
    decGrandTotal = json['decGrandTotal'];
    deconlinepayment = json['deconlinepayment'];
    deccashpayment = json['deccashpayment'];
    strRemarks = json['strRemarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intid'] = this.intid;
    data['intCustomerid'] = this.intCustomerid;
    data['intcompanyid'] = this.intcompanyid;
    data['intRouteid'] = this.intRouteid;
    data['dtPaymentDate'] = this.dtPaymentDate;
    data['decGrandTotal'] = this.decGrandTotal;
    data['deconlinepayment'] = this.deconlinepayment;
    data['deccashpayment'] = this.deccashpayment;
    data['strRemarks'] = this.strRemarks;
    return data;
  }
}