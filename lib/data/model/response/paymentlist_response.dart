class PaymentList_Response {
  List<PaymentListData>? data;
  String? strMsg;
  String? error;

  PaymentList_Response({this.data, this.strMsg, this.error});

  PaymentList_Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PaymentListData>[];
      json['data'].forEach((v) {
        data!.add(new PaymentListData.fromJson(v));
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

class PaymentListData {
  int? intId;
  int? intCustomerid;
  int? intRouteid;
  int? intcompanyid;
  String? customerName;
  String? dtPaymentDate;
  double? decGrandTotal;
  double? deconlinepayment;
  double? deccashpayment;
  int? intTranscationType;
  String? strRemarks;

  PaymentListData(
      {this.intId,
        this.intCustomerid,
        this.intRouteid,
        this.intcompanyid,
        this.customerName,
        this.dtPaymentDate,
        this.decGrandTotal,
        this.deconlinepayment,
        this.deccashpayment,
        this.intTranscationType,
        this.strRemarks});

  PaymentListData.fromJson(Map<String, dynamic> json) {
    intId = json['intId'];
    intCustomerid = json['intCustomerid'];
    intRouteid = json['intRouteid'];
    intcompanyid = json['intcompanyid'];
    customerName = json['CustomerName'];
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
    data['intRouteid'] = this.intRouteid;
    data['intcompanyid'] = this.intcompanyid;
    data['CustomerName'] = this.customerName;
    data['dtPaymentDate'] = this.dtPaymentDate;
    data['decGrandTotal'] = this.decGrandTotal;
    data['deconlinepayment'] = this.deconlinepayment;
    data['deccashpayment'] = this.deccashpayment;
    data['intTranscationType'] = this.intTranscationType;
    data['strRemarks'] = this.strRemarks;
    return data;
  }
}