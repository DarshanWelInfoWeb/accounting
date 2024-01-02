import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:data_table_plus/data_table_plus.dart';
import 'package:flutter/material.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/dashboard_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/no_internet_screen.dart';
import 'package:gas_accounting/view/screen/dashboard/dashboard_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfitLossReport extends StatefulWidget {
  String startDate,endDate,type;
  ProfitLossReport(this.startDate,this.endDate,this.type,{super.key});

  @override
  State<ProfitLossReport> createState() => _ProfitLossReportState();
}

class _ProfitLossReportState extends State<ProfitLossReport> {
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
  late String start_date = '';
  late String end_date = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime today = DateTime.now();
    formattedDate = DateFormat('dd/MM/yyyy').format(today);
    formattedMonth = DateFormat('MMMM').format(today);
    formattedMonthNumber = DateFormat('MM').format(today);
    formattedYear = DateFormat('yyyy').format(today);
    month = formattedMonth;
    monthNumber = formattedMonthNumber;
    year = formattedYear;
    _startDate = widget.type != "Side" ? widget.startDate : _startDate;
    _enddate = widget.type != "Side" ? widget.endDate : _enddate;
    var firstDayThisMonth = DateTime(today.year, today.month, 1);
    var firstDayNextMonth = DateTime(today.year, today.month + 1, 0);
    start_date = DateFormat('yyyy/MM/dd').format(firstDayThisMonth);
    end_date = DateFormat('yyyy/MM/dd').format(firstDayNextMonth);
    _loadData(context, true);
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<DashboardProvider>(context, listen: false).getProfitAndLossReport(
          context,
          PreferenceUtils.getString(AppConstants.companyId.toString()),
          widget.type != "Side" ? widget.startDate: start_date,
          widget.type != "Side" ? widget.endDate: end_date).then((value) {
        setState(() {
          is_loading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, profit, child) {
      return WillPopScope(
        onWillPop: () async{
          Navigator.push(context,MaterialPageRoute(builder: (context) => Dashboard(widget.type != "Side" ?"":"Home"),));
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorResources.LINE_BG,
            centerTitle: true,
            leading: IconButton(onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => Dashboard(widget.type != "Side" ?"":"Home"),));
            }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
            title: Text("Profit And Loss Report",style: montserratSemiBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
          ),
          body:
          is_loading
              ?
          const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
              :
          Column(
            // shrinkWrap: true,
            // scrollDirection: Axis.vertical,
            // physics: const ClampingScrollPhysics(),
            // padding: EdgeInsets.symmetric(
            //     horizontal: AppConstants.itemWidth * 0.02,
            //     vertical: AppConstants.itemHeight * 0.01),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCalendarDialogButton(),
                    Container(
                      alignment: Alignment.center,
                      height: AppConstants.itemHeight*0.05,
                      margin: EdgeInsets.only(top: AppConstants.itemHeight*0.01),
                      child: Text('Profit: ${AppConstants.profitAmount} (${AppConstants.profit} %)',
                          style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                    )
                  ],
                ),
              ),
              Provider.of<DashboardProvider>(context, listen: false).isLoading
                  ?
              Padding(
                padding: EdgeInsets.only(top: AppConstants.itemHeight*0.35),
                child: const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG,)),
              )
                  :
              profit.profitLossList.isNotEmpty
                  ?
              Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.itemWidth * 0.02,
                          vertical: AppConstants.itemHeight * 0.0),
                      itemCount: profit.profitLossList.length,
                      itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: AppConstants.itemHeight*0.003),
                            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth * 0.01,vertical: AppConstants.itemHeight*0.01),
                            decoration: BoxDecoration(
                              color: index.isEven?Colors.white:Colors.grey.shade50,
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text("${profit.profitLossList[index].strInvoiceno}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: poppinsSemiBold.copyWith(
                                              color: ColorResources.BLACK,
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: Dimensions.FONT_SIZE_15),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: Text("${profit.profitLossList[index].dtInvoiceDate}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: poppinsSemiBold.copyWith(
                                              color: ColorResources.BLACK,
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: Dimensions.FONT_SIZE_15),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                                      child: Text("${profit.profitLossList[index].strCustomerName}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: poppinsSemiBold.copyWith(
                                            color: ColorResources.BLACK,
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: Dimensions.FONT_SIZE_15),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            "Qty",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: poppinsSemiBold.copyWith(color: ColorResources.GREY,
                                                overflow: TextOverflow.fade,
                                                fontSize: Dimensions.FONT_SIZE_14),
                                          ),
                                          Text(
                                            "${profit.profitLossList[index].totalQty!.round()}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: poppinsSemiBold.copyWith(color: ColorResources.BLACK,
                                                overflow: TextOverflow.fade,
                                                fontSize: Dimensions.FONT_SIZE_16),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "Sell Amount",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: poppinsSemiBold.copyWith(color: ColorResources.GREY,
                                                overflow: TextOverflow.fade,
                                                fontSize: Dimensions.FONT_SIZE_14),
                                          ),
                                          Text(
                                            "\u20b9 ${profit.profitLossList[index].decTotalSellAmount!.round()}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: poppinsSemiBold.copyWith(color: ColorResources.BLACK,
                                                overflow: TextOverflow.fade,
                                                fontSize: Dimensions.FONT_SIZE_16),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "\u20b9 Profit",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: poppinsSemiBold.copyWith(color: ColorResources.GREY,
                                                overflow: TextOverflow.fade,
                                                fontSize: Dimensions.FONT_SIZE_14),
                                          ),
                                          Text(
                                            "\u20b9 ${profit.profitLossList[index].decProfit!.round()}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: poppinsSemiBold.copyWith(color: ColorResources.BLACK,
                                                overflow: TextOverflow.fade,
                                                fontSize: Dimensions.FONT_SIZE_16),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "Profit %",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: poppinsSemiBold.copyWith(color: ColorResources.GREY,
                                                overflow: TextOverflow.fade,
                                                fontSize: Dimensions.FONT_SIZE_14),
                                          ),
                                          Text(
                                            "${profit.profitLossList[index].decTotalProfitPercentage}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: poppinsSemiBold.copyWith(color: ColorResources.BLACK,
                                                overflow: TextOverflow.fade,
                                                fontSize: Dimensions.FONT_SIZE_16),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: AppConstants.itemHeight*0.001,
                            child: Divider(color: ColorResources.GREY),
                          ),
                        ],
                      );
                    },),
                  )
              /*SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(top: AppConstants.itemHeight*0.01),
                  child: DataTable(
                    dividerThickness: 1,
                    columnSpacing: 10,
                    dataRowHeight: AppConstants.itemHeight*0.04,
                    headingRowHeight: AppConstants.itemHeight*0.04,
                    decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                    columns: [
                      DataColumn(label: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(05),
                        child: Text('Invoice No.',
                            style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                      )),
                      DataColumn(label: _verticalDivider),
                      DataColumn(label: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(05),
                        child: Text('Customer',
                            style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                      )),
                      DataColumn(label: _verticalDivider),
                      DataColumn(label: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(05),
                        child: Text('Date',
                            style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                      )),
                      DataColumn(label: _verticalDivider),
                      DataColumn(label: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(05),
                        child: Text('Qty',
                            style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                      )),
                      DataColumn(label: _verticalDivider),
                      DataColumn(label: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(05),
                        child: Text('Sell Amount',
                            style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                      )),
                      DataColumn(label: _verticalDivider),
                      DataColumn(label: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(05),
                        child: Text('Profit \u20b9',
                            style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                      )),
                      DataColumn(label: _verticalDivider),
                      DataColumn(label: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(05),
                        child: Text('Profit %',
                            style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                      )),
                    ],
                    rows: List.generate(profit.profitLossList.length, (index) {
                      return DataRowPlus(
                          cells: <DataCell>[
                            DataCell(Container( alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(05),child: Text("${profit.profitLossList[index].strInvoiceno}",style: poppinsBold.copyWith(color: ColorResources.BLACK),textAlign: TextAlign.center,))),
                            DataCell(Container(child: _verticalDivider)),
                            DataCell(Container( alignment: Alignment.center,
                                padding: const EdgeInsets.all(05),child: Text("${profit.profitLossList[index].strCustomerName}",style: poppinsBold.copyWith(color: ColorResources.BLACK),textAlign: TextAlign.center,))),
                            DataCell(Container(child: _verticalDivider)),
                            DataCell(Container( alignment: Alignment.center,
                                padding: const EdgeInsets.all(05),child: Text("${profit.profitLossList[index].dtInvoiceDate}",style: poppinsBold.copyWith(color: ColorResources.BLACK),textAlign: TextAlign.center,))),
                            DataCell(Container(child: _verticalDivider)),
                            DataCell(Container( alignment: Alignment.center,
                                padding: const EdgeInsets.all(05),child: Text("${profit.profitLossList[index].totalQty!.round()}",style: poppinsBold.copyWith(color: ColorResources.BLACK),))),
                            DataCell(Container(child: _verticalDivider)),
                            DataCell(Container( alignment: Alignment.center,
                                padding: const EdgeInsets.all(05),child: Text("\u20b9 ${profit.profitLossList[index].decTotalSellAmount!.round()}",style: poppinsBold.copyWith(color: ColorResources.BLACK),))),
                            DataCell(Container(child: _verticalDivider)),
                            DataCell(Container( alignment: Alignment.center,
                                padding: const EdgeInsets.all(05),child: Text("\u20b9 ${profit.profitLossList[index].decProfit!.round()}",style: poppinsBold.copyWith(color: ColorResources.BLACK),))),
                            DataCell(Container(child: _verticalDivider)),
                            DataCell(Container( alignment: Alignment.center,
                                padding: const EdgeInsets.all(05),child: Text("${profit.profitLossList[index].decTotalProfitPercentage}",style: poppinsBold.copyWith(color: ColorResources.BLACK),))),
                          ]
                      );
                    }),
                  ),
                ),
              )*/
                  :
              Padding(
                padding: EdgeInsets.only(top: AppConstants.itemHeight*0.18),
                child: DataNotFoundScreen("No Data Found"),
              )
            ],
          ),
        ),
      );
    },);
  }

  final Widget _verticalDivider = const VerticalDivider(
    color: Colors.black12,
    thickness: 1,
  );

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
        var outputFormat = widget.type != "Side"?DateFormat('yyyy/MM/dd'):DateFormat("MM/dd/yyyy");
        var outputDate = outputFormat.format(inputDate);
        var outputsDate = outputFormat.format(inputsDate);
        _startDate = outputDate;
        _enddate = outputsDate;
        Provider.of<DashboardProvider>(context, listen: false).getProfitAndLossReport(context,PreferenceUtils.getString(AppConstants.companyId.toString()),_startDate,_enddate,).then((value) {
          setState(() {
            is_loading = false;
          });
        });
        // values.length > 1
        //     ? values[1].toString().replaceAll('00:00:00.000', '')
        //     : 'null';
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
      lastDate: DateTime(2040),
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
        margin: EdgeInsets.only(left: AppConstants.itemWidth*0.01,top: AppConstants.itemHeight*0.01),
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
