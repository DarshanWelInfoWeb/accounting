class GasDetailResponse {
  List<GasDetailData>? data;
  String? strMsg;
  String? err;

  GasDetailResponse({this.data, this.strMsg, this.err});

  GasDetailResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GasDetailData>[];
      json['data'].forEach((v) {
        data!.add(new GasDetailData.fromJson(v));
      });
    }
    strMsg = json['strMsg'];
    err = json['err'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['strMsg'] = this.strMsg;
    data['err'] = this.err;
    return data;
  }
}

class GasDetailData {
  int? intId;
  String? strMobileno;
  String? strFirstName;
  String? strLastName;
  String? strUserName;
  String? strEmail;
  String? strQrCode;
  double? decBalance;
  int? intCustomerId;
  int? intCompanyId;
  String? strCompanyName;
  List<PaymentDetail>? paymentDetail;
  String? strKey;
  String? strValue;

  GasDetailData(
      {this.intId,
        this.strMobileno,
        this.strFirstName,
        this.strLastName,
        this.strUserName,
        this.strEmail,
        this.strQrCode,
        this.decBalance,
        this.intCustomerId,
        this.intCompanyId,
        this.strCompanyName,
        this.paymentDetail,
        this.strKey,
        this.strValue});

  GasDetailData.fromJson(Map<String, dynamic> json) {
    intId = json['intId'];
    strMobileno = json['strMobileno'];
    strFirstName = json['strFirstName'];
    strLastName = json['strLastName'];
    strUserName = json['strUserName'];
    strEmail = json['strEmail'];
    strQrCode = json['strQrCode'];
    decBalance = json['decBalance'];
    intCustomerId = json['intCustomerId'];
    intCompanyId = json['intCompanyId'];
    strCompanyName = json['strCompanyName'];
    if (json['PaymentDetail'] != null) {
      paymentDetail = <PaymentDetail>[];
      json['PaymentDetail'].forEach((v) {
        paymentDetail!.add(new PaymentDetail.fromJson(v));
      });
    }
    strKey = json['strKey'];
    strValue = json['strValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intId'] = this.intId;
    data['strMobileno'] = this.strMobileno;
    data['strFirstName'] = this.strFirstName;
    data['strLastName'] = this.strLastName;
    data['strUserName'] = this.strUserName;
    data['strEmail'] = this.strEmail;
    data['strQrCode'] = this.strQrCode;
    data['decBalance'] = this.decBalance;
    data['intCustomerId'] = this.intCustomerId;
    data['intCompanyId'] = this.intCompanyId;
    data['strCompanyName'] = this.strCompanyName;
    if (this.paymentDetail != null) {
      data['PaymentDetail'] =
          this.paymentDetail!.map((v) => v.toJson()).toList();
    }
    data['strKey'] = this.strKey;
    data['strValue'] = this.strValue;
    return data;
  }
}

class PaymentDetail {
  int? intId;
  int? intType;
  int? intCustomerId;
  String? strInvoiceNo;
  String? dtPaymentDate;
  double? decAmount;
  String? strRemarks;
  String? deconlinepayment;
  String? deccashpayment;
  String? strUserName;
  String? strCompanyName;
  double? totalAmount;
  String? intUserType;
  String? dtCreatedDate;
  bool? bisStatus;
  double? decBalance;

  PaymentDetail(
      {this.intId,
        this.intType,
        this.intCustomerId,
        this.strInvoiceNo,
        this.dtPaymentDate,
        this.decAmount,
        this.strRemarks,
        this.deconlinepayment,
        this.deccashpayment,
        this.strUserName,
        this.strCompanyName,
        this.totalAmount,
        this.intUserType,
        this.dtCreatedDate,
        this.bisStatus,
        this.decBalance});

  PaymentDetail.fromJson(Map<String, dynamic> json) {
    intId = json['intId'];
    intType = json['intType'];
    intCustomerId = json['intCustomerId'];
    strInvoiceNo = json['strInvoiceNo'];
    dtPaymentDate = json['dtPaymentDate'];
    decAmount = json['decAmount'];
    strRemarks = json['strRemarks'];
    deconlinepayment = json['deconlinepayment'];
    deccashpayment = json['deccashpayment'];
    strUserName = json['strUserName'];
    strCompanyName = json['strCompanyName'];
    totalAmount = json['TotalAmount'];
    intUserType = json['intUserType'];
    dtCreatedDate = json['dtCreatedDate'];
    bisStatus = json['bisStatus'];
    decBalance = json['decBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intId'] = this.intId;
    data['intType'] = this.intType;
    data['intCustomerId'] = this.intCustomerId;
    data['strInvoiceNo'] = this.strInvoiceNo;
    data['dtPaymentDate'] = this.dtPaymentDate;
    data['decAmount'] = this.decAmount;
    data['strRemarks'] = this.strRemarks;
    data['deconlinepayment'] = this.deconlinepayment;
    data['deccashpayment'] = this.deccashpayment;
    data['strUserName'] = this.strUserName;
    data['strCompanyName'] = this.strCompanyName;
    data['TotalAmount'] = this.totalAmount;
    data['intUserType'] = this.intUserType;
    data['dtCreatedDate'] = this.dtCreatedDate;
    data['bisStatus'] = this.bisStatus;
    data['decBalance'] = this.decBalance;
    return data;
  }
}
