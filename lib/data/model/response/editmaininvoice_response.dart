class EditMainInvoice_Reponse {
  List<EditMainInvoiceData>? data;
  String? strMsg;
  String? error;

  EditMainInvoice_Reponse({this.data, this.strMsg, this.error});

  EditMainInvoice_Reponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <EditMainInvoiceData>[];
      json['data'].forEach((v) {
        data!.add(new EditMainInvoiceData.fromJson(v));
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

class EditMainInvoiceData {
  int? intid;
  int? intcustomerid;
  String? strInvoiceNo;
  String? dtInvoicedate;
  String? dtDueDate;
  double? decSubTotal;
  double? decDiscount;
  double? decGrandTotal;
  int? intCompanyid;

  EditMainInvoiceData(
      {this.intid,
        this.intcustomerid,
        this.strInvoiceNo,
        this.dtInvoicedate,
        this.dtDueDate,
        this.decSubTotal,
        this.decDiscount,
        this.decGrandTotal,
        this.intCompanyid});

  EditMainInvoiceData.fromJson(Map<String, dynamic> json) {
    intid = json['intid'];
    intcustomerid = json['intcustomerid'];
    strInvoiceNo = json['strInvoiceNo'];
    dtInvoicedate = json['dtInvoicedate'];
    dtDueDate = json['dtDueDate'];
    decSubTotal = json['decSubTotal'];
    decDiscount = json['decDiscount'];
    decGrandTotal = json['decGrandTotal'];
    intCompanyid = json['intCompanyid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intid'] = this.intid;
    data['intcustomerid'] = this.intcustomerid;
    data['strInvoiceNo'] = this.strInvoiceNo;
    data['dtInvoicedate'] = this.dtInvoicedate;
    data['dtDueDate'] = this.dtDueDate;
    data['decSubTotal'] = this.decSubTotal;
    data['decDiscount'] = this.decDiscount;
    data['decGrandTotal'] = this.decGrandTotal;
    data['intCompanyid'] = this.intCompanyid;
    return data;
  }
}