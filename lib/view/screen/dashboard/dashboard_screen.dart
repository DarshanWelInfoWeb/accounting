import 'dart:math';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gas_accounting/data/model/response/dailywise_response.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/dashboard_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/images.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/screen/dashboard/profit_loss_report.dart';
import 'package:gas_accounting/view/screen/dashboard/widget/drawer_view.dart';
import 'package:gas_accounting/view/screen/expense/add_expense/expense_list.dart';
import 'package:gas_accounting/view/screen/manage_invoice/invoice_list.dart';
import 'package:gas_accounting/view/screen/payment/payment_list.dart';
import 'package:gas_accounting/view/screen/supplier/supplier_invoice/supplier_invoice_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'chart/pi_chart.dart';
import 'widget/order_type_button_head.dart';

class Dashboard extends StatefulWidget {
  String type;
  Dashboard(this.type,{Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool is_loading = true;
  bool isLoading = true;
  String radioButtonItem = 'Today';
  int id = 1;
  String? intTotalSale,intTotalOrders,intTotalCustomers,intTotalSuppliers,intThisMonthSale,intTotalPurchase,intThisMonthPurchase,intTotalPayment,intThisMonthPayment,intTotalExpense,intThisMonthExpense,intTotalItems,decTotalProfit,decTotalProfitPercentage;
  double? intAverageSale;
  double totalPurchaseProfit = 0.0;
  late String start_date = '';
  late String end_date = '';
  late String todayDate = '';
  late String startDMY = '';
  late String startDM = '';
  late String endDMY = '';
  late String endDM = '';
  late String startDateYMD = '';
  late String todayDateYMD = '';
  late String endDateYMD = '';
  late String chartDate = '';
  late String last7StartDay = '';
  late String last7endDay = '';
  late String lastWeekStart = '';
  late String lastWeekEnd = '';
  late String lastMonthStart = '';
  late String lastMonthEnd = '';
  late String thisMonth = '';
  late String thisWeekStart = '';
  late String thisWeekEnd = '';
  var maxy;
  var maxyPayment;
  double maxY = 0.0;
  var maxySales;
  var date;
  int index = 0;
  double sale = 0.0;
  double due = 0.0;
  double payment = 0.0;
  List<FlSpot> dataPoints = [];
  List<FlSpot> dataPoint = [];
  List<SalesPaymentChartData> barData = [];
  DateTime today = DateTime.now();

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      print("type :: ${widget.type}");
      today = DateTime.now();
      var firstDayThisMonth = DateTime(today.year, today.month, 1);
      var firstDayNextMonth = DateTime(today.year, today.month + 1, 0);
      start_date = DateFormat('MM/dd/yyyy').format(firstDayThisMonth);
      end_date = DateFormat('MM/dd/yyyy').format(firstDayNextMonth);
      todayDate = DateFormat('MM/dd/yyyy').format(today);
      startDMY = DateFormat('dd/MMM/yyyy').format(firstDayThisMonth);
      startDM = DateFormat('dd/MMM/yyyy').format(firstDayThisMonth);
      endDMY = DateFormat('dd/MMM/yyyy').format(firstDayNextMonth);
      endDM = DateFormat('dd/MMM/yyyy').format(firstDayNextMonth);
      todayDateYMD = DateFormat('yyyy/MM/dd').format(today);
      startDateYMD = DateFormat('yyyy/MM/dd').format(firstDayThisMonth);
      endDateYMD = DateFormat('yyyy/MM/dd').format(today);
      var now_1w = today.subtract(const Duration(days: 6));
      last7StartDay = DateFormat('dd/MMM/yyyy').format(now_1w);
      last7endDay = DateFormat('dd/MMM/yyyy').format(today);
      var firstDayOfWeek = today.subtract(Duration(days: today.weekday - 1));
      thisWeekStart = DateFormat('dd/MMM/yyyy').format(firstDayOfWeek);
      thisWeekEnd = DateFormat('dd/MMM/yyyy').format(today);
      var lastDayOfWeekStart = today.subtract(Duration(days: today.weekday + 6));
      var lastDayOfWeekEnd = today.subtract(Duration(days: today.weekday));
      lastWeekStart = DateFormat('dd/MMM/yyyy').format(lastDayOfWeekStart);
      lastWeekEnd = DateFormat('dd/MMM/yyyy').format(lastDayOfWeekEnd);
      var lastDayOfMonthStart = DateTime(today.year, today.month - 1);
      var lastDayOfMonthEnd = DateTime(today.year, today.month - 0, 0);
      lastMonthStart = DateFormat('dd/MMM/yyyy').format(lastDayOfMonthStart);
      lastMonthEnd = DateFormat('dd/MMM/yyyy').format(lastDayOfMonthEnd);
      print("todayDate :: $todayDate :$startDateYMD :$endDateYMD");
      _startDate = startDateYMD;
      _enddate = endDateYMD;
      print("week :: $lastMonthStart ::$lastMonthEnd");
      _loadData(context, true);
    }

  List<double> dateList = [];

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<DashboardProvider>(context, listen: false).getUserAccountCount(context,PreferenceUtils.getString("${AppConstants.userId}"),PreferenceUtils.getString("${AppConstants.companyId}")).then((value) {
        setState(() {
          is_loading = false;
        });
      });
      Provider.of<DashboardProvider>(context, listen: false).getSalesChart(context,PreferenceUtils.getString("${AppConstants.companyId}"),startDateYMD,endDateYMD).then((value) {
        setState(() {
          is_loading = false;
          isLoading = false;
          for(int i=0;i<Provider.of<DashboardProvider>(context, listen: false).salesChartList.length;i++){
            var max = Provider.of<DashboardProvider>(context, listen: false).salesChartList[0];
            for (var element in Provider.of<DashboardProvider>(context, listen: false).salesChartList) {
              if (element.intTotalSale! > max.intTotalSale!) max = element;
            }
            maxySales = max.intTotalSale;
            print("max ::${max.intTotalSale!.round()} :: $maxySales");
          }
        });
      });
      Provider.of<DashboardProvider>(context, listen: false).getSalesPaymentChart(context,PreferenceUtils.getString("${AppConstants.companyId}"),last7StartDay,last7endDay).then((value) {
        setState(() {
          is_loading = false;
          for(int i=0;i<Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList.length;i++){
            var maX = Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[0];
            var maxPayment = Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[0];
            dateList = Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList.map((city) => double.parse(AppConstants.changeDateD(city.dtDate!))).toList();
            sale += Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[i].intTotalSale!;
            due += Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[i].intTotalDue!;
            payment += Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[i].intTotalPayment!;
            for (var element in Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList) {
              if (element.intTotalSale! > maX.intTotalSale!) maX = element;
              if (element.intTotalPayment! > maxPayment.intTotalPayment!) maxPayment = element;
            }
            maxy = maX.intTotalSale;
            maxyPayment = maxPayment.intTotalPayment;
            maxY = max(maX.intTotalSale!, maxPayment.intTotalPayment!);
            print("max ::${maX.intTotalSale!.round()} :: $maxy  ::$maxyPayment ::$dateList");
          }
        });
      });
    });
  }

  ScrollController barChartScroller = ScrollController();

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);

    return Text('\$ ${value + 0.5}', style: style);
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero,() {
      if (widget.type == "Home") {
        print("type1::");
        _key.currentState?.openDrawer();
      }else{
        print("type2::");
        _key.currentState?.closeDrawer();
      }
    },);
    return WillPopScope(
      onWillPop: () => AppConstants.onWillPop(context),
      child: Consumer<DashboardProvider>(builder: (context, dashboard, child) {
        for(int i=0;i<dashboard.dashboardList.length;i++){
          intTotalSale = dashboard.dashboardList[i].intTotalSale!.round().toString();
          intTotalOrders = dashboard.dashboardList[i].intTotalOrders.toString();
          intTotalCustomers = dashboard.dashboardList[i].intTotalCustomers.toString();
          intTotalSuppliers = dashboard.dashboardList[i].intTotalSuppliers.toString();
          intThisMonthSale = dashboard.dashboardList[i].intThisMonthSale!.round().toString();
          intAverageSale = double.parse(dashboard.dashboardList[i].intAverageSale!.toStringAsFixed(2));
          intTotalPurchase = dashboard.dashboardList[i].intTotalPurchase!.round().toString();
          totalPurchaseProfit = double.parse(intTotalPurchase.toString()) / 100.0;
          intThisMonthPurchase = dashboard.dashboardList[i].intThisMonthPurchase!.round().toString();
          intTotalPayment = dashboard.dashboardList[i].intTotalPayment!.round().toString();
          intThisMonthPayment = dashboard.dashboardList[i].intThisMonthPayment!.round().toString();
          intTotalExpense = dashboard.dashboardList[i].intTotalExpense!.round().toString();
          intThisMonthExpense = dashboard.dashboardList[i].intThismonthExpense!.round().toString();
          intTotalItems = dashboard.dashboardList[i].intTotalItems.toString();
          decTotalProfit = dashboard.dashboardList[i].decTotalProfit.toString();
          decTotalProfitPercentage = dashboard.dashboardList[i].decTotalProfitPercentage.toString();
          AppConstants.profitAmount = dashboard.dashboardList[i].decTotalProfit.toString();
          AppConstants.profit = dashboard.dashboardList[i].decTotalProfitPercentage.toString();
        }
        return Scaffold(
          key: _key,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: ColorResources.LINE_BG,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                _key.currentState?.openDrawer();
              },
              icon: const Icon(Icons.menu, color: ColorResources.WHITE),
            ),
            title: Text("Dashboard",style: montserratSemiBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
            actions: [
              PopupMenuButton(
                color: ColorResources.WHITE,
                elevation: 10,
                offset: const Offset(0.0, 60.0),
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                iconColor: ColorResources.WHITE,
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(child: Row(
                      children: [
                        Icon(Icons.report,color: ColorResources.BLACK,),
                        Text('Report & Error'),
                      ],
                    )),
                    const PopupMenuItem(child: Row(
                      children: [
                        Icon(Icons.error,color: ColorResources.BLACK,),
                        Text('Help'),
                      ],
                    )),
                  ];
                },
              )
            ],
          ),
          drawer: const Drawer_View(),
          body:
          is_loading
              ?
          const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
              :
          ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio(
                    value: 1,
                    groupValue: id,
                    activeColor: ColorResources.LINE_BG,
                    onChanged: (val) {
                      setState(() {
                        radioButtonItem = 'Today';
                        id = 1;
                        _key.currentState!.closeDrawer();
                        widget.type = "";
                        print("object ::${_key.currentState!.isDrawerOpen}");
                      });
                    },
                  ),
                  const Text(
                    'Today',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  Radio(
                    value: 2,
                    groupValue: id,
                    activeColor: ColorResources.LINE_BG,
                    onChanged: (val) {
                      setState(() {
                        radioButtonItem = 'Total';
                        id = 2;
                        widget.type = "";
                        _key.currentState!.closeDrawer();
                      });
                    },
                  ),
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),

                ],
              ),
              /* Today */
              id==1
                  ?
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OrderTypeButtonHead(
                        image: Images.increase,
                        text: 'Today Sale',
                        amount: "\u20b9 $intTotalSale",
                        onTap: InvoiceList(todayDate.toString(),todayDate.toString(),"","Dashboard"),
                      ),
                      OrderTypeButtonHead(
                        image: Images.bill,
                        text: 'Today Payment',
                        amount: "\u20b9 $intTotalPayment",
                        onTap: PaymentList(todayDate.toString(),todayDate.toString(),"","Dashboard"),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OrderTypeButtonHead(
                        image: Images.duePayment,
                        text: 'This Month Payment',
                        amount: "\u20b9 $intThisMonthPayment",
                        onTap: PaymentList(start_date,end_date,"","Dashboard"),
                      ),
                      OrderTypeButtonHead(
                        image: Images.accounting,
                        text: 'Today Expense',
                        amount: "\u20b9 $intThisMonthExpense",
                        onTap: Expense_List(todayDateYMD,todayDateYMD,"Dashboard"),
                      )
                    ],
                  ),
                ],
              )
                  :
              const SizedBox(),
              /* Total */
              id==2
                  ?
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OrderTypeButtonHead(
                        image: Images.increase,
                        text: 'This Month Sale',
                        amount: "Total : \u20b9 $intThisMonthSale\n Avg: \u20b9 $intAverageSale",
                        onTap: InvoiceList(start_date,end_date,"","Dashboard"),
                      ),
                      OrderTypeButtonHead(
                        image: Images.bill,
                        text: 'This Month Purchase',
                        amount: "\u20b9 $intThisMonthPurchase",
                        onTap: SupplierInvoiceList(start_date,end_date,"","Dashboard"),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OrderTypeButtonHead(
                        image: Images.duePayment,
                        text: 'This Month Profit',
                        amount: "\u20b9 $decTotalProfit\n ($decTotalProfitPercentage %)",
                        onTap: ProfitLossReport(startDateYMD,endDateYMD,"Dashboard"),
                      ),
                      OrderTypeButtonHead(
                        image: Images.accounting,
                        text: 'This Month Expense',
                        amount: "\u20b9 $intThisMonthExpense",
                        onTap: Expense_List(startDateYMD,endDateYMD,"Dashboard"),
                      )
                    ],
                  ),
                ],
              )
                  :
              const SizedBox(),
              /* Line Chart */
              SizedBox(height: AppConstants.itemHeight*0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Sales & Average Sale',
                    style: montserratRegular.copyWith(color: Colors.black, fontSize: Dimensions.FONT_SIZE_22),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: AppConstants.itemWidth*0.02,top: AppConstants.itemHeight*0.01),
                    padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
                    decoration: BoxDecoration(
                      color: ColorResources.GREY.withOpacity(0.05),
                      borderRadius:BorderRadius.circular(10),
                    ),
                    child: _buildCalendarDialogButton(),
                  ),
                  InkWell(
                    onTap: () {
                      onLineChartTapExpand(context, _LineChartWidget("Dashboard"));
                    },
                    child: Container(
                      height: AppConstants.itemHeight*0.03,
                      width: AppConstants.itemWidth*0.15,
                      color: Colors.transparent,
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                        child: Icon(Icons.zoom_out_map),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: SizedBox(height: AppConstants.itemHeight * 0.40, child: _LineChartWidget("Full")),
              ),
              /* Bar Chart*/
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Sales Vs Payment',
                    style: montserratRegular.copyWith(color: Colors.black, fontSize: Dimensions.FONT_SIZE_22),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: AppConstants.itemWidth*0.54,
                    margin: EdgeInsets.only(left: AppConstants.itemWidth*0.02),
                    padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
                    decoration: BoxDecoration(
                      color: ColorResources.GREY.withOpacity(0.05),
                      borderRadius:BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownMenu(
                        initialSelection: 0,
                        width: AppConstants.itemWidth*0.50,
                        menuStyle: MenuStyle(
                            elevation: const MaterialStatePropertyAll(1),
                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                        ),
                        onSelected: (value) {
                          if(value == 0){
                            Provider.of<DashboardProvider>(context, listen: false).getSalesPaymentChart(context,PreferenceUtils.getString("${AppConstants.companyId}"),last7StartDay,last7endDay).then((value) {
                              setState(() {
                                is_loading = false;
                                sale = 0.0;
                                due = 0.0;
                                payment = 0.0;
                                for(int i=0;i<Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList.length;i++){
                                  var maX = Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[0];
                                  var maxPayment = Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[0];
                                  sale += Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[i].intTotalSale!;
                                  due += Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[i].intTotalDue!;
                                  payment += Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[i].intTotalPayment!;
                                  for (var element in Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList) {
                                    if (element.intTotalSale! > maX.intTotalSale!) maX = element;
                                    if (element.intTotalPayment! > maxPayment.intTotalPayment!) maxPayment = element;
                                  }
                                  maxy = maX.intTotalSale;
                                  maxyPayment = maxPayment.intTotalPayment;
                                  maxY = max(maX.intTotalSale!, maxPayment.intTotalPayment!);
                                  print("max ::${maX.intTotalSale!.round()} :: $maxy  ::$maxyPayment");
                                }
                              });
                            });
                          }else if(value == 1){
                            Provider.of<DashboardProvider>(context, listen: false).getSalesPaymentChart(context,PreferenceUtils.getString("${AppConstants.companyId}"),thisWeekStart,thisWeekEnd).then((value) {
                              setState(() {
                                is_loading = false;
                                sale = 0.0;
                                due = 0.0;
                                payment = 0.0;
                                for(int i=0;i<Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList.length;i++){
                                  var maX = Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[0];
                                  var maxPayment = Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[0];
                                  sale += Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[i].intTotalSale!;
                                  due += Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[i].intTotalDue!;
                                  payment += Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[i].intTotalPayment!;
                                  for (var element in Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList) {
                                    if (element.intTotalSale! > maX.intTotalSale!) maX = element;
                                    if (element.intTotalPayment! > maxPayment.intTotalPayment!) maxPayment = element;
                                  }
                                  maxy = maX.intTotalSale;
                                  maxyPayment = maxPayment.intTotalPayment;
                                  maxY = max(maX.intTotalSale!, maxPayment.intTotalPayment!);
                                  print("max ::${maX.intTotalSale!.round()} :: $maxy  ::$maxyPayment");
                                }
                              });
                            });
                          }else if(value == 2){
                            Provider.of<DashboardProvider>(context, listen: false).getSalesPaymentChart(context,PreferenceUtils.getString("${AppConstants.companyId}"),startDMY,endDMY).then((value){
                              setState(() {
                                is_loading = false;
                                sale = 0.0;
                                due = 0.0;
                                payment = 0.0;
                                for(int i=0;i<Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList.length;i++){
                                  var maX = Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[0];
                                  var maxPayment = Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[0];
                                  sale += Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[i].intTotalSale!;
                                  due += Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[i].intTotalDue!;
                                  payment += Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[i].intTotalPayment!;
                                  for (var element in Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList) {
                                    if (element.intTotalSale! > maX.intTotalSale!) maX = element;
                                    if (element.intTotalPayment! > maxPayment.intTotalPayment!) maxPayment = element;
                                  }
                                  maxy = maX.intTotalSale;
                                  maxyPayment = maxPayment.intTotalPayment;
                                  maxY = max(maX.intTotalSale!, maxPayment.intTotalPayment!);
                                  print("The value of max= ${max(maX.intTotalSale!.round(), maxPayment.intTotalPayment!.round())}");
                                  print("maxY ::${maxy > maxyPayment}");
                                  print("max ::${maX.intTotalSale!.round()} :: $maxy  ::$maxyPayment");
                                }
                              });
                            });
                          }else if(value == 3){
                            Provider.of<DashboardProvider>(context, listen: false).getSalesPaymentChart(context,PreferenceUtils.getString("${AppConstants.companyId}"),lastWeekStart,lastWeekEnd).then((value) {
                              setState(() {
                                is_loading = false;
                                sale = 0.0;
                                due = 0.0;
                                payment = 0.0;
                                for(int i=0;i<Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList.length;i++){
                                  var maX = Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[0];
                                  var maxPayment = Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[0];
                                  sale += Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[i].intTotalSale!;
                                  due += Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[i].intTotalDue!;
                                  payment += Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[i].intTotalPayment!;
                                  for (var element in Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList) {
                                    if (element.intTotalSale! > maX.intTotalSale!) maX = element;
                                    if (element.intTotalPayment! > maxPayment.intTotalPayment!) maxPayment = element;
                                  }
                                  maxy = maX.intTotalSale;
                                  maxyPayment = maxPayment.intTotalPayment;
                                  maxY = max(maX.intTotalSale!, maxPayment.intTotalPayment!);
                                  print("max ::${maX.intTotalSale!.round()} :: $maxy ::$maxyPayment");
                                }
                              });
                            });
                          }else{
                            Provider.of<DashboardProvider>(context, listen: false).getSalesPaymentChart(context,PreferenceUtils.getString("${AppConstants.companyId}"),lastMonthStart,lastMonthEnd).then((value){
                              setState(() {
                                is_loading = false;
                                sale = 0.0;
                                due = 0.0;
                                payment = 0.0;
                                for(int i=0;i<Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList.length;i++){
                                  var maX = Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[0];
                                  var maxPayment = Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[0];
                                  sale += Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[i].intTotalSale!;
                                  due += Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[i].intTotalDue!;
                                  payment += Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList[i].intTotalPayment!;
                                  for (var element in Provider.of<DashboardProvider>(context, listen: false).salesPaymentChartList) {
                                    if (element.intTotalSale! > maX.intTotalSale!) maX = element;
                                    if (element.intTotalPayment! > maxPayment.intTotalPayment!) maxPayment = element;
                                  }
                                  maxy = maX.intTotalSale;
                                  maxyPayment = maxPayment.intTotalPayment;
                                  maxY = max(maX.intTotalSale!, maxPayment.intTotalPayment!);
                                  print("The value of max(10, 0) = ${max(maX.intTotalSale!.round(), maxPayment.intTotalPayment!.round())}");
                                  print("max ::$maxY :: $maxy ::$maxyPayment");
                                }
                              });
                            });
                          }
                        },
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: 0, label: 'Last Seven Day'),
                          DropdownMenuEntry(value: 1, label: 'This Week'),
                          DropdownMenuEntry(value: 2, label: 'This Month'),
                          DropdownMenuEntry(value: 3, label: 'Last Week'),
                          DropdownMenuEntry(value: 4, label: 'Last Month'),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      onBarChartTapExpand(context, _BarChartWidget("Dashboard"));
                    },
                    child: Container(
                      height: AppConstants.itemHeight*0.03,
                      width: AppConstants.itemWidth*0.15,
                      color: Colors.transparent,
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                        child: Icon(Icons.zoom_out_map),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: SizedBox(height: AppConstants.itemHeight * 0.40, child: _BarChartWidget("Full")),
              ),
              /* Pie Chart*/
              sale == 0.0 && due == 0.0 && payment == 0.0
                  ?
              const SizedBox()
                  :
              Pie_Charts(sale,due,payment),
            ],
          ),
        );
      },),
    );
  }

  void onLineChartTapExpand(BuildContext context, Widget sample) {
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => LineChartFullView(
              sampleWidget: sample,
            )));
  }

  void onBarChartTapExpand(BuildContext context, Widget sample) {
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => BartChartFullView(
              sampleWidget: sample,
            )));
  }

  List<DateTime?> _dialogCalendarPickerValue = [];
  String _startDate = '';
  String _enddate = '';

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
            Text(_startDate == "" ? "Select Date" : "${AppConstants.date_changs(_startDate)}  To  ${AppConstants.date_changs(_enddate)}",style: poppinsBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
            const Icon(Icons.keyboard_arrow_down_outlined,color: ColorResources.BLACK,size: 20),
          ],
        ),
      ),
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
        setState(() {
          isLoading = true;
        });
        Provider.of<DashboardProvider>(context, listen: false).getSalesChart(context,PreferenceUtils.getString("${AppConstants.companyId}"),_startDate,_enddate).then((value) {
          setState(() {
            is_loading = false;
            isLoading = false;
            for(int i=0;i<Provider.of<DashboardProvider>(context, listen: false).salesChartList.length;i++){
              var max = Provider.of<DashboardProvider>(context, listen: false).salesChartList[0];
              for (var element in Provider.of<DashboardProvider>(context, listen: false).salesChartList) {
                if (element.intTotalSale! > max.intTotalSale!) max = element;
              }
              maxySales = max.intTotalSale;
              print("max ::${max.intTotalSale!.round()} :: $maxySales");
            }
          });
        });
        valueText = '$_startDate to $_enddate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }
}


