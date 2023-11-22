import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_accounting/data/model/body/addPayment_body.dart';
import 'package:gas_accounting/data/model/body/main_payment_body.dart';
import 'package:gas_accounting/data/model/response/main_payment_response.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/main_payment_provider.dart';
import 'package:gas_accounting/provider/payment_provider.dart';
import 'package:gas_accounting/provider/route_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/custom_button.dart';
import 'package:gas_accounting/view/basewidget/custom_password_textfield.dart';
import 'package:gas_accounting/view/basewidget/custom_textfield.dart';
import 'package:gas_accounting/view/screen/payment/payment_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditMainPayment extends StatefulWidget {
  int customerId,type;
  MainPaymentData mainPaymentData;
  EditMainPayment(this.customerId,this.mainPaymentData,this.type,{Key? key}) : super(key: key);

  @override
  State<EditMainPayment> createState() => _EditMainPaymentState();
}

class _EditMainPaymentState extends State<EditMainPayment> {
  TextEditingController dateController = TextEditingController();
  TextEditingController invoiceNumberController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  TextEditingController onlineCodeController = TextEditingController();
  TextEditingController cashController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  FocusNode dateCode = FocusNode();
  FocusNode invoiceNumberCode = FocusNode();
  FocusNode totalCode = FocusNode();
  FocusNode onlineCode = FocusNode();
  FocusNode cashCode = FocusNode();
  FocusNode remarkCode = FocusNode();

  late String formattedDate = '';
  late String date_shcedule = '';
  TimeOfDay selectedTime = TimeOfDay.now();
  String? dropdownValues;
  int? dropdownValue;
  String? routeName;
  String? customerName;
  int? routeDropdownValue ;
  String? total_amount;

