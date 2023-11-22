class CustomerList_Response {
  List<CustomerListData>? data;
  String? strMessage;
  String? strStatus;

  CustomerList_Response({this.data, this.strMessage, this.strStatus});

  CustomerList_Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CustomerListData>[];
      json['data'].forEach((v) {
        data!.add(new CustomerListData.fromJson(v));
      });
    }
    strMessage = json['strMessage'];
    strStatus = json['strStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['strMessage'] = this.strMessage;
    data['strStatus'] = this.strStatus;
    return data;
  }
}

class CustomerListData {
  int? intId;
  int? intCompanyid;
  String? strCompanyName;
  String? strFirstName;
  String? strLastName;
  String? strStatus;
  String? strQrCode;
  String? strEmail;
  String? dtCreatedDate;
  String? strPassword;
  String? strMobileno;
  int? intModifiedBy;
  String? dtModifiedDate;

  CustomerListData(
      {this.intId,
        this.intCompanyid,
        this.strCompanyName,
        this.strFirstName,
        this.strLastName,
        this.strStatus,
        this.strQrCode,
        this.strEmail,
        this.dtCreatedDate,
        this.strPassword,
        this.strMobileno,
        this.intModifiedBy,
        this.dtModifiedDate});

  CustomerListData.fromJson(Map<String, dynamic> json) {
    intId = json['intId'];
    intCompanyid = json['intCompanyid'];
    strCompanyName = json['strCompanyName'];
    strFirstName = json['strFirstName'];
    strLastName = json['strLastName'];
    strStatus = json['strStatus'];
    strQrCode = json['strQrCode'];
    strEmail = json['strEmail'];
    dtCreatedDate = json['dtCreatedDate'];
    strPassword = json['strPassword'];
    strMobileno = json['strMobileno'];
    intModifiedBy = json['intModifiedBy'];
    dtModifiedDate = json['dtModifiedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intId'] = this.intId;
    data['intCompanyid'] = this.intCompanyid;
    data['strCompanyName'] = this.strCompanyName;
    data['strFirstName'] = this.strFirstName;
    data['strLastName'] = this.strLastName;
    data['strStatus'] = this.strStatus;
    data['strQrCode'] = this.strQrCode;
    data['strEmail'] = this.strEmail;
    data['dtCreatedDate'] = this.dtCreatedDate;
    data['strPassword'] = this.strPassword;
    data['strMobileno'] = this.strMobileno;
    data['intModifiedBy'] = this.intModifiedBy;
    data['dtModifiedDate'] = this.dtModifiedDate;
    return data;
  }
}