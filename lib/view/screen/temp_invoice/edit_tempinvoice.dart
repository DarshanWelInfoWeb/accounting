// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gas_accounting/data/model/body/add_tempinvoice.dart';
import 'package:gas_accounting/data/model/response/driver_response.dart';
import 'package:gas_accounting/data/model/response/edittempinvoice_response.dart';
import 'package:gas_accounting/data/model/response/selectroute.dart';
import 'package:gas_accounting/data/model/response/tempstock_response.dart';
import 'package:gas_accounting/helper/dataBase.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/customer_provider.dart';
import 'package:gas_accounting/provider/route_provider.dart';
import 'package:gas_accounting/provider/tempinvoice_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/custom_button.dart';
import 'package:gas_accounting/view/basewidget/custom_password_textfield.dart';
import 'package:gas_accounting/view/basewidget/custom_textfield.dart';
import 'package:gas_accounting/view/basewidget/no_internet_screen.dart';
import 'package:gas_accounting/view/screen/temp_invoice/tempinvoice_list.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class EditTempInvoice extends StatefulWidget {
  String id,date,subTotal,dueAmount,grandTotal,totalGrand,customerName,type;
  int customerId,routeId;
  List<TempStock_Body> modelList;
  EditTempInvoice(this.id,this.customerId,this.customerName,this.routeId,this.date,this.subTotal,this.dueAmount,this.grandTotal,this.totalGrand,this.type,this.modelList,{Key? key}) : super(key: key);

  @override
  State<EditTempInvoice> createState() => _EditTempInvoiceState();
}

class _EditTempInvoiceState extends State<EditTempInvoice> {
  TextEditingController routeController = TextEditingController();
  TextEditingController customerController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController onlineController = TextEditingController();
  TextEditingController cashController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController subTotalController = TextEditingController();
  TextEditingController dueAmountController = TextEditingController();
  TextEditingController grandTotalController = TextEditingController();
  FocusNode customerCode = FocusNode();
  FocusNode dateCode = FocusNode();
  FocusNode qtyCode = FocusNode();
  FocusNode rateCode = FocusNode();
  FocusNode onlineCode = FocusNode();
  FocusNode cashCode = FocusNode();
  FocusNode totalAmountCode = FocusNode();
  FocusNode amountCode = FocusNode();
  FocusNode subTotalCode = FocusNode();
  FocusNode dueAmountCode = FocusNode();
  FocusNode grandTotalCode = FocusNode();

  bool is_loading = true;
  bool _isLoading = false;

  TempDb itemDbManager = new TempDb();

  TempStock_Body? itemDetailsInvoiceModel;
  List<TempStock_Body> modelList = new List.empty(growable: true);
  TempStock_Body? model;
  List<TempStock_Body>? driverStockModel;
  List<TempStock_Body> modelLists = new List.empty(growable: true);
  List<TempStockData> items = [];
  String rate = "",amount= "";
  String qty = "";
  int? total_amount;
  int? stock_amount;
  int? sub_amount;
  int? dueTotal_amount;
  double grandTotal = 0.0;
  double grandTotals = 0.0;
  double subTotal = 0.0;
  double subTotals = 0.0;
  double grandTotalScore = 0.0;
  double dueAmount = 0.0;
  late String formattedDate = '';
  late String date_shcedule = '';
  TimeOfDay selectedTime = TimeOfDay.now();
  int dropdownValue = 0;
  dynamic itemdropdownValue ;
  String? itemsDropdownName ;
  String? itemsUnitName ;
  String? itemsDropdownPrice ;
  int routeDropdownValue = 0;
  int routeDropdownValues = 0;
  String? routeName;
  String? customerName;

