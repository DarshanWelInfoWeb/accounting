import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gas_accounting/data/model/body/route.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/confirm_dialog_view.dart';
import 'package:intl/intl.dart';


class AppConstants {

  static const String APP_NAME = 'Accounting for Gas';
  static const String APP_NAMES = 'Accounting for Plastic';
  static const String BASE_URL = 'http://api.welinfoweb.in/';
  static const String LOGIN_URI = 'Api/Login/UserLogin';
  static String profit = '';
  static String profitAmount = '';

  /* Dashboard */
  static const String DASHBOARD_COUNT_URI = 'api/ManageUser/GetUserAccountCount';
  static const String DAILY_UPDATE_URI = 'api/DailyUpdate/DailyUpdate?dtInvoiceDate';
  static const String DAILY_WISE_REPORTE_URI = 'Api/DailyReport/DailyWiseReport';
  static const String PROFIT_LOSSS_LIST_URI = 'Api/ProfitAndLoss/ProfitAndLossList?';
  static const String SALES_CHART_LIST_URI = 'Api/DashBoard/DashboardList?';
  static const String BAR_CHART_LIST_URI = 'http://api.welinfoweb.in/Api/DashBoard/DashboardBarGraphList?';

  /* Customer */
  static const String SEARCH_CUSTOMER_URI = 'Api/profile/GasDetailByMobile';
  static const String ADD_CUSTOMER_URI = 'api/ManageCustomer/InsertCustomer';
  static const String DELETE_CUSTOMER_URI = 'api/ManageCustomer/DeleteCustomer';
  static const String UPDATE_CUSTOMER_URI = 'api/ManageCustomer/UpdateCustomer';
  static const String CUSTOMER_LIST_URI = 'api/ManageCustomer/GetCustomerlist';
  static const String EDIT_CUSTOMER_URI = 'api/ManageCustomer/EditCustomerlist';
  static const String CUSTOMER_REPORT_DAILY_URI = 'Api/CustomerReport/GetCustomerReportDaily';
  static const String CUSTOMER_DUE_REPORT_URI = 'Api/CustomerDueReport/GetDueCustomerReport';
  static const String CUSTOMER_QR_CODE_GENERATE_URI = 'Api/profile/QRCodeScanner';

  /* Route */
  static const String ADD_ROUTE_URI = 'Api/Client/InsertClient';
  static const String InsertStockAndQty_URI = 'Api/Client/InsertStockAndQty';
  static const String StockAndQty_LIST_URI = 'Api/Client/RouteStockWiseDetails?intRouteId=';
  static const String DeleteStockAndQty_URI = 'Api/Client/DeleteStockAndQty';
  static const String SELECT_ITEM_LIST_URI = 'Api/Client/Selectlist';
  static const String DRIVER_LIST_URI = 'Api/Client/GetUserlist';
  static const String ROUTE_LIST_URI = 'Api/Client/RouteUserList';
  static const String DELETE_ROUTE_LIST_URI = 'Api/Client/DeleteClient';
  static const String ROUTE_DETAIL_LIST_URI = 'Api/Client/GetStockByID';
  static const String SELECT_ROUTE_URI = 'Api/TempInvoice/SelectRouteList?intCompanyId=';

  /* Main Invoice */
  static const String ADD_MAIN_INVOICE_URI = 'Api/ManageInvoice/InsertmainInvoiceManage';
  static const String DELETE_MAIN_INVOICE_URI = 'Api/ManageInvoice/DeleteMainInvoice';
  static const String MAIN_INVOICE_LIST_URI = 'Api/ManageInvoice/GetMainInvoicelist';
  static const String MAIN_INVOICE_EDIT_URI = 'Api/ManageInvoice/EditManageMainInvoice';
  static const String MAIN_INVOICE_STOCK_LIST_URI = 'Api/ManageInvoice/EditManageMainInvoiceItems';
  static const String DELETE_MAIN_INVOICE_STOCK_URI = 'Api/ManageInvoice/DeleteItemsInvoice';

