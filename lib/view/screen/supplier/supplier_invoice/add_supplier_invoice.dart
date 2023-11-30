// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_accounting/data/model/body/add_tempinvoice.dart';
import 'package:gas_accounting/data/model/body/supplier_body.dart';
import 'package:gas_accounting/helper/dataBase.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/supplier_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/images.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/custom_button.dart';
import 'package:gas_accounting/view/basewidget/custom_password_textfield.dart';
import 'package:gas_accounting/view/basewidget/custom_textfield.dart';
import 'package:gas_accounting/view/screen/supplier/supplier_invoice/supplier_invoice_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AddSupplierInvoice extends StatefulWidget {
  int supplierId;
  String invoiceNo,invoiceDate,dueDate,type;
  bool isGST;
  AddSupplierInvoice(this.supplierId, this.invoiceNo, this.invoiceDate, this.dueDate, this.isGST,this.type,{super.key});

  @override
  State<AddSupplierInvoice> createState() => _AddSupplierInvoiceState();
}

class _AddSupplierInvoiceState extends State<AddSupplierInvoice> {
  TextEditingController invoiceController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController hsnCodeController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController subTotalController = TextEditingController();
  TextEditingController cgstController = TextEditingController();
  TextEditingController sgstController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController grandTotalController = TextEditingController();
  TextEditingController memoController = TextEditingController();
  FocusNode invoiceCode = FocusNode();
  FocusNode dateCode = FocusNode();
  FocusNode dueDateCode = FocusNode();
  FocusNode hsnCode = FocusNode();
  FocusNode qtyCode = FocusNode();
  FocusNode rateCode = FocusNode();
  FocusNode amountCode = FocusNode();
  FocusNode subTotalCode = FocusNode();
  FocusNode cgstCode = FocusNode();
  FocusNode sgstCode = FocusNode();
  FocusNode discountCode = FocusNode();
  FocusNode grandTotalCode = FocusNode();
  FocusNode memoCode = FocusNode();

  bool isLoading = true;
  bool isLoad = false;
  bool includeGST = false;
  int inGST = 0;
  double cgst = 0.0;
  double sgst = 0.0;
  late String formattedDate = '';
  late String dateSchedule = '';
  TimeOfDay selectedTime = TimeOfDay.now();
  dynamic supplierDropDown;
  String? supplierName = "";
  dynamic itemDropDown;
  String itemName = "";
  String itemUnitName = "";
  InvoiceStockDb itemDB = InvoiceStockDb();
  MainInvoiceStockBody? itemDetailsInvoiceModel;
  List<MainInvoiceStockBody> modelList = [];

  double? dueTotalAmount,gstAmount,cgstAmount,sgstAmount;
  int stockAmount = 0;
  double itemGrandTotal = 0.0;
  double totalAmount = 0.0;