  bool is_loading =true;

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
    print("id::::${widget.customerId}:::${widget.type}:::${widget.mainPaymentData.intid}");
    DateTime today = DateTime.now();
    formattedDate = DateFormat('dd/MM/yyyy').format(today);
    dateController.text = formattedDate;
    dropdownValue = widget.mainPaymentData.intCustomerid;
    dateController.text = widget.mainPaymentData.dtPaymentDate.toString();
    invoiceNumberController.text = widget.mainPaymentData.strInvoiceNo.toString();
    totalController.text = widget.mainPaymentData.decAmount!.round().toString();
    onlineCodeController.text = widget.mainPaymentData.deconlinepayment!.round().toString();
    cashController.text = widget.mainPaymentData.deccashpayment!.round().toString();
    remarkController.text = widget.mainPaymentData.strRemarks==null?"":widget.mainPaymentData.strRemarks.toString();
    _loadData(context, true);
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<RouteProvider>(context, listen: false).getDriverHelper(context,PreferenceUtils.getString("${AppConstants.companyId}"),"3").then((value) {
        setState(() {
          is_loading = false;
        });
      });
    });
  }

  _addPayment(){
    if (dropdownValue == null) {
      AppConstants.getToast("Please Select Customer");
    } else if (dateController.text=='') {
      AppConstants.getToast("Please Select Date");
    } else if (totalController.text=='') {
      AppConstants.getToast("Please Enter Total Amount");
    } else if (onlineCodeController.text=='') {
      AppConstants.getToast("Please Enter Online");
    } else if (cashController.text=='') {
      AppConstants.getToast("Please Enter Cash");
    } else {
        Edit_Main_Payment_Body payment = Edit_Main_Payment_Body(
          intid: widget.mainPaymentData.intid,
          intType: 1,
          intCustomerid: dropdownValue,
          strInvoiceNo: int.parse(invoiceNumberController.text),
          dtPaymentDate: dateController.text,
          decAmount: int.parse(totalController.text),
          strRemarks: remarkController.text,
          deconlinepayment: int.parse(onlineCodeController.text),
          deccashpayment: int.parse(cashController.text),
          intCreatedBy: int.parse(PreferenceUtils.getString("${AppConstants.companyId}")),
          intCompanyId: int.parse(PreferenceUtils.getString("${AppConstants.companyId}")),
        );
        Provider.of<MainPaymentProvider>(context, listen: false).getUpdateMainPayment(context,payment,_route);
        AppConstants.closeKeyboard();
    }
  }

  _route(isRoute){
    if (isRoute) {
      dropdownValue = null;
      routeDropdownValue = null;
      Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentList("","","","Payment"),));
      AppConstants.getToast("Payment Edited Successfully");
    }  else{
      AppConstants.getToast("Please Try After Sometime");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.LINE_BG,
        centerTitle: true,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
        title: Text("Add Payment",style: montserratBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
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
            alignment: Alignment.center,
            width: AppConstants.itemWidth*0.50,
            margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
            decoration: BoxDecoration(
              color: ColorResources.GREY.withOpacity(0.05),
              borderRadius:BorderRadius.circular(10),
            ),
            child: Consumer<RouteProvider>(builder: (context, route, child) {
              for(int k=0;k<Provider.of<RouteProvider>(context, listen: false).driverList.length;k++){
                if (widget.mainPaymentData.intCustomerid == Provider.of<RouteProvider>(context, listen: false).driverList[k].intId) {
                  dropdownValue = Provider.of<RouteProvider>(context, listen: false).driverList[k].intId;
                  customerName = Provider.of<RouteProvider>(context, listen: false).driverList[k].srtFullName.toString();
                }
              }
              print("routename:::::$customerName:::::$dropdownValue");
              return DropdownButtonHideUnderline(
                child: CustomSearchableDropDown(
                  menuPadding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.15),
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.0),
                  multiSelect: false,
                  dropDownMenuItems: route.driverList.map((areaList) {
                    return areaList.srtFullName;
                  }).toList(),
                  label: customerName ?? 'Select Customer',
                  labelStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                  items : route.driverList.map((areaList) {
                    return  areaList.intId;
                  }).toList(),
                  onChanged: (value){
                    if(value!=null)
                    {
                      dropdownValue = value;
                      print("object:::$value");
                    }
                    else{
                      dropdownValue = null;
                      print("object:::$value");
                    }
                  },
                ),
              );
            },),
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
              _date_pik_shcedule();
              print("object:::$date_shcedule");
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
              child: CustomDateTextField(
                controller: dateController,
                focusNode: dateCode,
                nextNode: invoiceNumberCode,
              ),
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
              child: Text("Invoice Number",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
            child: CustomTextField(
              controller: invoiceNumberController,
              focusNode: invoiceNumberCode,
              nextNode: totalCode,
              hintText: "Invoice Number",
              isPhoneNumber: false,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.next,
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
                  onTap: () {
                    setState(() {
                      total_amount = totalController.text;
                      cashController.text!=''?
                      total_amount = "${int.parse(totalController.text) - int.parse(onlineCodeController.text)}":
                      total_amount = "${int.parse(onlineCodeController.text) - 0}";
                      cashController.text!=''?cashController.text:cashController.text ="0";
                      cashController.text = total_amount.toString();
                      print("amount::0::$total_amount");
                    });
                  },
                  onChanged: (v) {
                    setState(() {
                      total_amount = totalController.text;
                      cashController.text!=''?
                      total_amount = "${int.parse(totalController.text) - int.parse(onlineCodeController.text)}":
                      total_amount = "${int.parse(onlineCodeController.text) - 0}";
                      cashController.text!=''?cashController.text:cashController.text ="0";
                      cashController.text = total_amount.toString();
                      print("amount::1::$total_amount");
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
                  onTap: () {
                    setState(() {
                      total_amount = totalController.text;
                      onlineCodeController.text!=''?
                      total_amount = "${int.parse(totalController.text) - int.parse(cashController.text)}":
                      total_amount = "${int.parse(cashController.text) - 0}";
                      onlineCodeController.text!=''?onlineCodeController.text:onlineCodeController.text ="0";
                      onlineCodeController.text = total_amount.toString();
                      print("amount::0::${totalController.text}");
                    });
                  },
                  onChanged: (v) {
                    setState(() {
                      total_amount = totalController.text;
                      onlineCodeController.text!=''?
                      total_amount = "${int.parse(totalController.text) - int.parse(cashController.text)}":
                      total_amount = "${int.parse(cashController.text) - 0}";
                      onlineCodeController.text!=''?onlineCodeController.text:onlineCodeController.text ="0";
                      onlineCodeController.text = total_amount.toString();
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
          Provider.of<MainPaymentProvider>(context).isLoading
              ?
          const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
              :
          CustomButtonFuction(onTap: (){
            _addPayment();
          }, buttonText: "Save"),
        ],
      ),
    );
  }
}
