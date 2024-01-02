class ExpenseType_Response {
  List<ExpenseTypeData>? data;
  String? strMsg;
  String? error;

  ExpenseType_Response({this.data, this.strMsg, this.error});

  ExpenseType_Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ExpenseTypeData>[];
      json['data'].forEach((v) {
        data!.add(new ExpenseTypeData.fromJson(v));
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

class ExpenseTypeData {
  int? type;
  int? intExpenseTypeId;
  String? expenseType;
  int? intId;
  String? strTitle;
  String? strDescription;
  double? decAmount;
  String? dtDate;
  int? intCompanyId;
  double? decOnlinepayment;
  double? decCashpayment;
  String? strAttachment;
  String? strImageFileName;
  String? strmsg;

  ExpenseTypeData(
      {this.type,
        this.intExpenseTypeId,
        this.expenseType,
        this.intId,
        this.strTitle,
        this.strDescription,
        this.decAmount,
        this.dtDate,
        this.intCompanyId,
        this.decOnlinepayment,
        this.decCashpayment,
        this.strAttachment,
        this.strImageFileName,
        this.strmsg});

  ExpenseTypeData.fromJson(Map<String, dynamic> json) {
    type = json['Type'];
    intExpenseTypeId = json['intExpenseTypeId'];
    expenseType = json['ExpenseType'];
    intId = json['intId'];
    strTitle = json['strTitle'];
    strDescription = json['strDescription'];
    decAmount = json['decAmount'];
    dtDate = json['dtDate'];
    intCompanyId = json['intCompanyId'];
    decOnlinepayment = json['decOnlinepayment'];
    decCashpayment = json['decCashpayment'];
    strAttachment = json['strAttachment'];
    strImageFileName = json['strImageFileName'];
    strmsg = json['strmsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Type'] = this.type;
    data['intExpenseTypeId'] = this.intExpenseTypeId;
    data['ExpenseType'] = this.expenseType;
    data['intId'] = this.intId;
    data['strTitle'] = this.strTitle;
    data['strDescription'] = this.strDescription;
    data['decAmount'] = this.decAmount;
    data['dtDate'] = this.dtDate;
    data['intCompanyId'] = this.intCompanyId;
    data['decOnlinepayment'] = this.decOnlinepayment;
    data['decCashpayment'] = this.decCashpayment;
    data['strAttachment'] = this.strAttachment;
    data['strImageFileName'] = this.strImageFileName;
    data['strmsg'] = this.strmsg;
    return data;
  }
}