class MainInvoiceList_Reponse {
  List<MainInvoiceListData>? data;
  String? strMsg;
  String? error;

  MainInvoiceList_Reponse({this.data, this.strMsg, this.error});

  MainInvoiceList_Reponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <MainInvoiceListData>[];
      json['data'].forEach((v) {
        data!.add(new MainInvoiceListData.fromJson(v));
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

class MainInvoiceListData {
  int? intid;
  String? strInvoiceno;
  String? strCustomerName;
  String? dtInvoicedate;
  double? decTotal;
  String? strAddress;
  String? strGSTIN;

  MainInvoiceListData(
      {this.intid,
        this.strInvoiceno,
        this.strCustomerName,
        this.dtInvoicedate,
        this.decTotal,
        this.strAddress,
        this.strGSTIN});

  MainInvoiceListData.fromJson(Map<String, dynamic> json) {
    intid = json['intid'];
    strInvoiceno = json['strInvoiceno'];
    strCustomerName = json['strCustomerName'];
    dtInvoicedate = json['dtInvoicedate'];
    decTotal = json['DecTotal'];
    strAddress = json['strAddress'];
    strGSTIN = json['strGSTIN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intid'] = this.intid;
    data['strInvoiceno'] = this.strInvoiceno;
    data['strCustomerName'] = this.strCustomerName;
    data['dtInvoicedate'] = this.dtInvoicedate;
    data['DecTotal'] = this.decTotal;
    data['strAddress'] = this.strAddress;
    data['strGSTIN'] = this.strGSTIN;
    return data;
  }
}