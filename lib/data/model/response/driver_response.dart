class DriverList_Response {
  List<DriverData>? data;
  String? strMsg;
  String? error;

  DriverList_Response({this.data, this.strMsg, this.error});

  DriverList_Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DriverData>[];
      json['data'].forEach((v) {
        data!.add(new DriverData.fromJson(v));
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

class DriverData {
  int? intId;
  String? srtFullName;

  DriverData({this.intId, this.srtFullName});

  DriverData.fromJson(Map<String, dynamic> json) {
    intId = json['intId'];
    srtFullName = json['srtFullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intId'] = this.intId;
    data['srtFullName'] = this.srtFullName;
    return data;
  }
}