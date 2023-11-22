import 'dart:math';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gas_accounting/data/model/body/supplier_body.dart';
import 'package:gas_accounting/data/model/response/supplier_response.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/supplier_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/no_internet_screen.dart';
import 'package:gas_accounting/view/screen/dashboard/dashboard_screen.dart';
import 'package:gas_accounting/view/screen/supplier/supplier_payment/add_supplier_payment.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

class SupplierPaymentList extends StatefulWidget {
  String supplierId,type;
  SupplierPaymentList(this.supplierId,this.type,{super.key});

  @override
  State<SupplierPaymentList> createState() => _SupplierPaymentListState();
}

class _SupplierPaymentListState extends State<SupplierPaymentList> {
  bool isLoading = true;
  SupplierPaymentData supplierPaymentData = SupplierPaymentData();
  TextEditingController supplierController = TextEditingController();
  late String formattedMonth = '';
  late String formattedMonthNumber = '';
  late String formattedYear = '';
  late String month = '';
  late String monthNumber = '0';
  late String year = '0';
  TimeOfDay selectedTime = TimeOfDay.now();
  late String formattedDate = '';
  late String date_shcedule = '';
  late String start_date = '';
  late String end_date = '';
  String? supplierName;
  int supplierDropDown = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData(context, true);
    DateTime today = DateTime.now();
    formattedDate = DateFormat('dd/MM/yyyy').format(today);
    formattedMonth = DateFormat('MMMM').format(today);
    formattedMonthNumber = DateFormat('MM').format(today);
    formattedYear = DateFormat('yyyy').format(today);
    month = formattedMonth;
    monthNumber = formattedMonthNumber;
    year = formattedYear;
    _startDate = _startDate;
    _enddate =  _enddate;
    var firstDayThisMonth = DateTime(today.year, today.month, 1);
    var firstDayNextMonth = DateTime(today.year, today.month + 1, 0);
    start_date = DateFormat('yyyy-MM-dd').format(firstDayThisMonth);
    end_date = DateFormat('yyyy-MM-dd').format(firstDayNextMonth);
    print("type ::${widget.type}");
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<SupplierProvider>(context, listen: false).getSupplierPaymentList(context,
          PreferenceUtils.getString("${AppConstants.companyId}"),
          start_date,
          end_date,
          widget.supplierId==""?"0":widget.supplierId).then((value) {
        setState(() {
          isLoading = false;
        });
      });
      Provider.of<SupplierProvider>(context, listen: false).getSupplierList(context,PreferenceUtils.getString("${AppConstants.companyId}")).then((value) {
        setState(() {
          isLoading = false;
          for(int i=0;i<Provider.of<SupplierProvider>(context, listen: false).supplierList.length;i++){
            if(int.parse(widget.supplierId==""?"0":widget.supplierId) == Provider.of<SupplierProvider>(context, listen: false).supplierList[i].intid){
              supplierDropDown = int.parse(widget.supplierId);
              supplierName = "${Provider.of<SupplierProvider>(context, listen: false).supplierList[i].strCompanyName} (${Provider.of<SupplierProvider>(context, listen: false).supplierList[i].strContactPersonName})";
              print("widget supplier :: $supplierName :: $supplierDropDown");
            }
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SupplierProvider>(builder: (context, supplier, child) {
      return WillPopScope(
        onWillPop: () async{
          Navigator.push(context,MaterialPageRoute(builder: (context) => Dashboard("Home")));
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorResources.LINE_BG,
            centerTitle: true,
            leading: IconButton(onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => Dashboard("Home")));
            }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25)),
            title: Text("Supplier Payment",style: montserratSemiBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddSupplierPayment("0","0",supplierPaymentData,"New")));
            },
            backgroundColor: ColorResources.LINE_BG,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)
            ),
            child: const Icon(Icons.add,size: 40,color: ColorResources.WHITE),
          ),
          body:
          isLoading
              ?
          const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
              :
          Container(
            margin: EdgeInsets.all(AppConstants.itemHeight*0.01),
            padding: EdgeInsets.symmetric(vertical: AppConstants.itemHeight*0.01),
            decoration: BoxDecoration(
              color: ColorResources.WHITE,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(2, 4),
                    blurRadius: 3,
                    spreadRadius: 1)
              ],
            ),
            child:
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCalendarDialogButton(),
                    GestureDetector(
                      onTap: () {
                        showMonthPicker(
                            context: context,
                            selectedMonthBackgroundColor: ColorResources.LINE_BG,
                            selectedMonthTextColor: ColorResources.WHITE,
                            unselectedMonthTextColor: ColorResources.BLACK,
                            cancelWidget: Text('Cancel',style: robotoSemiBold.copyWith(color: ColorResources.LINE_BG,fontSize: Dimensions.FONT_SIZE_15)),
                            confirmWidget: Text('Ok',style: robotoSemiBold.copyWith(color: ColorResources.LINE_BG,fontSize: Dimensions.FONT_SIZE_15)),
                            initialDate: DateTime.utc(int.parse(year),int.parse(monthNumber)),
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2040)
                        ).then((pickedDate) {
                          if (pickedDate == null) {
                            return;
                          }
                          setState(() {
                            formattedMonth = DateFormat('MMMM').format(pickedDate);
                            formattedMonthNumber = DateFormat('MM').format(pickedDate);
                            formattedYear = DateFormat('yyyy').format(pickedDate);
                            month = formattedMonth;
                            monthNumber = formattedMonthNumber;
                            year = formattedYear;
                            var firstDayThisMonth = DateTime(pickedDate.year, pickedDate.month, 1);
                            var firstDayNextMonth = DateTime(pickedDate.year, pickedDate.month + 1, 0);
                            start_date = DateFormat('yyyy-MM-dd').format(firstDayThisMonth);
                            end_date = DateFormat('yyyy-MM-dd').format(firstDayNextMonth);
                            print("object:::::$start_date::::$end_date:$firstDayNextMonth:::$firstDayThisMonth");
                            print("object:::$pickedDate:$month:::::$year::$monthNumber");
                            Provider.of<SupplierProvider>(context, listen: false).getSupplierPaymentList(context,PreferenceUtils.getString("${AppConstants.companyId}"),start_date,end_date,supplierDropDown.toString()).then((value) {
                              setState(() {
                                isLoading = false;
                              });
                            });
                          });
                        });
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: AppConstants.itemHeight*0.05,
                        margin: EdgeInsets.only(right: AppConstants.itemWidth*0.03,top: AppConstants.itemHeight*0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(month == ""?"Select Month":month,style: poppinsBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
                            const Icon(Icons.keyboard_arrow_down_outlined,color: ColorResources.BLACK,size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.01,vertical: AppConstants.itemHeight*0.01),
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
                  decoration: BoxDecoration(
                    color: ColorResources.GREY.withOpacity(0.05),
                    borderRadius:BorderRadius.circular(10),
                  ),
                  child: Consumer<SupplierProvider>(builder: (context, supplier, child) {
                    // for(int k=0;k<Provider.of<SupplierProvider>(context, listen: false).supplierList.length;k++){
                    //   if (int.parse(widget.supplierId==""?"0":widget.supplierId) == Provider.of<SupplierProvider>(context, listen: false).supplierList[k].intid) {
                    //     supplierDropDown = Provider.of<SupplierProvider>(context, listen: false).supplierList[k].intid!;
                    //     supplierName = "${Provider.of<SupplierProvider>(context, listen: false).supplierList[k].strCompanyName} (${Provider.of<SupplierProvider>(context, listen: false).supplierList[k].strContactPersonName})";
                    //   }
                    // }
                    return DropdownButtonHideUnderline(
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: AppConstants.itemWidth*0.80,
                              // height: AppConstants.itemHeight*0.05,
                              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*.005),
                              child: TypeAheadFormField<SupplierData>(
                                textFieldConfiguration: TextFieldConfiguration(
                                  controller: supplierController,
                                  keyboardType: TextInputType.text,
                                  onTap: () {
                                    supplierController.clear();
                                    supplierName = "";
                                  },
                                  style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: supplierName==""?ColorResources.GREY:ColorResources.BLACK),
                                  decoration: InputDecoration(
                                    hintText: widget.type=="New"?supplierName:'Select Supplier',
                                    hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: supplierName==""?ColorResources.GREY:ColorResources.BLACK),
                                    border: InputBorder.none,
                                  ),
                                ),
                                suggestionsCallback: (pattern) {
                                  // supplierName = "";
                                  // "${Provider.of<SupplierProvider>(context, listen: false).supplierList[i].strCompanyName} (${Provider.of<SupplierProvider>(context, listen: false).supplierList[i].strContactPersonName})"
                                  return supplier.supplierList.where((driver) =>
                                  driver.strCompanyName!.toLowerCase().contains(pattern.toLowerCase()) ||
                                      driver.strCompanyName!.toUpperCase().contains(pattern.toUpperCase()) ||
                                      driver.strContactPersonName!.toLowerCase().contains(pattern.toLowerCase()) ||
                                      driver.strContactPersonName!.toUpperCase().contains(pattern.toUpperCase()))
                                      .toList();
                                },
                                itemBuilder: (context, suggestion) {
                                  // supplierName = "";
                                  return Container(
                                    alignment: Alignment.centerLeft,
                                    height: AppConstants.itemHeight*0.05,
                                    padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                                    child: Text("${suggestion.strCompanyName} (${suggestion.strContactPersonName})",style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK)),
                                  );
                                },
                                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    )
                                ),
                                onSuggestionSelected: (suggestion) {
                                  setState(() {
                                    supplierName = "${suggestion.strCompanyName} (${suggestion.strContactPersonName})";
                                    supplierDropDown = suggestion.intid!;
                                    supplierController.text = supplierName!;
                                    AppConstants.closeKeyboard();
                                    Provider.of<SupplierProvider>(context, listen: false).getSupplierPaymentList(context,PreferenceUtils.getString("${AppConstants.companyId}"),start_date,end_date,supplierDropDown.toString()).then((value) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    });
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
                    );
                  },),
                ),
                Provider.of<SupplierProvider>(context, listen: false).isLoading
                    ?
                const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG,))
                    :
                Flexible(
                  child:
                  supplier.supplierPaymentList.isNotEmpty
                      ?
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: supplier.supplierPaymentList.length,
                    padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: AppConstants.itemHeight*0.003),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: ListTile(
                          horizontalTitleGap: AppConstants.itemHeight*0.01,
                          leading: Container(
                            alignment: Alignment.center,
                            width: AppConstants.itemWidth*0.12,
                            height: AppConstants.itemHeight*0.06,
                            decoration: BoxDecoration(
                              color: Color(Random().nextInt(0xffffffff)).withAlpha(0xff).withOpacity(0.30),
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Text(
                              supplier.supplierPaymentList[index].strSuppliername!.substring(0,1).toUpperCase(),
                              style: poppinsBlack.copyWith(fontSize: Dimensions.FONT_SIZE_18,color: ColorResources.BLACK),
                            ),
                          ),
                          title: Text("${supplier.supplierPaymentList[index].strSuppliername}",style: poppinsSemiBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_17),),
                          subtitle: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppConstants.date_chang(supplier.supplierPaymentList[index].dtpaymentdate.toString()),style: poppinsSemiBold.copyWith(color: ColorResources.GREY,fontSize: Dimensions.FONT_SIZE_15),),
                              Text("\u20b9 ${supplier.supplierPaymentList[index].decAmount}",style: poppinsBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
                            ],
                          ),
                          trailing: PopupMenuButton(
                            color: ColorResources.WHITE,
                            surfaceTintColor: ColorResources.WHITE,
                            elevation: 10,
                            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            onSelected: (result) {
                              if (result == 0) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddSupplierPayment(supplier.supplierPaymentList[index].intid.toString(),supplierDropDown.toString(),supplier.supplierPaymentList[index],"Edit"),));
                              }else{
                                showDialog<bool>(
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text("Are You Sure You Want to Delete ?"),
                                        contentTextStyle: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_16),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Provider.of<SupplierProvider>(context, listen: false).getDeleteSupplierPayment(context,supplier.supplierPaymentList[index].intid.toString()).then((value) {
                                                AppConstants.getToast("Deleted Successfully");
                                                Navigator.push(context, MaterialPageRoute(builder: (context) =>  SupplierPaymentList(supplierDropDown.toString(),""),));
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
                              }
                            },
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(value: 0,child: Row(
                                  children: [
                                    const Icon(Icons.edit,color: ColorResources.BLACK,),
                                    Text('Edit',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
                                  ],
                                )),
                                PopupMenuItem(value: 1,child: Row(
                                  children: [
                                    const Icon(Icons.delete,color: ColorResources.BLACK,),
                                    Text('Delete',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
                                  ],
                                )),
                              ];
                            },
                            child: const Icon(Icons.more_vert,color: ColorResources.BLACK,),
                          ),
                        ),
                      );
                    },)
                      :
                  DataNotFoundScreen("No Data Found"),
                ),
              ],
            ),
          ),
        ),
      );
    },);
  }

  String _startDate = '';
  String _enddate = '';

  String _getValueText(
      CalendarDatePicker2Type datePickerType,
      List<DateTime?> values,
      ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
          .map((v) => v.toString().replaceAll('00:00:00.000', ''))
          .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        DateTime parseDate =DateFormat("yyyy-MM-dd").parse(values[0].toString().replaceAll('00:00:00.000', ''),true);
        DateTime parsDate =DateFormat("yyyy-MM-dd").parse(values[1].toString().replaceAll('00:00:00.000', ''),true);
        var inputDate = DateTime.parse(parseDate.toLocal().toString());
        var inputsDate = DateTime.parse(parsDate.toLocal().toString());
        var outputFormat = DateFormat("yyyy-MM-dd");
        var outputDate = outputFormat.format(inputDate);
        var outputsDate = outputFormat.format(inputsDate);
        _startDate = outputDate;
        _enddate = outputsDate;
        Provider.of<SupplierProvider>(context, listen: false).getSupplierPaymentList(context,PreferenceUtils.getString(AppConstants.companyId.toString()),_startDate,_enddate,supplierDropDown.toString()).then((value) {
          setState(() {
            isLoading = false;
          });
        });
        valueText = '$_startDate to $_enddate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }

  List<DateTime?> _dialogCalendarPickerValue = [];

  _buildCalendarDialogButton() {
    const dayTextStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle = TextStyle(color: Colors.red[500], fontWeight: FontWeight.w600);
    final config = CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: ColorResources.LINE_BG,
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      firstDate: DateTime(1995),
      lastDate: DateTime.now(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      currentDate: DateTime.now(),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }

        return textStyle;
      },
    );
    return GestureDetector(
      onTap: () async {
        final values = await showCalendarDatePicker2Dialog(
          context: context,
          config: config,
          dialogSize: const Size(325, 400),
          borderRadius: BorderRadius.circular(15),
          value: _dialogCalendarPickerValue,
          dialogBackgroundColor: Colors.white,
        );
        if (values != null) {
          print("date::1:${_getValueText(config.calendarType, values,)}");
          print("date::2:$_startDate::$_enddate");
          setState(() {
            _dialogCalendarPickerValue = values;
            print("object::${_dialogCalendarPickerValue[0]}");
          });
        }
      },
      child: Container(
        alignment: Alignment.centerLeft,
        height: AppConstants.itemHeight*0.05,
        margin: EdgeInsets.only(left: AppConstants.itemWidth*0.03,top: AppConstants.itemHeight*0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(_startDate == "" ? "Select Date" : "${AppConstants.date_chang(_startDate)}  To  ${AppConstants.date_chang(_enddate)}",style: poppinsBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
            const Icon(Icons.keyboard_arrow_down_outlined,color: ColorResources.BLACK,size: 20),
          ],
        ),
      ),
    );
  }
}
