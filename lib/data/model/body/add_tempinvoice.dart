class AddTempInvoiceBody {
  int? intRouteId;
  int? intCustomerId;
  String? dtInvoiceDate;
  int? intCompanyId;
  double? decSubTotal;
  double? decDueAmount;
  double? decGrandTotal;
  String? decOnlinePayment;
  String? decCashPayment;
  String? decTotalAmount;

  AddTempInvoiceBody(
      {this.intRouteId,
        this.intCustomerId,
        this.dtInvoiceDate,
        this.intCompanyId,
        this.decSubTotal,
        this.decDueAmount,
        this.decGrandTotal,
        this.decOnlinePayment,
        this.decCashPayment,
        this.decTotalAmount});

  AddTempInvoiceBody.fromJson(Map<String, dynamic> json) {
    intRouteId = json['intRouteId'];
    intCustomerId = json['intCustomerId'];
    dtInvoiceDate = json['dtInvoiceDate'];
    intCompanyId = json['intCompanyId'];
    decSubTotal = json['decSubTotal'];
    decDueAmount = json['decDueAmount'];
    decGrandTotal = json['decGrandTotal'];
    decOnlinePayment = json['decOnlinePayment'];
    decCashPayment = json['decCashPayment'];
    decTotalAmount = json['decTotalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intRouteId'] = this.intRouteId;
    data['intCustomerId'] = this.intCustomerId;
    data['dtInvoiceDate'] = this.dtInvoiceDate;
    data['intCompanyId'] = this.intCompanyId;
    data['decSubTotal'] = this.decSubTotal;
    data['decDueAmount'] = this.decDueAmount;
    data['decGrandTotal'] = this.decGrandTotal;
    data['decOnlinePayment'] = this.decOnlinePayment;
    data['decCashPayment'] = this.decCashPayment;
    data['decTotalAmount'] = this.decTotalAmount;
    return data;
  }
}

class UpdateTempInvoiceBody {
  int? intid;
  int? intRouteId;
  int? intCustomerId;
  String? dtInvoiceDate;
  int? intCompanyId;
  double? decSubTotal;
  double? decDueAmount;
  double? decGrandTotal;
  double? decOnlinePayment;
  double? decCashPayment;
  double? decTotalAmount;

  UpdateTempInvoiceBody(
      {this.intid,
        this.intRouteId,
        this.intCustomerId,
        this.dtInvoiceDate,
        this.intCompanyId,
        this.decSubTotal,
        this.decDueAmount,
        this.decGrandTotal,
        this.decOnlinePayment,
        this.decCashPayment,
        this.decTotalAmount});

  UpdateTempInvoiceBody.fromJson(Map<String, dynamic> json) {
    intid = json['intid'];
    intRouteId = json['intRouteId'];
    intCustomerId = json['intCustomerId'];
    dtInvoiceDate = json['dtInvoiceDate'];
    intCompanyId = json['intCompanyId'];
    decSubTotal = json['decSubTotal'];
    decDueAmount = json['decDueAmount'];
    decGrandTotal = json['decGrandTotal'];
    decOnlinePayment = json['decOnlinePayment'];
    decCashPayment = json['decCashPayment'];
    decTotalAmount = json['decTotalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intid'] = this.intid;
    data['intRouteId'] = this.intRouteId;
    data['intCustomerId'] = this.intCustomerId;
    data['dtInvoiceDate'] = this.dtInvoiceDate;
    data['intCompanyId'] = this.intCompanyId;
    data['decSubTotal'] = this.decSubTotal;
    data['decDueAmount'] = this.decDueAmount;
    data['decGrandTotal'] = this.decGrandTotal;
    data['decOnlinePayment'] = this.decOnlinePayment;
    data['decCashPayment'] = this.decCashPayment;
    data['decTotalAmount'] = this.decTotalAmount;
    return data;
  }
}

class TempStock_Body {
  int? id;
  int? inttempinvoiceId;
  int? intItemsDetails;
  String? name;
  String? strName;
  int? decQty;
  int? decRate;
  int? decAmount;

  TempStock_Body(
      {this.id,
        this.inttempinvoiceId,
        this.intItemsDetails,
        this.name,
        this.strName,
        this.decQty,
        this.decRate,
        this.decAmount});

  TempStock_Body.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    inttempinvoiceId = json['inttempinvoiceId'];
    intItemsDetails = json['intItemsDetails'];
    name = json['name'];
    strName = json['strName'];
    decQty = json['decQty'];
    decRate = json['decRate'];
    decAmount = json['decAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['inttempinvoiceId'] = this.inttempinvoiceId;
    data['intItemsDetails'] = this.intItemsDetails;
    data['name'] = this.name;
    data['strName'] = this.strName;
    data['decQty'] = this.decQty;
    data['decRate'] = this.decRate;
    data['decAmount'] = this.decAmount;
    return data;
  }
}

class MainInvoiceStockBody {
  int? id;
  String? strHSNCode;
  int? intitemid;
  String? name;
  String? strName;
  int? decQty;
  int? decRate;
  int? decAmount;
  int? intcompanyid;

  MainInvoiceStockBody(
      {this.id,
        this.strHSNCode,
        this.intitemid,
        this.name,
        this.strName,
        this.decQty,
        this.decRate,
        this.decAmount,
        this.intcompanyid});

  MainInvoiceStockBody.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    strHSNCode = json['strHSNCode'];
    intitemid = json['intitemid'];
    name = json['name'];
    strName = json['strName'];
    decQty = json['decQty'];
    decRate = json['decRate'];
    decAmount = json['decAmount'];
    intcompanyid = json['intcompanyid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['strHSNCode'] = this.strHSNCode;
    data['intitemid'] = this.intitemid;
    data['name'] = this.name;
    data['strName'] = this.strName;
    data['decQty'] = this.decQty;
    data['decRate'] = this.decRate;
    data['decAmount'] = this.decAmount;
    data['intcompanyid'] = this.intcompanyid;
    return data;
  }
}