  /* Temp Invoice */
  static const String ADD_TEMP_INVOICE_URI = 'Api/TempInvoice/InsertInvoice';
  static const String DELETE_TEMP_INVOICE_URI = 'Api/TempInvoice/DeleteInvoice';
  static const String TEMP_INVOICE_LIST_URI = 'Api/TempInvoice/GetInvoicelist';
  static const String EDIT_INVOICE_LIST_URI = 'Api/TempInvoice/EditInvoice';
  static const String ADD_INVOICE_STOCK_URI = 'Api/TempInvoice/MstItemsDetails';
  static const String INVOICE_STOCK_LIST_URI = 'Api/TempInvoice/ItemDetails?';
  static const String DELETE_INVOICE_STOCK_URI = 'Api/TempInvoice/DeleteDetails';

  /* Payment */
  static const String ADD_PAYMENT_URI = 'Api/Payments/InsertPayment';
  static const String DELETE_PAYMENT_URI = 'Api/Payments/DeletePayment';
  static const String PAYMENT_LIST_URI = 'Api/Payments/Selectlist';
  static const String UPDATE_PAYMENT_LIST_URI = 'Api/Payments/UpdatePayment';
  static const String EDIT_PAYMENT_LIST_URI = 'Api/Payments/EditList';

  /* Main Payment */
  static const String ADD_MAIN_PAYMENT_URI = 'Api/MainPayment/InsertMainPayment';
  static const String DELETE_MAIN_PAYMENT_URI = 'Api/MainPayment/DeleteMainPayment';
  static const String MAIN_PAYMENT_LIST_URI = 'Api/MainPayment/GetMainPaymentList';
  static const String UPDATE_MAIN_PAYMENT_LIST_URI = 'Api/MainPayment/UpdateMainPayment';

  /* Expense Manage */
  static const String SELECT_EXPENSE_TYPE_LIST_URI = 'Api/Expense/ListExpenseList?intComapnyId=';
  static const String EXPENSE_LIST_URI = 'Api/Expense/ExpenseTypeList';
  static const String ADD_EXPENSE_URI = 'Api/Expense/InsertExpenseModel';
  static const String DELETE_EXPENSE_URI = 'Api/Expense/DeleteExpenseModel';
  static const String EDIT_EXPENSE_URI = 'Api/Expense/EditExpense';

  /* Expense Type Manage */
  static const String ADD_EXPENSE_TYPE_URI = 'api/ManageExpenseType/InsertManageExpenseType';
  static const String EXPENSE_TYPE_LIST_URI = 'api/ManageExpenseType/GetExpenseTypeList';
  static const String EDIT_EXPENSE_TYPE_LIST_URI = 'api/ManageExpenseType/SingleExpenseData';
  static const String DELETE_EXPENSE_TYPE_URI = 'api/ManageExpenseType/DeleteExpense';
  static const String CHANGE_STATUS_EXPENSE_TYPE_URI = 'api/ManageExpenseType/UpdateExpenseStatus';

  /* Item Manage */
  static const String UNIT_SELECT_URI = 'api/ManageItem/GetUnitSelectionList';
  static const String ADD_ITEM_URI = 'api/ManageItem/InsertManageItem';
  static const String ITEM_LIST_URI = 'api/ManageItem/SelectItemlist';
  static const String DELETE_ITEM_URI = 'api/ManageItem/DeleteManageItem';
  static const String UPDATE_ITEM_URI = 'api/ManageItem/UpdateManageItem';
  static const String EDIT_ITEM_URI = 'api/ManageItem/EditItemlist';

  /* Item Price */
  static const String ITEM_PRICE_LIST_URI = 'api/ManageItemPrice/ManageItemPriceList';
  static const String ADD_ITEM_PRICE_URI = 'api/ManageItemPrice/InsertMangeItemPrice';

