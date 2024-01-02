class AddExpenseTypeBody {
  int? intId;
  int? intCompanyId;
  int? intClientId;
  int? intUserId;
  String? strName;

  AddExpenseTypeBody(
      {this.intId,
        this.intCompanyId,
        this.intClientId,
        this.intUserId,
        this.strName});

  AddExpenseTypeBody.fromJson(Map<String, dynamic> json) {
    intId = json['intId'];
    intCompanyId = json['intCompanyId'];
    intClientId = json['intClientId'];
    intUserId = json['intUserId'];
    strName = json['strName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intId'] = this.intId;
    data['intCompanyId'] = this.intCompanyId;
    data['intClientId'] = this.intClientId;
    data['intUserId'] = this.intUserId;
    data['strName'] = this.strName;
    return data;
  }
}