import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_accounting/data/model/body/addPayment_body.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/payment_provider.dart';
import 'package:gas_accounting/provider/route_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/custom_button.dart';
import 'package:gas_accounting/view/basewidget/custom_password_textfield.dart';
import 'package:gas_accounting/view/basewidget/custom_textfield.dart';
import 'package:gas_accounting/view/screen/manage_temp_payment/payment_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditTempPayment extends StatefulWidget {
  String id,type;
  EditTempPayment(this.id,this.type,{Key? key}) : super(key: key);

  @override
  State<EditTempPayment> createState() => _EditTempPaymentState();
}

class _EditTempPaymentState extends State<EditTempPayment> {
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
  String? dropdownValue;
  String? routeName;
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
    print("name::::${widget.id}");
    DateTime today = DateTime.now();
    formattedDate = DateFormat('dd/MM/yyyy').format(today);
    // dropdownValue = widget.customerId;
    dateController.text = formattedDate;
    _loadData(context, true);
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<PaymentProvider>(context, listen: false).getPaymentEdit(context,widget.id).then((value) {
        setState(() {
          is_loading = false;
          for(int i=0;i<Provider.of<PaymentProvider>(context, listen: false).editPaymentList.length;i++){
           routeDropdownValue = Provider.of<PaymentProvider>(context, listen: false).editPaymentList[i].intRouteid;
           dropdownValue = Provider.of<PaymentProvider>(context, listen: false).editPaymentList[i].intCustomerid.toString();
           dateController.text = Provider.of<PaymentProvider>(context, listen: false).editPaymentList[i].dtPaymentDate.toString();
           totalController.text = Provider.of<PaymentProvider>(context, listen: false).editPaymentList[i].decGrandTotal!.round().toString();
           onlineCodeController.text = Provider.of<PaymentProvider>(context, listen: false).editPaymentList[i].deconlinepayment!.round().toString();
           cashController.text = Provider.of<PaymentProvider>(context, listen: false).editPaymentList[i].deccashpayment!.round().toString();
          }
        });
      });
      Provider.of<RouteProvider>(context, listen: false).getDriverHelper(context,PreferenceUtils.getString("${AppConstants.companyId}"),"3");
      Provider.of<RouteProvider>(context, listen: false).getSelectRoute(context,PreferenceUtils.getString("${AppConstants.companyId}"));
    });
  }

  _addPayment(){
    if (routeDropdownValue==null) {
      AppConstants.getToast("Please Select Route");
    } else if (dropdownValue==null) {
      AppConstants.getToast("Please Select Customer");
    } else if (dateController.text=='') {
      AppConstants.getToast("Please Select Date");
    }
    // else if (invoiceNumberController.text=='') {
    //   AppConstants.getToast("Please Enter Invoice Number");
    // }
    else if (onlineCodeController.text=='') {
      AppConstants.getToast("Please Enter Online");
    } else if (cashController.text=='') {
      AppConstants.getToast("Please Enter Cash");
    } else if (totalController.text=='') {
      AppConstants.getToast("Please Enter Total Amount");
    } else{
      PaymentUpdate_Body payment = PaymentUpdate_Body(
        intid: int.parse(widget.id),
        intCustomerid: int.parse(dropdownValue.toString()),
        intcompanyid: int.parse(PreferenceUtils.getString("${AppConstants.companyId}")),
        intRouteid: routeDropdownValue,
        dtPaymentDate: AppConstants.date_change(dateController.text),
        decGrandTotal: int.parse(totalController.text),
        deconlinepayment: int.parse(onlineCodeController.text),
        deccashpayment: int.parse(cashController.text),
        strRemarks: "",
      );
      Provider.of<PaymentProvider>(context, listen: false).getUpdatePayment(context,payment,_route);
      AppConstants.closeKeyboard();
    }
  }

  _route(isRoute){
    if (isRoute) {
      dropdownValue = null;
      Navigator.push(context, MaterialPageRoute(builder: (context) => TempPaymentList("",""),));
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
                  Text("Select Route",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                  Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                ],
              )),
          /*Container(
            height: AppConstants.itemHeight*0.06,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
            decoration: BoxDecoration(
              color: ColorResources.GREY.withOpacity(0.05),
              borderRadius:BorderRadius.circular(10),
            ),
            child: Consumer<RouteProvider>(builder: (context, route, child) {
              return DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text('Select Route',style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),),
                  value: routeDropdownValue,
                  dropdownColor: Colors.white,
                  menuMaxHeight: 200,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 15,
                  style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                  underline: Container(
                    height: 0,
                    color: Colors.white,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      routeDropdownValue = newValue!;
                    });
                  },
                  items: route.selectrouteList.map((areaList) {
                    return DropdownMenuItem<String>(
                      value: areaList.intId.toString(),
                      child: Row(
                        children: [
                          Text(areaList.strRoute.toString()),
                        ],
                      ),
                    );
                  }).toList(),
                  itemHeight: AppConstants.itemHeight*0.07,
                ),
              );
            },),
          ),*/
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
                for(int i=0;i<Provider.of<PaymentProvider>(context, listen: false).editPaymentList.length;i++){
                  for(int k=0;k<Provider.of<RouteProvider>(context, listen: false).selectrouteList.length;k++){
                    if (Provider.of<PaymentProvider>(context, listen: false).editPaymentList[i].intRouteid == Provider.of<RouteProvider>(context, listen: false).selectrouteList[k].intId) {
                      routeDropdownValue = Provider.of<RouteProvider>(context, listen: false).selectrouteList[k].intId;
                      routeName = Provider.of<RouteProvider>(context, listen: false).selectrouteList[k].strRoute.toString();
                    }
                  }
                }
                print("routename:::::$routeName:::::$routeDropdownValue");
              return DropdownButtonHideUnderline(
                child: CustomSearchableDropDown(
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
                ),
              );
            },),
          ),
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
            height: AppConstants.itemHeight*0.06,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
            decoration: BoxDecoration(
              color: ColorResources.GREY.withOpacity(0.05),
              borderRadius:BorderRadius.circular(10),
            ),
            child: Consumer<RouteProvider>(builder: (context, customer, child) {
              return DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text('Select Customer',style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),),
                  value: dropdownValue,
                  dropdownColor: Colors.white,
                  menuMaxHeight: 200,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 15,
                  style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                  underline: Container(
                    height: 0,
                    color: Colors.white,
                  ),
                  onChanged: null,
                  //     (String? newValue) {
                  //   setState(() {
                  //     dropdownValue = newValue!;
                  //     print("object:::$dropdownValue");
                  //   });
                  // },
                  items: customer.driverList.map((areaList) {
                    return DropdownMenuItem<String>(
                      value: areaList.intId.toString(),
                      child: Text(areaList.srtFullName.toString(),style: TextStyle(fontWeight: FontWeight.w500,color: Theme.of(context).hintColor),),
                    );
                  }).toList(),
                  itemHeight: AppConstants.itemHeight*0.07,
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
              child: Row(
                children: [
                  Text("Invoice Number",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                  // Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                ],
              )),
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
                      // total_amount = "${int.parse(onlineCodeController.text) + int.parse(cashController.text)}";
                      // totalController.text = total_amount.toString();
                      // print("amount::::${totalController.text}");
                      cashController.text!=''?
                      total_amount = "${int.parse(onlineCodeController.text) + int.parse(cashController.text)}":
                      total_amount = "${int.parse(onlineCodeController.text) - 0}";
                      cashController.text!=''?cashController.text:cashController.text ="0";
                      totalController.text = total_amount.toString();
                      print("amount::1::${totalController.text}");
                    });
                  },
                  onChanged: (v) {
                    // FocusScope.of(context).requestFocus(cashCode);
                    setState(() {
                      // total_amount = "${int.parse(onlineCodeController.text) + int.parse(cashController.text)}";
                      // totalController.text = total_amount.toString();
                      // print("amount::::${totalController.text}");
                      cashController.text!=''?
                      total_amount = "${int.parse(onlineCodeController.text) + int.parse(cashController.text)}":
                      total_amount = "${int.parse(onlineCodeController.text) - 0}";
                      cashController.text!=''?cashController.text:cashController.text ="0";
                      totalController.text = total_amount.toString();
                      print("amount::1::${totalController.text}");
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
          /*Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
            child: CustomTextField(
              controller: onlineCodeController,
              focusNode: onlineCode,
              nextNode: cashCode,
              hintText: "Online Payment",
              isPhoneNumber: false,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
          ),*/
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
                      // cashController.text!=''?
                      // total_amount = "${int.parse(onlineCodeController.text) + int.parse(cashController.text)}":
                      // total_amount = "${int.parse(onlineCodeController.text) - 0}";
                      // // total_amount = "${int.parse(onlineCodeController.text) + int.parse(cashController.text)}";
                      // totalController.text = total_amount.toString();
                      // print("amount::::${totalController.text}");
                      onlineCodeController.text!=''?
                      total_amount = "${int.parse(cashController.text) + int.parse(onlineCodeController.text)}":
                      total_amount = "${int.parse(cashController.text) - 0}";
                      onlineCodeController.text!=''?onlineCodeController.text:onlineCodeController.text ="0";
                      totalController.text = total_amount.toString();
                      print("amount::0::${totalController.text}");
                    });
                  },
                  onChanged: (v) {
                    // FocusScope.of(context).requestFocus(onlineCode);
                    setState(() {
                      // cashController.text!=''?
                      // total_amount = "${int.parse(onlineCodeController.text) + int.parse(cashController.text)}":
                      // total_amount = "${int.parse(onlineCodeController.text) - 0}";
                      // // total_amount = "${int.parse(onlineCodeController.text) + int.parse(cashController.text)}";
                      // totalController.text = total_amount.toString();
                      // print("amount::::${totalController.text}");
                      onlineCodeController.text!=''?
                      total_amount = "${int.parse(cashController.text) + int.parse(onlineCodeController.text)}":
                      total_amount = "${int.parse(cashController.text) - 0}";
                      onlineCodeController.text!=''?onlineCodeController.text:onlineCodeController.text ="0";
                      totalController.text = total_amount.toString();
                      print("amount::0::${totalController.text}");
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
              nextNode: null,
              hintText: "Total Amount",
              isPhoneNumber: false,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.done,
            ),
          ),
        /*  Container(
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
          ),*/
          Provider.of<PaymentProvider>(context).isLoading
              ?
          const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
              :
          CustomButtonFuction(onTap: (){
            _addPayment();
          }, buttonText: "Add"),
        ],
      ),
    );
  }
}
