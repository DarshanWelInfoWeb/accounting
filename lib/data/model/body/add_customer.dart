class Add_Customer {
  int? intCompanyid;
  String? strCompanyName;
  String? strFirstName;
  String? strLastName;
  String? strEmail;
  String? strPassword;
  int? strMobileno;

  Add_Customer(
      {this.intCompanyid,
        this.strCompanyName,
        this.strFirstName,
        this.strLastName,
        this.strEmail,
        this.strPassword,
        this.strMobileno});

  Add_Customer.fromJson(Map<String, dynamic> json) {
    intCompanyid = json['intCompanyid'];
    strCompanyName = json['strCompanyName'];
    strFirstName = json['strFirstName'];
    strLastName = json['strLastName'];
    strEmail = json['strEmail'];
    strPassword = json['strPassword'];
    strMobileno = json['strMobileno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intCompanyid'] = this.intCompanyid;
    data['strCompanyName'] = this.strCompanyName;
    data['strFirstName'] = this.strFirstName;
    data['strLastName'] = this.strLastName;
    data['strEmail'] = this.strEmail;
    data['strPassword'] = this.strPassword;
    data['strMobileno'] = this.strMobileno;
    return data;
  }
}

class Update_Customer {
  int? intId;
  int? intCompanyid;
  String? strCompanyName;
  String? strFirstName;
  String? strLastName;
  String? strEmail;
  String? strPassword;
  int? strMobileno;

  Update_Customer(
      {this.intId,
        this.intCompanyid,
        this.strCompanyName,
        this.strFirstName,
        this.strLastName,
        this.strEmail,
        this.strPassword,
        this.strMobileno});

  Update_Customer.fromJson(Map<String, dynamic> json) {
    intId = json['intId'];
    intCompanyid = json['intCompanyid'];
    strCompanyName = json['strCompanyName'];
    strFirstName = json['strFirstName'];
    strLastName = json['strLastName'];
    strEmail = json['strEmail'];
    strPassword = json['strPassword'];
    strMobileno = json['strMobileno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intId'] = this.intId;
    data['intCompanyid'] = this.intCompanyid;
    data['strCompanyName'] = this.strCompanyName;
    data['strFirstName'] = this.strFirstName;
    data['strLastName'] = this.strLastName;
    data['strEmail'] = this.strEmail;
    data['strPassword'] = this.strPassword;
    data['strMobileno'] = this.strMobileno;
    return data;
  }
}