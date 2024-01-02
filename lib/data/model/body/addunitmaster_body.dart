class AddUnitBody {
  int? intid;
  String? strname;
  int? intCompanyid;
  int? createdBy;

  AddUnitBody({this.intid, this.strname, this.intCompanyid, this.createdBy});

  AddUnitBody.fromJson(Map<String, dynamic> json) {
    intid = json['intid'];
    strname = json['strname'];
    intCompanyid = json['intCompanyid'];
    createdBy = json['CreatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intid'] = this.intid;
    data['strname'] = this.strname;
    data['intCompanyid'] = this.intCompanyid;
    data['CreatedBy'] = this.createdBy;
    return data;
  }
}