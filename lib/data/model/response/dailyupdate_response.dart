class DailyUpdateList_Response {
  List<DailyUpdateData>? data;
  String? strMessage;
  String? strStatus;

  DailyUpdateList_Response({this.data, this.strMessage, this.strStatus});

  DailyUpdateList_Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DailyUpdateData>[];
      json['data'].forEach((v) {
        data!.add(new DailyUpdateData.fromJson(v));
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

class DailyUpdateData {
  int? intCompanyId;
  String? itemName;
  double? decAmount;
  double? profit;
  double? decQty;
  double? decOnlinePayment;
  String? dtInvoiceDate;
  double? decPurcharePrice;
  double? decCashPayment;
  double? totalAmount;
  double? expensedecOnlinepayment;
  double? expensedecCashpayment;
  double? expenseTotalAmount;

  DailyUpdateData(
      {this.intCompanyId,
        this.itemName,
        this.decAmount,
        this.profit,
        this.decQty,
        this.decOnlinePayment,
        this.dtInvoiceDate,
        this.decPurcharePrice,
        this.decCashPayment,
        this.totalAmount,
        this.expensedecOnlinepayment,
        this.expensedecCashpayment,
        this.expenseTotalAmount});

  DailyUpdateData.fromJson(Map<String, dynamic> json) {
    intCompanyId = json['intCompanyId'];
    itemName = json['ItemName'];
    decAmount = json['decAmount'];
    profit = json['Profit'];
    decQty = json['decQty'];
    decOnlinePayment = json['decOnlinePayment'];
    dtInvoiceDate = json['dtInvoiceDate'];
    decPurcharePrice = json['decPurcharePrice'];
    decCashPayment = json['decCashPayment'];
    totalAmount = json['TotalAmount'];
    expensedecOnlinepayment = json['ExpensedecOnlinepayment'];
    expensedecCashpayment = json['ExpensedecCashpayment'];
    expenseTotalAmount = json['ExpenseTotalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intCompanyId'] = this.intCompanyId;
    data['ItemName'] = this.itemName;
    data['decAmount'] = this.decAmount;
    data['Profit'] = this.profit;
    data['decQty'] = this.decQty;
    data['decOnlinePayment'] = this.decOnlinePayment;
    data['dtInvoiceDate'] = this.dtInvoiceDate;
    data['decPurcharePrice'] = this.decPurcharePrice;
    data['decCashPayment'] = this.decCashPayment;
    data['TotalAmount'] = this.totalAmount;
    data['ExpensedecOnlinepayment'] = this.expensedecOnlinepayment;
    data['ExpensedecCashpayment'] = this.expensedecCashpayment;
    data['ExpenseTotalAmount'] = this.expenseTotalAmount;
    return data;
  }
}