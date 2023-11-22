class CustomerDailyReport_Response {
  List<CustomerDailyReportData>? data;
  String? strMsg;
  String? error;

  CustomerDailyReport_Response({this.data, this.strMsg, this.error});

  CustomerDailyReport_Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CustomerDailyReportData>[];
      json['data'].forEach((v) {
        data!.add(new CustomerDailyReportData.fromJson(v));
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

class CustomerDailyReportData {
  int? intid;
  int? intCompanyid;
  int? intCustomerid;
  String? strStartdate;
  String? strEnddate;
  String? dtdate;
  double? decDebitAmt;
  double? decCreditAmt;
  double? decBalance;

  CustomerDailyReportData(
      {this.intid,
        this.intCompanyid,
        this.intCustomerid,
        this.strStartdate,
        this.strEnddate,
        this.dtdate,
        this.decDebitAmt,
        this.decCreditAmt,
        this.decBalance});

  CustomerDailyReportData.fromJson(Map<String, dynamic> json) {
    intid = json['intid'];
    intCompanyid = json['intCompanyid'];
    intCustomerid = json['intCustomerid'];
    strStartdate = json['strStartdate'];
    strEnddate = json['strEnddate'];
    dtdate = json['dtdate'];
    decDebitAmt = json['decDebitAmt'];
    decCreditAmt = json['decCreditAmt'];
    decBalance = json['DecBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intid'] = this.intid;
    data['intCompanyid'] = this.intCompanyid;
    data['intCustomerid'] = this.intCustomerid;
    data['strStartdate'] = this.strStartdate;
    data['strEnddate'] = this.strEnddate;
    data['dtdate'] = this.dtdate;
    data['decDebitAmt'] = this.decDebitAmt;
    data['decCreditAmt'] = this.decCreditAmt;
    data['DecBalance'] = this.decBalance;
    return data;
  }
}