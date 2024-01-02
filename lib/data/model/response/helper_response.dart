class ItemList_Response {
  List<ItemData>? data;
  String? strMsg;
  String? error;

  ItemList_Response({this.data, this.strMsg, this.error});

  ItemList_Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ItemData>[];
      json['data'].forEach((v) {
        data!.add(new ItemData.fromJson(v));
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

class ItemData {
  int? intid;
  int? intCompanyId;
  int? intCustomerId;
  String? itemName;
  String? strName;
  double? decScale;

  ItemData({this.intid, this.intCompanyId, this.intCustomerId,this.itemName, this.strName,this.decScale});

  ItemData.fromJson(Map<String, dynamic> json) {
    intid = json['intid'];
    intCompanyId = json['intCompanyId'];
    intCustomerId = json['intCustomerId'];
    itemName = json['itemName'];
    strName = json['strName'];
    decScale = json['decScale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intid'] = this.intid;
    data['intCompanyId'] = this.intCompanyId;
    data['intCustomerId'] = this.intCustomerId;
    data['itemName'] = this.itemName;
    data['strName'] = this.strName;
    data['decScale'] = this.decScale;
    return data;
  }
}