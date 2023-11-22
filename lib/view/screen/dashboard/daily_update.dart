import 'package:data_table_plus/data_table_plus.dart';
import 'package:flutter/material.dart';
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
import 'package:provider/provider.dart';

class DailyUpdate extends StatefulWidget {
  const DailyUpdate({Key? key}) : super(key: key);

  @override
  State<DailyUpdate> createState() => _DailyUpdateState();
}

class _DailyUpdateState extends State<DailyUpdate> {
  TextEditingController dateController = TextEditingController();
  FocusNode dateCode = FocusNode();
  bool is_loading = true;
  late String formattedDate = '';
  late String date_shcedule = '';
  TimeOfDay selectedTime = TimeOfDay.now();

  double qtyTotal = 0.0;
  double amountTotal = 0.0;
  double profitTotal = 0.0;

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
        onDatePickerModeChange: (value) {

        },
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
        qtyTotal = 0.0;
        amountTotal = 0.0;
        profitTotal = 0.0;
        Provider.of<DashboardProvider>(context, listen: false).getDailyUpdate(context,AppConstants.dateChange(dateController.text),PreferenceUtils.getString(AppConstants.companyId.toString())).then((value) {
          setState(() {
            is_loading = false;
            for(int i=0;i<Provider.of<DashboardProvider>(context, listen: false).dailyUpdateList.length;i++){
              qtyTotal += Provider.of<DashboardProvider>(context, listen: false).dailyUpdateList[i].decQty!;
              amountTotal += Provider.of<DashboardProvider>(context, listen: false).dailyUpdateList[i].decAmount!;
              profitTotal += Provider.of<DashboardProvider>(context, listen: false).dailyUpdateList[i].profit!;
              print("re:1:::$qtyTotal:::::$amountTotal:::$profitTotal");
            }
          });
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime today = DateTime.now();
    formattedDate = DateFormat('dd/MM/yyyy').format(today);
    dateController.text = formattedDate;
    _loadData(context, true);
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<DashboardProvider>(context, listen: false).getDailyUpdate(context,AppConstants.dateChange(dateController.text),PreferenceUtils.getString(AppConstants.companyId.toString())).then((value) {
        for(int i=0;i<Provider.of<DashboardProvider>(context, listen: false).dailyUpdateList.length;i++){
          qtyTotal += Provider.of<DashboardProvider>(context, listen: false).dailyUpdateList[i].decQty!;
          amountTotal += Provider.of<DashboardProvider>(context, listen: false).dailyUpdateList[i].decAmount!;
          profitTotal += Provider.of<DashboardProvider>(context, listen: false).dailyUpdateList[i].profit!;
          print("re::::$qtyTotal:::::$amountTotal:::$profitTotal");
        }
        setState(() {
          is_loading = false;
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
    return WillPopScope(
      onWillPop: () async{
        Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard("Home"),));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorResources.LINE_BG,
          centerTitle: true,
          leading: IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard("Home"),));
          }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
          title: Text("Daily Update",style: montserratSemiBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
        ),
        body:
        is_loading
            ?
        const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
            :
        ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: AppConstants.itemHeight*0.02),
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Text("Date",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
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
                  nextNode: null,
                ),
              ),
            ),
            /*   Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top:AppConstants.itemHeight*0.01,bottom: AppConstants.itemHeight*0.01,left: AppConstants.itemWidth*0.02,right: AppConstants.itemWidth*0.53),
              padding: EdgeInsets.all(AppConstants.itemHeight*0.005),
              decoration: BoxDecoration(
                color: ColorResources.WHITE,
                borderRadius: BorderRadius.circular(10),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.shade400,
                      offset: Offset(2, 4),
                      blurRadius: 3,
                      spreadRadius: 1)
                ],
              ),
              child: Container(
                alignment: Alignment.center,
                width: AppConstants.itemWidth*0.51,
                height: AppConstants.itemHeight*0.10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: AppConstants.itemWidth*0.01),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Item :",
                                textAlign: TextAlign.center,
                                style: montserratRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15,fontWeight: FontWeight.w600)),
                            Text("LPG Cylinder",
                                textAlign: TextAlign.center,
                                style: montserratRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15,fontWeight: FontWeight.w600)),
                          ],
                        ),
                        // SizedBox(height: AppConstants.itemHeight*0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Available Qty :",
                                textAlign: TextAlign.center,
                                style: montserratRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15,fontWeight: FontWeight.w600)),
                            Text("30",
                                textAlign: TextAlign.center,
                                style: montserratRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15,fontWeight: FontWeight.w600)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Sale Qty :",
                                textAlign: TextAlign.center,
                                style: montserratRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15,fontWeight: FontWeight.w600)),
                            Text("56",
                                textAlign: TextAlign.center,
                                style: montserratRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15,fontWeight: FontWeight.w600)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Amount :",
                                textAlign: TextAlign.center,
                                style: montserratRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15,fontWeight: FontWeight.w600)),
                            Text("\u20b9 30000",
                                textAlign: TextAlign.center,
                                style: montserratRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15,fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),*/
            // dashboard.dailyUpdateList.first.profit == 0.0?Container(margin: EdgeInsets.only(top: AppConstants.itemHeight*0.15),child: DataNotFoundScreen('No Data Found')):
            Consumer<DashboardProvider>(builder: (context, dashboard, child) {
              return Column(
                children: [
                  dashboard.dailyUpdateList.first.decAmount == 0.0 || qtyTotal == 0.0 ?const SizedBox():
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: AppConstants.itemWidth * 0.02,top: AppConstants.itemHeight * 0.01),
                    child: Row(
                      children: [
                        const Icon(Icons.circle,color: ColorResources.LINE_BG,size: 10),
                        SizedBox(width: AppConstants.itemWidth * 0.01),
                        Text("Item Detail",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_17),),
                      ],
                    ),
                  ),
                  Provider.of<DashboardProvider>(context, listen: false).isLoading ? const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG,)) :
                  dashboard.dailyUpdateList.first.decAmount == 0.0 || qtyTotal == 0.0 ? Center(child: DataNotFoundScreen("No Data Found")) :
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: DataTablePlus(
                          dividerThickness: 1,
                          columnSpacing: 10,
                          showBottomBorder: true,
                          dataRowHeight: AppConstants.itemHeight*0.04,
                          headingRowHeight: AppConstants.itemHeight*0.04,
                          decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                          columns: [
                            DataColumn(label: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(05),
                              child: Text('Item',
                                  style: montserratBold.copyWith(color: ColorResources.BLACK)),
                            )),
                            DataColumn(label: _verticalDivider),
                            DataColumn(label: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(05),
                              child: Text('Purchase Price',
                                  style: montserratBold.copyWith(color: ColorResources.BLACK)),
                            )),
                            DataColumn(label: _verticalDivider),
                            DataColumn(label: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(05),
                              child: Text('Qty',
                                  style: montserratBold.copyWith(color: ColorResources.BLACK)),
                            )),
                            DataColumn(label: _verticalDivider),
                            DataColumn(label: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(05),
                              child: Text('Amount',
                                  style: montserratBold.copyWith(color: ColorResources.BLACK)),
                            )),
                            DataColumn(label: _verticalDivider),
                            DataColumn(label: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(05),
                              child: Text('Profit',
                                  style: montserratBold.copyWith(color: ColorResources.BLACK)),
                            )),
                          ],
                          customRows: [
                            CustomRow(
                              index: dashboard.dailyUpdateList.length + 1,
                              typeCustomRow: TypeCustomRow.ADD,
                              cells: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(top: 05,bottom: 05),
                                  child: Text('Total',
                                      style: montserratBold.copyWith(color: ColorResources.BLACK)),
                                ),
                                SizedBox(height: AppConstants.itemHeight*0.04,child: _verticalDivider),
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(top: 05,bottom: 05),
                                  child: Text('',
                                      style: montserratBold.copyWith(color: ColorResources.WHITE)),
                                ),
                                SizedBox(height: AppConstants.itemHeight*0.04,child: _verticalDivider),
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(top: 05,bottom: 05),
                                  child: Text(qtyTotal.round().toString(),
                                      style: montserratBold.copyWith(color: ColorResources.BLACK)),
                                ),
                                SizedBox(height: AppConstants.itemHeight*0.04,child: _verticalDivider),
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(top: 05,bottom: 05),
                                  child: Text("\u20b9 ${amountTotal.round().toString()}",
                                      style: montserratBold.copyWith(color: ColorResources.BLACK)),
                                ),
                                SizedBox(height: AppConstants.itemHeight*0.04,child: _verticalDivider),
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(top: 05,bottom: 05,right: 20),
                                  child: Text('\u20b9 ${profitTotal.toStringAsFixed(2)}',
                                      style: montserratBold.copyWith(color: ColorResources.BLACK)),
                                ),
                              ],
                            ),
                          ],
                          rows: List.generate(dashboard.dailyUpdateList.length, (index) {
                            return DataRowPlus(
                              cells:  dashboard.dailyUpdateList[index].decQty==0.0
                                  ?
                              [
                                DataCell.empty,
                                DataCell.empty,
                                DataCell.empty,
                                DataCell.empty,
                                DataCell.empty,
                                DataCell.empty,
                                DataCell.empty,
                                DataCell.empty,
                                DataCell.empty,
                              ]
                                  :
                              <DataCell>[
                                DataCell(Container( alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.all(05),child: Text(dashboard.dailyUpdateList[index].itemName ?? "",style: montserratBold.copyWith(color: ColorResources.BLACK),textAlign: TextAlign.center,),),),
                                DataCell(Container(child: _verticalDivider)),
                                DataCell(Container( alignment: Alignment.center,
                                  padding: const EdgeInsets.all(05),child: Text("\u20b9 ${dashboard.dailyUpdateList[index].decPurcharePrice!.round().toString()}",style: montserratBold.copyWith(color: ColorResources.BLACK),textAlign: TextAlign.center,),),),
                                DataCell(Container(child: _verticalDivider)),
                                DataCell(Container( alignment: Alignment.center,
                                  padding: const EdgeInsets.all(05),child: Text(dashboard.dailyUpdateList[index].decQty!.round().toString(),style: montserratBold.copyWith(color: ColorResources.BLACK),textAlign: TextAlign.center,),),),
                                DataCell(Container(child: _verticalDivider)),
                                DataCell(Container( alignment: Alignment.center,
                                  padding: const EdgeInsets.all(05),child: Text("\u20b9 ${dashboard.dailyUpdateList[index].decAmount!.round().toString()}",style: montserratBold.copyWith(color: ColorResources.BLACK),),),),
                                DataCell(Container(child: _verticalDivider)),
                                DataCell(Container( alignment: Alignment.center,
                                  padding: const EdgeInsets.all(05),child: Text("\u20b9 ${dashboard.dailyUpdateList[index].profit!.toStringAsFixed(2)}",style: montserratBold.copyWith(color: ColorResources.BLACK),),),),
                              ],
                            );
                          })
                        // dashboard.dailyUpdateList.map(((element) => DataRow(
                        //   cells: <DataCell>[
                        //     DataCell(Container( alignment: Alignment.centerLeft,
                        //         padding: const EdgeInsets.all(05),child: Text(element.itemName ?? "",style: montserratBold.copyWith(color: ColorResources.BLACK),textAlign: TextAlign.center,))),
                        //     DataCell(Container(child: _verticalDivider)),
                        //     DataCell(Container( alignment: Alignment.center,
                        //         padding: const EdgeInsets.all(05),child: Text("\u20b9 ${element.decPurcharePrice!.round().toString()}",style: montserratBold.copyWith(color: ColorResources.BLACK),textAlign: TextAlign.center,))),
                        //     DataCell(Container(child: _verticalDivider)),
                        //     DataCell(Container( alignment: Alignment.center,
                        //         padding: const EdgeInsets.all(05),child: Text(element.decQty!.round().toString(),style: montserratBold.copyWith(color: ColorResources.BLACK),textAlign: TextAlign.center,))),
                        //     DataCell(Container(child: _verticalDivider)),
                        //     DataCell(Container( alignment: Alignment.center,
                        //         padding: const EdgeInsets.all(05),child: Text("\u20b9 ${element.decAmount!.round().toString()}",style: montserratBold.copyWith(color: ColorResources.BLACK),))),
                        //     DataCell(Container(child: _verticalDivider)),
                        //     DataCell(Container( alignment: Alignment.center,
                        //         padding: const EdgeInsets.all(05),child: Text("${element.profit!.toStringAsFixed(2)} %",style: montserratBold.copyWith(color: ColorResources.BLACK),))),
                        //   ],
                        // )),
                        // ).toList()
                      ),
                    ),
                  ),
                  dashboard.dailyUpdateList.last.totalAmount == 0.0 ? const SizedBox():
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: AppConstants.itemWidth*0.02),
                      child: Row(
                        children: [
                          const Icon(Icons.circle,size: 10,color: ColorResources.LINE_BG),
                          SizedBox(width: AppConstants.itemWidth*0.01),
                          Text("Payment Detail",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_17)),
                        ],
                      )),
                  dashboard.dailyUpdateList.last.totalAmount == 0.0 ? const SizedBox():
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03,vertical: AppConstants.itemHeight*0.01),
                    margin: EdgeInsets.only(top: AppConstants.itemHeight*0.005,left: AppConstants.itemWidth*0.02,right: AppConstants.itemWidth*0.02),
                    decoration: BoxDecoration(
                      color: ColorResources.WHITE,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Online",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                            Text("\u20b9 ${dashboard.dailyUpdateList.last.decOnlinePayment!.round().toString()}",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Cash",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                            Text("\u20b9 ${dashboard.dailyUpdateList.last.decCashPayment!.round().toString()}",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                          ],
                        ),
                        const Divider(thickness: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                            Text("\u20b9 ${dashboard.dailyUpdateList.last.totalAmount!.round().toString()}",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  dashboard.dailyUpdateList.last.expenseTotalAmount == 0.0 ? const SizedBox():
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: AppConstants.itemWidth*0.02,top: AppConstants.itemHeight*0.02),
                      child: Row(
                        children: [
                          const Icon(Icons.circle,size: 10,color: ColorResources.LINE_BG),
                          SizedBox(width: AppConstants.itemWidth*0.01),
                          Text("Expense Detail",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_17)),
                        ],
                      )),
                  dashboard.dailyUpdateList.last.expenseTotalAmount == 0.0 ? const SizedBox():
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03,vertical: AppConstants.itemHeight*0.01),
                    margin: EdgeInsets.only(top: AppConstants.itemHeight*0.005,left: AppConstants.itemWidth*0.02,right: AppConstants.itemWidth*0.02),
                    decoration: BoxDecoration(
                      color: ColorResources.WHITE,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Online",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                            Text("\u20b9 ${dashboard.dailyUpdateList.last.expensedecOnlinepayment!.round().toString()}",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Cash",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                            Text("\u20b9 ${dashboard.dailyUpdateList.last.expensedecCashpayment!.round().toString()}",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                          ],
                        ),
                        const Divider(thickness: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                            Text("\u20b9 ${dashboard.dailyUpdateList.last.expenseTotalAmount!.round().toString()}",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },),
          ],
        ),
      ),
    );
  }
}