  void _date_pik_shcedule() {
    showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: ColorResources.LINE_BG, // header background color
                onPrimary: ColorResources.WHITE, // header text color
                onSurface: ColorResources.BLACK, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: ColorResources.LINE_BG, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1970),
        lastDate: DateTime(2040))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
        dateController.text = formattedDate;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime today = DateTime.now();
    formattedDate = DateFormat('dd/MM/yyyy').format(today);
    // dateController.text = formattedDate;
    widget.date==""?
    dateController.text = formattedDate:
    dateController.text = widget.date;
    // items = Provider.of<TempInvoiceProvider>(context, listen: false).tempStockList;
    setState(() {
      itemDbManager = TempDb();
      itemDbManager.getStockList().then((value) {
        setState(() {
          modelList.addAll(value);
          modelList = value;
          for(int i=0;i<modelList.length;i++){
            print("widget:::${widget.grandTotal}:::${widget.totalGrand}::$subTotals::$subTotal");
            grandTotals += double.parse(modelList[i].decAmount.toString());
            // grandTotalScore = grandTotals + double.parse(widget.dueAmount);
            subTotalController.text = grandTotals.round().toString();
            grandTotalController.text = grandTotals.round().toString();
            print("widget:::$grandTotals");
          }
          print("object::::::4::${modelList.length}:::${widget.dueAmount}");
        });
      });
    });
    print("object:::::s:4::${widget.grandTotal}::::::${widget.subTotal}:::${widget.dueAmount}:");
    print("route::::0:${widget.routeId}:::::${widget.customerId}");
    // if(widget.type == "edit"){
      print("types::${widget.type}");
      _loadData(context, true);
    // }else{
    //   print("id:::::${widget.routeId}::::${widget.customerId}");
    //   Provider.of<TempInvoiceProvider>(context, listen: false).getTempInvoiceEdit(context,widget.id).then((value) {
    //     setState(() {
    //       is_loading = false;
    //       for(int i=0;i<Provider.of<TempInvoiceProvider>(context, listen: false).editTempInvoiceList.length;i++){
    //         routeDropdownValue = widget.routeId;
    //         dropdownValue = widget.customerId;
    //         dateController.text = widget.date==""?Provider.of<TempInvoiceProvider>(context, listen: false).editTempInvoiceList[i].dtInvoiceDate.toString(): widget.date;
    //         onlineController.text = Provider.of<TempInvoiceProvider>(context, listen: false).editTempInvoiceList[i].deconlinepayment!.round().toString();
    //         cashController.text = Provider.of<TempInvoiceProvider>(context, listen: false).editTempInvoiceList[i].deccashpayment!.round().toString();
    //         dueAmountController.text = Provider.of<TempInvoiceProvider>(context, listen: false).editTempInvoiceList[i].decDueAmount!.round().toString();
    //         dueAmount = double.parse(dueAmountController.text);
    //         totalAmountController.text = Provider.of<TempInvoiceProvider>(context, listen: false).editTempInvoiceList[i].decTotalAmount!.round().toString();
    //         print("route::1:0:$routeDropdownValue:::${widget.type}::$dropdownValue::");
    //       }
    //     });
    //   });
    //   Provider.of<TempInvoiceProvider>(context, listen: false).getTempStockList(context,widget.id).then((value) {
    //     is_loading = false;
    //     setState(() {
    //       for(int i=0;i<Provider.of<TempInvoiceProvider>(context, listen: false).tempStockList.length;i++){
    //         subTotals += Provider.of<TempInvoiceProvider>(context, listen: false).tempStockList[i].decAmount!.round();
    //         grandTotalScore = subTotals + grandTotals;
    //         grandTotal = grandTotalScore + dueAmount;
    //         subTotalController.text = grandTotalScore.round().toString();
    //         grandTotalController.text = grandTotal.round().toString();
    //       }
    //       print("stock::1:$subTotals::::$grandTotalScore::$grandTotal::::${dueAmountController.text}:");
    //     });
    //   });
    //   print("type::${widget.type}");
    // }
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<TempInvoiceProvider>(context, listen: false).getTempInvoiceEdit(context,widget.id).then((value) {
        setState(() {
          is_loading = false;
          for(int i=0;i<Provider.of<TempInvoiceProvider>(context, listen: false).editTempInvoiceList.length;i++){
            EditTempInvoiceData editTempInvoiceData = Provider.of<TempInvoiceProvider>(context, listen: false).editTempInvoiceList[i];
            Provider.of<RouteProvider>(context, listen: false).getSelectRoute(context,PreferenceUtils.getString("${AppConstants.companyId}")).then((value) {
              is_loading = false;
              for(int k=0;k<Provider.of<RouteProvider>(context, listen: false).selectrouteList.length;k++){
                if(widget.type == "edit"){
                  routeDropdownValue = Provider.of<TempInvoiceProvider>(context, listen: false).editTempInvoiceList[i].intRouteId!;
                  if(Provider.of<TempInvoiceProvider>(context, listen: false).editTempInvoiceList[i].intRouteId == Provider.of<RouteProvider>(context, listen: false).selectrouteList[k].intId){
                    routeName = Provider.of<RouteProvider>(context, listen: false).selectrouteList[k].strRoute;
                  }
                  print("route api :: $routeName :: $routeDropdownValue");
                }else{
                  routeDropdownValue = widget.routeId;
                  if(int.parse(widget.routeId.toString()) == Provider.of<RouteProvider>(context, listen: false).selectrouteList[k].intId){
                    routeName = Provider.of<RouteProvider>(context, listen: false).selectrouteList[k].strRoute;
                  }
                  print("widget route :: $routeName :: $routeDropdownValue");
                }
                print("selected to api::$routeName :: $routeDropdownValue");
              }
            });
            Provider.of<RouteProvider>(context, listen: false).getDriverHelper(context,PreferenceUtils.getString("${AppConstants.companyId}"),"3").then((value) {
              is_loading = false;
              for(int k=0;k<Provider.of<RouteProvider>(context, listen: false).driverList.length;k++){
                if(widget.type == "edit"){
                  dropdownValue = Provider.of<TempInvoiceProvider>(context, listen: false).editTempInvoiceList[i].intCustomerid!;
                  if(Provider.of<TempInvoiceProvider>(context, listen: false).editTempInvoiceList[i].intCustomerid == Provider.of<RouteProvider>(context, listen: false).driverList[k].intId){
                    customerName = Provider.of<RouteProvider>(context, listen: false).driverList[k].srtFullName!;
                  }
                  print("customer api :: $customerName :: $dropdownValue");
                }else{
                  dropdownValue = widget.customerId;
                  if(int.parse(widget.customerId.toString()) == Provider.of<RouteProvider>(context, listen: false).driverList[k].intId){
                    customerName = Provider.of<RouteProvider>(context, listen: false).driverList[k].srtFullName!;
                  }
                  print("widget customer :: $customerName :: $dropdownValue");
                }
                print("selected to api::$dropdownValue ::$customerName");
              }
            });
            Provider.of<CustomerProvider>(context, listen: false).getCustomerDueReport(context,PreferenceUtils.getString(AppConstants.companyId.toString())).then((value) {
              is_loading = false;
              for(int i=0;i<Provider.of<CustomerProvider>(context, listen: false).customerDueReportList.length;i++){
                if(widget.type == "edit"){
                  if(dropdownValue == Provider.of<CustomerProvider>(context, listen: false).customerDueReportList[i].intCustomerid){
                    dueAmountController.text = Provider.of<CustomerProvider>(context, listen: false).customerDueReportList[i].decDueAmount!.round().toString();
                    dueAmount = Provider.of<CustomerProvider>(context, listen: false).customerDueReportList[i].decDueAmount!;
                    dueAmountController.text!=''?dueAmountController.text:dueAmountController.text ="0";
                  }
                }else{
                  if(widget.customerId == Provider.of<CustomerProvider>(context, listen: false).customerDueReportList[i].intCustomerid){
                    dueAmountController.text = Provider.of<CustomerProvider>(context, listen: false).customerDueReportList[i].decDueAmount!.round().toString();
                    dueAmount = Provider.of<CustomerProvider>(context, listen: false).customerDueReportList[i].decDueAmount!;
                    dueAmountController.text!=''?dueAmountController.text:dueAmountController.text ="0";
                  }
                }
                print("due:: ${dueAmountController.text}");
              }
              Provider.of<TempInvoiceProvider>(context, listen: false).getTempStockList(context,widget.id,"18",PreferenceUtils.getString(AppConstants.companyId.toString())).then((value) {
                is_loading = false;
                setState(() {
                  for(int i=0;i<Provider.of<TempInvoiceProvider>(context, listen: false).tempStockList.length;i++){
                    subTotals += Provider.of<TempInvoiceProvider>(context, listen: false).tempStockList[i].decAmount!.round();
                    grandTotalScore = subTotals + grandTotals;
                    // grandTotal = grandTotalScore + double.parse(dueAmountController.text==""?"0":dueAmountController.text);
                    subTotalController.text = grandTotalScore.round().toString();
                    grandTotalController.text = grandTotalScore.round().toString();
                  }
                  print("stock::1::$subTotals::$dueAmount::$grandTotalScore::$grandTotal:::${dueAmountController.text}::");
                });
              });
            });
            dateController.text = widget.date==""?editTempInvoiceData.dtInvoiceDate.toString(): widget.date;
            onlineController.text = editTempInvoiceData.deconlinepayment!.round().toString();
            cashController.text = editTempInvoiceData.deccashpayment!.round().toString();
            totalAmountController.text = editTempInvoiceData.decTotalAmount!.round().toString();
            print("route::1:0:$routeDropdownValue:::${widget.type}::$dropdownValue");
          }
        });
      });
      // Provider.of<RouteProvider>(context, listen: false).getDriverHelper(context,PreferenceUtils.getString("${AppConstants.companyId}"),"3").then((value) {
      //   is_loading = false;
      //   Provider.of<CustomerProvider>(context, listen: false).getCustomerDueReport(context,PreferenceUtils.getString(AppConstants.companyId.toString())).then((value) {
      //     is_loading = false;
      //     for(int i=0;i<Provider.of<CustomerProvider>(context, listen: false).customerDueReportList.length;i++){
      //       if(widget.type == "edit"){
      //         if(dropdownValue == Provider.of<CustomerProvider>(context, listen: false).customerDueReportList[i].intCustomerid){
      //           dueAmountController.text = Provider.of<CustomerProvider>(context, listen: false).customerDueReportList[i].decDueAmount!.round().toString();
      //           dueAmount = Provider.of<CustomerProvider>(context, listen: false).customerDueReportList[i].decDueAmount!;
      //         }
      //       }else{
      //         if(widget.customerId == Provider.of<CustomerProvider>(context, listen: false).customerDueReportList[i].intCustomerid){
      //           dueAmountController.text = Provider.of<CustomerProvider>(context, listen: false).customerDueReportList[i].decDueAmount!.round().toString();
      //           dueAmount = Provider.of<CustomerProvider>(context, listen: false).customerDueReportList[i].decDueAmount!;
      //         }
      //       }
      //       print("due:: ${dueAmountController.text}");
      //     }
      //   });
      // });
      /*Provider.of<TempInvoiceProvider>(context, listen: false).getTempStockList(context,widget.id,"18").then((value) {
        is_loading = false;
        setState(() {
          for(int i=0;i<Provider.of<TempInvoiceProvider>(context, listen: false).tempStockList.length;i++){
            subTotals += Provider.of<TempInvoiceProvider>(context, listen: false).tempStockList[i].decAmount!.round();
            grandTotalScore = subTotals + grandTotals;
            grandTotal = grandTotalScore + double.parse(dueAmountController.text==""?"0":dueAmountController.text);
            subTotalController.text = grandTotalScore.round().toString();
            grandTotalController.text = grandTotal.round().toString();
          }
          print("stock::1::$subTotals::$dueAmount::$grandTotalScore::$grandTotal:::${dueAmountController.text}::");
        });
      });*/
      Provider.of<RouteProvider>(context, listen: false).getItemList(context,PreferenceUtils.getString("${AppConstants.companyId}"),'0','0');
    });
  }

  _addTempInvoice() async {
    if (routeDropdownValue==0) {
      AppConstants.getToast("Please Select Route");
    }  else if (dropdownValue==0) {
      AppConstants.getToast("Please Select Customer");
    } else if (dateController.text=='') {
      AppConstants.getToast("Please Select Date");
    }
    else if (modelList.isEmpty && Provider.of<TempInvoiceProvider>(context, listen: false).tempStockList.isEmpty) {
      AppConstants.getToast("Please Add Item");
    }
    else if (subTotalController.text=='') {
      AppConstants.getToast("Please Enter Sub Total");
    }
    else if (dueAmountController.text=='') {
      AppConstants.getToast("Please Enter Due Amount");
    }
    else if (grandTotalController.text=='') {
      AppConstants.getToast("Please Enter Grand Total");
    }  else if (onlineController.text=='') {
      AppConstants.getToast("Please Enter Online");
    }  else if (cashController.text=='') {
      AppConstants.getToast("Please Enter Cash");
    }  else if (totalAmountController.text == '') {
      AppConstants.getToast("Please Enter Payment Total");
    }
    //  else if (subTotalController.text != grandTotalController.text) {
    //   AppConstants.getToast("Sub Total or Grand Total is Not Mach");
    // }
    else {
      print("model list:::::::::::${modelList.toList()}");
      setState(() {
        _isLoading = true;
      });
      print("model list:::::::::::${modelList.toList()}");
      var apiUrl = '${AppConstants.BASE_URL}${AppConstants.ADD_TEMP_INVOICE_URI}'; // Replace with your API endpoint

      // Create the nested JSON SQL payload
      var payload = {
        "intid": int.parse(widget.id),
        "intRouteId": routeDropdownValue,
        "intCustomerId": dropdownValue,
        "dtInvoiceDate": dateController.text,
        "intCompanyId": int.parse(PreferenceUtils.getString("${AppConstants.companyId}")),
        "decSubTotal": double.parse(subTotalController.text),
        "decDueAmount": dueAmountController.text,
        "decGrandTotal": double.parse(grandTotalController.text),
        "decOnlinePayment": onlineController.text,
        "decCashPayment": cashController.text,
        "decTotalAmount": totalAmountController.text,
        "itemDetailsInvoiceModel": [
          for(int i=0; i< modelList.length; i++){
            'intItemsDetails': modelList[i].intItemsDetails,
            'decQty':modelList[i].decQty,
            'decRate': modelList[i].decRate,
            'decAmount': modelList[i].decAmount,
          }
        ]
      };

      // Convert the nested payload to JSON
      var payloadJson = json.encode(payload);

      // Send the POST request
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: payloadJson,
      );
      setState(() {
        _isLoading = false;
        for(int i=0;i<items.length;i++){
          print("itemId::${items[i].intid}");
          Provider.of<TempInvoiceProvider>(context, listen: false).getDeleteTempStock(context,items[i].intid.toString());
        }
      });
      // Check the response
      if (response.statusCode == 200) {
        // Request successful, handle the response here
        var responseData = json.decode(response.body);
        setState(() {
          _isLoading = false;
          // _deleteItem();
        });
        routeDropdownValue = 0;
        dropdownValue = 0;
        itemDbManager.deleteAllStock();
        _route();
        // AppConstants.getToast('Temp Invoice Updated Successfully');
        print("response::::$responseData");
      } else {
        // Request failed, handle the error here
        AppConstants.getToast("Please Try After Sometime");
        print('Request failed with status: ${response.statusCode}');
      }
      AppConstants.closeKeyboard();
    }
  }

  _route(){
    // if (isRoute) {
      routeDropdownValue = 0;
      dropdownValue = 0;
      // tempList.clear();
      itemDbManager.deleteAllStock();
      Navigator.push(context, MaterialPageRoute(builder: (context) => TempInvoiceList("","","Side"),));
      AppConstants.getToast('Temp Invoice Updated Successfully');
    // }  else {
    //   AppConstants.getToast("Please Try After Sometime");
    // }
  }

  List<TempStockData> tempList = [];
  int? idToRemove;
  TempStockData removedItem = TempStockData();
  List<TempStockData> removedList = [];

  List<DataRow> _buildRow() {
    List<DataRow> rows = [];

    TempStock_Body model;
    for(int i=0;i<modelList.length;i++) {
      model = modelList[i];
    }

    // Add rows from data1
    rows.addAll(modelList.map((item) {
      stock_amount = item.decRate! * item.decQty!;
      return DataRow(
        cells: [
          DataCell(GestureDetector(
            onTap: (){
              showDialog<bool>(
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text("Are You Sure You Want to Delete ?"),
                      contentTextStyle: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_16),
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              PreferenceUtils.remove('map');
                              grandTotal = double.parse(subTotalController.text) - int.parse(item.decAmount.toString());
                              subTotal = subTotal - grandTotal;
                              subTotalController.text = grandTotal.round().toString();
                              dueAmount = double.parse(subTotalController.text) + double.parse(dueAmountController.text);
                              grandTotalController.text = dueAmount.round().toString();
                              print("route::::d::${widget.routeId}::::${widget.customerId}");
                              itemDbManager.deleteStock(item).then((value) {
                                print("route::::d:${widget.routeId}:::::${widget.customerId}");
                              });
                              Navigator.pop(context);
                            });
                          },
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                          ),
                          child: Text('Yes',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                          ),
                          child: Text('No',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
                        ),
                      ],
                    );
                  },context: context);
            },
            child: Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(right: 10),
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                )),
          )),
          DataCell(Container(child: _verticalDivider)),
          DataCell(Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(05),
              child: Text(
                "${item.name}",
                style: poppinsBold.copyWith(
                    color: ColorResources.BLACK),
                textAlign: TextAlign.center,
              ))),
          DataCell(Container(child: _verticalDivider)),
          DataCell(Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(05),
              child: Text(
                "${item.decQty}",
                style: poppinsBold.copyWith(
                    color: ColorResources.BLACK),
                textAlign: TextAlign.center,
              ))),
          DataCell(Container(child: _verticalDivider)),
          DataCell(Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(05),
              child: Text(
                "\u20b9 ${item.decRate}",
                style: poppinsBold.copyWith(
                    color: ColorResources.BLACK),
                textAlign: TextAlign.center,
              ))),
          DataCell(Container(child: _verticalDivider)),
          DataCell(Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(05),
              child: Text(
                "\u20b9 $stock_amount",
                style: poppinsBold.copyWith(
                    color: ColorResources.BLACK),
                textAlign: TextAlign.center,
              ))),
        ],
      );
    }));

    // Add rows from data2
    rows.addAll(Provider.of<TempInvoiceProvider>(context).tempStockList.map((item) =>
        DataRow(
      cells: [
        DataCell(GestureDetector(
          onTap: (){
            showDialog<bool>(
                barrierDismissible: false,
                builder: (BuildContext context) {
                  print("id:::${item.intid}");
                  return AlertDialog(
                    content: const Text("Are You Sure You Want to Delete ?"),
                    contentTextStyle: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_16),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            grandTotal = double.parse(subTotalController.text) - int.parse(item.decAmount!.round().toString());
                            grandTotalScore = subTotal - grandTotal;
                            subTotalController.text = grandTotal.round().toString();
                            dueAmount = double.parse(subTotalController.text) + double.parse(dueAmountController.text);
                            grandTotalController.text = dueAmount.round().toString();
                            print("route::::d::${widget.routeId}::::${widget.customerId}");
                            print("stock::d:$subTotal:::$grandTotalScore::$grandTotal:::::${item.decAmount!.round().toString()}");
                            print("stock::d1:$subTotal::${widget.subTotal}:::$grandTotal:::${widget.grandTotal}:::${widget.totalGrand}:::${item.decAmount!.round().toString()}");
                            print(" :: $items");
                            items.add(item);
                            Provider.of<TempInvoiceProvider>(context, listen: false).tempStockList.removeWhere((element){
                              return element.intid == item.intid;
                            });
                            setState(() {
                              for(int i=0;i<items.length;i++){
                                print(" :::  ${items[i].intid}");
                              }
                              print(" ::: $items :: ${items[0].intid}");
                              Navigator.pop(context);
                            });
                          });
                        },
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                        ),
                        child: Text('Yes',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                        ),
                        child: Text('No',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
                      ),
                    ],
                  );
                },context: context);
          },
          child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(right: 10),
              child: const Icon(
                Icons.delete,
                color: Colors.red,
              )),
        )),
        DataCell(Container(child: _verticalDivider)),
        DataCell(Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(05),
            child: Text(
              "${item.strItemName}",
              style: poppinsBold.copyWith(
                  color: ColorResources.BLACK),
              textAlign: TextAlign.center,
            ))),
        DataCell(Container(child: _verticalDivider)),
        DataCell(Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(05),
            child: Text(
              "${item.decQty!.round()}",
              style: poppinsBold.copyWith(
                  color: ColorResources.BLACK),
              textAlign: TextAlign.center,
            ))),
        DataCell(Container(child: _verticalDivider)),
        DataCell(Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(05),
            child: Text(
              "\u20b9 ${item.decRate!.round()}",
              style: poppinsBold.copyWith(
                  color: ColorResources.BLACK),
              textAlign: TextAlign.center,
            ))),
        DataCell(Container(child: _verticalDivider)),
        DataCell(Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(05),
            child: Text(
              "\u20b9 ${item.decAmount!.round()}",
              style: poppinsBold.copyWith(
                  color: ColorResources.BLACK),
              textAlign: TextAlign.center,
            ))),
      ],
    )));

    return rows;
  }

  SelectRouteData? selectedValue;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        itemDbManager.deleteAllStock();
        Navigator.push(context,MaterialPageRoute(builder: (context) => TempInvoiceList(widget.id,widget.customerId.toString(),"Side"),));
        return true;
      },
      child: Consumer<TempInvoiceProvider>(builder: (context, temp, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorResources.LINE_BG,
            centerTitle: true,
            leading: IconButton(onPressed: () {
              itemDbManager.deleteAllStock();
              Navigator.push(context,MaterialPageRoute(builder: (context) => TempInvoiceList(widget.id,widget.customerId.toString(),"Side"),));
            }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
            title: Text("Edit Sale Invoice",style: montserratBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
          ),
          body:
          is_loading
              ?
          const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG),)
              :
          ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: AppConstants.itemHeight*0.02),
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                  child: Row(
                    children: [
                      Text("Select Route",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                      Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                    ],
                  )),
              Container(
                width: double.infinity,
                height: AppConstants.itemHeight*0.065,
                margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                decoration: BoxDecoration(
                  color: ColorResources.GREY.withOpacity(0.05),
                  borderRadius:BorderRadius.circular(10),
                ),
                child: Consumer<RouteProvider>(builder: (context, route, child) {
                  return DropdownButtonHideUnderline(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            width: AppConstants.itemWidth*0.80,
                            child: TypeAheadFormField<SelectRouteData>(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: routeController,
                                keyboardType: TextInputType.text,
                                onTap: () {
                                  routeController.clear();
                                  routeName = "";
                                },
                                style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: routeName==""?ColorResources.GREY:ColorResources.BLACK),
                                decoration: InputDecoration(
                                  hintText: routeName ?? 'Select Route',
                                  hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: routeName==""?ColorResources.GREY:ColorResources.BLACK),
                                  border: InputBorder.none,
                                ),
                              ),
                              suggestionsCallback: (pattern) {
                                return route.selectrouteList
                                    .where((driver) =>
                                driver.strRoute!.toLowerCase().contains(pattern.toLowerCase()) ||
                                    driver.strRoute!.toUpperCase().contains(pattern.toUpperCase()))
                                    .toList();
                              },
                              itemBuilder: (context, suggestion) {
                                return SizedBox(
                                  height: AppConstants.itemHeight*0.05,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                                    title: Text(suggestion.strRoute.toString(),style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK)),
                                  ),
                                );
                              },
                              onSuggestionSelected: (suggestion) {
                                setState(() {
                                  routeName = suggestion.strRoute;
                                  routeDropdownValue = suggestion.intId!;
                                  routeController.text = routeName!;
                                  print("route name :::$routeName ::$routeDropdownValue");
                                });
                              },
                              noItemsFoundBuilder: (context) {
                                return DataNotFoundScreen("No Item Found");
                              },
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down_outlined,color: ColorResources.GREY),
                        ],
                      )
                    /*CustomSearchableDropDown(
                        menuPadding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.15),
                        padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                        multiSelect: false,
                        dropDownMenuItems: route.selectrouteList.map((areaList) {
                          return areaList.strRoute;
                        }).toList(),
                        dropdownItemStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                        label: routeName ?? 'Select Route',
                        labelStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                        items : route.selectrouteList.map((areaList) {
                          return  areaList.intId;
                        }).toList(),
                        onChanged: (value){
                          if(value!=null)
                          {
                            routeDropdownValue = value;
                            // for(int k=0;k<Provider.of<RouteProvider>(context, listen: false).selectrouteList.length;k++){
                            //   if (value == Provider.of<RouteProvider>(context, listen: false).selectrouteList[k].intId) {
                            //     routeDropdownValue = Provider.of<RouteProvider>(context, listen: false).selectrouteList[k].intId!;
                            //     routeName = Provider.of<RouteProvider>(context, listen: false).selectrouteList[k].strRoute.toString();
                            //     print("routes::1:$routeDropdownValue::$routeName");
                            //   }
                            // }
                            print("object:::$value");
                          }
                          else{
                            routeDropdownValue = 0;
                            print("object:::$value");
                          }
                        },
                      )*/
                  );
                },),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                  child: Row(
                    children: [
                      Text("Select Customer",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                      Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                    ],
                  )),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                decoration: BoxDecoration(
                  color: ColorResources.GREY.withOpacity(0.05),
                  borderRadius:BorderRadius.circular(10),
                ),
                child: Consumer<RouteProvider>(builder: (context, customer, child) {
                  // for(int i=0;i<Provider.of<TempInvoiceProvider>(context, listen: false).editTempInvoiceList.length;i++){
                  //   for(int k=0;k<Provider.of<RouteProvider>(context, listen: false).driverList.length;k++){
                  //     if (dropdownValue == Provider.of<RouteProvider>(context, listen: false).driverList[k].intId) {
                  //       dropdownValue = Provider.of<RouteProvider>(context, listen: false).driverList[k].intId!;
                  //       customerName = Provider.of<RouteProvider>(context, listen: false).driverList[k].srtFullName.toString();
                  //       print("routes:::$dropdownValue::$customerName");
                  //     }
                  //   }
                  // }
                  return DropdownButtonHideUnderline(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          width: AppConstants.itemWidth*0.80,
                          child: TypeAheadFormField<DriverData>(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: customerController,
                              keyboardType: TextInputType.text,
                              onTap: () {
                                customerController.clear();
                                customerName = "";
                              },
                              style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: customerName==""?ColorResources.GREY:ColorResources.BLACK),
                              decoration: InputDecoration(
                                hintText: customerName ?? 'Select Customer',
                                hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: customerName==""?ColorResources.GREY:ColorResources.BLACK),
                                border: InputBorder.none,
                              ),
                            ),
                            suggestionsCallback: (pattern) {
                              return customer.driverList
                                  .where((driver) =>
                              driver.srtFullName!.toLowerCase().contains(pattern.toLowerCase()) ||
                                  driver.srtFullName!.toUpperCase().contains(pattern.toUpperCase()))
                                  .toList();
                            },
                            itemBuilder: (context, suggestion) {
                              return SizedBox(
                                height: AppConstants.itemHeight*0.05,
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                                  title: Text(suggestion.srtFullName.toString(),style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK)),
                                ),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              setState(() {
                                customerName = suggestion.srtFullName!;
                                dropdownValue = suggestion.intId!;
                                customerController.text = customerName!;
                                Provider.of<RouteProvider>(context, listen: false).getItemList(context,PreferenceUtils.getString("${AppConstants.companyId}"),'$dropdownValue','$itemdropdownValue').then((value) {
                                  Provider.of<CustomerProvider>(context, listen: false).getCustomerDueReport(context,PreferenceUtils.getString(AppConstants.companyId.toString())).then((value) {
                                    for(int i=0;i<Provider.of<CustomerProvider>(context, listen: false).customerDueReportList.length;i++){
                                      if(dropdownValue == Provider.of<CustomerProvider>(context, listen: false).customerDueReportList[i].intCustomerid){
                                        dueAmountController.text = Provider.of<CustomerProvider>(context, listen: false).customerDueReportList[i].decDueAmount!.round().toString();
                                      }
                                    }
                                  });
                                });
                                print("customer name :::$customerName ::$dropdownValue");
                              });
                            },
                            noItemsFoundBuilder: (context) {
                              return DataNotFoundScreen("No Item Found");
                            },
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down_outlined,color: ColorResources.GREY),
                      ],
                    )
                    /*CustomSearchableDropDown(
                      menuPadding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.15),
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                      multiSelect: false,
                      dropDownMenuItems: customer.driverList.map((areaList) {
                        return areaList.srtFullName;
                      }).toList(),
                      dropdownItemStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                      label: customerName=="" ? 'Select Customer':customerName,
                      labelStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                      items : customer.driverList.map((areaList) {
                        return  areaList.intId;
                      }).toList(),
                      onChanged: (value){
                        if(value!=null)
                        {
                          dropdownValue = value;
                          print("object:::$value");
                        }
                        else{
                          dropdownValue = 0;
                          print("object:::$value");
                        }
                      },
                    )*/
                  );
                },),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                  child: Row(
                    children: [
                      Text("Invoice Date",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                      Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                    ],
                  )),
              GestureDetector(
                onTap: () {
                  _date_pik_shcedule();
                  print("object:::$date_shcedule");
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                  child: CustomDateTextField(
                    controller: dateController,
                    focusNode: dateCode,
                    nextNode: null,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Text("Item Detail",style: montserratBold.copyWith(color: ColorResources.BLACK)),
              ),
              Container(
                // height: AppConstants.itemHeight*0.06,
                width: AppConstants.itemWidth*0.50,
                margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
                decoration: BoxDecoration(
                  color: ColorResources.GREY.withOpacity(0.05),
                  borderRadius:BorderRadius.circular(10),
                ),
                child: Consumer<RouteProvider>(builder: (context, item, child) {
                  return DropdownButtonHideUnderline(
                    child: DropdownButtonHideUnderline(
                        child:
                        CustomSearchableDropDown(
                          menuPadding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.15),
                          padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                          multiSelect: false,
                          dropDownMenuItems: item.itemList.map((areaList) {
                            // itemdropdownValue = null;
                            return areaList.itemName;
                          }).toList(),
                          dropdownItemStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                          label: 'Select Item',
                          labelStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                          items : item.itemList.map((areaList) {
                            // itemdropdownValue = null;
                            return  areaList.intid;
                          }).toList(),
                          onChanged: (value){
                            if(value!=null)
                            {
                              itemdropdownValue = value;
                              Provider.of<RouteProvider>(context, listen: false).getItemList(context,PreferenceUtils.getString("${AppConstants.companyId}"),'$dropdownValue','$itemdropdownValue').then((value) {
                                for(int i=0;i<item.itemList.length;i++){
                                  if(item.itemList[i].intid == itemdropdownValue){
                                    itemsDropdownName=item.itemList[i].itemName;
                                    itemsUnitName=item.itemList[i].strName;
                                    itemsDropdownPrice = item.itemList[i].decScale?.round().toString();
                                    rateController.text = itemsDropdownPrice.toString();
                                    print("name:::::$itemsDropdownName");
                                  }
                                }
                              });
                              print("object:::$value");
                            }
                            else{
                              itemdropdownValue = null;
                              print("object:::$value");
                            }
                          },
                        )
                    )
                  );
                },),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                      child:
                      Container(
                        width: AppConstants.itemWidth*0.28,
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: ColorResources.GREY.withOpacity(0.05),
                          borderRadius:BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: qtyController,
                          maxLines: 1,
                          focusNode: qtyCode,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          cursorColor: ColorResources.LINE_BG,
                          onTap: () {
                            setState(() {
                              total_amount = int.parse(qtyController.text) * int.parse(rateController.text);
                              amountController.text = total_amount.toString();
                              print("amount::::${amountController.text}");
                              print("amount::::${total_amount.toString()}");
                            });
                          },
                          onChanged: (v) {
                            // FocusScope.of(context).requestFocus(qtyCode);
                            setState(() {
                              total_amount = int.parse(qtyController.text) * int.parse(rateController.text);
                              amountController.text = total_amount.toString();
                              print("amount::::${amountController.text}");
                              print("amount::::${total_amount.toString()}");
                            });
                          },
                          style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly ,FilteringTextInputFormatter.singleLineFormatter],
                          decoration: InputDecoration(
                            hintText: 'Qty',
                            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
                            isDense: true,
                            counterText: '',
                            focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                            hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),
                            errorStyle: const TextStyle(height: 1.5),
                            border: InputBorder.none,
                          ),
                        ),
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                      child:
                      Container(
                        width: AppConstants.itemWidth*0.28,
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: ColorResources.GREY.withOpacity(0.05),
                          borderRadius:BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: rateController,
                          maxLines: 1,
                          focusNode: rateCode,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          cursorColor: ColorResources.LINE_BG,
                          onTap: () {
                            setState(() {
                              total_amount = int.parse(qtyController.text) * int.parse(rateController.text);
                              amountController.text = total_amount.toString();
                              print("amount::::${amountController.text}");
                              print("amount::::${total_amount.toString()}");
                            });
                          },
                          onChanged: (v) {
                            // FocusScope.of(context).requestFocus(qtyCode);
                            setState(() {
                              total_amount = int.parse(qtyController.text) * int.parse(rateController.text);
                              amountController.text = total_amount.toString();
                              print("amount::::${amountController.text}");
                              print("amount::::${total_amount.toString()}");
                            });
                          },
                          style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly ,FilteringTextInputFormatter.singleLineFormatter],
                          decoration: InputDecoration(
                            hintText: 'Rate',
                            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
                            isDense: true,
                            counterText: '',
                            focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                            hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),
                            errorStyle: const TextStyle(height: 1.5),
                            border: InputBorder.none,
                          ),
                        ),
                      )
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                    child: CustomTextFixWidthFieldEnabled(
                      controller: amountController,
                      focusNode: amountCode,
                      nextNode: null,
                      enabled: false,
                      hintText: "Amount",
                      isPhoneNumber: false,
                      textInputType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ],
              ),
              CustomButtonFuction(onTap: (){
                if (itemdropdownValue == 0) {
                  AppConstants.getToast("Please Select Item");
                } else if (qtyController.text=='') {
                  AppConstants.getToast('Please Enter Qty');
                } else if (rateController.text == '') {
                  AppConstants.getToast('Please Enter Rate');
                } else if (rateController.text == '0') {
                  AppConstants.getToast('Rate Is Not Valid');
                  setState(() {
                    itemdropdownValue = 0;
                    qtyController.clear();
                    rateController.clear();
                    amountController.clear();
                    print("route:::::s1:$routeDropdownValue:::::$dropdownValue");
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => EditTempInvoice(widget.id,dropdownValue,customerName!,routeDropdownValue,dateController.text,subTotalController.text,dueAmountController.text,grandTotalController.text,grandTotal.toString(),"table",modelList),));
                  });
                } else if (amountController.text == '') {
                  AppConstants.getToast('Please Enter Amount');
                } else {
                  bool doesItemExit = modelList.any((element) => element.name == itemsDropdownName);
                  bool doesItemExits = temp.tempStockList.any((element) => element.strItemName == itemsDropdownName);
                  setState(() {
                    if(!doesItemExit && !doesItemExits){
                      grandTotal = double.parse(amountController.text.toString());
                      subTotal = grandTotal + subTotal;
                      // grandTotalScore = subTotal + double.parse(dueAmountController.text);
                      subTotalController.text = subTotal.round().toString();
                      grandTotalController.text = subTotal.round().toString();
                      print("stock::$subTotal:::::$grandTotal:::$grandTotalScore");
                      itemDetailsInvoiceModel = TempStock_Body(
                          intItemsDetails: itemdropdownValue,
                          name: itemsDropdownName.toString(),
                          strName: itemsUnitName.toString(),
                          decQty: int.parse(qtyController.text),
                          decRate: int.parse(rateController.text),
                          decAmount: int.parse(amountController.text));
                      print("route:::::2:$routeDropdownValue:::$dropdownValue");
                      itemDbManager.insertStock(itemDetailsInvoiceModel!).then((value){
                        for(int i=0;i<items.length;i++){
                          print("itemIdDelete::${items[i].intid}");
                          Provider.of<TempInvoiceProvider>(context, listen: false).getDeleteTempStock(context,items[i].intid.toString());
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditTempInvoice(widget.id,dropdownValue,customerName.toString(),routeDropdownValue,dateController.text,subTotalController.text,dueAmountController.text,grandTotalController.text,grandTotal.toString(),"table",modelList),));
                      });
                      itemdropdownValue = null;
                      qtyController.text = "";
                      rateController.text = "";
                      amountController.text= "";
                    }else {
                      itemdropdownValue = null;
                      qtyController.text = "";
                      rateController.text = "";
                      amountController.text= "";
                      print("route::::3:$routeDropdownValue:::::$dropdownValue");
                      AppConstants.getToast("This Item is Already Added Please Add Different Item");
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => EditTempInvoice(widget.id,dropdownValue,customerName!,routeDropdownValue,dateController.text,subTotalController.text,dueAmountController.text,grandTotalController.text,grandTotal.toString(),"table",modelList),));
                    }
                  });
                }
              }, buttonText: "Add More Item"),
              /*FutureBuilder(
                  future: itemDbManager.getStockList(),
                  builder: (context,snapshot) {
                    if(snapshot.hasData){
                      modelList = snapshot.data as List<TempStock_Body>;
                      print("data::${modelList}");
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: DataTable(
                          dividerThickness: 1,
                          columnSpacing: AppConstants.itemWidth*0.015,
                          dataRowHeight: AppConstants.itemHeight*0.04,
                          headingRowHeight: AppConstants.itemHeight*0.04,
                          decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                          columns: [
                            const DataColumn(label: SizedBox()),
                            DataColumn(label: _verticalDivider),
                            DataColumn(label: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(05),
                              child: Text('Name',
                                  style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                            )),
                            DataColumn(label: _verticalDivider),
                            DataColumn(label: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(05),
                              child: Text('QTY',
                                  style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                            )),
                            DataColumn(label: _verticalDivider),
                            DataColumn(label: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(05),
                              child: Text('Rate',
                                  style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                            )),
                            DataColumn(label: _verticalDivider),
                            DataColumn(label: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(05),
                              child: Text('Amount',
                                  style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                            )),
                          ],
                          rows: _buildRow(),
                        ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG));
                  }
              ),*/
              FutureBuilder(
                future: itemDbManager.getStockList(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    modelList = snapshot.data as List<TempStock_Body>;
                    return
                      modelList.isEmpty
                          ?
                      const SizedBox()
                          :
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: modelList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: AppConstants.itemHeight*0.005),
                            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
                            decoration: BoxDecoration(
                                color: ColorResources.GREY.withOpacity(0.05),
                                border: Border.all(color: ColorResources.GREY.withOpacity(0.10)),
                                borderRadius: BorderRadius.circular(05)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Container(
                                        //   alignment: Alignment.center,
                                        //   padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.01,vertical: AppConstants.itemHeight*0.001),
                                        //   decoration: BoxDecoration(
                                        //       color: ColorResources.WHITE,
                                        //       border: Border.all(color: ColorResources.GREY.withOpacity(0.20)),
                                        //       borderRadius: BorderRadius.circular(05)
                                        //   ),
                                        //   child: Text("# ${index + 1}",style: montserratRegular.copyWith(fontSize: 13),),
                                        // ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          width: AppConstants.itemWidth*0.40,
                                          // margin: EdgeInsets.only(left: AppConstants.itemWidth*0.01),
                                          child: Text("${modelList[index].name}",maxLines:1,overflow: TextOverflow.visible,style: montserratBlack.copyWith(
                                              fontWeight: FontWeight.w600
                                          )),
                                        ),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          width: AppConstants.itemWidth*0.40,
                                          child: Text("\u20b9 ${modelList[index].decAmount!.round()}",style: montserratBlack.copyWith(
                                              fontWeight: FontWeight.w600
                                          )),
                                        ),
                                      ],
                                    ),
                                    // Container(
                                    //   alignment: Alignment.centerLeft,
                                    //   width: AppConstants.itemWidth*0.25,
                                    //   child: Text("Item Subtotal",style: montserratRegular.copyWith(
                                    //       fontWeight: FontWeight.w400
                                    //   )),
                                    // ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // Container(
                                    //   alignment: Alignment.centerRight,
                                    //   width: AppConstants.itemWidth*0.30,
                                    //   child: Text("\u20b9 ${modelList[index].decAmount!.round()}",style: montserratBlack.copyWith(
                                    //       fontWeight: FontWeight.w600
                                    //   )),
                                    // ),
                                    // Container(
                                    //   alignment: Alignment.centerRight,
                                    //   width: AppConstants.itemWidth*0.40,
                                    //   child: Text("${modelList[index].decQty!.round()} ${modelList[index].strName} x ${modelList[index].decRate!.round()} = \u20b9 ${modelList[index].decAmount!.round()}",
                                    //       maxLines: 1,
                                    //       overflow: TextOverflow.ellipsis,
                                    //       style: montserratRegular.copyWith(
                                    //           fontWeight: FontWeight.w400
                                    //       )),
                                    // )
                                  ],
                                ),
                                GestureDetector(
                                  onTap: (){
                                    showDialog<bool>(
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: const Text("Are You Sure You Want to Delete ?"),
                                            contentTextStyle: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_16),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    grandTotal = double.parse(subTotalController.text) - int.parse(modelList[index].decAmount.toString());
                                                    subTotal = subTotal - grandTotal;
                                                    subTotalController.text = grandTotal.round().toString();
                                                    // dueAmount = double.parse(subTotalController.text) + double.parse(dueAmountController.text);
                                                    grandTotalController.text = grandTotal.round().toString();
                                                    print("route::::d::${widget.routeId}::::${widget.customerId}");
                                                    itemDbManager.deleteStock(modelList[index]).then((value) {
                                                      print("route::::d:${widget.routeId}:::::${widget.customerId}");
                                                    });
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                style: const ButtonStyle(
                                                    backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                                                ),
                                                child: Text('Yes',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  itemdropdownValue = "Select Item";
                                                  itemsDropdownName = "";
                                                  qtyController.text = "";
                                                  Navigator.pop(context);
                                                },
                                                style: const ButtonStyle(
                                                    backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                                                ),
                                                child: Text('No',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
                                              ),
                                            ],
                                          );
                                        },context: context);
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                ),
                              ],
                            ),
                          );
                        },);
                  }
                  return const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG));
                },),
              temp.isLoading
                  ?
                  Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG,),):
              temp.tempStockList.isEmpty
                  ?
              const SizedBox()
                  :
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: temp.tempStockList.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: AppConstants.itemHeight*0.005),
                    padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
                    decoration: BoxDecoration(
                        color: ColorResources.GREY.withOpacity(0.05),
                        border: Border.all(color: ColorResources.GREY.withOpacity(0.10)),
                        borderRadius: BorderRadius.circular(05)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Container(
                                //   alignment: Alignment.center,
                                //   padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.01,vertical: AppConstants.itemHeight*0.001),
                                //   decoration: BoxDecoration(
                                //       color: ColorResources.WHITE,
                                //       border: Border.all(color: ColorResources.GREY.withOpacity(0.20)),
                                //       borderRadius: BorderRadius.circular(05)
                                //   ),
                                //   child: Text("# ${index + 1}",style: montserratRegular.copyWith(fontSize: 13),),
                                // ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: AppConstants.itemWidth*0.40,
                                  // margin: EdgeInsets.only(left: AppConstants.itemWidth*0.01),
                                  child: Text("${temp.tempStockList[index].strItemName}",maxLines:1,overflow: TextOverflow.visible,style: montserratBlack.copyWith(
                                      fontWeight: FontWeight.w600
                                  )),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  width: AppConstants.itemWidth*0.40,
                                  child: Text("\u20b9 ${temp.tempStockList[index].decAmount!.round()}",style: montserratBlack.copyWith(
                                      fontWeight: FontWeight.w600
                                  )),
                                ),
                              ],
                            ),
                            // Container(
                            //   alignment: Alignment.centerLeft,
                            //   width: AppConstants.itemWidth*0.25,
                            //   child: Text("Item Subtotal",style: montserratRegular.copyWith(
                            //       fontWeight: FontWeight.w400
                            //   )),
                            // ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Container(
                            //   alignment: Alignment.centerRight,
                            //   width: AppConstants.itemWidth*0.40,
                            //   child: Text("\u20b9 ${temp.tempStockList[index].decAmount!.round()}",style: montserratBlack.copyWith(
                            //       fontWeight: FontWeight.w600
                            //   )),
                            // ),
                            // Container(
                            //   alignment: Alignment.centerRight,
                            //   width: AppConstants.itemWidth*0.40,
                            //   child: Text("${temp.tempStockList[index].decQty!.round()} ${temp.tempStockList[index].strUnitName} x ${temp.tempStockList[index].decRate!.round()} = \u20b9 ${temp.tempStockList[index].decAmount!.round()}",
                            //       maxLines: 1,
                            //       overflow: TextOverflow.ellipsis,
                            //       style: montserratRegular.copyWith(
                            //           fontWeight: FontWeight.w400
                            //       )),
                            // )
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            showDialog<bool>(
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: const Text("Are You Sure You Want to Delete ?"),
                                    contentTextStyle: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_16),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            grandTotal = double.parse(subTotalController.text) - int.parse(temp.tempStockList[index].decAmount!.round().toString());
                                            // grandTotalScore = subTotal - grandTotal;
                                            subTotalController.text = grandTotal.round().toString();
                                            // dueAmount = double.parse(subTotalController.text) + double.parse(dueAmountController.text);
                                            grandTotalController.text = grandTotal.round().toString();
                                            print("route::::d::${widget.routeId}::::${widget.customerId}");
                                            print("stock::d:$subTotal:::$grandTotalScore::$grandTotal:::::${temp.tempStockList[index].decAmount!.round().toString()}");
                                            print("stock::d1:$subTotal::${widget.subTotal}:::$grandTotal:::${widget.grandTotal}:::${widget.totalGrand}:::${temp.tempStockList[index].decAmount!.round().toString()}");
                                            print(" :: $items");
                                            items.add(temp.tempStockList[index]);
                                            Provider.of<TempInvoiceProvider>(context, listen: false).tempStockList.removeWhere((element){
                                              return element.intid == temp.tempStockList[index].intid;
                                            });
                                            setState(() {
                                              for(int i=0;i<items.length;i++){
                                                print(" :::  ${items[i].intid}");
                                              }
                                              print(" ::: $items :: ${items[0].intid}");
                                              Navigator.pop(context);
                                            });
                                          });
                                        },
                                        style: const ButtonStyle(
                                            backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                                        ),
                                        child: Text('Yes',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          itemdropdownValue = "Select Item";
                                          itemsDropdownName = "";
                                          qtyController.text = "";
                                          Navigator.pop(context);
                                        },
                                        style: const ButtonStyle(
                                            backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                                        ),
                                        child: Text('No',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
                                      ),
                                    ],
                                  );
                                },context: context);
                          },
                          child: Container(
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ),
                      ],
                    ),
                  );
                },),
             //  MyDataTableMerge(widget.id,routeDropdownValue,dropdownValue,dateController.text,subTotalController.text,dueAmountController.text,grandTotalController.text,grandTotal.toString(),"table",modelList,temp.tempStockList),
              const Divider(color: ColorResources.BLACK),
              SizedBox(height: AppConstants.itemHeight*0.01),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                  child: Text("Sub Total",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                child: CustomTextFieldEnabled(
                  controller: subTotalController,
                  focusNode: subTotalCode,
                  nextNode: dueAmountCode,
                  enabled: false,
                  hintText: "Sub Total",
                  isPhoneNumber: true,
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                  child: Text("Due Amount",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                  child:
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                      color: ColorResources.GREY.withOpacity(0.05),
                      borderRadius:BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: dueAmountController,
                      maxLines: 1,
                      focusNode: dueAmountCode,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      cursorColor: ColorResources.LINE_BG,
                      onTap: () {
                        setState(() {
                          dueAmountController.text != '' ?
                          dueTotal_amount = int.parse(subTotalController.text) + int.parse(dueAmountController.text):
                          dueTotal_amount = int.parse(subTotalController.text) - 0;
                          dueAmountController.text!=''?dueAmountController.text:dueAmountController.text ="0";
                          // grandTotalController.text = dueTotal_amount.toString();
                          print("grandTotalController::::${grandTotalController.text}");
                        });
                      },
                      onChanged: (v) {
                        // FocusScope.of(context).requestFocus(rateCode);
                        setState(() {
                          dueAmountController.text!=''?
                          dueTotal_amount = int.parse(subTotalController.text) + int.parse(dueAmountController.text):
                          dueTotal_amount = int.parse(subTotalController.text) - 0;
                          // dueAmountController.text!=''?dueAmountController.text:dueAmountController.text ="0";
                          // grandTotalController.text = dueTotal_amount.toString();
                          print("amount::::${grandTotalController.text}");
                        });
                      },
                      style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly ,FilteringTextInputFormatter.singleLineFormatter],
                      decoration: InputDecoration(
                        hintText: 'Due Amount',
                        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
                        isDense: true,
                        counterText: '',
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                        hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),
                        errorStyle: const TextStyle(height: 1.5),
                        border: InputBorder.none,
                      ),
                    ),
                  )
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                  child: Text("Grand Total",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                child: CustomTextFieldEnabled(
                  controller: grandTotalController,
                  focusNode: grandTotalCode,
                  nextNode: null,
                  enabled: false,
                  hintText: "Grand Total",
                  isPhoneNumber: true,
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                ),
              ),
              _isLoading
                  ?
              const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG,))
                  :
              CustomButtonFuction(onTap: (){
                _addTempInvoice();
              }, buttonText: "Save"),
            ],
          ),
        );
      },),
    );
  }
  final Widget _verticalDivider = const VerticalDivider(
    color: Colors.black12,
    thickness: 1,
  );
}


