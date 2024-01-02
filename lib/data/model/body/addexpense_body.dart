class AddExpense_Body {
  int? expenseintid;
  String? strTitle;
  String? strDescription;
  int? decAmount;
  String? dtExpenseDate;
  int? intCompanyId;
  int? decOnlinePayment;
  int? deccashPayment;
  String? strFile;

  AddExpense_Body(
      {this.expenseintid,
        this.strTitle,
        this.strDescription,
        this.decAmount,
        this.dtExpenseDate,
        this.intCompanyId,
        this.decOnlinePayment,
        this.deccashPayment,
        this.strFile});

  AddExpense_Body.fromJson(Map<String, dynamic> json) {
    expenseintid = json['Expenseintid'];
    strTitle = json['strTitle'];
    strDescription = json['strDescription'];
    decAmount = json['decAmount'];
    dtExpenseDate = json['dtExpenseDate'];
    intCompanyId = json['intCompanyId'];
    decOnlinePayment = json['decOnlinePayment'];
    deccashPayment = json['deccashPayment'];
    strFile = json['strFile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Expenseintid'] = this.expenseintid;
    data['strTitle'] = this.strTitle;
    data['strDescription'] = this.strDescription;
    data['decAmount'] = this.decAmount;
    data['dtExpenseDate'] = this.dtExpenseDate;
    data['intCompanyId'] = this.intCompanyId;
    data['decOnlinePayment'] = this.decOnlinePayment;
    data['deccashPayment'] = this.deccashPayment;
    data['strFile'] = this.strFile;
    return data;
  }
}

class UpdateExpense_Body {
  int? intId;
  int? expenseintid;
  String? strTitle;
  String? strDescription;
  int? decAmount;
  String? dtExpenseDate;
  int? intCompanyId;
  int? decOnlinePayment;
  int? deccashPayment;
  String? strFile;

  UpdateExpense_Body(
      {this.intId,
        this.expenseintid,
        this.strTitle,
        this.strDescription,
        this.decAmount,
        this.dtExpenseDate,
        this.intCompanyId,
        this.decOnlinePayment,
        this.deccashPayment,
        this.strFile});

  UpdateExpense_Body.fromJson(Map<String, dynamic> json) {
    intId = json['intId'];
    expenseintid = json['Expenseintid'];
    strTitle = json['strTitle'];
    strDescription = json['strDescription'];
    decAmount = json['decAmount'];
    dtExpenseDate = json['dtExpenseDate'];
    intCompanyId = json['intCompanyId'];
    decOnlinePayment = json['decOnlinePayment'];
    deccashPayment = json['deccashPayment'];
    strFile = json['strFile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intId'] = this.intId;
    data['Expenseintid'] = this.expenseintid;
    data['strTitle'] = this.strTitle;
    data['strDescription'] = this.strDescription;
    data['decAmount'] = this.decAmount;
    data['dtExpenseDate'] = this.dtExpenseDate;
    data['intCompanyId'] = this.intCompanyId;
    data['decOnlinePayment'] = this.decOnlinePayment;
    data['deccashPayment'] = this.deccashPayment;
    data['strFile'] = this.strFile;
    return data;
  }
}