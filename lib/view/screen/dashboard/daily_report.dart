import 'package:data_table_plus/data_table_plus.dart';
import 'package:flutter/material.dart';
import 'package:gas_accounting/data/model/response/dailywise_response.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/dashboard_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/custom_password_textfield.dart';
import 'package:gas_accounting/view/basewidget/no_internet_screen.dart';
import 'package:gas_accounting/view/screen/dashboard/dashboard_screen.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

class DailyReport extends StatefulWidget {
  const DailyReport({super.key});

  @override
  State<DailyReport> createState() => _DailyReportState();
}

class _DailyReportState extends State<DailyReport> {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  FocusNode startDateCode = FocusNode();
  FocusNode endDateCode = FocusNode();

  bool isLoading = true;
  bool isLoadings = true;
  late String formattedDate = '';
  late String start_date = '';
  late String end_date = '';
  int intPageSize = 0;
  int intPageSizes = 0;
  DateTime selectedTime = DateTime.now();
  DateTime? birthday;
  final date2 = DateTime.now();
  DateTime currentDate = DateTime.now();
  late String formattedMonth = '';
  late String formattedMonthNumber = '';
  late String formattedYear = '';
  late String month = '';
  late String monthNumber = '0';
  late String year = '0';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime today = DateTime.now();
    intPageSize = today.difference(date2).inDays;
    formattedDate = DateFormat('dd/MM/yyyy').format(today);
    formattedMonth = DateFormat('MMMM').format(today);
    formattedMonthNumber = DateFormat('MM').format(today);
    formattedYear = DateFormat('yyyy').format(today);
    month = formattedMonth;
    monthNumber = formattedMonthNumber;
    year = formattedYear;
    startDateController.text = month;
    var firstDayThisMonth = DateTime(today.year, today.month, 1);
    var firstDayNextMonth = DateTime(today.year, today.month + 1, 0);
    start_date = DateFormat('dd/MM/yyyy').format(firstDayThisMonth);
    endDateController.text = DateFormat('dd/MM/yyyy').format(firstDayNextMonth);
    print("object:::$intPageSize::::$start_date::::${endDateController.text}::$firstDayNextMonth:::$firstDayThisMonth");
    _loadData(context, true);
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<DashboardProvider>(context, listen: false).getDailyWiseReport(context,PreferenceUtils.getString(AppConstants.companyId.toString()),AppConstants.date_change(start_date),AppConstants.date_change(endDateController.text)).then((value) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  void _date_pik_start() {
    // showDatePicker(
    //     builder: (context, child) {
    //       return Theme(
    //         data: Theme.of(context).copyWith(
    //           colorScheme: const ColorScheme.light(
    //             primary: ColorResources.LINE_BG, // header background color
    //             onPrimary: ColorResources.WHITE, // header text color
    //             onSurface: ColorResources.BLACK, // body text color
    //           ),
    //           textButtonTheme: TextButtonThemeData(
    //             style: TextButton.styleFrom(
    //               primary: ColorResources.LINE_BG, // button text color
    //             ),
    //           ),
    //         ),
    //         child: child!,
    //       );
    //     },
    // initialEntryMode: DatePickerEntryMode.calendarOnly,
    //     context: context,
    //     currentDate: currentDate,
    //     initialDate: DateTime.now(),
    //     firstDate: DateTime(1970),
    //     lastDate: DateTime(2040))
    //     .then((pickedDate) {
    //   if (pickedDate == null) {
    //     return;
    //   }
    //   setState(() {
    //     formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
    //     startDateController.text = formattedDate;
    //     birthday = pickedDate;
    //     intPageSize = int.parse("${currentDate.difference(birthday!).inDays}");
    //     print("object:::$intPageSize");
    //     Provider.of<DashboardProvider>(context, listen: false).getDailyWiseReport(context,PreferenceUtils.getString(AppConstants.companyId.toString()),AppConstants.date_change(startDateController.text),AppConstants.date_change(endDateController.text),"${intPageSize + 1}","1").then((value) {
    //       setState(() {
    //         isLoading = false;
    //       });
    //     });
    //   });
    // });
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
        formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
        startDateController.text = formattedMonth;
        selectedTime = pickedDate;
        intPageSize = DateTime(pickedDate.year, pickedDate.month, pickedDate.day).difference(pickedDate).inDays;
        formattedMonth = DateFormat('MMMM').format(pickedDate);
        formattedMonthNumber = DateFormat('MM').format(pickedDate);
        formattedYear = DateFormat('yyyy').format(pickedDate);
        month = formattedMonth;
        monthNumber = formattedMonthNumber;
        year = formattedYear;
        startDateController.text = month;
        var firstDayThisMonth = DateTime(pickedDate.year, pickedDate.month, 1);
        var firstDayNextMonth = DateTime(pickedDate.year, pickedDate.month + 1, 0);
        start_date = DateFormat('dd/MM/yyyy').format(firstDayThisMonth);
        endDateController.text = DateFormat('dd/MM/yyyy').format(firstDayNextMonth);
        print("object:::$pickedDate:$month:::::$intPageSize:::::$firstDayThisMonth:::::$firstDayNextMonth");
        Provider.of<DashboardProvider>(context, listen: false).getDailyWiseReport(context,PreferenceUtils.getString(AppConstants.companyId.toString()),AppConstants.date_change(start_date),AppConstants.date_change(endDateController.text)).then((value) {
          setState(() {
            isLoading = false;
          });
        });
      });
    });
  }


  final Widget _verticalDivider = const VerticalDivider(
    color: Colors.black12,
    thickness: 1,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, dashboard, child) {
      return WillPopScope(
        onWillPop: () async{
          Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard("Home"),));
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorResources.LINE_BG,
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard("Home"),));
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: ColorResources.WHITE,
                  size: 25,
                )),
            title: Text(
              "Daily Report",
              style: montserratSemiBold.copyWith(
                  color: ColorResources.WHITE, fontSize: Dimensions.FONT_SIZE_20),
            ),
          ),
          body:
          isLoading
              ?
          const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
              :
          ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.itemWidth * 0.02,
                vertical: AppConstants.itemHeight * 0.01),
            children: [
              InkWell(
                onTap: () {
                  _date_pik_start();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                          top: AppConstants.itemHeight * 0.02,
                          left: AppConstants.itemWidth * 0.02),
                      child: Text("Select Month",
                          style: poppinsBold.copyWith(
                              fontSize: Dimensions.FONT_SIZE_16)),
                    ),
                    Container(
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
                  ],
                ),
              ),
              /*GestureDetector(
                onTap: () {
                  _date_pik_start();
                  print("object:::$start_date");
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.itemWidth * 0.02,
                      vertical: AppConstants.itemHeight * 0.01),
                  child: CustomDateTextField(
                    controller: startDateController,
                    focusNode: startDateCode,
                    nextNode: endDateCode,
                    hintTxt: "Please Select Month",
                  ),
                ),
              ),*/
              Provider.of<DashboardProvider>(context, listen: false).isLoading
                  ?
              Padding(
                padding: EdgeInsets.only(top: AppConstants.itemHeight*0.35),
                child: const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG,)),
              )
                  :
              dashboard.dailyWiseList.isNotEmpty
                  ?
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(top: AppConstants.itemHeight*0.01),
                  child:
                    /*PaginatedDataTable(
                        columnSpacing: 10,
                        dataRowHeight: AppConstants.itemHeight * 0.04,
                        headingRowHeight: AppConstants.itemHeight * 0.04,
                        columns: [
                          DataColumn(label: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(05),
                            child: Text('Date',
                                style: montserratBold.copyWith(color: ColorResources.BLACK)),
                          )),
                          DataColumn(label: _verticalDivider),
                          DataColumn(label: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(05),
                            child: Text('Sale',
                                style: montserratBold.copyWith(color: ColorResources.BLACK)),
                          )),
                          DataColumn(label: _verticalDivider),
                          DataColumn(label: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(05),
                            child: Text('Payment',
                                style: montserratBold.copyWith(color: ColorResources.BLACK)),
                          )),
                          DataColumn(label: _verticalDivider),
                          DataColumn(label: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(05),
                            child: Text('Online',
                                style: montserratBold.copyWith(color: ColorResources.BLACK)),
                          )),
                          DataColumn(label: _verticalDivider),
                          DataColumn(label: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(05),
                            child: Text('Cash',
                                style: montserratBold.copyWith(color: ColorResources.BLACK)),
                          )),
                          DataColumn(label: _verticalDivider),
                          DataColumn(label: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(05),
                            child: Text('Purchase',
                                style: montserratBold.copyWith(color: ColorResources.BLACK)),
                          )),
                          DataColumn(label: _verticalDivider),
                          DataColumn(label: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(05),
                            child: Text('Online Purchase',
                                style: montserratBold.copyWith(color: ColorResources.BLACK)),
                          )),
                          DataColumn(label: _verticalDivider),
                          DataColumn(label: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(05),
                            child: Text('Cash Purchase',
                                style: montserratBold.copyWith(color: ColorResources.BLACK)),
                          )),
                          DataColumn(label: _verticalDivider),
                          DataColumn(label: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(05),
                            child: Text('Expense',
                                style: montserratBold.copyWith(color: ColorResources.BLACK)),
                          )),
                          DataColumn(label: _verticalDivider),
                          DataColumn(label: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(05),
                            child: Text('Balance',
                                style: montserratBold.copyWith(color: ColorResources.BLACK)),
                          )),
                          DataColumn(label: _verticalDivider),
                          DataColumn(label: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(05),
                            child: Text('Online Balance',
                                style: montserratBold.copyWith(color: ColorResources.BLACK)),
                          )),
                          DataColumn(label: _verticalDivider),
                          DataColumn(label: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(05),
                            child: Text('Cash Balance',
                                style: montserratBold.copyWith(color: ColorResources.BLACK)),
                          )),
                        ],
                        source: MyData(dashboard.dailyWiseList))*/
                  DataTable(
                      dividerThickness: 1,
                      columnSpacing: 10,
                      // showBottomBorder: true,
                      dataRowHeight: AppConstants.itemHeight*0.04,
                      headingRowHeight: AppConstants.itemHeight*0.04,
                      decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                      columns: [
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
                          child: Text('Sale',
                              style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                        )),
                        DataColumn(label: _verticalDivider),
                        DataColumn(label: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(05),
                          child: Text('Payment',
                              style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                        )),
                        DataColumn(label: _verticalDivider),
                        DataColumn(label: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(05),
                          child: Text('Online',
                              style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                        )),
                        DataColumn(label: _verticalDivider),
                        DataColumn(label: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(05),
                          child: Text('Cash',
                              style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                        )),
                        DataColumn(label: _verticalDivider),
                        DataColumn(label: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(05),
                          child: Text('Purchase',
                              style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                        )),
                        DataColumn(label: _verticalDivider),
                        DataColumn(label: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(05),
                          child: Text('Online Purchase',
                              style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                        )),
                        DataColumn(label: _verticalDivider),
                        DataColumn(label: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(05),
                          child: Text('Cash Purchase',
                              style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                        )),
                        DataColumn(label: _verticalDivider),
                        DataColumn(label: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(05),
                          child: Text('Expense',
                              style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                        )),
                        DataColumn(label: _verticalDivider),
                        DataColumn(label: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(05),
                          child: Text('Balance',
                              style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                        )),
                        DataColumn(label: _verticalDivider),
                        DataColumn(label: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(05),
                          child: Text('Online Balance',
                              style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                        )),
                        DataColumn(label: _verticalDivider),
                        DataColumn(label: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(05),
                          child: Text('Cash Balance',
                              style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                        )),
                      ],
                      rows: List.generate(dashboard.dailyWiseList.length, (index) {
                        return DataRowPlus(
                          cells: <DataCell>[
                            DataCell(Container( alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(05),child: Text("${dashboard.dailyWiseList[index].dtDate}",style: poppinsBold.copyWith(color: ColorResources.BLACK),textAlign: TextAlign.center,))),
                            DataCell(Container(child: _verticalDivider)),
                            DataCell(Container( alignment: Alignment.center,
                                padding: const EdgeInsets.all(05),child: Text("\u20b9 ${dashboard.dailyWiseList[index].decSale!.round()}",style: poppinsBold.copyWith(color: ColorResources.BLACK),textAlign: TextAlign.center,))),
                            DataCell(Container(child: _verticalDivider)),
                            DataCell(Container( alignment: Alignment.center,
                                padding: const EdgeInsets.all(05),child: Text("\u20b9 ${dashboard.dailyWiseList[index].decPayment!.round()}",style: poppinsBold.copyWith(color: ColorResources.BLACK),textAlign: TextAlign.center,))),
                            DataCell(Container(child: _verticalDivider)),
                            DataCell(Container( alignment: Alignment.center,
                                padding: const EdgeInsets.all(05),child: Text("\u20b9 ${dashboard.dailyWiseList[index].decOnline!.round()}",style: poppinsBold.copyWith(color: ColorResources.BLACK),))),
                            DataCell(Container(child: _verticalDivider)),
                            DataCell(Container( alignment: Alignment.center,
                                padding: const EdgeInsets.all(05),child: Text("\u20b9 ${dashboard.dailyWiseList[index].decCash!.round()}",style: poppinsBold.copyWith(color: ColorResources.BLACK),))),
                            DataCell(Container(child: _verticalDivider)),
                            DataCell(Container( alignment: Alignment.center,
                                padding: const EdgeInsets.all(05),child: Text("\u20b9 ${dashboard.dailyWiseList[index].decPurchase!.round()}",style: poppinsBold.copyWith(color: ColorResources.BLACK),))),
                            DataCell(Container(child: _verticalDivider)),
                            DataCell(Container( alignment: Alignment.center,
                                padding: const EdgeInsets.all(05),child: Text("\u20b9 ${dashboard.dailyWiseList[index].decOnlinePurchase!.round()}",style: poppinsBold.copyWith(color: ColorResources.BLACK),))),
                            DataCell(Container(child: _verticalDivider)),
                            DataCell(Container( alignment: Alignment.center,
                                padding: const EdgeInsets.all(05),child: Text("\u20b9 ${dashboard.dailyWiseList[index].decCashPurchase!.round()}",style: poppinsBold.copyWith(color: ColorResources.BLACK),))),
                            DataCell(Container(child: _verticalDivider)),
                            DataCell(Container( alignment: Alignment.center,
                                padding: const EdgeInsets.all(05),child: Text("\u20b9 ${dashboard.dailyWiseList[index].decExpense!.round()}",style: poppinsBold.copyWith(color: ColorResources.BLACK),))),
                            DataCell(Container(child: _verticalDivider)),
                            DataCell(Container( alignment: Alignment.center,
                                padding: const EdgeInsets.all(05),child: Text("\u20b9 ${dashboard.dailyWiseList[index].decTotalAmount!.round()}",style: poppinsBold.copyWith(color: ColorResources.BLACK),))),
                            DataCell(Container(child: _verticalDivider)),
                            DataCell(Container( alignment: Alignment.center,
                                padding: const EdgeInsets.all(05),child: Text("\u20b9 ${dashboard.dailyWiseList[index].decOnlineAmount!.round()}",style: poppinsBold.copyWith(color: ColorResources.BLACK),))),
                            DataCell(Container(child: _verticalDivider)),
                            DataCell(Container( alignment: Alignment.center,
                                padding: const EdgeInsets.all(05),child: Text("\u20b9 ${dashboard.dailyWiseList[index].decCashAmount!.round()}",style: poppinsBold.copyWith(color: ColorResources.BLACK),))),
                          ],
                        );
                      })
                  ),
                ),
              )
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
}