class MyDataTableMerge extends StatefulWidget {
  String id,date,subTotal,dueAmount,grandTotal,totalGrand,type;
  int routeId,customerId;
  List<TempStock_Body> modelList;
  List<TempStockData> stockList;
  MyDataTableMerge(this.id,this.routeId,this.customerId,this.date,this.subTotal,this.dueAmount,this.grandTotal,this.totalGrand,this.type,this.modelList, this.stockList,{super.key});

  @override
  State<MyDataTableMerge> createState() => _MyDataTableMergeState();
}

class _MyDataTableMergeState extends State<MyDataTableMerge> {
  TempDb dbManager = new TempDb();
  TempStock_Body? model;
  List<TempStock_Body>? driverStockModel;
  List<TempStock_Body> modelList = new List.empty(growable: true);
  List<TempStockData> modelLists = new List.empty(growable: true);
  String? sameItem ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbManager.getStockList();
    // modelLists = Provider.of<TempInvoiceProvider>(context).tempStockList;
    setState(() {
      dbManager = TempDb();
      dbManager.getStockList().then((value) {
        setState(() {
          modelList.addAll(value);
          modelList = value;
          print("object:::table::${widget.subTotal}:::${widget.grandTotal}");
        });
      });
    });
    print("route::::4:${widget.routeId}:::::${widget.customerId}");
  }

  final Widget _verticalDivider = const VerticalDivider(
    color: Colors.black12,
    thickness: 1,
  );

  int? stock_amount;
  double grandTotal = 0.0;
  double grandTotalScore = 0.0;
  double subTotal = 0.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
          future: Future(() {
            dbManager.getStockList();
          }),
          builder: (context,snapshot) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: DataTable(
                dividerThickness: 1,
                columnSpacing: AppConstants.itemWidth*0.015,
                dataRowHeight: AppConstants.itemHeight*0.04,
                headingRowHeight: AppConstants.itemHeight*0.04,
                decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                columns: [
                  const DataColumn(label: SizedBox()),
                  DataColumn(label: _verticalDivider),
                  DataColumn(label: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(05),
                    child: Text('Name',
                        style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                  )),
                  DataColumn(label: _verticalDivider),
                  DataColumn(label: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(05),
                    child: Text('QTY',
                        style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                  )),
                  DataColumn(label: _verticalDivider),
                  DataColumn(label: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(05),
                    child: Text('Rate',
                        style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                  )),
                  DataColumn(label: _verticalDivider),
                  DataColumn(label: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(05),
                    child: Text('Amount',
                        style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                  )),
                ],
                rows: _buildRows(),
              ),
            );
          }
      ),
    );
  }
  List<TempStockData> tempList = [];
  int idToRemove = 0;
  TempStockData removedItem = TempStockData();

  List<DataRow> _buildRows() {
    List<DataRow> rows = [];

    TempStock_Body model;
    for(int i=0;i<modelList.length;i++) {
      model = modelList[i];
    }

    // Add rows from data1
    rows.addAll(modelList.map((item) {
      stock_amount = item.decRate! * item.decQty!;
      return DataRow(
        cells: [
          DataCell(GestureDetector(
            onTap: (){
              showDialog<bool>(
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text("Are You Sure You Want to Delete ?"),
                      contentTextStyle: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_16),
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              PreferenceUtils.remove('map');
                              grandTotal = double.parse(widget.subTotal) - int.parse(item.decAmount.toString());
                              subTotal = subTotal - grandTotal;
                              widget.subTotal = subTotal.round().toString();
                              widget.grandTotal = subTotal.round().toString();
                              print("route::::d:${widget.routeId}:::::${widget.customerId}");
                              dbManager.deleteStock(item).then((value) {
                                print("route::::d:${widget.routeId}:::::${widget.customerId}");
                                // MyDataTableMerge(widget.id,widget.routeId,widget.customerId,widget.date,widget.subTotal,widget.dueAmount,widget.grandTotal,grandTotal.round().toString(),"table",modelList,widget.stockList);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => EditTempInvoice(widget.id,widget.customerId,"",widget.routeId,widget.date,widget.subTotal,widget.dueAmount,widget.grandTotal,"","table",modelList),));
                              });
                              Navigator.pop(context);
                            });
                          },
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                          ),
                          child: Text('Yes',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                          ),
                          child: Text('No',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
                        ),
                      ],
                    );
                  },context: context);
            },
            child: Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(right: 10),
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                )),
          )),
          DataCell(Container(child: _verticalDivider)),
          DataCell(Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(05),
              child: Text(
                "${item.name}",
                style: poppinsBold.copyWith(
                    color: ColorResources.BLACK),
                textAlign: TextAlign.center,
              ))),
          DataCell(Container(child: _verticalDivider)),
          DataCell(Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(05),
              child: Text(
                "${item.decQty}",
                style: poppinsBold.copyWith(
                    color: ColorResources.BLACK),
                textAlign: TextAlign.center,
              ))),
          DataCell(Container(child: _verticalDivider)),
          DataCell(Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(05),
              child: Text(
                "\u20b9 ${item.decRate}",
                style: poppinsBold.copyWith(
                    color: ColorResources.BLACK),
                textAlign: TextAlign.center,
              ))),
          DataCell(Container(child: _verticalDivider)),
          DataCell(Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(05),
              child: Text(
                "\u20b9 $stock_amount",
                style: poppinsBold.copyWith(
                    color: ColorResources.BLACK),
                textAlign: TextAlign.center,
              ))),
        ],
      );
    }));

    // Add rows from data2
    rows.addAll(Provider.of<TempInvoiceProvider>(context).tempStockList.map((item) => DataRow(
      cells: [
        DataCell(GestureDetector(
        onTap: (){
          showDialog<bool>(
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: const Text("Are You Sure You Want to Delete ?"),
                  contentTextStyle: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_16),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          grandTotal = double.parse(widget.subTotal) - int.parse(item.decAmount!.round().toString());
                          grandTotalScore = subTotal - grandTotal;
                          widget.subTotal = subTotal.round().toString();
                          widget.grandTotal = subTotal.round().toString();
                          print("route::::d:${widget.routeId}:::::${widget.customerId}");
                          print("stock::d:$subTotal:::$grandTotalScore::$grandTotal:::::${item.decAmount!.round().toString()}");
                          print("stock::d1:$subTotal::${widget.subTotal}:::$grandTotal:::${widget.grandTotal}:::${widget.totalGrand}:::${item.decAmount!.round().toString()}");
                          Provider.of<TempInvoiceProvider>(context, listen: false).tempStockList.removeWhere((item) {
                            idToRemove = item.intid!;
                            print("removeId::$idToRemove");
                            if (item.intid == idToRemove) {
                              removedItem = item;
                              return true;
                            }
                            return false;
                          });
                          if (removedItem != null) {
                            tempList.add(removedItem);
                            print("tempList::::${tempList.length}");
                            // Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EditTempInvoice(widget.id,widget.customerId,"",widget.routeId,widget.date,widget.subTotal,widget.dueAmount,widget.grandTotal,grandTotal.round().toString(),"table",modelList),));
                          }

                          // Provider.of<TempInvoiceProvider>(context, listen: false).tempStockList.removeWhere(0);
                          // Provider.of<TempInvoiceProvider>(context).tempStockList.removeAt(item.intid!);
                          // widget.stockList.removeAt(item.intid!);
                          // Provider.of<TempInvoiceProvider>(context, listen: false).getDeleteTempStock(context,item.intid.toString()).then((value) {
                            print("route::::d:${widget.routeId}:::::${widget.customerId}");
                            // MyDataTableMerge(widget.id,widget.routeId,widget.customerId,widget.date,widget.subTotal,widget.dueAmount,widget.grandTotal,grandTotal.round().toString(),"table",modelList,widget.stockList);
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => EditTempInvoice(widget.id,widget.customerId,widget.routeId,widget.date,widget.subTotal,widget.dueAmount,widget.grandTotal,grandTotal.round().toString(),"table",modelList),));
                          // });
                        });
                      },
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                      ),
                      child: Text('Yes',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                      ),
                      child: Text('No',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
                    ),
                  ],
                );
              },context: context);
        },
        child: Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(right: 10),
            child: const Icon(
              Icons.delete,
              color: Colors.red,
            )),
      )),
        DataCell(Container(child: _verticalDivider)),
        DataCell(Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(05),
            child: Text(
              "${item.strItemName}",
              style: poppinsBold.copyWith(
                  color: ColorResources.BLACK),
              textAlign: TextAlign.center,
            ))),
        DataCell(Container(child: _verticalDivider)),
        DataCell(Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(05),
            child: Text(
              "${item.decQty!.round()}",
              style: poppinsBold.copyWith(
                  color: ColorResources.BLACK),
              textAlign: TextAlign.center,
            ))),
        DataCell(Container(child: _verticalDivider)),
        DataCell(Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(05),
            child: Text(
              "\u20b9 ${item.decRate!.round()}",
              style: poppinsBold.copyWith(
                  color: ColorResources.BLACK),
              textAlign: TextAlign.center,
            ))),
        DataCell(Container(child: _verticalDivider)),
        DataCell(Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(05),
            child: Text(
              "\u20b9 ${item.decAmount!.round()}",
              style: poppinsBold.copyWith(
                  color: ColorResources.BLACK),
              textAlign: TextAlign.center,
            ))),
      ],
    )));

    return rows;
  }
}


