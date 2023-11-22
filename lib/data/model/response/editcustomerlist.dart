class EditCustomerList_Response {
  List<EditCustomerListData>? data;
  String? strMessage;
  String? strStatus;

  EditCustomerList_Response({this.data, this.strMessage, this.strStatus});

  EditCustomerList_Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <EditCustomerListData>[];
      json['data'].forEach((v) {
        data!.add(new EditCustomerListData.fromJson(v));
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

class EditCustomerListData {
  int? intId;
  int? intCompanyid;
  String? strCompanyName;
  String? strFirstName;
  String? strLastName;
  String? strStatus;
  String? strEmail;
  String? strPassword;
  String? strMobileno;
  int? intModifiedBy;
  String? dtModifiedDate;

  EditCustomerListData(
      {this.intId,
        this.intCompanyid,
        this.strCompanyName,
        this.strFirstName,
        this.strLastName,
        this.strStatus,
        this.strEmail,
        this.strPassword,
        this.strMobileno,
        this.intModifiedBy,
        this.dtModifiedDate});

  EditCustomerListData.fromJson(Map<String, dynamic> json) {
    intId = json['intId'];
    intCompanyid = json['intCompanyid'];
    strCompanyName = json['strCompanyName'];
    strFirstName = json['strFirstName'];
    strLastName = json['strLastName'];
    strStatus = json['strStatus'];
    strEmail = json['strEmail'];
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
    data['strEmail'] = this.strEmail;
    data['strPassword'] = this.strPassword;
    data['strMobileno'] = this.strMobileno;
    data['intModifiedBy'] = this.intModifiedBy;
    data['dtModifiedDate'] = this.dtModifiedDate;
    return data;
  }
}