  File imageFile = File('');
  String imageName = '';
  File profileImageFile = File('');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime today = DateTime.now();
    formattedDate = DateFormat('dd/MM/yyyy').format(today);
    dateController.text = widget.type == "New" ? formattedDate : widget.invoiceDate;
    dueDateController.text = widget.type == "New" ? "" : widget.dueDate;
    invoiceController.text = widget.type == "New" ? "" : widget.invoiceNo;
    includeGST = widget.type == "New" ? false : widget.isGST;
    setState(() {
      // totalAmount = 0.0;
      itemDB = InvoiceStockDb();
      itemDB.getInvoiceStockList().then((value) {
        setState(() {
          modelList.addAll(value);
          modelList = value;
          if (includeGST != false) {
            for(int i=0;i<modelList.length;i++){
              totalAmount += double.parse(modelList[i].decAmount.toString());
              subTotalController.text = totalAmount.round().toString();
              cgstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text)* cgst / 100.0;
              sgstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text)* sgst / 100.0;
              cgstController.text = cgstAmount.toString();
              sgstController.text = sgstAmount.toString();
              gstAmount = cgstAmount! + sgstAmount! + totalAmount;
              grandTotalController.text = gstAmount!.toStringAsFixed(2);
            }
          }else{
            for(int i=0;i<modelList.length;i++){
              totalAmount += double.parse(modelList[i].decAmount.toString());
              subTotalController.text = totalAmount.round().toString();
              grandTotalController.text = totalAmount.round().toString();
            }
          }
          print("itemList :: $totalAmount :: ${subTotalController.text} :: ${grandTotalController.text} :: $gstAmount");
        });
      });
    });
    print("widget data :: ${widget.isGST} :: ${widget.supplierId} :: ${widget.invoiceNo} :: ${widget.invoiceDate} :: ${widget.dueDate} :: ${widget.type}");
    _loadData(context, true);
  }

  void _datePickSchedule() {
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

  void _dueDatePickSchedule() {
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
        dateSchedule = DateFormat('dd/MM/yyyy').format(pickedDate);
        dueDateController.text = dateSchedule;
      });
    });
  }

  Future filePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'docx', 'png', 'txt'],
    );
    File? file = File(profileImageFile.path);

    print("image:::${profileImageFile.path}");
    if (result != null) {
      setState(() {
        imageFile = File("${result.files[0].path}");
        imageName = result.files[0].name;
        print("object:::${result.files[0].path}");
      });
      print('Image file Path:::::::::${imageFile.path}');
    }
    return file;
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<SupplierProvider>(context, listen: false).getSupplierList(context,PreferenceUtils.getString("${AppConstants.companyId}")).then((value) {
        setState(() {
          isLoading = false;
          for(int i=0;i<Provider.of<SupplierProvider>(context, listen: false).supplierList.length;i++){
            if(widget.supplierId == Provider.of<SupplierProvider>(context, listen: false).supplierList[i].intid){
              supplierDropDown = widget.supplierId;
              supplierName = "${Provider.of<SupplierProvider>(context, listen: false).supplierList[i].strCompanyName} (${Provider.of<SupplierProvider>(context, listen: false).supplierList[i].strContactPersonName})";
              print("widget supplier :: $supplierName :: $supplierDropDown");
            }
          }
        });
      });
      Provider.of<SupplierProvider>(context, listen: false).getSupplierTax(context, "25").then((value){
        setState(() {
          isLoading = false;
          for(int i=0;i<Provider.of<SupplierProvider>(context, listen: false).supplierSGST.length;i++){
            sgst = double.parse(Provider.of<SupplierProvider>(context, listen: false).supplierSGST[i].strValue.toString());
          }
        });
      });
      Provider.of<SupplierProvider>(context, listen: false).getSupplierTax(context, "26").then((value){
        setState(() {
          isLoading = false;
          for(int i=0;i<Provider.of<SupplierProvider>(context, listen: false).supplierCGST.length;i++){
            cgst = double.parse(Provider.of<SupplierProvider>(context, listen: false).supplierCGST[i].strValue.toString());
          }
        });
      });
      Provider.of<SupplierProvider>(context, listen: false).getSupplierItemSelectList(context,'0','0',PreferenceUtils.getString("${AppConstants.companyId}")).then((value) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  addInvoice() async {
    if(supplierDropDown == null){
      AppConstants.getToast("Please Select Supplier");
    }else if(dateController.text == ""){
      AppConstants.getToast("Please Select Invoice Date");
    }else if (modelList.isEmpty) {
      AppConstants.getToast("Please Add Item");
    }else{
      setState(() {
        isLoad = true;
      });

      var request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.ADD_SUPPLIER_INVOICE_URI}'));
      //for token
      request.headers.addAll({"Authorization": "Bearer token"});

      request.fields['intCompanyId'] = PreferenceUtils.getString(AppConstants.companyId.toString());
      request.fields['intSupplierId'] = supplierDropDown.toString();
      request.fields['strInvoiceNo'] = invoiceController.text;
      request.fields['strInvoiceDate'] = dateController.text;
      request.fields['strDueDate'] = dueDateController.text;
      request.fields['decTotal'] = subTotalController.text;
      request.fields['decDiscount'] = discountController.text == "" ? "0" : discountController.text;
      request.fields['decGrandTotal'] = grandTotalController.text;
      request.fields['intCreatedBy'] = PreferenceUtils.getString(AppConstants.companyId.toString());
      request.fields['bIsIncludeGST'] = includeGST.toString();
      request.fields['decCGSTTax'] = includeGST != false ? cgstController.text : "0";
      request.fields['decSGSTTax'] = includeGST != false ? sgstController.text : "0";
      request.fields['strMemo'] = memoController.text;
      var bytes = (await rootBundle.load(Images.noImage)).buffer.asUint8List();

      imageFile.path == ''
          ?
      request.files.add(http.MultipartFile.fromBytes("strFilePath", bytes, filename: Images.noImage))
          :
      request.files.add(await http.MultipartFile.fromPath("strFilePath", imageFile.path));

      var response = await request.send();
      var responseDecode = await http.Response.fromStream(response);
      final responseData = json.decode(responseDecode.body);
      setState(() {
        isLoad = false;
      });

      if(response.statusCode == 200){
        print("SUCCESS :: ${responseData['data']['intid']}");
        for(int i=0;i<modelList.length;i++){
          Item_Body item_body = Item_Body(
            intInvoiceid: responseData['data']['intid'],
            itemid: modelList[i].intitemid,
            strHsnCode: modelList[i].strHSNCode,
            intQty: modelList[i].decQty,
            decPrice: modelList[i].decRate,
            decTotalAmount: modelList[i].decAmount,
            intCompanyid: modelList[i].intcompanyid
          );
          _route(item_body);
        }
        // AppConstants.getToast("Supplier Invoice Added Successfully");
        print("response:::$responseData");
      }else {
        AppConstants.getToast("Please Try After Sometime");
        print("ERROR");
      }
    }
  }

  _route(Item_Body itemBody){
    Provider.of<SupplierProvider>(context, listen: false).getAddSupplierItem(context,itemBody);
    AppConstants.getToast("Supplier Invoice Added Successfully");
    itemDB.deleteAllInvoiceStock();
    Navigator.push(context, MaterialPageRoute(builder: (context) => SupplierInvoiceList("","","","SupplierInvoice"),));
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        itemDB.deleteAllInvoiceStock();
        Navigator.push(context,MaterialPageRoute(builder: (context) => SupplierInvoiceList("","","","SupplierInvoice")));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorResources.LINE_BG,
          centerTitle: true,
          leading: IconButton(onPressed: () {
            itemDB.deleteAllInvoiceStock();
            Navigator.push(context,MaterialPageRoute(builder: (context) => SupplierInvoiceList("","","","SupplierInvoice")));
          }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25)),
          title: Text("Add Supplier Invoice",style: montserratSemiBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
        ),
        body:
        isLoading
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
                    Text("Supplier",style: montserratBold.copyWith(color: ColorResources.BLACK),),
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
              child: Consumer<SupplierProvider>(builder: (context, supplier, child) {
                return DropdownButtonHideUnderline(
                    child: CustomSearchableDropDown(
                      menuPadding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.15),
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                      multiSelect: false,
                      dropDownMenuItems: supplier.supplierList.map((areaList) {
                        // supplierName = '${areaList.strCompanyName} (${areaList.strContactPersonName})';
                        return "${areaList.strCompanyName} (${areaList.strContactPersonName})";
                      }).toList(),
                      dropdownItemStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                      label: supplierName == ""? 'Select Supplier' : supplierName,
                      labelStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                      items : supplier.supplierList.map((areaList) {
                        return  areaList.intid;
                      }).toList(),
                      onChanged: (value){
                        supplierDropDown = value;
                        Provider.of<SupplierProvider>(context, listen: false).getSupplierItemSelectList(context,'$itemDropDown','$supplierDropDown',PreferenceUtils.getString("${AppConstants.companyId}"));
                        print("supplier ::$value");
                      },
                    )
                );
              },),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Row(
                  children: [
                    Text("Invoice No.",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                    // Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                  ],
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
              child: CustomTextField(
                controller: invoiceController,
                focusNode: invoiceCode,
                nextNode: dateCode,
                hintText: "Invoice No.",
                isPhoneNumber: true,
                textInputType: TextInputType.phone,
                textInputAction: TextInputAction.done,
              ),
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
                _datePickSchedule();
                print("object:::$dateSchedule");
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                child: CustomDateTextField(
                  controller: dateController,
                  focusNode: dateCode,
                  nextNode: dueDateCode,
                  // hintTxt: "DD/MM/YYYY",
                ),
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Text("Due Date",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
            GestureDetector(
              onTap: () {
                _dueDatePickSchedule();
                print("due date:::$dateSchedule");
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
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
              child: Text("Item Detail",style: montserratBold.copyWith(color: ColorResources.BLACK)),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
              decoration: BoxDecoration(
                color: ColorResources.GREY.withOpacity(0.05),
                borderRadius:BorderRadius.circular(10),
              ),
              child: Consumer<SupplierProvider>(builder: (context, item, child) {
                return DropdownButtonHideUnderline(
                    child: CustomSearchableDropDown(
                      menuPadding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.15),
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                      multiSelect: false,
                      dropDownMenuItems: item.supplierSelectItemList.map((areaList) {
                        return areaList.strItemname;
                      }).toList(),
                      dropdownItemStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                      label: itemName==""?"Select Item":itemName,
                      labelStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                      items : item.supplierSelectItemList.map((areaList) {
                        return  areaList.intid;
                      }).toList(),
                      onChanged: (value){
                        if(value!=null) {
                          itemDropDown = value;
                          Provider.of<SupplierProvider>(context, listen: false).getSupplierItemSelectList(context,'$itemDropDown','$supplierDropDown',PreferenceUtils.getString("${AppConstants.companyId}")).then((value) {
                            for(int i=0;i<item.supplierSelectItemList.length;i++){
                              if (item.supplierSelectItemList[i].intid == itemDropDown) {
                                itemName = item.supplierSelectItemList[i].strItemname.toString();
                                itemUnitName = item.supplierSelectItemList[i].strUnitName.toString();
                                rateController.text = item.supplierSelectItemList[i].decrate!.round().toString();
                                print("item::::: $itemDropDown :: $itemName :: ${rateController.text}");
                              }
                            }
                          });
                          print("selectItem::: $value");
                        } else{
                          itemDropDown = 0;
                          print("selectItem:$value");
                        }
                      },
                    )
                );
              },),
            ),
            Padding(
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
            ),
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
                          totalAmount = double.parse(qtyController.text) * int.parse(rateController.text);
                          amountController.text = totalAmount.round().toString();
                          cgstAmount = totalAmount* cgst / 100.0;
                          sgstAmount = totalAmount* sgst / 100.0;
                          gstAmount = cgstAmount! + sgstAmount!;
                          cgstController.text = cgstAmount.toString();
                          sgstController.text = sgstAmount.toString();
                          print("amount::::${amountController.text}:: $gstAmount");
                        });
                      },
                      onChanged: (v) {
                        setState(() {
                          totalAmount = double.parse(qtyController.text) * int.parse(rateController.text);
                          amountController.text = totalAmount.round().toString();
                          cgstAmount = totalAmount* cgst / 100.0;
                          sgstAmount = totalAmount* sgst / 100.0;
                          gstAmount = cgstAmount! + sgstAmount!;
                          cgstController.text = cgstAmount.toString();
                          sgstController.text = sgstAmount.toString();
                          print("amount::::${amountController.text}:: $gstAmount");
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
                          totalAmount = double.parse(qtyController.text) * int.parse(rateController.text);
                          amountController.text = totalAmount.round().toString();
                          cgstAmount = totalAmount* cgst / 100.0;
                          sgstAmount = totalAmount* sgst / 100.0;
                          gstAmount = cgstAmount! + sgstAmount!;
                          cgstController.text = cgstAmount.toString();
                          sgstController.text = sgstAmount.toString();
                          print("amount::::${amountController.text}:::${sgstController.text}");
                        });
                      },
                      onChanged: (v) {
                        setState(() {
                          totalAmount = double.parse(qtyController.text) * int.parse(rateController.text);
                          amountController.text = totalAmount.round().toString();
                          cgstAmount = totalAmount* cgst / 100.0;
                          sgstAmount = totalAmount* sgst / 100.0;
                          gstAmount = cgstAmount! + sgstAmount!;
                          cgstController.text = cgstAmount.toString();
                          sgstController.text = sgstAmount.toString();
                          print("amount::::${amountController.text}:::${sgstController.text}");
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
            CustomButtonFuction(
                onTap: (){
                  if(itemDropDown == 0){
                    AppConstants.getToast("Please Select Item");
                  }else if(qtyController.text == ""){
                    AppConstants.getToast("Please Enter Item QTY");
                  }else if(rateController.text == "0"){
                    AppConstants.getToast("Rate Is Not Valid");
                    setState(() {
                      itemDropDown = 0;
                      itemName = "";
                      qtyController.clear();
                      rateController.clear();
                      amountController.clear();
                    });
                  }else if(amountController.text == '') {
                    AppConstants.getToast('Please Enter Amount');
                  }else {
                    setState(() {
                      bool doesItemExit = modelList.any((element) => element.name == itemName);
                      if(!doesItemExit){
                        if(includeGST != false){
                          print("sub::");
                          itemGrandTotal += double.parse(amountController.text.toString());
                          subTotalController.text = itemGrandTotal.round().toString();
                          // grandTotalController.text = itemGrandTotal.round().toString();
                          cgstAmount = double.parse(subTotalController.text)* cgst / 100.0;
                          sgstAmount = double.parse(subTotalController.text)* sgst / 100.0;
                          gstAmount = cgstAmount! + sgstAmount!;
                          gstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text) + gstAmount!;
                          grandTotalController.text = gstAmount!.toStringAsFixed(2);
                          // sgstController.text = gstAmount.toString();
                        }else{
                          print("sub:: ");
                          itemGrandTotal += double.parse(amountController.text.toString());
                          subTotalController.text = itemGrandTotal.round().toString();
                          grandTotalController.text = itemGrandTotal.round().toString();
                        }
                        print("item list ::::: $itemGrandTotal :: $gstAmount :: ${subTotalController.text} :: ${grandTotalController.text}");
                        itemDetailsInvoiceModel = MainInvoiceStockBody(
                            strHSNCode: hsnCodeController.text,
                            intitemid: itemDropDown,
                            name: itemName,
                            strName: itemUnitName,
                            decQty: int.parse(qtyController.text),
                            decRate: int.parse(rateController.text),
                            decAmount: int.parse(amountController.text),
                            intcompanyid : int.parse(PreferenceUtils.getString("${AppConstants.companyId}"))
                        );
                        print("navigate:: $supplierDropDown :: ${invoiceController.text} :: \n${dateController.text} :: ${dueDateController.text}");
                        itemDB.insertInvoiceStock(itemDetailsInvoiceModel!).then((value) {
                          itemDropDown = 0;
                          itemName = "";
                          qtyController.clear();
                          rateController.clear();
                          amountController.clear();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddSupplierInvoice(
                              supplierDropDown ?? 0,invoiceController.text,dateController.text,dueDateController.text,includeGST,"Item"
                          ),));
                        });
                      }else{
                        itemDropDown = 0;
                        itemName = "";
                        qtyController.clear();
                        rateController.clear();
                        amountController.clear();
                        AppConstants.getToast("This Item is Already Added Please Add Different Item");
                      }
                    });
                  }
                },
                buttonText: "Add More Item"),
            FutureBuilder(
              future: itemDB.getInvoiceStockList(),
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
                                                  if(includeGST != false){
                                                    print("delete:: $includeGST :: $inGST");
                                                    totalAmount = double.parse(subTotalController.text) - int.parse(modelList[index].decAmount.toString());
                                                    subTotalController.text = totalAmount.round().toString();
                                                    cgstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text)* cgst / 100.0;
                                                    sgstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text)* sgst / 100.0;
                                                    cgstController.text = cgstAmount.toString();
                                                    sgstController.text = sgstAmount.toString();
                                                    gstAmount = cgstAmount! + sgstAmount!;
                                                    gstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text) + gstAmount! - double.parse(discountController.text==""?"0":discountController.text);
                                                    grandTotalController.text = gstAmount!.toStringAsFixed(2);
                                                    itemDB.deleteInvoiceStock(modelList[index]);
                                                    print("include gst in de:: $totalAmount :: $cgstAmount :: $sgstAmount :: $gstAmount :: ${grandTotalController.text} :: ${subTotalController.text}");
                                                  }else{
                                                    totalAmount = double.parse(subTotalController.text) - int.parse(modelList[index].decAmount.toString());
                                                    subTotalController.text = totalAmount.round().toString();
                                                    cgstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text)* cgst / 100.0;
                                                    sgstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text)* sgst / 100.0;
                                                    cgstController.text = cgstAmount.toString();
                                                    sgstController.text = sgstAmount.toString();
                                                    gstAmount = cgstAmount! + sgstAmount!;
                                                    gstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text) - double.parse(discountController.text==""?"0":discountController.text);
                                                    grandTotalController.text = gstAmount.toString();
                                                    itemDB.deleteInvoiceStock(modelList[index]);
                                                    print("remove gst to delete :: $includeGST :: $inGST :: $totalAmount :: $cgstAmount :: $sgstAmount :: $gstAmount :: ${grandTotalController.text} :: ${subTotalController.text}");
                                                  }
                                                  itemDropDown = 0;
                                                  itemName = "";
                                                  qtyController.clear();
                                                  amountController.clear();
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
                                                itemDropDown = 0;
                                                itemName = "";
                                                qtyController.clear();
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
                    /*SingleChildScrollView(
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
                            ))
                          ],
                          rows: List.generate(modelList.length, (index) {
                            MainInvoiceStockBody model = modelList[index];
                            model = modelList[index];
                            stockAmount = model.decRate! * model.decQty!;
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
                                                      if(includeGST != false){
                                                        print("delete:: $includeGST :: $inGST");
                                                        totalAmount = double.parse(subTotalController.text) - int.parse(model.decAmount.toString());
                                                        subTotalController.text = totalAmount.round().toString();
                                                        cgstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text)* cgst / 100.0;
                                                        sgstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text)* sgst / 100.0;
                                                        cgstController.text = cgstAmount.toString();
                                                        sgstController.text = sgstAmount.toString();
                                                        gstAmount = cgstAmount! + sgstAmount!;
                                                        gstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text) + gstAmount! - double.parse(discountController.text==""?"0":discountController.text);
                                                        grandTotalController.text = gstAmount!.toStringAsFixed(2);
                                                        itemDB.deleteInvoiceStock(modelList[index]);
                                                        print("include gst in de:: $totalAmount :: $cgstAmount :: $sgstAmount :: $gstAmount :: ${grandTotalController.text} :: ${subTotalController.text}");
                                                      }else{
                                                        totalAmount = double.parse(subTotalController.text) - int.parse(model.decAmount.toString());
                                                        subTotalController.text = totalAmount.round().toString();
                                                        cgstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text)* cgst / 100.0;
                                                        sgstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text)* sgst / 100.0;
                                                        cgstController.text = cgstAmount.toString();
                                                        sgstController.text = sgstAmount.toString();
                                                        gstAmount = cgstAmount! + sgstAmount!;
                                                        gstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text) - double.parse(discountController.text==""?"0":discountController.text);
                                                        grandTotalController.text = gstAmount.toString();
                                                        itemDB.deleteInvoiceStock(modelList[index]);
                                                        print("remove gst to delete :: $includeGST :: $inGST :: $totalAmount :: $cgstAmount :: $sgstAmount :: $gstAmount :: ${grandTotalController.text} :: ${subTotalController.text}");
                                                      }
                                                      itemDropDown = 0;
                                                      itemName = "";
                                                      qtyController.clear();
                                                      amountController.clear();
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
                                                    itemDropDown = 0;
                                                    itemName = "";
                                                    qtyController.clear();
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
                                        "\u20b9 $stockAmount",
                                        style: poppinsBold.copyWith(
                                            color: ColorResources.BLACK),
                                        textAlign: TextAlign.center,
                                      ))),
                                ]);
                          })
                      ),
                    );*/
                }
                return const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG));
              },
            ),
            const Divider(color: ColorResources.BLACK),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Text("Sub Total",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
              child: CustomTextFieldEnabled(
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
            const Divider(color: ColorResources.BLACK),
            Container(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Checkbox(
                    value: includeGST,
                    activeColor: ColorResources.LINE_BG,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(05)),
                    onChanged: (value) {
                      setState(() {
                        includeGST = value!;
                        if(includeGST != false){
                          print("sub:: $includeGST ::");
                          inGST = 1;
                          cgstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text)* cgst / 100.0;
                          sgstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text)* sgst / 100.0;
                          cgstController.text = cgstAmount.toString();
                          sgstController.text = sgstAmount.toString();
                          gstAmount = cgstAmount! + sgstAmount!;
                          gstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text) + gstAmount! - double.parse(discountController.text==""?"0":discountController.text);
                          grandTotalController.text = gstAmount!.toStringAsFixed(2);
                          print("include gst :: $inGST :: $includeGST :$totalAmount :: $cgstAmount :: $sgstAmount :: $gstAmount :: ${grandTotalController.text} :: ${subTotalController.text}");
                        }else{
                          inGST = 0;
                          cgstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text)* sgst / 100.0;
                          sgstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text)* sgst / 100.0;
                          cgstController.text = cgstAmount.toString();
                          sgstController.text = sgstAmount.toString();
                          gstAmount = cgstAmount! + sgstAmount!;
                          gstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text) - double.parse(discountController.text==""?"0":discountController.text);
                          grandTotalController.text = gstAmount.toString();
                          print("remove gst :: $inGST :: $includeGST :: $totalAmount :: $cgstAmount :: $sgstAmount :: $gstAmount :: ${grandTotalController.text} :: ${subTotalController.text}");
                        }
                      });
                    },
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                    child: Text("Include GST",style: montserratBold.copyWith(color: ColorResources.BLACK)),
                  ),
                ],
              ),
            ),
            const Divider(color: ColorResources.BLACK),
            includeGST
                ?
            Column(
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                    child: Text("CGST (9%)",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                  child: CustomTextFieldEnabled(
                    controller: cgstController,
                    focusNode: cgstCode,
                    nextNode: sgstCode,
                    hintText: "CGST (9%)",
                    isPhoneNumber: true,
                    enabled: false,
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                    child: Text("SGST (9%)",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                  child: CustomTextFieldEnabled(
                    controller: sgstController,
                    focusNode: sgstCode,
                    nextNode: discountCode,
                    hintText: "SGST (9%)",
                    isPhoneNumber: true,
                    enabled: false,
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const Divider(color: ColorResources.BLACK),
              ],
            )
                :
            const SizedBox(),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Text("Discount",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                child: Container(
                  width: double.infinity,
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
                        if(includeGST != false){
                          print("sub::");
                          // cgstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text)* 9.0 / 100.0;
                          // sgstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text)* 9.0 / 100.0;
                          // cgstController.text = cgstAmount.toString();
                          // sgstController.text = sgstAmount.toString();
                          gstAmount = cgstAmount! + sgstAmount!;
                          gstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text) + gstAmount!;
                          grandTotalController.text = gstAmount.toString();
                          discountController.text!=''?
                          dueTotalAmount = gstAmount! - int.parse(discountController.text):
                          dueTotalAmount = gstAmount! - 0;
                          grandTotalController.text = dueTotalAmount!.toStringAsFixed(2);
                          print("amount:::: ${subTotalController.text} :: ${grandTotalController.text} :: $dueTotalAmount");
                          print("sub :: $totalAmount :: $cgstAmount :: $sgstAmount :: $gstAmount :: ${grandTotalController.text} :: ${subTotalController.text}");
                        }else{
                          discountController.text!=''?
                          dueTotalAmount = double.parse(subTotalController.text) - int.parse(discountController.text):
                          dueTotalAmount = int.parse(subTotalController.text) - 0;
                          discountController.text!=''?discountController.text:discountController.text ="0";
                          grandTotalController.text = dueTotalAmount.toString();
                          print("amount:::: ${subTotalController.text} :: ${grandTotalController.text} :: $dueTotalAmount");
                        }
                      });
                    },
                    onChanged: (v) {
                      setState(() {
                        if(includeGST != false){
                          print("sub::");
                          // cgstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text)* 9.0 / 100.0;
                          // sgstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text)* 9.0 / 100.0;
                          // cgstController.text = cgstAmount.toString();
                          // sgstController.text = sgstAmount.toString();
                          gstAmount = cgstAmount! + sgstAmount!;
                          gstAmount = subTotalController.text==""?0.0:double.parse(subTotalController.text) + gstAmount!;
                          grandTotalController.text = gstAmount.toString();
                          discountController.text!=''?
                          dueTotalAmount = gstAmount! - int.parse(discountController.text):
                          dueTotalAmount = gstAmount! - 0;
                          grandTotalController.text = dueTotalAmount.toString();
                          print("amount:::: ${subTotalController.text} :: ${grandTotalController.text} :: $dueTotalAmount");
                          print("sub :: $totalAmount :: $cgstAmount :: $sgstAmount :: $gstAmount :: ${grandTotalController.text} :: ${subTotalController.text}");
                        }else{
                          discountController.text!=''?
                          dueTotalAmount = double.parse(subTotalController.text) - int.parse(discountController.text):
                          dueTotalAmount = int.parse(subTotalController.text) - 0;
                          // discountController.text!=''?discountController.text:discountController.text ="0";
                          grandTotalController.text = dueTotalAmount.toString();
                          print("amount:::: ${subTotalController.text} :: ${grandTotalController.text} :: $dueTotalAmount");
                        }
                      });
                    },
                    style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly ,FilteringTextInputFormatter.singleLineFormatter],
                    decoration: InputDecoration(
                      hintText: 'Discount',
                      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
                      isDense: true,
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
                hintText: "Grand Total",
                isPhoneNumber: true,
                textInputType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Text("Attachment",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
            Container(
              alignment: Alignment.centerLeft,
              height: AppConstants.itemHeight*0.065,
              margin: EdgeInsets.only(left: AppConstants.itemWidth*0.02,right: AppConstants.itemWidth*0.02,top: AppConstants.itemHeight*0.01,bottom: AppConstants.itemHeight*0.01),
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(05),
                  border: Border.all(color: ColorResources.BLACK)
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => filePick(),
                    child: Container(
                        alignment: Alignment.center,
                        height: AppConstants.itemHeight*0.04,
                        width: AppConstants.itemWidth*0.20,
                        decoration: BoxDecoration(
                            color: ColorResources.GREY.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(05),
                            border: Border.all(color: ColorResources.BLACK)
                        ),
                        child: Text('Pick File',style: montserratBold.copyWith(color: ColorResources.BLACK))),
                  ),
                  Container(
                      width: AppConstants.itemWidth * 0.65,
                      margin: EdgeInsets.only(left: AppConstants.itemWidth * 0.01),
                      child: Text(imageName == "" ? 'No file chosen': imageName,
                        style: montserratBold.copyWith(color: ColorResources.BLACK),
                      ))
                ],
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Text("Memo on Invoice",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
              child: CustomTextField(
                controller: memoController,
                focusNode: memoCode,
                nextNode: null,
                hintText: "This will show up on the invoice.",
                isPhoneNumber: false,
                maxLine: 3,
                textInputType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
              ),
            ),
            isLoad
                ?
            const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
                :
            CustomButtonFuction(onTap: (){
              addInvoice();
            }, buttonText: "Add"),
          ],
        ),
      ),
    );
  }

  final Widget _verticalDivider = const VerticalDivider(
    color: Colors.black12,
    thickness: 1,
  );
}