class CustomSearchableDropdown extends StatefulWidget {
  final List<SelectRouteData> items;
  final Function(SelectRouteData) onChanged;

  CustomSearchableDropdown({required this.items, required this.onChanged});

  @override
  _CustomSearchableDropdownState createState() =>
      _CustomSearchableDropdownState();
}

class _CustomSearchableDropdownState extends State<CustomSearchableDropdown> {
  SelectRouteData? selectedValue;

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<SelectRouteData>(
      textFieldConfiguration: const TextFieldConfiguration(
        decoration: InputDecoration(
          labelText: 'Select Route',
          border: OutlineInputBorder(),
        ),
      ),
      suggestionsCallback: (pattern) {
        return widget.items
            .where((driver) =>
            driver.strRoute!.toLowerCase().contains(pattern.toLowerCase()) ||
            driver.strRoute!.toUpperCase().contains(pattern.toUpperCase()))
            .toList();
      },
      itemBuilder: (context, suggestion) {
        return Text(suggestion.strRoute.toString());
      },
      onSuggestionSelected: (suggestion) {
        setState(() {
          selectedValue = suggestion;
        });
        widget.onChanged(suggestion);
      },
      noItemsFoundBuilder: (context) {
        return const SizedBox.shrink();
      },
    );
  }
}
