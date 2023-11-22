import 'dart:convert';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gas_accounting/data/model/body/add_tempinvoice.dart';
import 'package:gas_accounting/data/model/response/driver_response.dart';
import 'package:gas_accounting/data/model/response/selectroute.dart';
import 'package:gas_accounting/helper/dataBase.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/customer_provider.dart';
import 'package:gas_accounting/provider/route_provider.dart';
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

class AddTempInvoice extends StatefulWidget {
  String date,subTotal,grandTotal,online,cash,total,routeId;
  int id,type;
  double dueAmount;
  dynamic customerId;
  AddTempInvoice(this.date,this.subTotal,this.dueAmount,this.grandTotal,this.online,this.cash,this.total,this.customerId,this.routeId,this.id,this.type,{Key? key}) : super(key: key);

  @override
  State<AddTempInvoice> createState() => _AddTempInvoiceState();
}

class _AddTempInvoiceState extends State<AddTempInvoice> {
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

  String radioButtonItem = 'Online';
  int id = -1;
  bool is_loading = true;
  bool _isLoading = false;

  TempDb itemDbManager = new TempDb();

  TempStock_Body? itemDetailsInvoiceModel;
  List<TempStock_Body> modelList=new List.empty(growable: true);
  String rate = "",amount= "";
  String qty = "";
  int? total_amount;
  int? dueTotal_amount;
  int? stock_amount;
  String? stock_TotalAmount;
  double totalScores = 0.0;
  double dueAmount = 0.0;
  int? sub_amount;
  late String formattedDate = '';
  late String date_shcedule = '';
  TimeOfDay selectedTime = TimeOfDay.now();
  dynamic dropdownValue;
  String? customerName;
  dynamic itemdropdownValue ;
  String? itemsDropdownName ;
  String? itemsUnitName ;
  String? itemsDropdownPrice ;
  int? routeDropdownValue ;
  String? routeName;

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
    setState(() {
      total_amount = 0;
      // dropdownValue = widget.type == "search"? widget.id : null;
      print("id::::::${widget.id}");
      itemDbManager = TempDb();
      itemDbManager.getStockList().then((value) {
        setState(() {
          modelList.addAll(value);
          modelList = value;
          for(int i=0;i<modelList.length;i++){
            print("widget:::${widget.grandTotal}");
            totalScores += double.parse(modelList[i].decAmount.toString());
            subTotalController.text = totalScores.round().toString();
            dueAmountController.text = widget.dueAmount.toString();
            // dueAmount = totalScores + double.parse(dueAmountController.text);
            grandTotalController.text = totalScores.round().toString();
            print("widget:::$totalScores::$dueAmount");
          }
          print("object::::::4::$modelList");
        });
      });
    });
    // dueAmountController.text = "0";
    DateTime today = DateTime.now();
    formattedDate = DateFormat('dd/MM/yyyy').format(today);
    dateController.text = widget.type!=1?formattedDate:widget.date;
    _loadData(context, true);
  }


  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<RouteProvider>(context, listen: false).getRouteUserList(context,PreferenceUtils.getString("${AppConstants.companyId}"),"0","0").then((value) {
        setState(() {
          is_loading = false;
        });
      });
      Provider.of<RouteProvider>(context, listen: false).getSelectRoute(context,PreferenceUtils.getString("${AppConstants.companyId}")).then((value) {
        setState(() {
          is_loading = false;
          for(int k=0;k<Provider.of<RouteProvider>(context, listen: false).selectrouteList.length;k++){
            if (Provider.of<RouteProvider>(context, listen: false).selectrouteList[0].intId == Provider.of<RouteProvider>(context, listen: false).selectrouteList[k].intId) {
                print("object:::2::");
                routeDropdownValue = Provider.of<RouteProvider>(context, listen: false).selectrouteList[k].intId;
                routeName = Provider.of<RouteProvider>(context, listen: false).selectrouteList[k].strRoute.toString();
            }else if(int.parse(widget.routeId) == Provider.of<RouteProvider>(context, listen: false).selectrouteList[k].intId){
              print("object:::1::");
              routeDropdownValue = int.parse(widget.routeId);
              routeName = Provider.of<RouteProvider>(context, listen: false).selectrouteList[k].strRoute.toString();
            }else{
              print("object::::1:::$routeDropdownValue:::::$routeName");
            }
          }
        });
      });
      Provider.of<RouteProvider>(context, listen: false).getItemList(context,PreferenceUtils.getString("${AppConstants.companyId}"),'0','0').then((value) {
        setState(() {
          is_loading = false;
        });
      });
      Provider.of<RouteProvider>(context, listen: false).getDriverHelper(context,PreferenceUtils.getString("${AppConstants.companyId}"),"3").then((value) {
        setState(() {
          is_loading = false;
          for(int i=0;i<Provider.of<RouteProvider>(context, listen: false).driverList.length;i++){
            if (widget.customerId == Provider.of<RouteProvider>(context, listen: false).driverList[i].intId) {
              dropdownValue = widget.customerId;
              customerName = Provider.of<RouteProvider>(context, listen: false).driverList[i].srtFullName;
            }
          }
        });
      });
      Provider.of<CustomerProvider>(context, listen: false).getCustomerDueReport(context,PreferenceUtils.getString(AppConstants.companyId.toString())).then((value) {
        setState(() {
          is_loading = false;
          for(int i=0;i<Provider.of<CustomerProvider>(context, listen: false).customerDueReportList.length;i++){
            if(widget.customerId == Provider.of<CustomerProvider>(context, listen: false).customerDueReportList[i].intCustomerid){
              dueAmountController.text = Provider.of<CustomerProvider>(context, listen: false).customerDueReportList[i].decDueAmount!.round().toString();
            }
          }
        });
      });
    });
  }

  _addTempInvoice() async {
    if (routeDropdownValue==null) {
      AppConstants.getToast("Please Select Route");
    }  else if (dropdownValue==null) {
      AppConstants.getToast("Please Select Customer");
    } else if (dateController.text=='') {
      AppConstants.getToast("Please Select Date");
    }  else if (modelList.isEmpty) {
      AppConstants.getToast("Please Add Item");
    }  else if (subTotalController.text=='') {
      AppConstants.getToast("Please Enter Sub Total");
    }
   /* else if (dueAmountController.text=='') {
      AppConstants.getToast("Please Enter Due Amount");
    } */
    else if (grandTotalController.text=='') {
      AppConstants.getToast("Please Enter Grand Total");
    }
    /*else if (onlineController.text=='') {
      AppConstants.getToast("Please Enter Online");
    }  else if (cashController.text=='') {
      AppConstants.getToast("Please Enter Cash");
    }  else if (totalAmountController.text == '') {
      AppConstants.getToast("Please Enter Payment Total");
    }*/
    /*else if (subTotalController.text != grandTotalController.text) {
      AppConstants.getToast("Sub Total or Gran Total is Not Mach");
    } */
    else {
      setState(() {
        _isLoading = true;
      });
      print("model list:::::::::::${modelList.toList()}");
      var apiUrl = '${AppConstants.BASE_URL}${AppConstants.ADD_TEMP_INVOICE_URI}'; // Replace with your API endpoint

      var payload = {
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
      var payloadJson = json.encode(payload);
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: payloadJson,
      );
      print("send data :: $payloadJson");
      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        setState(() {
          _isLoading = false;
        });
        routeDropdownValue = null;
        dropdownValue = null;
        itemDbManager.deleteAllStock();
        if(responseData['data'] != null){
          _route();
          print("response:::: data ${responseData['data']}");
        }else{
          AppConstants.getToast("Please Try After Sometime");
          print("response:::: data ${responseData['error']}");
        }
        // _route();
        // AppConstants.getToast('Temp Invoice Added Successfully');
        print("response:::: data $responseData");
      } else {
        AppConstants.getToast("Please Try After Sometime");
        print('Request failed with status: ${response.statusCode}');
      }
      AppConstants.closeKeyboard();
    }
  }

  _route(){
    // if (isRoute) {
      routeDropdownValue = null;
      dropdownValue = null;
      itemDbManager.deleteAllStock();
      Navigator.push(context, MaterialPageRoute(builder: (context) => TempInvoiceList("","","Side"),));
      AppConstants.getToast('Temp Invoice Added Successfully');
    // }  else {
    //   AppConstants.getToast("Please Try After Sometime");
    // }
  }

  final Widget _verticalDivider = const VerticalDivider(
    color: Colors.black12,
    thickness: 1,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        itemDbManager.deleteAllStock();
        Navigator.push(context,MaterialPageRoute(builder: (context) => TempInvoiceList("","","Side"),));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorResources.LINE_BG,
          centerTitle: true,
          leading: IconButton(onPressed: () {
            itemDbManager.deleteAllStock();
            Navigator.push(context,MaterialPageRoute(builder: (context) => TempInvoiceList("","","Side"),));
          }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
          title: Text("Add Sale Invoice",style: montserratBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
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
                margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
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
                                routeDropdownValue = suggestion.intId;
                                routeController.text = routeName!;
                                print("customer name :::$routeName ::$routeDropdownValue");
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
                          print("object:::$value");
                        }
                        else{
                          routeDropdownValue = null;
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
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
                decoration: BoxDecoration(
                  color: ColorResources.GREY.withOpacity(0.05),
                  borderRadius:BorderRadius.circular(10),
                ),
                child: Consumer<RouteProvider>(builder: (context, customer, child) {
                  for(int k=0;k<Provider.of<RouteProvider>(context, listen: false).driverList.length;k++){
                    if (widget.id == Provider.of<RouteProvider>(context, listen: false).driverList[k].intId) {
                      dropdownValue = Provider.of<RouteProvider>(context, listen: false).driverList[k].intId;
                      customerName = Provider.of<RouteProvider>(context, listen: false).driverList[k].srtFullName.toString();
                    }
                  }
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
                                customerName = suggestion.srtFullName;
                                dropdownValue = suggestion.intId;
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
                   /* CustomSearchableDropDown(
                      menuPadding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.15),
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                      multiSelect: false,
                      dropDownMenuItems: customer.driverList.map((areaList) {
                        return areaList.srtFullName;
                      }).toList(),
                      dropdownItemStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                      label: customerName ?? 'Select Customer',
                      labelStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                      items : customer.driverList.map((areaList) {
                        return  areaList.intId;
                      }).toList(),
                      onChanged: (value){
                          dropdownValue = value;
                          Provider.of<RouteProvider>(context, listen: false).getItemList(context,PreferenceUtils.getString("${AppConstants.companyId}"),'$dropdownValue','$itemdropdownValue').then((value) {
                            Provider.of<CustomerProvider>(context, listen: false).getCustomerDueReport(context,PreferenceUtils.getString(AppConstants.companyId.toString())).then((value) {
                              for(int i=0;i<Provider.of<CustomerProvider>(context, listen: false).customerDueReportList.length;i++){
                                if(dropdownValue == Provider.of<CustomerProvider>(context, listen: false).customerDueReportList[i].intCustomerid){
                                  dueAmountController.text = Provider.of<CustomerProvider>(context, listen: false).customerDueReportList[i].decDueAmount!.round().toString();
                                }
                              }
                            });
                          });
                          print("customerId:::$value ::${dueAmountController.text}");
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
                    child:
                    CustomSearchableDropDown(
                      menuPadding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.15),
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                      multiSelect: false,
                      dropDownMenuItems: item.itemList.map((areaList) {
                        return areaList.itemName;
                      }).toList(),
                      dropdownItemStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                      label: 'Select Item',
                      labelStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                      items : item.itemList.map((areaList) {
                        return  areaList.intid;
                      }).toList(),
                      onChanged: (value){
                        if(value!=null)
                        {
                          itemdropdownValue = value;
                          Provider.of<RouteProvider>(context, listen: false).getItemList(context,PreferenceUtils.getString("${AppConstants.companyId}"),"$dropdownValue",'$itemdropdownValue').then((value) {
                            for(int i=0;i<item.itemList.length;i++){
                              if(item.itemList[i].intid == itemdropdownValue){
                                itemsDropdownName = item.itemList[i].itemName;
                                itemsUnitName = item.itemList[i].strName;
                                itemsDropdownPrice = item.itemList[i].decScale!.round().toString();
                                rateController.text = itemsDropdownPrice.toString();
                                print("name:::::$itemsDropdownName::$itemsDropdownPrice");
                              }
                            }
                          });
                          print("itemId:::$value");
                        }
                        else{
                          itemdropdownValue = null;
                          print("object:::$value");
                        }
                      },
                    ),
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
                          onTap: () {
                            setState(() {
                              total_amount = int.parse(qtyController.text) * int.parse(rateController.text);
                              amountController.text = total_amount.toString();
                              print("amount::::${amountController.text}");
                            });
                          },
                          onChanged: (v) {
                            // FocusScope.of(context).requestFocus(qtyCode);
                            setState(() {
                              total_amount = int.parse(qtyController.text) * int.parse(rateController.text);
                              amountController.text = total_amount.toString();
                              print("amount::::${amountController.text}");
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
                      child: Container(
                        width: AppConstants.itemWidth*0.28,
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: ColorResources.GREY.withOpacity(0.05),
                          borderRadius:BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: rateController,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          focusNode: rateCode,
                          onTap: () {
                            setState(() {
                              total_amount = int.parse(qtyController.text) * int.parse(rateController.text);
                              amountController.text = total_amount.toString();
                              print("amount::::${amountController.text}");
                            });
                          },
                          onChanged: (v) {
                            // FocusScope.of(context).requestFocus(qtyCode);
                            setState(() {
                              total_amount = int.parse(qtyController.text) * int.parse(rateController.text);
                              amountController.text = total_amount.toString();
                              print("amount::::${amountController.text}");
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
              CustomButtonFuction(onTap: () {
                if (itemdropdownValue == null) {
                  AppConstants.getToast("Please Select Item");
                } else if (qtyController.text=='') {
                  AppConstants.getToast('Please Enter Qty');
                } else if (rateController.text == '0'){
                  AppConstants.getToast('Rate Is Not Valid');
                  setState(() {
                    itemsDropdownName = '';
                    qtyController.clear();
                    rateController.clear();
                    amountController.clear();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddTempInvoice(
                        dateController.text,
                        subTotalController.text,
                        double.parse(dueAmountController.text),
                        grandTotalController.text,
                        onlineController.text,
                        cashController.text,
                        totalAmountController.text,
                        dropdownValue,routeDropdownValue.toString(),0,1),));
                  });
                } else if (amountController.text == '') {
                  AppConstants.getToast('Please Enter Amount');
                }  else {
                  setState(() {
                    bool doesItemExit = modelList.any((element) => element.name == itemsDropdownName);
                    if (!doesItemExit) {
                      totalScores += double.parse(amountController.text.toString());
                      subTotalController.text = totalScores.round().toString();
                      grandTotalController.text = totalScores.round().toString();
                      itemDetailsInvoiceModel = TempStock_Body(
                          intItemsDetails: itemdropdownValue,
                          name: itemsDropdownName.toString(),
                          strName: itemsUnitName.toString(),
                          decQty: int.parse(qtyController.text),
                          decRate: int.parse(rateController.text),
                          decAmount: int.parse(amountController.text)
                      );
                      print("due ::${dueAmountController.text}");
                      itemDbManager.insertStock(itemDetailsInvoiceModel!).then((value){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddTempInvoice(dateController.text,subTotalController.text,
                            dueAmountController.text == "" ? 0.0 :double.parse(dueAmountController.text),
                            grandTotalController.text,
                            onlineController.text,
                            cashController.text,
                            totalAmountController.text,dropdownValue,routeDropdownValue.toString(),0,1),));
                      });
                      itemsDropdownName = null;
                      qtyController.text = "";
                      rateController.text = "";
                      amountController.text= "";
                    }else{
                      itemsDropdownName = null;
                      qtyController.text = "";
                      rateController.text = "";
                      amountController.text= "";
                      AppConstants.getToast("This Item is Already Added Please Add Different Item");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddTempInvoice(dateController.text,subTotalController.text,
                          double.parse(dueAmountController.text),
                          grandTotalController.text,
                          onlineController.text,
                          cashController.text,
                          totalAmountController.text,dropdownValue,routeDropdownValue.toString(),0,1),));
                    }
                    print("itemId:::::$itemdropdownValue::::$itemsDropdownName::::$dropdownValue");
                  });
                }
              }, buttonText: "Add More Item"),
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
                                                      totalScores = double.parse(subTotalController.text) - int.parse(modelList[index].decAmount.toString());
                                                      subTotalController.text = totalScores.round().toString();
                                                      // dueAmount = totalScores + double.parse(dueAmountController.text);
                                                      grandTotalController.text = totalScores.round().toString();
                                                      print("object::::$totalScores");
                                                      itemDbManager.deleteStock(modelList[index]);
                                                      itemdropdownValue = "Select Item";
                                                      itemsDropdownName = "";
                                                      qtyController.text = "";
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
                  },
              ),
              /*FutureBuilder(
                future: itemDbManager.getStockList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    modelList = snapshot.data as List<TempStock_Body>;
                    return
                      modelList.isEmpty
                          ?
                      const SizedBox()
                          :
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: DataTable(
                          dividerThickness: 1,
                          columnSpacing: AppConstants.itemWidth*0.015,
                          dataRowHeight: AppConstants.itemHeight*0.04,
                          headingRowHeight: AppConstants.itemHeight*0.04,
                          decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                          columns: [
                            DataColumn(label: SizedBox()),
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
                          rows: List.generate(modelList.length, (index) {
                            TempStock_Body model = modelList[index];
                            model = modelList[index];
                            stock_amount = model.decRate! * model.decQty!;
                            print("stockAMount::::$stock_amount");
                            return DataRow(
                                cells: <DataCell>[
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
                                                      totalScores = double.parse(subTotalController.text) - int.parse(model.decAmount.toString());
                                                      subTotalController.text = totalScores.round().toString();
                                                      dueAmount = totalScores + double.parse(dueAmountController.text);
                                                      grandTotalController.text = dueAmount.round().toString();
                                                      print("object::::$totalScores");
                                                      itemDbManager.deleteStock(modelList[index]);
                                                      itemdropdownValue = "Select Item";
                                                      itemsDropdownName = "";
                                                      qtyController.text = "";
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
                                        "${model.name}",
                                        style: poppinsBold.copyWith(
                                            color: ColorResources.BLACK),
                                        textAlign: TextAlign.center,
                                      ))),
                                  DataCell(Container(child: _verticalDivider)),
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.all(05),
                                      child: Text(
                                        "${model.decQty}",
                                        style: poppinsBold.copyWith(
                                            color: ColorResources.BLACK),
                                        textAlign: TextAlign.center,
                                      ))),
                                  DataCell(Container(child: _verticalDivider)),
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.all(05),
                                      child: Text(
                                        "\u20b9 ${model.decRate}",
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
                                ]
                            );
                          }),
                        ),
                      );
                    */
              /*return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: modelList.length,
                      itemBuilder: (context, index) {
                        TempStock_Body _model = modelList[index];
                        itemDetailsInvoiceModel = modelList[index];
                        stock_amount = _model.decRate! * _model.decQty!;
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: AppConstants.itemWidth*0.70,
                                      child: Text(
                                        'Name: ${_model.name}',
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    Text(
                                      'Quantity: ${_model.decQty}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      'Amount: \u20b9 $stock_amount',
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                        onPressed: (){
                                          setState(() {
                                            totalScores = double.parse(subTotalController.text) - int.parse(_model.decAmount.toString());
                                            subTotalController.text = totalScores.round().toString();
                                            grandTotalController.text = totalScores.round().toString();
                                            print("object::::$totalScores");
                                            itemDbManager.deleteStock(modelList[index]);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );*/
              /*
                  }
                  return const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG));
                },
              ),*/
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
                      onTap: () {
                        setState(() {
                          dueAmountController.text!=''?
                          dueTotal_amount = int.parse(subTotalController.text) + int.parse(dueAmountController.text):
                          dueTotal_amount = int.parse(subTotalController.text) - 0;
                          dueAmountController.text!=''?dueAmountController.text:dueAmountController.text ="0";
                          // grandTotalController.text = dueTotal_amount.toString();
                          print("amount::::${grandTotalController.text}");
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
              const Divider(color: ColorResources.BLACK),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Text("Payment Detail",style: montserratBold.copyWith(color: ColorResources.BLACK)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    height: AppConstants.itemHeight*0.06,
                    width: AppConstants.itemWidth*0.45,
                    margin: EdgeInsets.only(left: AppConstants.itemWidth*0.01,top: AppConstants.itemHeight*0.01),
                    decoration: BoxDecoration(
                      color: ColorResources.GREY.withOpacity(0.05),
                      borderRadius:BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: onlineController,
                      maxLines: 1,
                      focusNode: onlineCode,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      onTap: () {
                        setState(() {
                          cashController.text!=''?
                          sub_amount = int.parse(onlineController.text) + int.parse(cashController.text):
                          sub_amount = int.parse(onlineController.text) - 0;
                          cashController.text!=''?cashController.text:cashController.text ="0";
                          totalAmountController.text = sub_amount.toString();
                          print("amount:::0:${totalAmountController.text}");
                        });
                      },
                      onFieldSubmitted: (v) {
                        setState(() {
                          cashController.text!=''?
                          sub_amount = int.parse(onlineController.text) + int.parse(cashController.text):
                          sub_amount = int.parse(onlineController.text) - 0;
                          cashController.text!=''?cashController.text:cashController.text ="0";
                          totalAmountController.text = sub_amount.toString();
                          print("amount::1::${totalAmountController.text}");
                        });
                      },
                      style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly ,FilteringTextInputFormatter.singleLineFormatter],
                      decoration: InputDecoration(
                        hintText: 'Online',
                        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
                        isDense: true,
                        counterText: '',
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                        hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),
                        errorStyle: const TextStyle(height: 1.5),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: AppConstants.itemHeight*0.06,
                    width: AppConstants.itemWidth*0.45,
                    margin: EdgeInsets.only(left: AppConstants.itemWidth*0.01,top: AppConstants.itemHeight*0.01),
                    decoration: BoxDecoration(
                      color: ColorResources.GREY.withOpacity(0.05),
                      borderRadius:BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: cashController,
                      maxLines: 1,
                      focusNode: cashCode,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      textAlign: TextAlign.start,
                      onTap: () {
                        setState(() {
                          onlineController.text!=''?
                          sub_amount = int.parse(cashController.text) + int.parse(onlineController.text):
                          sub_amount = int.parse(cashController.text) - 0;
                          onlineController.text!=''?onlineController.text:onlineController.text ="0";
                          totalAmountController.text = sub_amount.toString();
                          print("amount::0::${totalAmountController.text}");
                        });
                      },
                      onChanged: (v) {
                        setState(() {
                          onlineController.text!=''?
                          sub_amount = int.parse(cashController.text) + int.parse(onlineController.text):
                          sub_amount = int.parse(cashController.text) - 0;
                          onlineController.text!=''?onlineController.text:onlineController.text ="0";
                          totalAmountController.text = sub_amount.toString();
                          print("amount::1::${totalAmountController.text}");
                        });
                      },
                      style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly ,FilteringTextInputFormatter.singleLineFormatter],
                      decoration: InputDecoration(
                        hintText: 'Cash',
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
                ],
              ),
              SizedBox(height: AppConstants.itemHeight*0.01),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                  child: Text("Payment Total",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                child: CustomTextFieldEnabled(
                  controller: totalAmountController,
                  focusNode: totalAmountCode,
                  nextNode: null,
                  enabled: false,
                  hintText: "Payment Total",
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
      ),
    );
  }
}


