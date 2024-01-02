import 'dart:convert';
import 'dart:ui';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gas_accounting/data/model/body/add_tempinvoice.dart';
import 'package:gas_accounting/data/model/response/driver_response.dart';
import 'package:gas_accounting/helper/dataBase.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/route_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:gas_accounting/view/basewidget/custom_button.dart';
import 'package:gas_accounting/view/basewidget/custom_password_textfield.dart';
import 'package:gas_accounting/view/basewidget/custom_textfield.dart';
import 'package:gas_accounting/view/basewidget/no_internet_screen.dart';
import 'package:gas_accounting/view/screen/manage_invoice/invoice_list.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class AddInvoice extends StatefulWidget {
  String invoiceDate,dueDate,subTotal,discount,grandTotal,type;
  dynamic customerId;
  AddInvoice(this.customerId,this.invoiceDate,this.dueDate,this.subTotal,this.discount,this.grandTotal,this.type,{Key? key}) : super(key: key);

  @override
  State<AddInvoice> createState() => _AddInvoiceState();
}

class _AddInvoiceState extends State<AddInvoice> {
  TextEditingController companyController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController invoiceNumberController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController hsnCodeController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController subTotalController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController grandTotalController = TextEditingController();
  FocusNode companyCode = FocusNode();
  FocusNode dateCode = FocusNode();
  FocusNode invoiceNumberCode = FocusNode();
  FocusNode dueDateCode = FocusNode();
  FocusNode hsnCode = FocusNode();
  FocusNode qtyCode = FocusNode();
  FocusNode rateCode = FocusNode();
  FocusNode amountCode = FocusNode();
  FocusNode subTotalCode = FocusNode();
  FocusNode discountCode = FocusNode();
  FocusNode grandTotalCode = FocusNode();

  bool is_loading = true;
  bool _isLoading = false;
  late String formattedDate = '';
  late String date_shcedule = '';
  TimeOfDay selectedTime = TimeOfDay.now();
  dynamic dropdownValue ;
  String? customerName;
  dynamic itemDropdownValue ;
  String? itemsDropdownName ;
  String? itemsUnitName ;
  String? itemsDropdownPrice ;
  double totalScores = 0.0;
  int? total_amount;
  int? dueTotal_amount;
  int? stock_amount;

  InvoiceStockDb invoiceStockDb = new InvoiceStockDb();

  MainInvoiceStockBody? itemDetailsInvoiceModel;
  List<MainInvoiceStockBody> modelList=new List.empty(growable: true);

