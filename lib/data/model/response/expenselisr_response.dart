class ExpensList_Response {
  List<ExpenseListData>? data1;
  String? strMsg;
  String? error;

  ExpensList_Response({this.data1, this.strMsg, this.error});

  ExpensList_Response.fromJson(Map<String, dynamic> json) {
    if (json['data1'] != null) {
      data1 = <ExpenseListData>[];
      json['data1'].forEach((v) {
        data1!.add(new ExpenseListData.fromJson(v));
      });
    }
    strMsg = json['strMsg'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data1 != null) {
      data['data1'] = this.data1!.map((v) => v.toJson()).toList();
    }
    data['strMsg'] = this.strMsg;
    data['error'] = this.error;
    return data;
  }
}

class ExpenseListData {
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
  double? decTotalAmount;
  String? strmsg;

  ExpenseListData(
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
        this.decTotalAmount,
        this.strmsg});

  ExpenseListData.fromJson(Map<String, dynamic> json) {
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
    decTotalAmount = json['decTotalAmount'];
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
    data['decTotalAmount'] = this.decTotalAmount;
    data['strmsg'] = this.strmsg;
    return data;
  }
}

class ExpenseEdit_Response {
  List<ExpenseEditData>? data;
  String? strMsg;
  String? error;

  ExpenseEdit_Response({this.data, this.strMsg, this.error});

  ExpenseEdit_Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ExpenseEditData>[];
      json['data'].forEach((v) {
        data!.add(new ExpenseEditData.fromJson(v));
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

class ExpenseEditData {
  int? intRouteid;
  int? intExpenseTypeId;
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

  ExpenseEditData(
      {this.intRouteid,
        this.intExpenseTypeId,
        this.intId,
        this.strTitle,
        this.strDescription,
        this.decAmount,
        this.dtDate,
        this.intCompanyId,
        this.decOnlinepayment,
        this.decCashpayment,
        this.strAttachment,
        this.strImageFileName});

  ExpenseEditData.fromJson(Map<String, dynamic> json) {
    intRouteid = json['intRouteid'];
    intExpenseTypeId = json['intExpenseTypeId'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intRouteid'] = this.intRouteid;
    data['intExpenseTypeId'] = this.intExpenseTypeId;
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
    return data;
  }
}

class ExpenseTypeListResponse {
  List<ExpenseTypeListData>? data;
  String? strMessage;
  String? strStatus;

  ExpenseTypeListResponse({this.data, this.strMessage, this.strStatus});

  ExpenseTypeListResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ExpenseTypeListData>[];
      json['data'].forEach((v) {
        data!.add(new ExpenseTypeListData.fromJson(v));
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

class ExpenseTypeListData {
  int? intId;
  String? strName;
  int? intCompanyId;
  int? intClientId;
  int? intUserId;
  bool? bIsStatus;
  String? strResponse;

  ExpenseTypeListData(
      {this.intId,
        this.strName,
        this.intCompanyId,
        this.intClientId,
        this.intUserId,
        this.bIsStatus,
        this.strResponse});

  ExpenseTypeListData.fromJson(Map<String, dynamic> json) {
    intId = json['intId'];
    strName = json['strName'];
    intCompanyId = json['intCompanyId'];
    intClientId = json['intClientId'];
    intUserId = json['intUserId'];
    bIsStatus = json['bIsStatus'];
    strResponse = json['strResponse'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intId'] = this.intId;
    data['strName'] = this.strName;
    data['intCompanyId'] = this.intCompanyId;
    data['intClientId'] = this.intClientId;
    data['intUserId'] = this.intUserId;
    data['bIsStatus'] = this.bIsStatus;
    data['strResponse'] = this.strResponse;
    return data;
  }
}


class EditExpenseTypeListResponse {
  List<EditExpenseTypeData>? data;
  String? strMessage;

  EditExpenseTypeListResponse({this.data, this.strMessage});

  EditExpenseTypeListResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <EditExpenseTypeData>[];
      json['data'].forEach((v) {
        data!.add(new EditExpenseTypeData.fromJson(v));
      });
    }
    strMessage = json['strMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['strMessage'] = this.strMessage;
    return data;
  }
}

class EditExpenseTypeData {
  int? intId;
  String? strName;
  int? intCompanyId;
  int? intClientId;
  int? intUserId;
  String? bIsStatus;
  String? strResponse;

  EditExpenseTypeData(
      {this.intId,
        this.strName,
        this.intCompanyId,
        this.intClientId,
        this.intUserId,
        this.bIsStatus,
        this.strResponse});

  EditExpenseTypeData.fromJson(Map<String, dynamic> json) {
    intId = json['intId'];
    strName = json['strName'];
    intCompanyId = json['intCompanyId'];
    intClientId = json['intClientId'];
    intUserId = json['intUserId'];
    bIsStatus = json['bIsStatus'];
    strResponse = json['strResponse'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intId'] = this.intId;
    data['strName'] = this.strName;
    data['intCompanyId'] = this.intCompanyId;
    data['intClientId'] = this.intClientId;
    data['intUserId'] = this.intUserId;
    data['bIsStatus'] = this.bIsStatus;
    data['strResponse'] = this.strResponse;
    return data;
  }
}