class MyData extends DataTableSource {
  final List<DailyWiseReportData> data;
  MyData(this.data);

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    final DailyWiseReportData result = data[index];

    return DataRow.byIndex(index: index, cells: <DataCell>[
      DataCell(Container( alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(05),child: Text("${result.dtDate}",style: montserratBold.copyWith(color: ColorResources.BLACK),textAlign: TextAlign.center,))),
      DataCell(Container(child: const VerticalDivider(
        color: Colors.black12,
        thickness: 1,
      ))),
      DataCell(Container( alignment: Alignment.center,
          padding: const EdgeInsets.all(05),child: Text("\u20b9 ${result.decSale!.round()}",style: montserratBold.copyWith(color: ColorResources.BLACK),textAlign: TextAlign.center,))),
      DataCell(Container(child: const VerticalDivider(
        color: Colors.black12,
        thickness: 1,
      ))),
      DataCell(Container( alignment: Alignment.center,
          padding: const EdgeInsets.all(05),child: Text("\u20b9 ${result.decPayment!.round()}",style: montserratBold.copyWith(color: ColorResources.BLACK),textAlign: TextAlign.center,))),
      DataCell(Container(child: const VerticalDivider(
        color: Colors.black12,
        thickness: 1,
      ))),
      DataCell(Container( alignment: Alignment.center,
          padding: const EdgeInsets.all(05),child: Text("\u20b9 ${result.decOnline!.round()}",style: montserratBold.copyWith(color: ColorResources.BLACK),))),
      DataCell(Container(child: const VerticalDivider(
        color: Colors.black12,
        thickness: 1,
      ))),
      DataCell(Container( alignment: Alignment.center,
          padding: const EdgeInsets.all(05),child: Text("\u20b9 ${result.decCash!.round()}",style: montserratBold.copyWith(color: ColorResources.BLACK),))),
      DataCell(Container(child: const VerticalDivider(
        color: Colors.black12,
        thickness: 1,
      ))),
      DataCell(Container( alignment: Alignment.center,
          padding: const EdgeInsets.all(05),child: Text("\u20b9 ${result.decPurchase!.round()}",style: montserratBold.copyWith(color: ColorResources.BLACK),))),
      DataCell(Container(child: const VerticalDivider(
        color: Colors.black12,
        thickness: 1,
      ))),
      DataCell(Container( alignment: Alignment.center,
          padding: const EdgeInsets.all(05),child: Text("\u20b9 ${result.decOnlinePurchase!.round()}",style: montserratBold.copyWith(color: ColorResources.BLACK),))),
      DataCell(Container(child: const VerticalDivider(
        color: Colors.black12,
        thickness: 1,
      ))),
      DataCell(Container( alignment: Alignment.center,
          padding: const EdgeInsets.all(05),child: Text("\u20b9 ${result.decCashPurchase!.round()}",style: montserratBold.copyWith(color: ColorResources.BLACK),))),
      DataCell(Container(child: const VerticalDivider(
        color: Colors.black12,
        thickness: 1,
      ))),
      DataCell(Container( alignment: Alignment.center,
          padding: const EdgeInsets.all(05),child: Text("\u20b9 ${result.decExpense!.round()}",style: montserratBold.copyWith(color: ColorResources.BLACK),))),
      DataCell(Container(child: const VerticalDivider(
        color: Colors.black12,
        thickness: 1,
      ))),
      DataCell(Container( alignment: Alignment.center,
          padding: const EdgeInsets.all(05),child: Text("\u20b9 ${result.decTotalAmount!.round()}",style: montserratBold.copyWith(color: ColorResources.BLACK),))),
      DataCell(Container(child: const VerticalDivider(
        color: Colors.black12,
        thickness: 1,
      ))),
      DataCell(Container( alignment: Alignment.center,
          padding: const EdgeInsets.all(05),child: Text("\u20b9 ${result.decOnlineAmount!.round()}",style: montserratBold.copyWith(color: ColorResources.BLACK),))),
      DataCell(Container(child: const VerticalDivider(
        color: Colors.black12,
        thickness: 1,
      ))),
      DataCell(Container( alignment: Alignment.center,
          padding: const EdgeInsets.all(05),child: Text("\u20b9 ${result.decCashAmount!.round()}",style: montserratBold.copyWith(color: ColorResources.BLACK),))),
    ]);
  }
}