  /* Supplier */
  static const String ADD_SUPPLIER_URI = 'Api/ManageSupplier/InsertManageSupplier';
  static const String UPDATE_SUPPLIER_URI = 'Api/ManageSupplier/UpdateManageSupplier';
  static const String DELETE_SUPPLIER_URI = 'Api/ManageSupplier/DeleteManageSupplier';
  static const String SUPPLIER_LIST_URI = 'Api/ManageSupplier/GetManageSupplier?intComapnyId=';

  /* Supplier Invoice */
  static const String SUPPLIER_ITEM_LIST_URI = 'Api/SupplierItems/SupplierItemSelectItem';
  static const String SUPPLIER_TAX_URI = 'Api/ManageSupplierInvoice/GetSupplierTax';
  static const String ADD_SUPPLIER_INVOICE_URI = 'Api/ManageSupplierInvoice/InsertSupplierInvoice';
  static const String DELETE_SUPPLIER_INVOICE_URI = 'Api/ManageSupplierInvoice/DeleteSupplierInvoice';
  static const String ADD_SUPPLIER_ITEM_URI = 'Api/SupplierItems/InsertSupplierItems';
  static const String SUPPLIER_INVOICE_LIST_URI = 'Api/ManageSupplierInvoice/SupplierInvoiceList?';
  static const String UPDATE_SUPPLIER_INVOICE_URI = 'Api/ManageSupplierInvoice/EditInvoiceOfSupplier';
  static const String SUPPLIER_INVOICE_ITEM_LIST_URI = 'Api/SupplierItems/SupplierItemList';
  static const String DELETE_SUPPLIER_INVOICE_ITEM_URI = 'Api/SupplierItems/DeleteSupplieritems';

  /* Supplier Payment */
  static const String ADD_SUPPLIER_PAYMENT_URI = 'Api/ManageSupplierPayment/InsertSupplierPayment';
  static const String DELETE_SUPPLIER_PAYMENT_URI = 'Api/ManageSupplierPayment/DeleteSupplierPayment';
  static const String SUPPLIER_PAYMENT_LIST_URI = 'Api/ManageSupplierPayment/SupplierPaymentList?';

  /* Unit Master */
  static const String UNIT_MASTER_LIST_URI = 'Api/UnitMaster/GetUnitMasterList?intComapnyId=';
  static const String ADD_UNIT_MASTER_URI = 'Api/UnitMaster/InsertUnitMaster';
  static const String DELETE_UNIT_MASTER_URI = 'Api/UnitMaster/DeleteUpdateUnitMaster';
  static const String CHANGE_STATUS_UNIT_MASTER_URI = 'Api/UnitMaster/GetUnitMasterstatus';

  static const String THEME = 'theme';
  static const String TOKEN = 'token';

  static String isLoggedIn = "isLoggedIn";
  static const String intro = 'intro';
  static const String password = 'Password';
  static const String email = 'email';
  static const int userId = 0;
  static const String mobile = 'mobile';
  static const String fName = 'fname';
  static const String lName = 'lname';
  static const String companyName = 'cname';
  static const String includeGst = "GST";
  static const int companyId = 0;

  static var screenSize;
  static double textScale=0.0;
  static double itemHeight=0.0;
  static double itemWidth=0.0;

  static List<InsertStock_Body> cart_list = [];

  /* Email Validation */
  static bool isNotValid(String email) {
    return !RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  /* Password Validation */
  static bool validateStructure(String password){
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  // Close KeyBoard
  static closeKeyboard() {
    return SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static serverError(BuildContext context){
    showDialog<bool>(
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text("Internal Server Error Please Try After Some Time"),
            actions: [
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text('Ok',style: montserratRegular.copyWith(color: ColorResources.BLACK),),
              ),
            ],
          );
        },context: context);
  }

