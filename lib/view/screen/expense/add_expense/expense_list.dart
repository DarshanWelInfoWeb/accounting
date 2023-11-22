import 'dart:math';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/expense_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/no_internet_screen.dart';
import 'package:gas_accounting/view/screen/dashboard/dashboard_screen.dart';
import 'package:gas_accounting/view/screen/expense/add_expense/add_new_expense.dart';
import 'package:gas_accounting/view/screen/expense/add_expense/edit_expense.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

import '../../../../utill/color_resources.dart';

class Expense_List extends StatefulWidget {
  String startDate,endDate,type;
  Expense_List(this.startDate,this.endDate,this.type,{super.key});

  @override
  State<Expense_List> createState() => _Expense_ListState();
}

class _Expense_ListState extends State<Expense_List> {
  bool is_loading = true;
  double decTotalAmount = 0.0;
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
  String _startDate = '';
  String _enddate = '';

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
    _startDate = widget.type != "Expense" ? widget.startDate: _startDate;
    _enddate = widget.type != "Expense" ? widget.endDate: _enddate;
    var firstDayThisMonth = DateTime(today.year, today.month, 1);
    var firstDayNextMonth = DateTime(today.year, today.month + 1, 0);
    start_date = DateFormat('yyyy/MM/dd').format(firstDayThisMonth);
    end_date = DateFormat('yyyy/MM/dd').format(firstDayNextMonth);
    print("object:::::$start_date::${widget.startDate}:${widget.endDate}:$end_date:$firstDayNextMonth:::$firstDayThisMonth");
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<ExpenseProvider>(context, listen: false).getExpenseList(
          context,
          PreferenceUtils.getString("${AppConstants.companyId}"),
          widget.type != "Expense" ? widget.startDate: start_date,
          widget.type != "Expense" ? widget.endDate: end_date).then((value) {
        setState(() {
          is_loading = false;
          for(int i=0;i<Provider.of<ExpenseProvider>(context, listen: false).expenseList.length;i++){
            decTotalAmount = Provider.of<ExpenseProvider>(context, listen: false).expenseList[i].decTotalAmount!;
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.push(context,MaterialPageRoute(builder: (context) => Dashboard(widget.type != "Expense" ?"":"Home")));
        return true;
      },
      child: Consumer<ExpenseProvider>(builder: (context, expense, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorResources.LINE_BG,
            centerTitle: true,
            leading: IconButton(onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => Dashboard(widget.type != "Expense" ?"":"Home")));
            }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
            title: Text("Expense",style: montserratBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
          ),
          floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100)
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Add_New_Expense(),));
            },
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
            child:
            Column(
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
                            start_date = DateFormat('yyyy/MM/dd').format(firstDayThisMonth);
                            end_date = DateFormat('yyyy/MM/dd').format(firstDayNextMonth);
                            print("object:::::$start_date::::$end_date:$firstDayNextMonth:::$firstDayThisMonth");
                            print("object:::$pickedDate:$month:::::$year::$monthNumber");
                            Provider.of<ExpenseProvider>(context, listen: false).getExpenseList(context,PreferenceUtils.getString("${AppConstants.companyId}"),start_date,end_date).then((value) {
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
                Provider.of<ExpenseProvider>(context, listen: false).isLoading
                    ?
                Padding(
                  padding: EdgeInsets.only(top: AppConstants.itemHeight*0.35),
                  child: const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG,)),
                )
                    :
                Flexible(
                  child:
                  expense.expenseList.isNotEmpty
                      ?
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: expense.expenseList.length,
                    padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
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
                              expense.expenseList[index].expenseType!.substring(0,1).toUpperCase(),
                              style: poppinsBlack.copyWith(fontSize: Dimensions.FONT_SIZE_18,color: ColorResources.BLACK),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${expense.expenseList[index].expenseType}",style: poppinsSemiBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_17),),
                                  SizedBox(width: AppConstants.itemWidth*0.01),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "${expense.expenseList[index].strTitle}",
                                        style: poppinsSemiBold.copyWith(
                                            color: ColorResources.BLACK,
                                            fontSize: Dimensions.FONT_SIZE_14),
                                      )),
                                  Text("${expense.expenseList[index].dtDate}",style: poppinsSemiBold.copyWith(color: ColorResources.GREY,fontSize: Dimensions.FONT_SIZE_14),)
                                ],
                              ),
                              Text("\u20b9 ${expense.expenseList[index].decAmount}",style: poppinsBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
                            ],
                          ),
                          trailing: PopupMenuButton(
                            color: ColorResources.WHITE,
                            surfaceTintColor: ColorResources.WHITE,
                            elevation: 10,
                            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            onSelected: (result) {
                              if (result == 0) {
                                print("object::${expense.expenseList[index].intId.toString()}");
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Edit_Expense(expense.expenseList[index].intId.toString(),expense.expenseList[index].expenseType.toString()),));
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
                                              print("object::${expense.expenseList[index].intId.toString()}");
                                              Provider.of<ExpenseProvider>(context, listen: false).getDeleteExpense(context,expense.expenseList[index].intId.toString()).then((value) {
                                                AppConstants.getToast("Deleted Successfully");
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => Expense_List("","","Expense"),));
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
                                    Text('Edit',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
                                  ],
                                )),
                                PopupMenuItem(value: 1,child: Row(
                                  children: [
                                    const Icon(Icons.delete,color: ColorResources.BLACK,),
                                    Text('Delete',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
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
        var outputFormat = DateFormat("yyyy/MM/dd");
        var outputDate = outputFormat.format(inputDate);
        var outputsDate = outputFormat.format(inputsDate);
        _startDate = outputDate;
        _enddate = outputsDate;
        Provider.of<ExpenseProvider>(context, listen: false).getExpenseList(context,PreferenceUtils.getString("${AppConstants.companyId}"),_startDate,_enddate).then((value) {
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
          // ignore: avoid_print
          print("date::1:${_getValueText(config.calendarType, values,)}");
          print("date:s:2:$_startDate::$_enddate");
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
            Text(_startDate == "" ? "Select Date" : "${AppConstants.date_changs(_startDate)}  To  ${AppConstants.date_changs(_enddate)}",style: poppinsBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
            const Icon(Icons.keyboard_arrow_down_outlined,color: ColorResources.BLACK,size: 20),
          ],
        ),
      ),
    );
  }
}
