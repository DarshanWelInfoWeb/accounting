class UnitMasterListResponse {
  List<UnitMasterData>? data;
  String? strMsg;
  String? error;

  UnitMasterListResponse({this.data, this.strMsg, this.error});

  UnitMasterListResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <UnitMasterData>[];
      json['data'].forEach((v) {
        data!.add(new UnitMasterData.fromJson(v));
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

class UnitMasterData {
  int? intid;
  String? strname;
  bool? boolStatus;

  UnitMasterData({this.intid, this.strname, this.boolStatus});

  UnitMasterData.fromJson(Map<String, dynamic> json) {
    intid = json['intid'];
    strname = json['strname'];
    boolStatus = json['BoolStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intid'] = this.intid;
    data['strname'] = this.strname;
    data['BoolStatus'] = this.boolStatus;
    return data;
  }
}