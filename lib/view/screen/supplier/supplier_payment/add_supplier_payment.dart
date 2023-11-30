import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_accounting/data/model/body/supplier_body.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/supplier_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/custom_button.dart';
import 'package:gas_accounting/view/basewidget/custom_password_textfield.dart';
import 'package:gas_accounting/view/basewidget/custom_textfield.dart';
import 'package:gas_accounting/view/screen/supplier/supplier_payment/supplier_payment_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddSupplierPayment extends StatefulWidget {
  String id,supplierId,type;
  SupplierPaymentData supplierPaymentData;
  AddSupplierPayment(this.id ,this.supplierId,this.supplierPaymentData ,this.type ,{super.key});

  @override
  State<AddSupplierPayment> createState() => _AddSupplierPaymentState();
}

class _AddSupplierPaymentState extends State<AddSupplierPayment> {
  TextEditingController dateController = TextEditingController();
  TextEditingController invoiceController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  TextEditingController onlineCodeController = TextEditingController();
  TextEditingController cashController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  FocusNode dateCode = FocusNode();
  FocusNode invoiceCode = FocusNode();
  FocusNode totalCode = FocusNode();
  FocusNode onlineCode = FocusNode();
  FocusNode cashCode = FocusNode();
  FocusNode remarkCode = FocusNode();