  static getToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16
    );
  }

  static date_formate_change(String date) {
    DateTime parseDate =DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date,true);
    var inputDate = DateTime.parse(parseDate.toLocal().toString());
    var outputFormat = DateFormat("dd-MM-yyyy");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static date_formate_chan(String date) {
    DateTime parseDate =DateFormat("yyyy-MM-dd HH:mm:ss").parse(date,true);
    var inputDate = DateTime.parse(parseDate.toLocal().toString());
    var outputFormat = DateFormat("dd-MM-yyyy");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static date_formateChan(String date) {
    DateTime parseDate =DateFormat("yyyy-MM-dd").parse(date,true);
    var inputDate = DateTime.parse(parseDate.toLocal().toString());
    var outputFormat = DateFormat("d");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static date_change(String date) {
    DateTime parseDate =DateFormat("dd/MM/yyy").parse(date,true);
    var inputDate = DateTime.parse(parseDate.toLocal().toString());
    var outputFormat = DateFormat("yyyy-MM-dd");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static date_chang(String date) {
    DateTime parseDate =DateFormat("yyyy-MM-dd").parse(date,true);
    var inputDate = DateTime.parse(parseDate.toLocal().toString());
    var outputFormat = DateFormat("dd/MM/yyyy");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static date_changs(String date) {
    DateTime parseDate =DateFormat("yyyy/MM/dd").parse(date,true);
    var inputDate = DateTime.parse(parseDate.toLocal().toString());
    var outputFormat = DateFormat("dd/MM/yyyy");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static dateChangeYMDToDMY(String date) {
    DateTime parseDate =DateFormat("yyyy-MM-dd").parse(date,true);
    var inputDate = DateTime.parse(parseDate.toLocal().toString());
    var outputFormat = DateFormat("dd/MM/yyyy");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static dateChangeYMDToD(String date) {
    DateTime parseDate =DateFormat("yyyy-MM-dd").parse(date,true);
    var inputDate = DateTime.parse(parseDate.toLocal().toString());
    var outputFormat = DateFormat("dd/MM");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static dateChange(String date) {
    DateTime parseDate =DateFormat("dd/MM/yyy").parse(date,true);
    var inputDate = DateTime.parse(parseDate.toLocal().toString());
    var outputFormat = DateFormat("MM-dd-yyyy");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static dateChanges(String date) {
    DateTime parseDate =DateFormat("dd/MM/yyy").parse(date,true);
    var inputDate = DateTime.parse(parseDate.toLocal().toString());
    var outputFormat = DateFormat("dd-MMMM-yyyy");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static changeDate(String date) {
    DateTime parseDate = DateFormat("dd/MM/yyy").parse(date,true);
    var inputDate = DateTime.parse(parseDate.toLocal().toString());
    var outputFormat = DateFormat("dd MMMM");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static changeDateD(String date) {
    DateTime parseDate = DateFormat("dd/MM/yyyy").parse(date,true);
    var inputDate = DateTime.parse(parseDate.toLocal().toString());
    var outputFormat = DateFormat("d");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static changeDateMonth(String date) {
    DateTime parseDate =DateFormat("dd/MM/yyyy").parse(date,true);
    var inputDate = DateTime.parse(parseDate.toLocal().toString());
    var outputFormat = DateFormat("dd MMMM yy");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static changeDateToMDY(String date) {
    DateTime parseDate =DateFormat("MM/dd/yyyy").parse(date,true);
    var inputDate = DateTime.parse(parseDate.toLocal().toString());
    var outputFormat = DateFormat("dd/MM/yyyy");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static changeDateToDMY(String date) {
    DateTime parseDate =DateFormat("dd-MM-yyyy").parse(date,true);
    var inputDate = DateTime.parse(parseDate.toLocal().toString());
    var outputFormat = DateFormat("dd/MM/yyyy");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }


  static Future<bool> onWillPop(BuildContext context) {
    return showDialog<bool>(
        builder: (BuildContext context) {
          return ConfirmDialogView(
              description: "Do You Really Want To Quit?",
              leftButtonText: "CANCEL",
              rightButtonText: "OK",
              onAgreeTap: () {
                SystemNavigator.pop();
              });
        }, context: context).then((value) => value ?? false);
  }
}
