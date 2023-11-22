class SelectRouteList_Response {
  List<SelectRouteData>? data;
  String? strMsg;
  String? error;

  SelectRouteList_Response({this.data, this.strMsg, this.error});

  SelectRouteList_Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SelectRouteData>[];
      json['data'].forEach((v) {
        data!.add(new SelectRouteData.fromJson(v));
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

class SelectRouteData {
  int? intId;
  String? strRoute;

  SelectRouteData({this.intId, this.strRoute});

  SelectRouteData.fromJson(Map<String, dynamic> json) {
    intId = json['intId'];
    strRoute = json['StrRoute'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intId'] = this.intId;
    data['StrRoute'] = this.strRoute;
    return data;
  }
}