/* Line Chart */

class LineChartFullView extends StatelessWidget {
  const LineChartFullView({super.key, this.sampleWidget});
  final Widget? sampleWidget;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) =>
            Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(60.0),
                  child: AppBar(
                    backgroundColor: ColorResources.LINE_BG,
                    centerTitle: true,
                    title: Text('Sales & Average Sale',style: montserratSemiBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20)),
                    leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back, color: ColorResources.WHITE),
                    ),
                  )),
              body: Container(
                  decoration: const BoxDecoration(
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12)),
                      color: Colors.white),
                  child: Container(child: sampleWidget)),
            ));
  }
}

class _LineChartWidget extends StatefulWidget {
   String type;
  _LineChartWidget(this.type,{Key? key}) : super(key: key);

  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<_LineChartWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, dashboard, child) {
      return Scaffold(
        body: SfCartesianChart(
            enableAxisAnimation: true,
            tooltipBehavior: TooltipBehavior(enable: true),
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              orientation: LegendItemOrientation.horizontal,
              textStyle: montserratRegular.copyWith(color: ColorResources.BLACK,fontSize: 16),
            ),
            primaryXAxis: CategoryAxis(
              labelStyle: montserratRegular.copyWith(fontSize: 10,color: ColorResources.BLACK),
              labelRotation: -30,
              maximumLabels: 100,
              autoScrollingDelta: 7,
              autoScrollingMode: widget.type != "Dashboard" ? AutoScrollingMode.end :AutoScrollingMode.start,
              title: AxisTitle(text: "Date",textStyle: montserratRegular.copyWith(color: ColorResources.BLACK,fontSize: 12)),
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(width: 1),
            ),
            primaryYAxis: NumericAxis(
                numberFormat: NumberFormat(),
                minimum: 1.0,
                title: AxisTitle(text: "Amount \u20b9",textStyle: montserratRegular.copyWith(color: ColorResources.BLACK,fontSize: 12)),
                majorGridLines: const MajorGridLines(width: 1)),
            zoomPanBehavior: ZoomPanBehavior(
              enablePanning: widget.type != "Dashboard" ? false : true,
            ),
            series: <ChartSeries>[
              LineSeries<SalesChartData, String>(
                enableTooltip: true,
                name: "Sale",
                color: Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 4,
                    width: 4,
                    shape: DataMarkerType.circle,
                    borderWidth: 3,
                    borderColor: Colors.blue),
                dataSource: dashboard.salesChartList,
                xValueMapper: (SalesChartData data, _) => AppConstants.date_chang(data.dtDate!),
                yValueMapper: (SalesChartData data, _) => data.intTotalSale!.round(),
                pointColorMapper: (SalesChartData data, _) => Colors.blue,
              ),
              LineSeries<SalesChartData, String>(
                enableTooltip: true,
                name: "Average Sale",
                color: Colors.indigoAccent,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 4,
                    width: 4,
                    shape: DataMarkerType.rectangle,
                    borderWidth: 3,
                    borderColor: Colors.indigoAccent),
                dataSource: dashboard.salesChartList,
                xValueMapper: (SalesChartData data, _) => AppConstants.date_chang(data.dtDate!),
                yValueMapper: (SalesChartData data, _) => data.intAverageSale!.round(),
                pointColorMapper: (SalesChartData data, _) => Colors.indigoAccent,
              ),
            ]),);
    },);
  }
}



