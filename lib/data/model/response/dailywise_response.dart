class DailyWiseReport_Response {
  List<DailyWiseReportData>? data;
  String? strMsg;
  String? error;

  DailyWiseReport_Response({this.data, this.strMsg, this.error});

  DailyWiseReport_Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DailyWiseReportData>[];
      json['data'].forEach((v) {
        data!.add(new DailyWiseReportData.fromJson(v));
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

class DailyWiseReportData {
  int? intCompanyid;
  String? dtFromDate;
  String? dtToDate;
  String? dtDate;
  double? decSale;
  double? decPayment;
  double? decOnline;
  double? decCash;
  double? decPurchase;
  double? decExpense;
  double? decOnlinePurchase;
  double? decCashPurchase;
  double? decTotalAmount;
  double? decCashAmount;
  double? decOnlineAmount;

  DailyWiseReportData(
      {this.intCompanyid,
        this.dtFromDate,
        this.dtToDate,
        this.dtDate,
        this.decSale,
        this.decPayment,
        this.decOnline,
        this.decCash,
        this.decPurchase,
        this.decExpense,
        this.decOnlinePurchase,
        this.decCashPurchase,
        this.decTotalAmount,
        this.decCashAmount,
        this.decOnlineAmount});

  DailyWiseReportData.fromJson(Map<String, dynamic> json) {
    intCompanyid = json['intCompanyid'];
    dtFromDate = json['dtFromDate'];
    dtToDate = json['dtToDate'];
    dtDate = json['dtDate'];
    decSale = json['decSale'];
    decPayment = json['decPayment'];
    decOnline = json['decOnline'];
    decCash = json['decCash'];
    decPurchase = json['decPurchase'];
    decExpense = json['decExpense'];
    decOnlinePurchase = json['decOnlinePurchase'];
    decCashPurchase = json['decCashPurchase'];
    decTotalAmount = json['decTotalAmount'];
    decCashAmount = json['decCashAmount'];
    decOnlineAmount = json['decOnlineAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intCompanyid'] = this.intCompanyid;
    data['dtFromDate'] = this.dtFromDate;
    data['dtToDate'] = this.dtToDate;
    data['dtDate'] = this.dtDate;
    data['decSale'] = this.decSale;
    data['decPayment'] = this.decPayment;
    data['decOnline'] = this.decOnline;
    data['decCash'] = this.decCash;
    data['decPurchase'] = this.decPurchase;
    data['decExpense'] = this.decExpense;
    data['decOnlinePurchase'] = this.decOnlinePurchase;
    data['decCashPurchase'] = this.decCashPurchase;
    data['decTotalAmount'] = this.decTotalAmount;
    data['decCashAmount'] = this.decCashAmount;
    data['decOnlineAmount'] = this.decOnlineAmount;
    return data;
  }
}

class ProfitLossResponseList {
  List<ProfitLossData>? data1;
  String? strMsg;
  String? error;

  ProfitLossResponseList({this.data1, this.strMsg, this.error});

  ProfitLossResponseList.fromJson(Map<String, dynamic> json) {
    if (json['data1'] != null) {
      data1 = <ProfitLossData>[];
      json['data1'].forEach((v) {
        data1!.add(new ProfitLossData.fromJson(v));
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

class ProfitLossData {
  int? intid;
  String? strCustomerName;
  String? strInvoiceno;
  String? dtInvoiceDate;
  int? intCompanyid;
  double? totalQty;
  double? decTotalSellAmount;
  double? decProfit;
  double? decTotalProfitPercentage;

  ProfitLossData(
      {this.intid,
        this.strCustomerName,
        this.strInvoiceno,
        this.dtInvoiceDate,
        this.intCompanyid,
        this.totalQty,
        this.decTotalSellAmount,
        this.decProfit,
        this.decTotalProfitPercentage});

  ProfitLossData.fromJson(Map<String, dynamic> json) {
    intid = json['intid'];
    strCustomerName = json['strCustomerName'];
    strInvoiceno = json['strInvoiceno'];
    dtInvoiceDate = json['dtInvoiceDate'];
    intCompanyid = json['intCompanyid'];
    totalQty = json['TotalQty'];
    decTotalSellAmount = json['decTotalSellAmount'];
    decProfit = json['DecProfit'];
    decTotalProfitPercentage = json['decTotalProfitPercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intid'] = this.intid;
    data['strCustomerName'] = this.strCustomerName;
    data['strInvoiceno'] = this.strInvoiceno;
    data['dtInvoiceDate'] = this.dtInvoiceDate;
    data['intCompanyid'] = this.intCompanyid;
    data['TotalQty'] = this.totalQty;
    data['decTotalSellAmount'] = this.decTotalSellAmount;
    data['DecProfit'] = this.decProfit;
    data['decTotalProfitPercentage'] = this.decTotalProfitPercentage;
    return data;
  }
}


class SalesChartResponse {
  List<SalesChartData>? data;
  String? strMsg;
  String? error;

  SalesChartResponse({this.data, this.strMsg, this.error});

  SalesChartResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SalesChartData>[];
      json['data'].forEach((v) {
        data!.add(new SalesChartData.fromJson(v));
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

class SalesChartData {
  String? dtDate;
  double? intTotalSale;
  double? intAverageSale;

  SalesChartData({this.dtDate, this.intTotalSale, this.intAverageSale});

  SalesChartData.fromJson(Map<String, dynamic> json) {
    dtDate = json['dtDate'];
    intTotalSale = json['intTotalSale'];
    intAverageSale = json['intAverageSale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dtDate'] = this.dtDate;
    data['intTotalSale'] = this.intTotalSale;
    data['intAverageSale'] = this.intAverageSale;
    return data;
  }
}

class SalesPaymentChartResponse {
  List<SalesPaymentChartData>? data;
  String? strMsg;
  String? error;

  SalesPaymentChartResponse({this.data, this.strMsg, this.error});

  SalesPaymentChartResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SalesPaymentChartData>[];
      json['data'].forEach((v) {
        data!.add(new SalesPaymentChartData.fromJson(v));
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

class SalesPaymentChartData {
  String? dtDate;
  double? intTotalSale;
  double? intTotalPayment;
  double? intTotalDue;

  SalesPaymentChartData(
      {this.dtDate, this.intTotalSale, this.intTotalPayment, this.intTotalDue});

  SalesPaymentChartData.fromJson(Map<String, dynamic> json) {
    dtDate = json['dtDate'];
    intTotalSale = json['intTotalSale'];
    intTotalPayment = json['intTotalPayment'];
    intTotalDue = json['intTotalDue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dtDate'] = this.dtDate;
    data['intTotalSale'] = this.intTotalSale;
    data['intTotalPayment'] = this.intTotalPayment;
    data['intTotalDue'] = this.intTotalDue;
    return data;
  }
}