  bool isLoading = true;
  late String formattedDate = '';
  late String dateSchedule = '';
  TimeOfDay selectedTime = TimeOfDay.now();
  dynamic supplierDropDown;
  String? supplierName = "";
  String? totalAmount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime today = DateTime.now();
    formattedDate = DateFormat('dd/MM/yyyy').format(today);
    dateController.text = widget.type=="New" ? formattedDate.toString() : AppConstants.date_chang(widget.supplierPaymentData.dtpaymentdate.toString());
    invoiceController.text = widget.type=="New" ? "" : widget.supplierPaymentData.strInvoiceno==null?"":widget.supplierPaymentData.strInvoiceno.toString();
    totalController.text = widget.type=="New" ? "" : widget.supplierPaymentData.decAmount!.round().toString();
    onlineCodeController.text = widget.type=="New" ? "" : widget.supplierPaymentData.decOnlinePayment!.round().toString();
    cashController.text = widget.type=="New" ? "" : widget.supplierPaymentData.decCashPayment!.round().toString();
    remarkController.text = widget.type=="New" ? "" : widget.supplierPaymentData.strRemarks==null?"":widget.supplierPaymentData.strRemarks.toString();
    _loadData(context, true);
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<SupplierProvider>(context, listen: false).getSupplierList(context,PreferenceUtils.getString("${AppConstants.companyId}")).then((value) {
        setState(() {
          isLoading = false;
          for(int i=0;i<Provider.of<SupplierProvider>(context, listen: false).supplierList.length;i++){
            if(widget.supplierPaymentData.intSupplierid == Provider.of<SupplierProvider>(context, listen: false).supplierList[i].intid){
              supplierDropDown = widget.supplierPaymentData.intSupplierid;
              supplierName = widget.supplierPaymentData.strSuppliername;
              print("widget supplier :: $supplierName :: $supplierDropDown");
            }
          }
        });
      });
    });
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

  addPayment(){
    if(supplierDropDown == null){
      AppConstants.getToast("Please Select Supplier");
    }else if(dateController.text == ""){
      AppConstants.getToast("Please Select Payment Date");
    }else if(totalController.text == ""){
      AppConstants.getToast("Please Enter Total Amount");
    }else if (onlineCodeController.text=='') {
      AppConstants.getToast("Please Enter Online");
    }else if (cashController.text=='') {
      AppConstants.getToast("Please Enter Cash");
    }else{
      if (widget.type=="New") {
        AddSupplierPaymentBody payment = AddSupplierPaymentBody(
          strInvoiceno: invoiceController.text==""?"":invoiceController.text,
          dtpaymentdate: dateController.text,
          decAmount: int.parse(totalController.text),
          decOnlinePayment: int.parse(onlineCodeController.text),
          decCashPayment: int.parse(cashController.text),
          strRemarks: remarkController.text,
          intSupplierid: supplierDropDown,
          intCreatedby: int.parse(PreferenceUtils.getString("${AppConstants.companyId}")),
          intCompanyid: int.parse(PreferenceUtils.getString("${AppConstants.companyId}")),
        );
        Provider.of<SupplierProvider>(context, listen: false).getAddSupplierPayment(context,payment,_route);
      }else{
        AddSupplierPaymentBody payment = AddSupplierPaymentBody(
          intid: int.parse(widget.id),
          strInvoiceno: invoiceController.text==""?"":invoiceController.text,
          dtpaymentdate: dateController.text,
          decAmount: int.parse(totalController.text),
          decOnlinePayment: int.parse(onlineCodeController.text),
          decCashPayment: int.parse(cashController.text),
          strRemarks: remarkController.text,
          intSupplierid: supplierDropDown,
          intCreatedby: int.parse(PreferenceUtils.getString("${AppConstants.companyId}")),
          intCompanyid: int.parse(PreferenceUtils.getString("${AppConstants.companyId}")),
        );
        Provider.of<SupplierProvider>(context, listen: false).getAddSupplierPayment(context,payment,route);
      }
      AppConstants.closeKeyboard();
    }
  }

  _route(isRoute){
    if(isRoute){
      Navigator.push(context, MaterialPageRoute(builder: (context) => SupplierPaymentList("",""),));
      AppConstants.getToast("Supplier Payment Added Successfully");
    }else{
      AppConstants.getToast("Please Try After Sometime");
    }
  }

  route(isRoute){
    if(isRoute){
      Navigator.push(context, MaterialPageRoute(builder: (context) => SupplierPaymentList("",""),));
      AppConstants.getToast("Supplier Payment Edited Successfully");
    }else{
      AppConstants.getToast("Please Try After Sometime");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SupplierProvider>(builder: (context, supplier, child) {
      return WillPopScope(
        onWillPop: () async{
          Navigator.push(context,MaterialPageRoute(builder: (context) => SupplierPaymentList(widget.supplierId,"Side")));
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorResources.LINE_BG,
            centerTitle: true,
            leading: IconButton(onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => SupplierPaymentList(widget.supplierId,"Side")));
            }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25)),
            title: Text(widget.type=="New"?"Add Supplier Payment":"Edit Supplier Payment",style: montserratSemiBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
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
                      Text("Select Supplier",style: montserratBold.copyWith(color: ColorResources.BLACK),),
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
                child: DropdownButtonHideUnderline(
                    child: CustomSearchableDropDown(
                      menuPadding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.15),
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                      multiSelect: false,
                      dropDownMenuItems: supplier.supplierList.map((areaList) {
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
                        print("supplier ::$value");
                      },
                    )
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                  child: Row(
                    children: [
                      Text("Payment Date",style: montserratBold.copyWith(color: ColorResources.BLACK),),
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
                    nextNode: invoiceCode,
                    // hintTxt: "DD/MM/YYYY",
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                  child: Row(
                    children: [
                      Text("Invoice No.",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                child: CustomTextField(
                  controller: invoiceController,
                  focusNode: invoiceCode,
                  nextNode: totalCode,
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
                      Text("Total Amount",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                      Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                    ],
                  )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                child: CustomTextField(
                  controller: totalController,
                  focusNode: totalCode,
                  nextNode: onlineCode,
                  hintText: "Total Amount",
                  isPhoneNumber: false,
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                  child: Text("Online Payment",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
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
                      controller: onlineCodeController,
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: onlineCode,
                      cursorColor: ColorResources.LINE_BG,
                      onTap: () {
                        setState(() {
                          totalAmount = totalController.text;
                          cashController.text!=''?
                          totalAmount = "${int.parse(totalController.text) - int.parse(onlineCodeController.text)}":
                          totalAmount = "${int.parse(onlineCodeController.text) - 0}";
                          cashController.text!=''?cashController.text:cashController.text ="0";
                          cashController.text = totalAmount.toString();
                          print("amount::0::$totalAmount");
                        });
                      },
                      onChanged: (v) {
                        setState(() {
                          totalAmount = totalController.text;
                          cashController.text!=''?
                          totalAmount = "${int.parse(totalController.text) - int.parse(onlineCodeController.text)}":
                          totalAmount = "${int.parse(onlineCodeController.text) - 0}";
                          cashController.text!=''?cashController.text:cashController.text ="0";
                          cashController.text = totalAmount.toString();
                          print("amount::1::$totalAmount");
                        });
                      },
                      style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly ,FilteringTextInputFormatter.singleLineFormatter],
                      decoration: InputDecoration(
                        hintText: 'Online Payment',
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
                  child: Text("Cash Payment",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
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
                      controller: cashController,
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      focusNode: cashCode,
                      cursorColor: ColorResources.LINE_BG,
                      onTap: () {
                        setState(() {
                          totalAmount = totalController.text;
                          onlineCodeController.text!=''?
                          totalAmount = "${int.parse(totalController.text) - int.parse(cashController.text)}":
                          totalAmount = "${int.parse(cashController.text) - 0}";
                          onlineCodeController.text!=''?onlineCodeController.text:onlineCodeController.text ="0";
                          onlineCodeController.text = totalAmount.toString();
                          print("amount::0::${totalController.text}");
                        });
                      },
                      onChanged: (v) {
                        setState(() {
                          totalAmount = totalController.text;
                          onlineCodeController.text!=''?
                          totalAmount = "${int.parse(totalController.text) - int.parse(cashController.text)}":
                          totalAmount = "${int.parse(cashController.text) - 0}";
                          onlineCodeController.text!=''?onlineCodeController.text:onlineCodeController.text ="0";
                          onlineCodeController.text = totalAmount.toString();
                          print("amount::1::${totalController.text}");
                        });
                      },
                      style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly ,FilteringTextInputFormatter.singleLineFormatter],
                      decoration: InputDecoration(
                        hintText: 'Cash Payment',
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
                  child: Text("Remark",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                child: CustomTextField(
                  controller: remarkController,
                  focusNode: remarkCode,
                  nextNode: null,
                  hintText: "Remark",
                  isPhoneNumber: false,
                  maxLine: 4,
                  textInputType: TextInputType.multiline,
                  textInputAction: TextInputAction.done,
                ),
              ),
              Provider.of<SupplierProvider>(context).isLoading
                  ?
              const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
                  :
              CustomButtonFuction(onTap: (){
                addPayment();
              }, buttonText: widget.type=="New"?"Add":"Save"),
            ],
          ),
        ),
      );
    },);
  }
}
