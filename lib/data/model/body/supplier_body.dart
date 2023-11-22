class AddSupplierBody {
  String? strCompanyName;
  String? strContactPersonName;
  int? strContactMobilenumber;
  String? strAddress;
  int? intCreatedBy;
  int? intCompanyId;

  AddSupplierBody(
      {this.strCompanyName,
        this.strContactPersonName,
        this.strContactMobilenumber,
        this.strAddress,
        this.intCreatedBy,
        this.intCompanyId,});

  AddSupplierBody.fromJson(Map<String, dynamic> json) {
    strCompanyName = json['strCompanyName'];
    strContactPersonName = json['strContactPersonName'];
    strContactMobilenumber = json['strContactMobilenumber'];
    strAddress = json['strAddress'];
    intCreatedBy = json['intCreatedBy'];
    intCompanyId = json['intCompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['strCompanyName'] = this.strCompanyName;
    data['strContactPersonName'] = this.strContactPersonName;
    data['strContactMobilenumber'] = this.strContactMobilenumber;
    data['strAddress'] = this.strAddress;
    data['intCreatedBy'] = this.intCreatedBy;
    data['intCompanyId'] = this.intCompanyId;
    return data;
  }
}

class UpdateSupplierBody {
  int? intid;
  String? strCompanyName;
  String? strContactPersonName;
  int? strContactMobilenumber;
  String? strAddress;
  int? intCreatedBy;
  int? intCompanyId;

  UpdateSupplierBody(
      {this.intid,
        this.strCompanyName,
        this.strContactPersonName,
        this.strContactMobilenumber,
        this.strAddress,
        this.intCreatedBy,
        this.intCompanyId});

  UpdateSupplierBody.fromJson(Map<String, dynamic> json) {
    intid = json['intid'];
    strCompanyName = json['strCompanyName'];
    strContactPersonName = json['strContactPersonName'];
    strContactMobilenumber = json['strContactMobilenumber'];
    strAddress = json['strAddress'];
    intCreatedBy = json['intCreatedBy'];
    intCompanyId = json['intCompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intid'] = this.intid;
    data['strCompanyName'] = this.strCompanyName;
    data['strContactPersonName'] = this.strContactPersonName;
    data['strContactMobilenumber'] = this.strContactMobilenumber;
    data['strAddress'] = this.strAddress;
    data['intCreatedBy'] = this.intCreatedBy;
    data['intCompanyId'] = this.intCompanyId;
    return data;
  }
}

class Item_Body {
  int? intInvoiceid;
  int? itemid;
  String? strHsnCode;
  int? intQty;
  int? decPrice;
  int? decTotalAmount;
  int? intCompanyid;

  Item_Body(
      {this.intInvoiceid,
        this.itemid,
        this.strHsnCode,
        this.intQty,
        this.decPrice,
        this.decTotalAmount,
        this.intCompanyid});

  Item_Body.fromJson(Map<String, dynamic> json) {
    intInvoiceid = json['intInvoiceid'];
    itemid = json['itemid'];
    strHsnCode = json['strHsnCode'];
    intQty = json['intQty'];
    decPrice = json['decPrice'];
    decTotalAmount = json['decTotalAmount'];
    intCompanyid = json['intCompanyid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intInvoiceid'] = this.intInvoiceid;
    data['itemid'] = this.itemid;
    data['strHsnCode'] = this.strHsnCode;
    data['intQty'] = this.intQty;
    data['decPrice'] = this.decPrice;
    data['decTotalAmount'] = this.decTotalAmount;
    data['intCompanyid'] = this.intCompanyid;
    return data;
  }
}

class AddSupplierPaymentBody {
  int? intid;
  String? strInvoiceno;
  String? dtpaymentdate;
  int? decAmount;
  int? decOnlinePayment;
  int? decCashPayment;
  String? strRemarks;
  int? intSupplierid;
  int? intCreatedby;
  int? intCompanyid;

  AddSupplierPaymentBody(
      {this.intid,
        this.strInvoiceno,
        this.dtpaymentdate,
        this.decAmount,
        this.decOnlinePayment,
        this.decCashPayment,
        this.strRemarks,
        this.intSupplierid,
        this.intCreatedby,
        this.intCompanyid});

  AddSupplierPaymentBody.fromJson(Map<String, dynamic> json) {
    intid = json['intid'];
    strInvoiceno = json['strInvoiceno'];
    dtpaymentdate = json['dtpaymentdate'];
    decAmount = json['decAmount'];
    decOnlinePayment = json['decOnlinePayment'];
    decCashPayment = json['decCashPayment'];
    strRemarks = json['strRemarks'];
    intSupplierid = json['intSupplierid'];
    intCreatedby = json['intCreatedby'];
    intCompanyid = json['intCompanyid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intid'] = this.intid;
    data['strInvoiceno'] = this.strInvoiceno;
    data['dtpaymentdate'] = this.dtpaymentdate;
    data['decAmount'] = this.decAmount;
    data['decOnlinePayment'] = this.decOnlinePayment;
    data['decCashPayment'] = this.decCashPayment;
    data['strRemarks'] = this.strRemarks;
    data['intSupplierid'] = this.intSupplierid;
    data['intCreatedby'] = this.intCreatedby;
    data['intCompanyid'] = this.intCompanyid;
    return data;
  }
}

class SupplierPaymentListResponse {
  List<SupplierPaymentData>? data;
  String? strMsg;
  String? error;

  SupplierPaymentListResponse({this.data, this.strMsg, this.error});

  SupplierPaymentListResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SupplierPaymentData>[];
      json['data'].forEach((v) {
        data!.add(new SupplierPaymentData.fromJson(v));
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

class SupplierPaymentData {
  int? intid;
  String? strInvoiceno;
  String? dtpaymentdate;
  double? decAmount;
  double? decOnlinePayment;
  double? decCashPayment;
  String? strSuppliername;
  String? strRemarks;
  int? intSupplierid;

  SupplierPaymentData(
      {this.intid,
        this.strInvoiceno,
        this.dtpaymentdate,
        this.decAmount,
        this.decOnlinePayment,
        this.decCashPayment,
        this.strSuppliername,
        this.strRemarks,
        this.intSupplierid});

  SupplierPaymentData.fromJson(Map<String, dynamic> json) {
    intid = json['intid'];
    strInvoiceno = json['strInvoiceno'];
    dtpaymentdate = json['dtpaymentdate'];
    decAmount = json['decAmount'];
    decOnlinePayment = json['decOnlinePayment'];
    decCashPayment = json['decCashPayment'];
    strSuppliername = json['strSuppliername'];
    strRemarks = json['strRemarks'];
    intSupplierid = json['intSupplierid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intid'] = this.intid;
    data['strInvoiceno'] = this.strInvoiceno;
    data['dtpaymentdate'] = this.dtpaymentdate;
    data['decAmount'] = this.decAmount;
    data['decOnlinePayment'] = this.decOnlinePayment;
    data['decCashPayment'] = this.decCashPayment;
    data['strSuppliername'] = this.strSuppliername;
    data['strRemarks'] = this.strRemarks;
    data['intSupplierid'] = this.intSupplierid;
    return data;
  }
}

class SupplierSelectItemListResponse {
  List<SupplierSelectItemData1>? data1;
  String? strMsg;
  String? error;

  SupplierSelectItemListResponse({this.data1, this.strMsg, this.error});

  SupplierSelectItemListResponse.fromJson(Map<String, dynamic> json) {
    if (json['data1'] != null) {
      data1 = <SupplierSelectItemData1>[];
      json['data1'].forEach((v) {
        data1!.add(new SupplierSelectItemData1.fromJson(v));
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

class SupplierSelectItemData1 {
  int? intid;
  int? intitemid;
  String? strItemname;
  int? intSupplierid;
  String? strUnitName;
  double? decrate;
  int? intcompanyid;

  SupplierSelectItemData1(
      {this.intid,
        this.intitemid,
        this.strItemname,
        this.intSupplierid,
        this.strUnitName,
        this.decrate,
        this.intcompanyid});

  SupplierSelectItemData1.fromJson(Map<String, dynamic> json) {
    intid = json['intid'];
    intitemid = json['intitemid'];
    strItemname = json['strItemname'];
    intSupplierid = json['intSupplierid'];
    strUnitName = json['strUnitName'];
    decrate = json['decrate'];
    intcompanyid = json['intcompanyid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intid'] = this.intid;
    data['intitemid'] = this.intitemid;
    data['strItemname'] = this.strItemname;
    data['intSupplierid'] = this.intSupplierid;
    data['strUnitName'] = this.strUnitName;
    data['decrate'] = this.decrate;
    data['intcompanyid'] = this.intcompanyid;
    return data;
  }
}


class SupplierSGSTResponse {
  List<SupplierSGSTData>? data;
  String? strMsg;
  String? error;

  SupplierSGSTResponse({this.data, this.strMsg, this.error});

  SupplierSGSTResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SupplierSGSTData>[];
      json['data'].forEach((v) {
        data!.add(new SupplierSGSTData.fromJson(v));
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

class SupplierSGSTData {
  String? strKey;
  String? strValue;
  int? intid;

  SupplierSGSTData({this.strKey, this.strValue, this.intid});

  SupplierSGSTData.fromJson(Map<String, dynamic> json) {
    strKey = json['strKey'];
    strValue = json['strValue'];
    intid = json['intid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['strKey'] = this.strKey;
    data['strValue'] = this.strValue;
    data['intid'] = this.intid;
    return data;
  }
}

class SupplierCGSTResponse {
  List<SupplierCGSTData>? data;
  String? strMsg;
  String? error;

  SupplierCGSTResponse({this.data, this.strMsg, this.error});

  SupplierCGSTResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SupplierCGSTData>[];
      json['data'].forEach((v) {
        data!.add(new SupplierCGSTData.fromJson(v));
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

class SupplierCGSTData {
  String? strKey;
  String? strValue;
  int? intid;

  SupplierCGSTData({this.strKey, this.strValue, this.intid});

  SupplierCGSTData.fromJson(Map<String, dynamic> json) {
    strKey = json['strKey'];
    strValue = json['strValue'];
    intid = json['intid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['strKey'] = this.strKey;
    data['strValue'] = this.strValue;
    data['intid'] = this.intid;
    return data;
  }
}


