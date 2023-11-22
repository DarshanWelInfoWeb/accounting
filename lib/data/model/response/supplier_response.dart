class SupplierListResponse {
  List<SupplierData>? data;
  String? strMsg;
  String? error;

  SupplierListResponse({this.data, this.strMsg, this.error});

  SupplierListResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SupplierData>[];
      json['data'].forEach((v) {
        data!.add(new SupplierData.fromJson(v));
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

class SupplierData {
  int? intid;
  String? strCompanyName;
  String? strContactPersonName;
  String? strContactMobilenumber;
  String? strAddress;

  SupplierData(
      {this.intid,
        this.strCompanyName,
        this.strContactPersonName,
        this.strContactMobilenumber,
        this.strAddress});

  SupplierData.fromJson(Map<String, dynamic> json) {
    intid = json['intid'];
    strCompanyName = json['strCompanyName'];
    strContactPersonName = json['strContactPersonName'];
    strContactMobilenumber = json['strContactMobilenumber'];
    strAddress = json['strAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intid'] = this.intid;
    data['strCompanyName'] = this.strCompanyName;
    data['strContactPersonName'] = this.strContactPersonName;
    data['strContactMobilenumber'] = this.strContactMobilenumber;
    data['strAddress'] = this.strAddress;
    return data;
  }
}

class SupplierInvoiceList_Response {
  List<SupplierInvoiceData>? data;
  String? strMsg;
  String? error;

  SupplierInvoiceList_Response({this.data, this.strMsg, this.error});

  SupplierInvoiceList_Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SupplierInvoiceData>[];
      json['data'].forEach((v) {
        data!.add(new SupplierInvoiceData.fromJson(v));
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

class SupplierInvoiceData {
  int? intid;
  String? strInvoiceno;
  String? strSuppliername;
  String? strinvoicedate;
  double? decTotal;
  String? strImageFileName;

  SupplierInvoiceData(
      {this.intid,
        this.strInvoiceno,
        this.strSuppliername,
        this.strinvoicedate,
        this.decTotal,
        this.strImageFileName});

  SupplierInvoiceData.fromJson(Map<String, dynamic> json) {
    intid = json['intid'];
    strInvoiceno = json['StrInvoiceno'];
    strSuppliername = json['strSuppliername'];
    strinvoicedate = json['strinvoicedate'];
    decTotal = json['decTotal'];
    strImageFileName = json['strImageFileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intid'] = this.intid;
    data['StrInvoiceno'] = this.strInvoiceno;
    data['strSuppliername'] = this.strSuppliername;
    data['strinvoicedate'] = this.strinvoicedate;
    data['decTotal'] = this.decTotal;
    data['strImageFileName'] = this.strImageFileName;
    return data;
  }
}

class EditSupplierInvoiceResponse {
  List<SupplierInvoiceData1>? data1;
  String? strMsg;
  String? error;

  EditSupplierInvoiceResponse({this.data1, this.strMsg, this.error});

  EditSupplierInvoiceResponse.fromJson(Map<String, dynamic> json) {
    if (json['data1'] != null) {
      data1 = <SupplierInvoiceData1>[];
      json['data1'].forEach((v) {
        data1!.add(new SupplierInvoiceData1.fromJson(v));
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

class SupplierInvoiceData1 {
  int? intid;
  int? intCompanyId;
  int? intSupplierId;
  String? strInvoiceNo;
  String? strInvoiceDate;
  String? strDueDate;
  double? decTotal;
  double? decDiscount;
  double? decGrandTotal;
  double? decCGSTTax;
  double? decSGSTTax;
  bool? bIsIncludeGST;
  String? strFilePath;
  String? strImageFileName;
  String? strMemo;

  SupplierInvoiceData1(
      {this.intid,
        this.intCompanyId,
        this.intSupplierId,
        this.strInvoiceNo,
        this.strInvoiceDate,
        this.strDueDate,
        this.decTotal,
        this.decDiscount,
        this.decGrandTotal,
        this.decCGSTTax,
        this.decSGSTTax,
        this.bIsIncludeGST,
        this.strFilePath,
        this.strImageFileName,
        this.strMemo});

  SupplierInvoiceData1.fromJson(Map<String, dynamic> json) {
    intid = json['intid'];
    intCompanyId = json['intCompanyId'];
    intSupplierId = json['intSupplierId'];
    strInvoiceNo = json['strInvoiceNo'];
    strInvoiceDate = json['strInvoiceDate'];
    strDueDate = json['strDueDate'];
    decTotal = json['decTotal'];
    decDiscount = json['decDiscount'];
    decGrandTotal = json['decGrandTotal'];
    decCGSTTax = json['decCGSTTax'];
    decSGSTTax = json['decSGSTTax'];
    bIsIncludeGST = json['bIsIncludeGST'];
    strFilePath = json['strFilePath'];
    strImageFileName = json['strImageFileName'];
    strMemo = json['strMemo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intid'] = this.intid;
    data['intCompanyId'] = this.intCompanyId;
    data['intSupplierId'] = this.intSupplierId;
    data['strInvoiceNo'] = this.strInvoiceNo;
    data['strInvoiceDate'] = this.strInvoiceDate;
    data['strDueDate'] = this.strDueDate;
    data['decTotal'] = this.decTotal;
    data['decDiscount'] = this.decDiscount;
    data['decGrandTotal'] = this.decGrandTotal;
    data['decCGSTTax'] = this.decCGSTTax;
    data['decSGSTTax'] = this.decSGSTTax;
    data['bIsIncludeGST'] = this.bIsIncludeGST;
    data['strFilePath'] = this.strFilePath;
    data['strImageFileName'] = this.strImageFileName;
    data['strMemo'] = this.strMemo;
    return data;
  }
}

class SupplierInvoiceItemResponse {
  List<SupplierInvoiceItemData1>? data1;
  String? strMsg;
  String? error;

  SupplierInvoiceItemResponse({this.data1, this.strMsg, this.error});

  SupplierInvoiceItemResponse.fromJson(Map<String, dynamic> json) {
    if (json['data1'] != null) {
      data1 = <SupplierInvoiceItemData1>[];
      json['data1'].forEach((v) {
        data1!.add(new SupplierInvoiceItemData1.fromJson(v));
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

class SupplierInvoiceItemData1 {
  int? intid;
  int? intInvoiceid;
  String? strItemName;
  int? intqty;
  String? StrUnitName;
  double? decRate;
  double? totalAmount;

  SupplierInvoiceItemData1(
      {this.intid,
        this.intInvoiceid,
        this.strItemName,
        this.intqty,
        this.StrUnitName,
        this.decRate,
        this.totalAmount});

  SupplierInvoiceItemData1.fromJson(Map<String, dynamic> json) {
    intid = json['intid'];
    intInvoiceid = json['IntInvoiceid'];
    strItemName = json['strItemName'];
    intqty = json['intqty'];
    StrUnitName = json['StrUnitName'];
    decRate = json['DecRate'];
    totalAmount = json['TotalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intid'] = this.intid;
    data['IntInvoiceid'] = this.intInvoiceid;
    data['strItemName'] = this.strItemName;
    data['intqty'] = this.intqty;
    data['StrUnitName'] = this.StrUnitName;
    data['DecRate'] = this.decRate;
    data['TotalAmount'] = this.totalAmount;
    return data;
  }
}