/* Bar Chart */

class BartChartFullView extends StatelessWidget {
  const BartChartFullView({super.key, this.sampleWidget});
  final Widget? sampleWidget;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) =>
            Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(60.0),
                  child: AppBar(
                    backgroundColor: ColorResources.LINE_BG,
                    centerTitle: true,
                    title: Text('Sales Vs Payment',style: montserratSemiBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20)),
                    leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back, color: ColorResources.WHITE),
                    ),
                  )),
              body: Container(
                  decoration: const BoxDecoration(
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12)),
                      color: Colors.white),
                  child: Container(child: sampleWidget)),
            ));
  }
}

class _BarChartWidget extends StatefulWidget {
  String type;
  _BarChartWidget(this.type,{Key? key}) : super(key: key);

  @override
  State<_BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<_BarChartWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, dashboard, child) {
      return Scaffold(
        body: SfCartesianChart(
            enableAxisAnimation: true,
            tooltipBehavior: TooltipBehavior(enable: true),
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              orientation: LegendItemOrientation.horizontal,
              textStyle: montserratRegular.copyWith(color: ColorResources.BLACK,fontSize: 16),
            ),
            primaryXAxis: CategoryAxis(
              labelStyle: montserratRegular.copyWith(fontSize: 10,color: ColorResources.BLACK),
              labelRotation: -30,
              maximumLabels: 31,
              autoScrollingDelta: 7,

              autoScrollingMode: widget.type != "Dashboard" ? AutoScrollingMode.end :AutoScrollingMode.start,
              title: AxisTitle(text: "Date",textStyle: montserratRegular.copyWith(color: ColorResources.BLACK,fontSize: 12)),
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(width: 1),
            ),
            primaryYAxis: NumericAxis(
                numberFormat: NumberFormat(),
                minimum: 1.0,
                title: AxisTitle(text: "Amount \u20b9",textStyle: montserratRegular.copyWith(color: ColorResources.BLACK,fontSize: 12)),
                majorGridLines: const MajorGridLines(width: 1)),
            zoomPanBehavior: ZoomPanBehavior(
              enablePanning: widget.type != "Dashboard" ? false : true,
            ),
            series: <ChartSeries>[
              ColumnSeries<SalesPaymentChartData, String>(
                  enableTooltip: true,
                  name: "Sales",
                  color: Colors.blue,
                  dataSource: dashboard.salesPaymentChartList,
                  xValueMapper: (SalesPaymentChartData data, _) => data.dtDate,
                  yValueMapper: (SalesPaymentChartData data, _) => data.intTotalSale,
                  pointColorMapper: (SalesPaymentChartData data, _) => Colors.blue,
                  dataLabelSettings: const DataLabelSettings(isVisible: false,angle: -50),
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(05),topLeft: Radius.circular(05)),
                  emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.average)
              ),
              ColumnSeries<SalesPaymentChartData, String>(
                  enableTooltip: true,
                  name: "Payment",
                  color: Colors.indigoAccent,
                  dataSource: dashboard.salesPaymentChartList,
                  xValueMapper: (SalesPaymentChartData data, _) => data.dtDate,
                  yValueMapper: (SalesPaymentChartData data, _) => data.intTotalPayment,
                  pointColorMapper: (SalesPaymentChartData data, _) => Colors.indigoAccent,
                  dataLabelSettings: const DataLabelSettings(isVisible: false,angle: -50),
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(05),topLeft: Radius.circular(05)),
                  emptyPointSettings: EmptyPointSettings(
                      mode: EmptyPointMode.average)),
            ]),
      );
    },);
  }
}

