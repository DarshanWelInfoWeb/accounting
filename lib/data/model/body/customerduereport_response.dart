class CustomerDueReport_Response {
  List<CustomerDueReportData>? data;
  String? strMsg;
  String? error;

  CustomerDueReport_Response({this.data, this.strMsg, this.error});

  CustomerDueReport_Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CustomerDueReportData>[];
      json['data'].forEach((v) {
        data!.add(new CustomerDueReportData.fromJson(v));
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

class CustomerDueReportData {
  int? intCompanyid;
  int? intCustomerid;
  String? strCustomerName;
  String? strMobileNo;
  double? decDueAmount;
  String? dtLastpaymentdate;
  String? dtDuedate;
  double? decTotalDueAmount;

  CustomerDueReportData(
      {this.intCompanyid,
        this.intCustomerid,
        this.strCustomerName,
        this.strMobileNo,
        this.decDueAmount,
        this.dtLastpaymentdate,
        this.dtDuedate,
        this.decTotalDueAmount});

  CustomerDueReportData.fromJson(Map<String, dynamic> json) {
    intCompanyid = json['intCompanyid'];
    intCustomerid = json['intCustomerid'];
    strCustomerName = json['strCustomerName'];
    strMobileNo = json['strMobileNo'];
    decDueAmount = json['decDueAmount'];
    dtLastpaymentdate = json['dtLastpaymentdate'];
    dtDuedate = json['dtDuedate'];
    decTotalDueAmount = json['decTotalDueAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intCompanyid'] = this.intCompanyid;
    data['intCustomerid'] = this.intCustomerid;
    data['strCustomerName'] = this.strCustomerName;
    data['strMobileNo'] = this.strMobileNo;
    data['decDueAmount'] = this.decDueAmount;
    data['dtLastpaymentdate'] = this.dtLastpaymentdate;
    data['dtDuedate'] = this.dtDuedate;
    data['decTotalDueAmount'] = this.decTotalDueAmount;
    return data;
  }
}