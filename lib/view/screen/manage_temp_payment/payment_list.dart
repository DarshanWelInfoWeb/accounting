import 'dart:math';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gas_accounting/data/model/response/driver_response.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/payment_provider.dart';
import 'package:gas_accounting/provider/route_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:gas_accounting/view/basewidget/no_internet_screen.dart';
import 'package:gas_accounting/view/screen/dashboard/dashboard_screen.dart';
import 'package:gas_accounting/view/screen/manage_temp_payment/add_temp_payment.dart';
import 'package:gas_accounting/view/screen/manage_temp_payment/edit_payment.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

class TempPaymentList extends StatefulWidget {
  String customerId,type;
  TempPaymentList(this.customerId,this.type,{Key? key}) : super(key: key);

  @override
  State<TempPaymentList> createState() => _TempPaymentListState();
}

class _TempPaymentListState extends State<TempPaymentList> {
  TextEditingController customerController = TextEditingController();
  bool is_loading = true;
  late String formattedMonth = '';
  late String formattedMonthNumber = '';
  late String formattedYear = '';
  late String month = '';
  late String monthNumber = '0';
  late String year = '0';
  TimeOfDay selectedTime = TimeOfDay.now();
  late String formattedDate = '';
  late String date_shcedule = '';
  DateTime? selectedDate;
  late String start_date = '';
  late String end_date = '';
  DateTime? startDate;
  DateTime? endDate;
  String routeName = "";
  String? customerName;
  int customerDropDown = 0;

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
    var firstDayThisMonth = DateTime(today.year, today.month, 1);
    var firstDayNextMonth = DateTime(today.year, today.month + 1, 0);
    start_date = DateFormat('MM/dd/yyyy').format(firstDayThisMonth);
    end_date = DateFormat('MM/dd/yyyy').format(firstDayNextMonth);
    print("object:::::$start_date::::$end_date:$firstDayNextMonth:::$firstDayThisMonth");
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<PaymentProvider>(context, listen: false).getPaymentList(
          context,
          PreferenceUtils.getString(AppConstants.companyId.toString()),
          start_date,
          end_date,
          widget.customerId==""?"0":widget.customerId).then((value) {
        setState(() {
          is_loading = false;
        });
      });
      Provider.of<RouteProvider>(context, listen: false).getSelectRoute(context,PreferenceUtils.getString("${AppConstants.companyId}")).then((value) {
        setState(() {
          is_loading = false;
        });
      });
      Provider.of<RouteProvider>(context, listen: false).getDriverHelper(context,PreferenceUtils.getString("${AppConstants.companyId}"),"3").then((value) {
        setState(() {
          is_loading = false;
          for(int i=0;i<Provider.of<RouteProvider>(context, listen: false).driverList.length;i++){
            if (int.parse(widget.customerId==""?"0":widget.customerId) == Provider.of<RouteProvider>(context, listen: false).driverList[i].intId) {
              customerDropDown = int.parse(widget.customerId);
              customerName = Provider.of<RouteProvider>(context, listen: false).driverList[i].srtFullName;
            }
          }
        });
      });
    });
  }

  String _startDate = '';
  String _enddate = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.push(context,MaterialPageRoute(builder: (context) => Dashboard("Home"),));
        return true;
      },
      child: Consumer<PaymentProvider>(builder: (context, payment, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorResources.LINE_BG,
            centerTitle: true,
            leading: IconButton(onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => Dashboard("Home"),));
            }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
            title: Text("Payment",style: montserratSemiBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddTempPayment(0,0),));
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)
            ),
            backgroundColor: ColorResources.LINE_BG,
            child: const Icon(Icons.add,size: 40,color: ColorResources.WHITE),
          ),
          body:
          is_loading
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
            child: Column(
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
                            start_date = DateFormat('MM/dd/yyyy').format(firstDayThisMonth);
                            end_date = DateFormat('MM/dd/yyyy').format(firstDayNextMonth);
                            print("object:::::$start_date::::$end_date:$firstDayNextMonth:::$firstDayThisMonth");
                            print("object:::$pickedDate:$month:::::$year::$monthNumber");
                            Provider.of<PaymentProvider>(context, listen: false).getPaymentList(context,PreferenceUtils.getString("${AppConstants.companyId}"),start_date,end_date,customerDropDown.toString()).then((value) {
                              setState(() {
                                is_loading = false;
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
                  child: Consumer<RouteProvider>(builder: (context, customer, child) {
                    for(int k=0;k<Provider.of<RouteProvider>(context, listen: false).driverList.length;k++){
                      if (int.parse(widget.customerId==""?"0":widget.customerId) == Provider.of<RouteProvider>(context, listen: false).driverList[k].intId) {
                        customerDropDown = Provider.of<RouteProvider>(context, listen: false).driverList[k].intId!;
                        customerName = Provider.of<RouteProvider>(context, listen: false).driverList[k].srtFullName.toString();
                      }
                    }
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
                                    hintText: widget.type != ""?customerName:'Select Customer',
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
                                  return Container(
                                    alignment: Alignment.centerLeft,
                                    height: AppConstants.itemHeight*0.05,
                                    padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                                    child: Text(suggestion.srtFullName.toString(),style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK)),
                                  );
                                },
                                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    )
                                ),
                                onSuggestionSelected: (suggestion) {
                                  setState(() {
                                    customerName = suggestion.srtFullName!;
                                    customerDropDown = suggestion.intId!;
                                    customerController.text = customerName!;
                                    AppConstants.closeKeyboard();
                                    Provider.of<PaymentProvider>(context, listen: false).getPaymentList(context,PreferenceUtils.getString("${AppConstants.companyId}"),start_date,end_date,customerDropDown.toString()).then((value) {
                                      setState(() {
                                        is_loading = false;
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
                Provider.of<PaymentProvider>(context, listen: false).isLoading
                    ?
                const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG,))
                    :
                Flexible(
                  child:
                  payment.paymentList.isNotEmpty
                      ?
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: payment.paymentList.length,
                    padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
                    itemBuilder: (context, index) {
                      for(int k=0;k<Provider.of<RouteProvider>(context, listen: false).selectrouteList.length;k++){
                        if (payment.paymentList[index].intRouteid == Provider.of<RouteProvider>(context, listen: false).selectrouteList[k].intId) {
                          routeName = Provider.of<RouteProvider>(context, listen: false).selectrouteList[k].strRoute.toString();
                        }
                      }
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: AppConstants.itemHeight*0.003),
                        padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.01,vertical: AppConstants.itemHeight*0.01),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: AppConstants.itemWidth*0.11,
                              height: AppConstants.itemHeight*0.055,
                              decoration: BoxDecoration(
                                color: Color(Random().nextInt(0xffffffff)).withAlpha(0xff).withOpacity(0.30),
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Text(
                                payment.paymentList[index].customerName!.substring(0,1).toUpperCase(),
                                style: poppinsBlack.copyWith(fontSize: Dimensions.FONT_SIZE_18,color: ColorResources.BLACK),
                              ),
                            ),
                            SizedBox(width: AppConstants.itemWidth * 0.03),
                            Container(
                              alignment: Alignment.centerLeft,
                              width: AppConstants.itemWidth*0.66,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${payment.paymentList[index].customerName}",style: poppinsSemiBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_17),),
                                      Text("\u20b9 ${payment.paymentList[index].decGrandTotal}",style: poppinsBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Date :- ${AppConstants.date_chang(payment.paymentList[index].dtPaymentDate.toString())}",style: poppinsSemiBold.copyWith(color: ColorResources.GREY,fontSize: Dimensions.FONT_SIZE_14),),
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: AppConstants.itemWidth*0.66,
                                    child: Text("Route :- $routeName",maxLines: 1,overflow: TextOverflow.ellipsis,style: poppinsSemiBold.copyWith(color: ColorResources.GREY,fontSize: Dimensions.FONT_SIZE_14),)),
                                ],
                              ),
                            ),
                            PopupMenuButton(
                              color: ColorResources.WHITE,
                              surfaceTintColor: ColorResources.WHITE,
                              elevation: 10,
                              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              onSelected: (result) {
                                if (result == 0) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditTempPayment(payment.paymentList[index].intId.toString(),"edit"),));
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
                                                Provider.of<PaymentProvider>(context, listen: false).getDeletePayment(context,"${payment.paymentList[index].intId}").then((value) {
                                                  AppConstants.getToast("Deleted Successfully");
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => TempPaymentList(customerDropDown.toString(),""),));
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
                          ],
                        ),
                      );
                    },)
                      :
                  DataNotFoundScreen("No Data Found"),
                ),
              ],
            ),
          ),
        );
      },),
    );
  }

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
        var outputFormat = DateFormat("MM/dd/yyyy");
        var outputDate = outputFormat.format(inputDate);
        var outputsDate = outputFormat.format(inputsDate);
        _startDate = outputDate;
        _enddate = outputsDate;
        Provider.of<PaymentProvider>(context, listen: false).getPaymentList(context,PreferenceUtils.getString(AppConstants.companyId.toString()),_startDate,_enddate,customerDropDown.toString()).then((value) {
          setState(() {
            is_loading = false;
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
    // final anniversaryTextStyle = TextStyle(
    //   color: Colors.red[400],
    //   fontWeight: FontWeight.w700,
    //   decoration: TextDecoration.underline,
    // );
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
        // if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
        //   textStyle = anniversaryTextStyle;
        // }
        return textStyle;
      },
      // dayBuilder: ({
      //   required date,
      //   textStyle,
      //   decoration,
      //   isSelected,
      //   isDisabled,
      //   isToday,
      // }) {
      //   Widget? dayWidget;
      //   if (date.day % 3 == 0 && date.day % 9 != 0) {
      //     dayWidget = Container(
      //       decoration: decoration,
      //       child: Center(
      //         child: Stack(
      //           alignment: AlignmentDirectional.center,
      //           children: [
      //             Text(
      //               MaterialLocalizations.of(context).formatDecimal(date.day),
      //               style: textStyle,
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.only(top: 27.5),
      //               child: Container(
      //                 height: 4,
      //                 width: 4,
      //                 decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(5),
      //                   color: isSelected == true
      //                       ? Colors.white
      //                       : Colors.grey[500],
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //   }
      //   return dayWidget;
      // },
      // yearBuilder: ({
      //   required year,
      //   decoration,
      //   isCurrentYear,
      //   isDisabled,
      //   isSelected,
      //   textStyle,
      // }) {
      //   return Center(
      //     child: Container(
      //       decoration: decoration,
      //       height: 36,
      //       width: 72,
      //       child: Center(
      //         child: Semantics(
      //           selected: isSelected,
      //           button: true,
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Text(
      //                 year.toString(),
      //                 style: textStyle,
      //               ),
      //               if (isCurrentYear == true)
      //                 Container(
      //                   padding: const EdgeInsets.all(5),
      //                   margin: const EdgeInsets.only(left: 5),
      //                   decoration: const BoxDecoration(
      //                     shape: BoxShape.circle,
      //                     color: Colors.redAccent,
      //                   ),
      //                 ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   );
      // },
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
          // ignore: avoid_print
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
            Text(_startDate == "" ? "Select Date" : "${AppConstants.changeDateToMDY(_startDate)}  To  ${AppConstants.changeDateToMDY(_enddate)}",style: poppinsBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
            const Icon(Icons.keyboard_arrow_down_outlined,color: ColorResources.BLACK,size: 20),
          ],
        ),
      ),
    );
  }
}