  void _datePicSchedule() {
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

  void _dueDatePicSchedule() {
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
        date_shcedule = DateFormat('dd/MM/yyyy').format(pickedDate);
        dueDateController.text = date_shcedule;
      });
    });
  }

  final Widget _verticalDivider = const VerticalDivider(
    color: Colors.black12,
    thickness: 1,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      total_amount = 0;
      invoiceStockDb = InvoiceStockDb();
      invoiceStockDb.getInvoiceStockList().then((value) {
        setState(() {
          modelList.addAll(value);
          modelList = value;
          for(int i=0;i<modelList.length;i++){
            print("widget:::${widget.grandTotal}");
            totalScores += double.parse(modelList[i].decAmount.toString());
            subTotalController.text = totalScores.round().toString();
            grandTotalController.text = totalScores.round().toString();
            print("widget:::$totalScores:::${widget.discount}");
          }
        });
      });
    });
    DateTime today = DateTime.now();
    formattedDate = DateFormat('dd/MM/yyyy').format(today);
    dateController.text = widget.type!="1"?formattedDate:widget.invoiceDate;
    dueDateController.text = widget.type!="1"?"":widget.dueDate;
    print("object::1c:::${widget.customerId}");
    _loadData(context, true);
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<RouteProvider>(context, listen: false).getDriverHelper(context,PreferenceUtils.getString("${AppConstants.companyId}"),"3").then((value) {
        setState(() {
          is_loading = false;
          for(int i=0;i<Provider.of<RouteProvider>(context, listen: false).driverList.length;i++){
            if (widget.customerId == Provider.of<RouteProvider>(context, listen: false).driverList[i].intId) {
              dropdownValue = widget.customerId;
              customerName = Provider.of<RouteProvider>(context, listen: false).driverList[i].srtFullName;
              print("object::1c:::${widget.customerId}");
              print("object::1c:::$dropdownValue:::$customerName");
            }
          }
        });
      });
      Provider.of<RouteProvider>(context, listen: false).getItemList(context,PreferenceUtils.getString("${AppConstants.companyId}"),'0','0');
    });
  }

  _addInvoice() async {
    if (dropdownValue == null) {
      AppConstants.getToast("Please Select Customer");
    }
    // else if (invoiceNumberController.text == '') {
    //   AppConstants.getToast("Please Enter Invoice Number");
    // }
    else if (modelList.isEmpty) {
      AppConstants.getToast("Please Add Item");
    }  else if (subTotalController.text == '') {
      AppConstants.getToast("Please Enter Sub Total");
    }
    // else if (discountController.text == '') {
    //   AppConstants.getToast("Please Enter Discount");
    // }
    else if (grandTotalController.text == '') {
      AppConstants.getToast("Please Enter Grand Total");
    }  else {
      setState(() {
        _isLoading = true;
      });
      print("model list:::::::::::${modelList.toList()}");
      var apiUrl = '${AppConstants.BASE_URL}${AppConstants.ADD_MAIN_INVOICE_URI}';
      var payload = {
        "intcustomerid": dropdownValue,
        "strInvoiceNo": invoiceNumberController.text,
        "dtInvoicedate": dateController.text,
        "dtDueDate": dueDateController.text,
        "decSubTotal": double.parse(subTotalController.text),
        "decDiscount": discountController.text,
        "decGrandTotal": double.parse(grandTotalController.text),
        "intCompanyId": int.parse(PreferenceUtils.getString("${AppConstants.companyId}")),
        "itemDetailsInvoiceModel": [
          for(int i=0; i< modelList.length; i++) {
            'strHSNCode': modelList[i].hashCode,
            'intitemid': modelList[i].intitemid,
            'decQty':modelList[i].decQty,
            'decRate': modelList[i].decRate,
            'decAmount': modelList[i].decAmount,
            'intcompanyid': int.parse(PreferenceUtils.getString("${AppConstants.companyId}")),
          }
        ]
      };

      var payloadJson = json.encode(payload);
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: payloadJson,
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        setState(() {
          _isLoading = false;
        });
        dropdownValue = null;
        invoiceStockDb.deleteAllInvoiceStock();
        _route();
        // AppConstants.getToast('Invoice Added Successfully');
        print("response::::$responseData");
      } else {
        AppConstants.getToast("Please Try After Sometime");
        print('Request failed with status: ${response.statusCode}');
      }
      AppConstants.closeKeyboard();
    }
  }

  _route(){
    dropdownValue = null;
    invoiceStockDb.deleteAllInvoiceStock();
    Navigator.push(context, MaterialPageRoute(builder: (context) => InvoiceList("","","","Invoice")));
    AppConstants.getToast('Invoice Added Successfully');
  }

  TextEditingController customerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        invoiceStockDb.deleteAllInvoiceStock();
        // widget.type == widget.type?
        // Navigator.pop(context):
        Navigator.push(context,MaterialPageRoute(builder: (context) => InvoiceList("","","","Invoice")));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorResources.LINE_BG,
          centerTitle: true,
          leading: IconButton(onPressed: () {
            invoiceStockDb.deleteAllInvoiceStock();
            // widget.type == "0"?
            // Navigator.pop(context):
            Navigator.push(context,MaterialPageRoute(builder: (context) => InvoiceList("","","","Invoice"),));
          }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
          title: Text("Add Invoice",style: montserratBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
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
                return Row(
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
                          cursorColor: ColorResources.LINE_BG,
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
                );
                //   SearchDropDown(
                //   key: singleSearchKey,
                //   listItems: customer.driverList.map((areaList) {
                //     // widget.type=="1"?customerName.toString():"";
                //     dropdownValue = areaList.intId;
                //     customerName = areaList.srtFullName;
                //     return ValueItem(label: areaList.srtFullName!,value: areaList.intId);
                //   }).toList(),
                //   confirmDelete: false,
                //   addMode: false,
                //   deleteMode: false,
                //   hint: 'Select Customer',
                //   hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.GREY),
                //   selectedItem: ValueItem(label: customerName.toString(),value: dropdownValue),
                //   onAddItem: (value ) {
                //     print("object ::$value");
                //   },
                //   backgroundColor: ColorResources.GREY.withOpacity(0.05),
                //   elevation: 0,
                //   dialogBackgroundColor: ColorResources.WHITE,
                //   selectedDialogColor: ColorResources.GREY.withOpacity(0.2),
                //   selectedInsideBoxTextStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                //   unselectedInsideBoxTextStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                //   updateSelectedItem: (valueItem) {
                //     customerName = valueItem!.label;
                //     dropdownValue = valueItem.value;
                //     print("customer ::${valueItem.value} :: ${valueItem.label}");
                //     print("customer ::$dropdownValue :: $customerName");
                //   },
                // );
              },),
            ),
            /*Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
              child: Consumer<RouteProvider>(builder: (context, customer, child) {
                return SearchDropDown(
                  key: singleSearchKey,
                  listItems: customer.driverList.map((areaList) {
                    widget.type=="1"?customerName.toString():"";
                    return ValueItem(label: areaList.srtFullName!,value: areaList.intId);
                  }).toList(),
                  confirmDelete: false,
                  addMode: false,
                  deleteMode: false,
                  hint: 'Select Customer',
                  hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.GREY),
                  selectedItem: ValueItem(label: widget.type=="1"?customerName.toString():"",value: dropdownValue),
                  onAddItem: (value ) {
                    print("object ::$value");
                  },
                  backgroundColor: ColorResources.GREY.withOpacity(0.05),
                  elevation: 0,
                  dialogBackgroundColor: ColorResources.WHITE,
                  selectedDialogColor: ColorResources.GREY.withOpacity(0.2),
                  selectedInsideBoxTextStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                  unselectedInsideBoxTextStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                  updateSelectedItem: (valueItem) {
                    customerName = valueItem!.label;
                    dropdownValue = valueItem.value;
                    print("customer ::${valueItem.value} :: ${valueItem.label}");
                    print("customer ::$dropdownValue :: $customerName");
                  },
                );
              },),
            ),*/
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
                _datePicSchedule();
                print("object:::$date_shcedule");
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                child: CustomDateTextField(
                  controller: dateController,
                  focusNode: dateCode,
                  nextNode: dueDateCode,
                ),
              ),
            ),
          /*  Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Text("Due Date",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
            GestureDetector(
              onTap: () {
                _dueDatePicSchedule();
                print("object:::$date_shcedule");
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                child: CustomTextFieldEnabled(
                  enabled: false,
                  controller: dueDateController,
                  hintText: "DD/MM/YYYY",
                  focusNode: dueDateCode,
                  nextNode: null,
                ),
              ),
            ),*/
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
                  child: CustomSearchableDropDown(
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
                        qtyController.clear();
                        itemDropdownValue = value;
                        Provider.of<RouteProvider>(context, listen: false).getItemList(context,PreferenceUtils.getString("${AppConstants.companyId}"),"$dropdownValue",'$itemDropdownValue').then((value) {
                          for(int i=0;i<item.itemList.length;i++){
                            if(item.itemList[i].intid == itemDropdownValue){
                              itemsDropdownName = item.itemList[i].itemName;
                              itemsUnitName = item.itemList[i].strName;
                              itemsDropdownPrice = item.itemList[i].decScale!.round().toString();
                              rateController.text = itemsDropdownPrice.toString();
                              print("name:::::$itemsDropdownName:::$itemsDropdownPrice");
                            }
                          }
                        });
                        print("itemId:::$value");
                      }
                      else{
                        itemDropdownValue = null;
                        print("object:::$value");
                      }
                    },
                  ),
                );
              },),
            ),
            /*Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
              child: CustomTextField(
                controller: hsnCodeController,
                focusNode: hsnCode,
                nextNode: qtyCode,
                hintText: "HSN Code",
                isPhoneNumber: false,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
            ),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                  child: Container(
                    width: AppConstants.itemWidth*0.28,
                    decoration: BoxDecoration(
                      color: ColorResources.GREY.withOpacity(0.05),
                      borderRadius:BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: qtyController,
                      maxLines: 1,
                      focusNode: qtyCode,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      cursorColor: ColorResources.LINE_BG,
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
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                  child: Container(
                    width: AppConstants.itemWidth*0.28,
                    decoration: BoxDecoration(
                      color: ColorResources.GREY.withOpacity(0.05),
                      borderRadius:BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: rateController,
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      focusNode: rateCode,
                      cursorColor: ColorResources.LINE_BG,
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
                  ),
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
              if (itemDropdownValue == null) {
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
                  hsnCodeController.clear();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddInvoice(dropdownValue,dateController.text,dueDateController.text,subTotalController.text,discountController.text,grandTotalController.text,"1"),));
                });
              } else if (amountController.text == '') {
                AppConstants.getToast('Please Enter Amount');
              }  else {
                setState(() {
                  bool doesItemExit = modelList.any((element) => element.name == itemsDropdownName);
                  if(!doesItemExit){
                    totalScores += double.parse(amountController.text.toString());
                    subTotalController.text = totalScores.round().toString();
                    grandTotalController.text = totalScores.round().toString();
                    itemDetailsInvoiceModel = MainInvoiceStockBody(
                        strHSNCode: hsnCodeController.text,
                        intitemid: itemDropdownValue,
                        name: itemsDropdownName.toString(),
                        strName: itemsUnitName.toString(),
                        decQty: int.parse(qtyController.text),
                        decRate: int.parse(rateController.text),
                        decAmount: int.parse(amountController.text),
                        intcompanyid : int.parse(PreferenceUtils.getString("${AppConstants.companyId}"))
                    );
                    invoiceStockDb.insertInvoiceStock(itemDetailsInvoiceModel!).then((value) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddInvoice(dropdownValue,dateController.text,dueDateController.text,subTotalController.text,discountController.text,grandTotalController.text,"1"),));
                    });
                    itemsDropdownName = null;
                    itemsUnitName = "";
                    qtyController.text = "";
                    rateController.text = "";
                    amountController.text= "";
                    hsnCodeController.clear();
                  }else{
                    itemsDropdownName = null;
                    itemsUnitName = "";
                    qtyController.text = "";
                    rateController.text = "";
                    amountController.text= "";
                    hsnCodeController.clear();
                    AppConstants.getToast("This Item is Already Added Please Add Different Item");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddInvoice(dropdownValue,dateController.text,dueDateController.text,subTotalController.text,discountController.text,grandTotalController.text,"1"),));
                  }
                  print("itemId:::::$itemDropdownValue::::$itemsDropdownName::::$dropdownValue");
                });
              }
            }, buttonText: "Add More Item"),
            /*FutureBuilder(
              future: invoiceStockDb.getInvoiceStockList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  modelList = snapshot.data as List<MainInvoiceStockBody>;
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
                          MainInvoiceStockBody model = modelList[index];
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
                                                    grandTotalController.text = totalScores.round().toString();
                                                    print("object::::$totalScores");
                                                    invoiceStockDb.deleteInvoiceStock(modelList[index]).then((value) {
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddInvoice(dropdownValue,dateController.text,dueDateController.text,subTotalController.text,discountController.text,grandTotalController.text,"1"),));
                                                    });
                                                    itemDropdownValue = "Select Item";
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
                                                  itemDropdownValue = "Select Item";
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
                                DataCell(_verticalDivider),
                                DataCell(Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.all(05),
                                    child: Text(
                                      "${model.name}",
                                      style: poppinsBold.copyWith(
                                          color: ColorResources.BLACK),
                                      textAlign: TextAlign.center,
                                    ))),
                                DataCell(_verticalDivider),
                                DataCell(Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.all(05),
                                    child: Text(
                                      "${model.decQty}",
                                      style: poppinsBold.copyWith(
                                          color: ColorResources.BLACK),
                                      textAlign: TextAlign.center,
                                    ))),
                                DataCell(_verticalDivider),
                                DataCell(Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.all(05),
                                    child: Text(
                                      "\u20b9 ${model.decRate}",
                                      style: poppinsBold.copyWith(
                                          color: ColorResources.BLACK),
                                      textAlign: TextAlign.center,
                                    ))),
                                DataCell(_verticalDivider),
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
                }
                return const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG));
              },
            ),*/
            FutureBuilder(
              future: invoiceStockDb.getInvoiceStockList(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  modelList = snapshot.data as List<MainInvoiceStockBody>;
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
                                      child: Text("${modelList[index].name}",maxLines:1,overflow: TextOverflow.visible,style: montserratBlack.copyWith(
                                          fontWeight: FontWeight.w600
                                      )),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: AppConstants.itemWidth*0.25,
                                  child: Text("Item Subtotal",style: montserratRegular.copyWith(
                                      fontWeight: FontWeight.w400
                                  )),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  alignment: Alignment.centerRight,
                                  width: AppConstants.itemWidth*0.30,
                                  child: Text("\u20b9 ${modelList[index].decAmount!.round()}",style: montserratBlack.copyWith(
                                      fontWeight: FontWeight.w600
                                  )),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  width: AppConstants.itemWidth*0.40,
                                  child: Text("${modelList[index].decQty!.round()} ${modelList[index].strName} x ${modelList[index].decRate!.round()} = \u20b9 ${modelList[index].decAmount!.round()}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: montserratRegular.copyWith(
                                          fontWeight: FontWeight.w400
                                      )),
                                )
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
                                                grandTotalController.text = totalScores.round().toString();
                                                print("object::::$totalScores");
                                                invoiceStockDb.deleteInvoiceStock(modelList[index]).then((value) {
                                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => AddInvoice(dropdownValue,dateController.text,dueDateController.text,subTotalController.text,discountController.text,grandTotalController.text,"1"),));
                                                });
                                                itemDropdownValue = "Select Item";
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
                                              itemDropdownValue = "Select Item";
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
                        /*Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.01,vertical: AppConstants.itemHeight*0.001),
                                      decoration: BoxDecoration(
                                          color: ColorResources.WHITE,
                                          border: Border.all(color: ColorResources.GREY.withOpacity(0.20)),
                                          borderRadius: BorderRadius.circular(05)
                                      ),
                                      child: Text("# ${index + 1}",style: montserratRegular.copyWith(fontSize: 13),),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: AppConstants.itemWidth*0.40,
                                      margin: EdgeInsets.only(left: AppConstants.itemWidth*0.01),
                                      child: Text("${modelList[index].name}",style: montserratBlack.copyWith(
                                        fontWeight: FontWeight.w600
                                      )),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      width: AppConstants.itemWidth*0.35,
                                      child: Text("\u20b9 ${modelList[index].decAmount}",style: montserratBlack.copyWith(
                                          fontWeight: FontWeight.w600
                                      )),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: AppConstants.itemWidth*0.40,
                                      child: Text("Item Subtotal",style: montserratRegular.copyWith(
                                          fontWeight: FontWeight.w400
                                      )),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      width: AppConstants.itemWidth*0.43,
                                      child: Text(" ${modelList[index].decQty} Qty x ${modelList[index].decRate} = \u20b9 ${modelList[index].decAmount}",style: montserratRegular.copyWith(
                                          fontWeight: FontWeight.w400
                                      )),
                                    )
                                  ],
                                ),
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
                                                grandTotalController.text = totalScores.round().toString();
                                                print("object::::$totalScores");
                                                invoiceStockDb.deleteInvoiceStock(modelList[index]).then((value) {
                                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => AddInvoice(dropdownValue,dateController.text,dueDateController.text,subTotalController.text,discountController.text,grandTotalController.text,"1"),));
                                                });
                                                itemDropdownValue = "Select Item";
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
                                              itemDropdownValue = "Select Item";
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
                        ),*/
                      );
                    },);
                }
              return const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG));
            },),
            const Divider(color: ColorResources.BLACK),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                        child: Text("Sub Total",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                      child: CustomTextFixWidthFieldEnabled(
                        controller: subTotalController,
                        focusNode: subTotalCode,
                        nextNode: discountCode,
                        hintText: "Sub Total",
                        isPhoneNumber: true,
                        enabled: false,
                        textInputType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                        child: Text("Discount",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                        child: Container(
                          width: AppConstants.itemWidth*0.28,
                          decoration: BoxDecoration(
                            color: ColorResources.GREY.withOpacity(0.05),
                            borderRadius:BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            controller: discountController,
                            maxLines: 1,
                            focusNode: discountCode,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            cursorColor: ColorResources.LINE_BG,
                            onTap: () {
                              setState(() {
                                discountController.text!=''?
                                dueTotal_amount = int.parse(subTotalController.text) - int.parse(discountController.text):
                                dueTotal_amount = int.parse(subTotalController.text) - 0;
                                discountController.text!=''?discountController.text:discountController.text ="0";
                                grandTotalController.text = dueTotal_amount.toString();
                                print("amount::::${grandTotalController.text}");
                              });
                            },
                            onChanged: (v) {
                              setState(() {
                                discountController.text!=''?
                                dueTotal_amount = int.parse(subTotalController.text) - int.parse(discountController.text):
                                dueTotal_amount = int.parse(subTotalController.text) - 0;
                                // discountController.text!=''?discountController.text:discountController.text ="0";
                                grandTotalController.text = dueTotal_amount.toString();
                                print("amount::::${grandTotalController.text}");
                              });
                            },
                            style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly ,FilteringTextInputFormatter.singleLineFormatter],
                            decoration: InputDecoration(
                              hintText: 'Discount',
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
                  ],
                ),
                Column(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                        child: Text("Grand Total",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                      child: CustomTextFixWidthFieldEnabled(
                        controller: grandTotalController,
                        focusNode: grandTotalCode,
                        nextNode: null,
                        hintText: "Grand Total",
                        isPhoneNumber: true,
                        textInputType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            _isLoading
                ?
            const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG,))
                :
            CustomButtonFuction(onTap: (){
             _addInvoice();
            }, buttonText: "Save"),
          ],
        ),
      ),
    );
  }
}