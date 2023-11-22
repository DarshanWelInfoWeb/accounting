class ItemsEdit_Response {
  List<ItemsEditData>? data;
  String? strMessage;
  String? strStatus;

  ItemsEdit_Response({this.data, this.strMessage, this.strStatus});

  ItemsEdit_Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ItemsEditData>[];
      json['data'].forEach((v) {
        data!.add(new ItemsEditData.fromJson(v));
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

class ItemsEditData {
  int? intId;
  int? strUnitselection;
  int? intCompanyId;
  String? strName;
  String? strItemCode;
  String? itemName;
  String? strDescription;
  String? strSpecification;
  int? intRank;
  double? decOpningStock;
  double? decAvailablestock;
  bool? bisIsdisplayonweb;
  bool? bisIsNew;
  String? strStatus;
  String? strFile;
  String? strImageFileName;

  ItemsEditData(
      {this.intId,
        this.strUnitselection,
        this.intCompanyId,
        this.strName,
        this.strItemCode,
        this.itemName,
        this.strDescription,
        this.strSpecification,
        this.intRank,
        this.decOpningStock,
        this.decAvailablestock,
        this.bisIsdisplayonweb,
        this.bisIsNew,
        this.strStatus,
        this.strFile,
        this.strImageFileName});

  ItemsEditData.fromJson(Map<String, dynamic> json) {
    intId = json['intId'];
    strUnitselection = json['strUnitselection'];
    intCompanyId = json['intCompanyId'];
    strName = json['strName'];
    strItemCode = json['strItemCode'];
    itemName = json['ItemName'];
    strDescription = json['strDescription'];
    strSpecification = json['strSpecification'];
    intRank = json['intRank'];
    decOpningStock = json['decOpningStock'];
    decAvailablestock = json['decAvailablestock'];
    bisIsdisplayonweb = json['bisIsdisplayonweb'];
    bisIsNew = json['bisIsNew'];
    strStatus = json['strStatus'];
    strFile = json['strFile'];
    strImageFileName = json['strImageFileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intId'] = this.intId;
    data['strUnitselection'] = this.strUnitselection;
    data['intCompanyId'] = this.intCompanyId;
    data['strName'] = this.strName;
    data['strItemCode'] = this.strItemCode;
    data['ItemName'] = this.itemName;
    data['strDescription'] = this.strDescription;
    data['strSpecification'] = this.strSpecification;
    data['intRank'] = this.intRank;
    data['decOpningStock'] = this.decOpningStock;
    data['decAvailablestock'] = this.decAvailablestock;
    data['bisIsdisplayonweb'] = this.bisIsdisplayonweb;
    data['bisIsNew'] = this.bisIsNew;
    data['strStatus'] = this.strStatus;
    data['strFile'] = this.strFile;
    data['strImageFileName'] = this.strImageFileName;
    return data;
  }
}

class UnitList_Response {
  List<UnitListData>? data;
  String? strMessage;
  String? strStatus;

  UnitList_Response({this.data, this.strMessage, this.strStatus});

  UnitList_Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <UnitListData>[];
      json['data'].forEach((v) {
        data!.add(new UnitListData.fromJson(v));
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

class UnitListData {
  int? intId;
  int? intCompanyId;
  String? strName;
  String? strItemCode;
  String? itemName;
  String? strDescription;
  String? strSpecification;
  int? intRank;
  double? decOpningStock;
  bool? bisIsdisplayonweb;
  bool? bisIsNew;
  String? strStatus;
  String? strFile;
  String? strImageFileName;

  UnitListData(
      {this.intId,
        this.intCompanyId,
        this.strName,
        this.strItemCode,
        this.itemName,
        this.strDescription,
        this.strSpecification,
        this.intRank,
        this.decOpningStock,
        this.bisIsdisplayonweb,
        this.bisIsNew,
        this.strStatus,
        this.strFile,
        this.strImageFileName});

  UnitListData.fromJson(Map<String, dynamic> json) {
    intId = json['intId'];
    intCompanyId = json['intCompanyId'];
    strName = json['strName'];
    strItemCode = json['strItemCode'];
    itemName = json['ItemName'];
    strDescription = json['strDescription'];
    strSpecification = json['strSpecification'];
    intRank = json['intRank'];
    decOpningStock = json['decOpningStock'];
    bisIsdisplayonweb = json['bisIsdisplayonweb'];
    bisIsNew = json['bisIsNew'];
    strStatus = json['strStatus'];
    strFile = json['strFile'];
    strImageFileName = json['strImageFileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intId'] = this.intId;
    data['intCompanyId'] = this.intCompanyId;
    data['strName'] = this.strName;
    data['strItemCode'] = this.strItemCode;
    data['ItemName'] = this.itemName;
    data['strDescription'] = this.strDescription;
    data['strSpecification'] = this.strSpecification;
    data['intRank'] = this.intRank;
    data['decOpningStock'] = this.decOpningStock;
    data['bisIsdisplayonweb'] = this.bisIsdisplayonweb;
    data['bisIsNew'] = this.bisIsNew;
    data['strStatus'] = this.strStatus;
    data['strFile'] = this.strFile;
    data['strImageFileName'] = this.strImageFileName;
    return data;
  }
}

class ItemsList_Response {
  List<ItemsListData>? data;
  String? strMessage;
  String? strStatus;

  ItemsList_Response({this.data, this.strMessage, this.strStatus});

  ItemsList_Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ItemsListData>[];
      json['data'].forEach((v) {
        data!.add(new ItemsListData.fromJson(v));
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

class ItemsListData {
  int? intId;
  int? intCompanyId;
  String? strName;
  String? strItemCode;
  String? itemName;
  String? strDescription;
  String? strSpecification;
  int? intRank;
  double? decOpningStock;
  double? decAvailablestock;
  bool? bisIsdisplayonweb;
  bool? bisIsNew;
  String? strStatus;
  String? strFile;
  String? strImageFileName;
  double? decPurchaseprice;
  double? decSellPrice;

  ItemsListData(
      {this.intId,
        this.intCompanyId,
        this.strName,
        this.strItemCode,
        this.itemName,
        this.strDescription,
        this.strSpecification,
        this.intRank,
        this.decOpningStock,
        this.decAvailablestock,
        this.bisIsdisplayonweb,
        this.bisIsNew,
        this.strStatus,
        this.strFile,
        this.strImageFileName,
        this.decPurchaseprice,
        this.decSellPrice});

  ItemsListData.fromJson(Map<String, dynamic> json) {
    intId = json['intId'];
    intCompanyId = json['intCompanyId'];
    strName = json['strName'];
    strItemCode = json['strItemCode'];
    itemName = json['ItemName'];
    strDescription = json['strDescription'];
    strSpecification = json['strSpecification'];
    intRank = json['intRank'];
    decOpningStock = json['decOpningStock'];
    decAvailablestock = json['decAvailablestock'];
    bisIsdisplayonweb = json['bisIsdisplayonweb'];
    bisIsNew = json['bisIsNew'];
    strStatus = json['strStatus'];
    strFile = json['strFile'];
    strImageFileName = json['strImageFileName'];
    decPurchaseprice = json['decPurchaseprice'];
    decSellPrice = json['decSellPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intId'] = this.intId;
    data['intCompanyId'] = this.intCompanyId;
    data['strName'] = this.strName;
    data['strItemCode'] = this.strItemCode;
    data['ItemName'] = this.itemName;
    data['strDescription'] = this.strDescription;
    data['strSpecification'] = this.strSpecification;
    data['intRank'] = this.intRank;
    data['decOpningStock'] = this.decOpningStock;
    data['decAvailablestock'] = this.decAvailablestock;
    data['bisIsdisplayonweb'] = this.bisIsdisplayonweb;
    data['bisIsNew'] = this.bisIsNew;
    data['strStatus'] = this.strStatus;
    data['strFile'] = this.strFile;
    data['strImageFileName'] = this.strImageFileName;
    data['decPurchaseprice'] = this.decPurchaseprice;
    data['decSellPrice'] = this.decSellPrice;
    return data;
  }
}

class ItemPriceListResponse {
  List<ItemPriceData>? data;
  String? strMessage;
  String? strStatus;

  ItemPriceListResponse({this.data, this.strMessage, this.strStatus});

  ItemPriceListResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ItemPriceData>[];
      json['data'].forEach((v) {
        data!.add(new ItemPriceData.fromJson(v));
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

class ItemPriceData {
  int? intId;
  int? intItemId;
  int? intCompanyId;
  int? intCreateBy;
  double? decSellPrice;
  double? decPurcharePrice;
  double? decAvailablestock;
  String? dtUpdatedDate;
  String? strUpdateBy;
  String? strAvailablestockDate;
  String? strItemCode;
  String? itemName;
  String? strName;

  ItemPriceData(
      {this.intId,
        this.intItemId,
        this.intCompanyId,
        this.intCreateBy,
        this.decSellPrice,
        this.decPurcharePrice,
        this.decAvailablestock,
        this.dtUpdatedDate,
        this.strUpdateBy,
        this.strAvailablestockDate,
        this.strItemCode,
        this.itemName,
        this.strName});

  ItemPriceData.fromJson(Map<String, dynamic> json) {
    intId = json['intId'];
    intItemId = json['intItemId'];
    intCompanyId = json['intCompanyId'];
    intCreateBy = json['intCreateBy'];
    decSellPrice = json['decSellPrice'];
    decPurcharePrice = json['decPurcharePrice'];
    decAvailablestock = json['decAvailablestock'];
    dtUpdatedDate = json['dtUpdatedDate'];
    strUpdateBy = json['strUpdateBy'];
    strAvailablestockDate = json['strAvailablestockDate'];
    strItemCode = json['strItemCode'];
    itemName = json['ItemName'];
    strName = json['strName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intId'] = this.intId;
    data['intItemId'] = this.intItemId;
    data['intCompanyId'] = this.intCompanyId;
    data['intCreateBy'] = this.intCreateBy;
    data['decSellPrice'] = this.decSellPrice;
    data['decPurcharePrice'] = this.decPurcharePrice;
    data['decAvailablestock'] = this.decAvailablestock;
    data['dtUpdatedDate'] = this.dtUpdatedDate;
    data['strUpdateBy'] = this.strUpdateBy;
    data['strAvailablestockDate'] = this.strAvailablestockDate;
    data['strItemCode'] = this.strItemCode;
    data['ItemName'] = this.itemName;
    data['strName'] = this.strName;
    return data;
  }
}


class AddItemPriceBody {
  int? intCompanyId;
  int? intItemId;
  double? decSellPrice;
  double? decPurcharePrice;
  double? decAvailablestock;

  AddItemPriceBody(
      {this.intCompanyId,
        this.intItemId,
        this.decSellPrice,
        this.decPurcharePrice,
        this.decAvailablestock});

  AddItemPriceBody.fromJson(Map<String, dynamic> json) {
    intCompanyId = json['intCompanyId'];
    intItemId = json['intItemId'];
    decSellPrice = json['decSellPrice'];
    decPurcharePrice = json['decPurcharePrice'];
    decAvailablestock = json['decAvailablestock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intCompanyId'] = this.intCompanyId;
    data['intItemId'] = this.intItemId;
    data['decSellPrice'] = this.decSellPrice;
    data['decPurcharePrice'] = this.decPurcharePrice;
    data['decAvailablestock'] = this.decAvailablestock;
    return data;
  }
}