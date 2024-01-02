import 'package:flutter/material.dart';
import 'package:gas_accounting/data/model/response/customerdailyreport_response.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/customer_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/custom_password_textfield.dart';
import 'package:gas_accounting/view/basewidget/no_internet_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionHistory extends StatefulWidget {
  int customerId, type;
  String mobile, companyName, customerName;

  TransactionHistory(this.customerId, this.type, this.mobile, this.companyName,
      this.customerName,
      {super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  DataGridController _controller = DataGridController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  FocusNode startDateCode = FocusNode();
  FocusNode endDateCode = FocusNode();

  bool isLoading = true;
  bool isLoadings = true;
  late String formattedDate = '';
  late String start_date = '';
  late String end_date = '';
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime today = DateTime.now();
    formattedDate = DateFormat('dd/MM/yyyy').format(today);
    endDateController.text = formattedDate;
    _loadData(context, true);
    print("front:::${widget.customerName}::${widget.customerId}::${AppConstants.dateChanges(endDateController.text)}");
  }

  void _date_pik_start() {
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
        startDateController.text = formattedDate;
        Provider.of<CustomerProvider>(context, listen: false)
            .getCustomerDailyReport(
                context,
                PreferenceUtils.getString(AppConstants.companyId.toString()),
                widget.customerId.toString(),
                AppConstants.dateChanges(startDateController.text),
                AppConstants.dateChanges(endDateController.text))
            .then((value) {
          setState(() {
            isLoading = false;
            _employees = Provider.of<CustomerProvider>(context, listen: false).customerDailyReportList;
            _employeeDataSource = EmployeeDataSource(employees: _employees);
          });
        });
      });
    });
  }

  void _date_pik_end() {
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
        endDateController.text = formattedDate;
        Provider.of<CustomerProvider>(context, listen: false)
            .getCustomerDailyReport(
                context,
                PreferenceUtils.getString(AppConstants.companyId.toString()),
                widget.customerId.toString(),
                AppConstants.dateChanges(startDateController.text),
                AppConstants.dateChanges(endDateController.text))
            .then((value) {
          setState(() {
            isLoadings = false;
            _employees = Provider.of<CustomerProvider>(context, listen: false).customerDailyReportList;
            _employeeDataSource = EmployeeDataSource(employees: _employees);
          });
        });
      });
    });
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<CustomerProvider>(context, listen: false)
          .getCustomerDailyReport(
              context,
              PreferenceUtils.getString(AppConstants.companyId.toString()),
              widget.customerId.toString(),
              "",
              AppConstants.dateChanges(endDateController.text))
          .then((value) {
        setState(() {
          isLoading = false;
          _employees = Provider.of<CustomerProvider>(context, listen: false)
              .customerDailyReportList;
          _employeeDataSource = EmployeeDataSource(employees: _employees);
        });
      });
    });
  }

  makingPhoneCall(mobile) async {
    var url = Uri.parse("tel: $mobile");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("objectttt");
      throw 'Could not launch $url';
    }
  }

  List listOfColumn = [
    {"Date": "15 Apr", "Debit": "", "Credit": "50000", "Balance": "38152"},
    {"Date": "06 Apr", "Debit": "17440", "Credit": "", "Balance": "88152"},
    {"Date": "02 Apr", "Debit": "", "Credit": "150000", "Balance": "70712"},
    {"Date": "02 Apr", "Debit": "26832", "Credit": "", "Balance": "220712"},
    {"Date": "25 Mar", "Debit": "", "Credit": "35000", "Balance": "139880"},
  ];

  late List<CustomerDailyReportData> _employees = <CustomerDailyReportData>[];
  late EmployeeDataSource _employeeDataSource = EmployeeDataSource(employees: []);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.LINE_BG,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: ColorResources.WHITE,
              size: 25,
            )),
        title: Text(
          "Transaction History",
          style: montserratSemiBold.copyWith(
              color: ColorResources.WHITE, fontSize: Dimensions.FONT_SIZE_20),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: ColorResources.LINE_BG))
          : Consumer<CustomerProvider>(
              builder: (context, customer, child) {
                return ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.itemWidth * 0.02,
                      vertical: AppConstants.itemHeight * 0.01),
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.itemWidth * 0.02,
                          vertical: AppConstants.itemHeight * 0.01),
                      decoration: BoxDecoration(
                        color: ColorResources.WHITE,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 0.5,
                              spreadRadius: 0.5,
                              offset: Offset(0, 0)),
                        ],
                        // border: Border.all(color: ColorResources.BLACK),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.companyName == ""?SizedBox():
                              Container(
                                alignment: Alignment.centerLeft,
                                width: AppConstants.itemWidth * 0.75,
                                child: Text(
                                  widget.companyName,
                                  style: montserratSemiBold.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_15,
                                      color: ColorResources.BLACK),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: AppConstants.itemWidth * 0.75,
                                child: Text(
                                  widget.customerName,
                                  style: montserratSemiBold.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_15,
                                      color: ColorResources.GREY),
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () => makingPhoneCall(widget.mobile),
                              icon: const Icon(Icons.call,
                                  color: ColorResources.LINE_BG, size: 30)),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                          top: AppConstants.itemHeight * 0.02,
                          left: AppConstants.itemWidth * 0.02),
                      child: Text("Start Date",
                          style: montserratSemiBold.copyWith(
                              fontSize: Dimensions.FONT_SIZE_16)),
                    ),
                    GestureDetector(
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
                          hintTxt: "Please Select Date",
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                          top: AppConstants.itemHeight * 0.0,
                          left: AppConstants.itemWidth * 0.02),
                      child: Text("End Date",
                          style: montserratSemiBold.copyWith(
                              fontSize: Dimensions.FONT_SIZE_16)),
                    ),
                    GestureDetector(
                      onTap: () {
                        _date_pik_end();
                        print("object:::$end_date");
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.itemWidth * 0.02,
                            vertical: AppConstants.itemHeight * 0.01),
                        child: CustomDateTextField(
                          controller: endDateController,
                          focusNode: endDateCode,
                          nextNode: null,
                          hintTxt: "Please Select Date",
                        ),
                      ),
                    ),
                    customer.customerDailyReportList.isEmpty
                        ?
                    const SizedBox()
                        :
                    Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(
                                top: AppConstants.itemHeight * 0.02),
                            child: Text("Transaction History",
                                style: montserratBold.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_16)),
                          ),
                    Provider.of<CustomerProvider>(context, listen: false).isLoading
                        ?
                    const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
                        :
                    customer.customerDailyReportList.isEmpty
                        ?
                    Center(child: DataNotFoundScreen("No Data Found"),)
                        :
                    SfDataGrid(
                                controller: _controller,
                                shrinkWrapRows: true,
                                source: _employeeDataSource,
                                columnWidthMode: ColumnWidthMode.auto,
                                showHorizontalScrollbar: false,
                                showVerticalScrollbar: false,
                                verticalScrollPhysics: const ClampingScrollPhysics(),
                                horizontalScrollPhysics: const BouncingScrollPhysics(),
                                headerRowHeight: AppConstants.itemHeight * 0.04,
                                rowHeight: AppConstants.itemHeight * 0.04,
                                gridLinesVisibility: GridLinesVisibility.both,
                                headerGridLinesVisibility:
                                    GridLinesVisibility.both,
                                allowColumnsResizing: true,
                                columns: <GridColumn>[
                                    GridColumn(
                                        columnName: 'dtdate',
                                        label: Container(
                                            padding: const EdgeInsets.all(05),
                                            color: Colors.grey.shade200,
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Date',
                                            ))),
                                    GridColumn(
                                        columnName: 'decDebitAmt',
                                        label: Container(
                                            padding: const EdgeInsets.all(05),
                                            color: Colors.grey.shade200,
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Debit(-)',
                                            ))),
                                    GridColumn(
                                        columnName: 'decCreditAmt',
                                        label: Container(
                                            padding: const EdgeInsets.all(05),
                                            color: Colors.grey.shade200,
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Credit(+)',
                                            ))),
                                    GridColumn(
                                        columnName: 'decBalance',
                                        label: Container(
                                            padding: const EdgeInsets.all(05),
                                            color: Colors.grey.shade200,
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Balance',
                                            ))),
                                  ]),
                  ],
                );
              },
            ),
    );
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List<CustomerDailyReportData> employees}) {
    _employees = employees;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<CustomerDailyReportData> _employees;

  void updateDataGridRows() {
    dataGridRow = _employees
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'dtdate',
                  value: AppConstants.changeDate(e.dtdate.toString())),
              DataGridCell<String>(
                  columnName: 'decDebitAmt',
                  value: e.decDebitAmt!.round().toString()),
              DataGridCell<String>(
                  columnName: 'decCreditAmt',
                  value: e.decCreditAmt!.round().toString()),
              DataGridCell<String>(
                  columnName: 'decBalance',
                  value: e.decBalance!.round().toString()),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      Color? columnBackgroundColor;
      if (dataGridCell.columnName == 'decDebitAmt') {
        columnBackgroundColor = Colors.redAccent.withOpacity(0.10);
      } else if (dataGridCell.columnName == 'decCreditAmt') {
        columnBackgroundColor = Colors.greenAccent.withOpacity(0.10);
      } else {
        columnBackgroundColor = Colors.transparent;
      }

      return Container(
        alignment: Alignment.center,
        color: columnBackgroundColor,
        // padding: EdgeInsets.symmetric(horizontal: 05),
        child: dataGridCell.columnName == 'decBalance'
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dataGridCell.value.toString(),
                    style: montserratSemiBold.copyWith(
                        color: ColorResources.RED,
                        fontSize: Dimensions.FONT_SIZE_13),
                  ),
                  Text(
                    " Dr",
                    style: montserratSemiBold.copyWith(
                        color: ColorResources.BLACK,
                        fontSize: Dimensions.FONT_SIZE_13),
                  ),
                ],
              )
            : Text(
                dataGridCell.value.toString(),
                style: montserratSemiBold.copyWith(
                    fontSize: Dimensions.FONT_SIZE_13),
              ),
      );
    }).toList());
  }
}
