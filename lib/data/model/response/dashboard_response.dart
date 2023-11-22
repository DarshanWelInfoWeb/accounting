class Dashboard_Response {
  List<DashboardData>? data;
  String? strMessage;

  Dashboard_Response({this.data, this.strMessage});

  Dashboard_Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DashboardData>[];
      json['data'].forEach((v) {
        data!.add(new DashboardData.fromJson(v));
      });
    }
    strMessage = json['strMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['strMessage'] = this.strMessage;
    return data;
  }
}

class DashboardData {
  int? intId;
  int? intCompanyid;
  double? intTotalSale;
  int? intTotalOrders;
  int? intTotalCustomers;
  int? intTotalSuppliers;
  double? intThisMonthSale;
  double? intAverageSale;
  double? intTotalPurchase;
  double? intThisMonthPurchase;
  double? intTotalPayment;
  double? intThisMonthPayment;
  double? intTotalExpense;
  double? intThismonthExpense;
  int? intTotalItems;
  double? decTotalProfit;
  double? decTotalProfitPercentage;

  DashboardData(
      {this.intId,
        this.intCompanyid,
        this.intTotalSale,
        this.intTotalOrders,
        this.intTotalCustomers,
        this.intTotalSuppliers,
        this.intThisMonthSale,
        this.intAverageSale,
        this.intTotalPurchase,
        this.intThisMonthPurchase,
        this.intTotalPayment,
        this.intThisMonthPayment,
        this.intTotalExpense,
        this.intThismonthExpense,
        this.intTotalItems,
        this.decTotalProfit,
        this.decTotalProfitPercentage});

  DashboardData.fromJson(Map<String, dynamic> json) {
    intId = json['intId'];
    intCompanyid = json['intCompanyid'];
    intTotalSale = json['intTotalSale'];
    intTotalOrders = json['intTotalOrders'];
    intTotalCustomers = json['intTotalCustomers'];
    intTotalSuppliers = json['intTotalSuppliers'];
    intThisMonthSale = json['intThisMonthSale'];
    intAverageSale = json['intAverageSale'];
    intTotalPurchase = json['intTotalPurchase'];
    intThisMonthPurchase = json['intThisMonthPurchase'];
    intTotalPayment = json['intTotalPayment'];
    intThisMonthPayment = json['intThisMonthPayment'];
    intTotalExpense = json['intTotalExpense'];
    intThismonthExpense = json['intThismonthExpense'];
    intTotalItems = json['intTotalItems'];
    decTotalProfit = json['decTotalProfit'];
    decTotalProfitPercentage = json['decTotalProfitPercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intId'] = this.intId;
    data['intCompanyid'] = this.intCompanyid;
    data['intTotalSale'] = this.intTotalSale;
    data['intTotalOrders'] = this.intTotalOrders;
    data['intTotalCustomers'] = this.intTotalCustomers;
    data['intTotalSuppliers'] = this.intTotalSuppliers;
    data['intThisMonthSale'] = this.intThisMonthSale;
    data['intAverageSale'] = this.intAverageSale;
    data['intTotalPurchase'] = this.intTotalPurchase;
    data['intThisMonthPurchase'] = this.intThisMonthPurchase;
    data['intTotalPayment'] = this.intTotalPayment;
    data['intThisMonthPayment'] = this.intThisMonthPayment;
    data['intTotalExpense'] = this.intTotalExpense;
    data['intThismonthExpense'] = this.intThismonthExpense;
    data['intTotalItems'] = this.intTotalItems;
    data['decTotalProfit'] = this.decTotalProfit;
    data['decTotalProfitPercentage'] = this.decTotalProfitPercentage;
    return data;
  }
}