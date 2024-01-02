class EditPayment {
  List<EditData>? data;
  String? strMsg;
  String? error;

  EditPayment({this.data, this.strMsg, this.error});

  EditPayment.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <EditData>[];
      json['data'].forEach((v) {
        data!.add(new EditData.fromJson(v));
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

class EditData {
  int? intId;
  int? intCustomerid;
  int? intcompanyid;
  int? intRouteid;
  String? dtPaymentDate;
  double? decGrandTotal;
  double? deconlinepayment;
  double? deccashpayment;
  int? intTranscationType;
  String? strRemarks;

  EditData(
      {this.intId,
        this.intCustomerid,
        this.intcompanyid,
        this.intRouteid,
        this.dtPaymentDate,
        this.decGrandTotal,
        this.deconlinepayment,
        this.deccashpayment,
        this.intTranscationType,
        this.strRemarks});

  EditData.fromJson(Map<String, dynamic> json) {
    intId = json['intId'];
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
    data['intId'] = this.intId;
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