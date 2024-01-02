class AddItem_Body {
  String? strFile;
  int? intCompanyId;
  int? strItemCode;
  String? itemName;
  String? strDescription;
  int? intRank;
  int? decOpningStock;
  bool? bisIsdisplayonweb;
  bool? bisIsNew;

  AddItem_Body(
      {this.strFile,
        this.intCompanyId,
        this.strItemCode,
        this.itemName,
        this.strDescription,
        this.intRank,
        this.decOpningStock,
        this.bisIsdisplayonweb,
        this.bisIsNew});

  AddItem_Body.fromJson(Map<String, dynamic> json) {
    strFile = json['strFile'];
    intCompanyId = json['intCompanyId'];
    strItemCode = json['strItemCode'];
    itemName = json['ItemName'];
    strDescription = json['strDescription'];
    intRank = json['intRank'];
    decOpningStock = json['decOpningStock'];
    bisIsdisplayonweb = json['bisIsdisplayonweb'];
    bisIsNew = json['bisIsNew'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['strFile'] = this.strFile;
    data['intCompanyId'] = this.intCompanyId;
    data['strItemCode'] = this.strItemCode;
    data['ItemName'] = this.itemName;
    data['strDescription'] = this.strDescription;
    data['intRank'] = this.intRank;
    data['decOpningStock'] = this.decOpningStock;
    data['bisIsdisplayonweb'] = this.bisIsdisplayonweb;
    data['bisIsNew'] = this.bisIsNew;
    return data;
  }
}