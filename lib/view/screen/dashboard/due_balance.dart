import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gas_accounting/data/model/body/customerduereport_response.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/customer_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/no_internet_screen.dart';
import 'package:gas_accounting/view/screen/dashboard/dashboard_screen.dart';
import 'package:gas_accounting/view/screen/manage_customer/transaction_history.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DueBalance extends StatefulWidget {
  const DueBalance({Key? key}) : super(key: key);

  @override
  State<DueBalance> createState() => _DueBalanceState();
}

class _DueBalanceState extends State<DueBalance> {
  TextEditingController controller = TextEditingController();
  bool is_loading = true;
  List<CustomerDueReportData> customerFiltered = [];
  double amountTotal = 0.0;
  double decTotalDueAmount = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerFiltered = Provider.of<CustomerProvider>(context, listen: false).customerDueReportList;
    _loadData(context, true);
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<CustomerProvider>(context, listen: false).getCustomerDueReport(context,PreferenceUtils.getString(AppConstants.companyId.toString())).then((value) {
        for(int i=0;i<Provider.of<CustomerProvider>(context, listen: false).customerDueReportList.length;i++){
          amountTotal += Provider.of<CustomerProvider>(context, listen: false).customerDueReportList[i].decDueAmount!;
          decTotalDueAmount = Provider.of<CustomerProvider>(context, listen: false).customerDueReportList[i].decTotalDueAmount!;
        }
        setState(() {
          is_loading = false;
          customerFiltered = is_loading
              ? Provider.of<CustomerProvider>(context, listen: false).customerDueReportList
              : Provider.of<CustomerProvider>(context, listen: false).customerDueReportList
              .where((item) => item.strCustomerName!.contains("") ||
              item.strMobileNo!.contains(""))
              .toList();
        });
      });
    });
  }


  void _onSearchTextChanged(String text) {
    setState(() {
      print("search::$text");
      customerFiltered = text.isEmpty
          ? Provider.of<CustomerProvider>(context, listen: false).customerDueReportList
          : Provider.of<CustomerProvider>(context, listen: false).customerDueReportList
          .where((item) => item.strCustomerName!.toUpperCase().contains(text.toUpperCase()) ||
          item.strCustomerName!.toLowerCase().contains(text.toLowerCase()) ||
          item.strMobileNo!.contains(text))
          .toList();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(builder: (context, customer, child) {
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
            title: Text("Due Balance",style: montserratSemiBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
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
                // width: AppConstants.itemWidth*0.825,
                margin: EdgeInsets.symmetric(horizontal: AppConstants.itemHeight*0.01,vertical: AppConstants.itemHeight*0.01),
                decoration: BoxDecoration(
                  color: ColorResources.WHITE,
                  borderRadius:BorderRadius.circular(10),
                  border: Border.all(color: ColorResources.GREY),
                ),
                child: TextFormField(
                  controller: controller,
                  maxLines: 1,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.search,
                  cursorColor: ColorResources.LINE_BG,
                  style: montserratRegular.copyWith(fontWeight: FontWeight.w500,color: ColorResources.BLACK,fontSize: 17),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search,color: ColorResources.GREY,size: 25),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.cancel,color: ColorResources.GREY,size: 25),
                      onPressed: () {
                        setState(() {
                          controller.clear();
                          customerFiltered = Provider.of<CustomerProvider>(context, listen: false).customerDueReportList;
                          AppConstants.closeKeyboard();
                        });
                      },
                    ),
                    hintText: "Search",
                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                    border: InputBorder.none,
                    fillColor: ColorResources.WHITE,
                    contentPadding: EdgeInsets.symmetric(vertical: AppConstants.itemHeight*0.02, horizontal: AppConstants.itemWidth*0.006),
                  ),
                  onChanged: _onSearchTextChanged,
                ),
              ),
              Column(
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: AppConstants.itemWidth * 0.05,top: AppConstants.itemHeight * 0.01),
                    child: Text("Total Amount : \u20b9 $decTotalDueAmount",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_17),),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: AppConstants.itemWidth * 0.02,top: AppConstants.itemHeight * 0.01),
                    child: Row(
                      children: [
                        const Icon(Icons.circle,color: ColorResources.LINE_BG,size: 10),
                        SizedBox(width: AppConstants.itemWidth * 0.01),
                        Text("Customer Detail",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_17),),
                      ],
                    ),
                  ),
                  customerFiltered.isNotEmpty
                      ?
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                    decoration: BoxDecoration(
                      color: ColorResources.WHITE,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: ColorResources.GREY.withOpacity(0.10),
                          offset: const Offset(1, 1),
                          spreadRadius: 1,
                          blurRadius: 1
                        )
                      ]
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      itemCount: customerFiltered.length,
                      itemBuilder: (context, index) {
                        String myString = customerFiltered[index].strCustomerName.toString();
                        String capitalizedString = myString.capitalize();

                      return ListTile(
                        horizontalTitleGap: AppConstants.itemHeight*0.01,
                        onTap: () {
                          print("customerId::::${customerFiltered[index].intCustomerid}");
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionHistory(customerFiltered[index].intCustomerid!,0,
                              customerFiltered[index].strMobileNo.toString(),"",customerFiltered[index].strCustomerName.toString()),));
                        },
                        title: Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.0,vertical: AppConstants.itemHeight*0.005),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: AppConstants.itemWidth * 0.12,
                                    height: AppConstants.itemHeight * 0.06,
                                    margin: EdgeInsets.only(right: AppConstants.itemWidth*0.02),
                                    decoration: BoxDecoration(
                                      color: Color(Random().nextInt(0xffffffff)).withAlpha(0xff).withOpacity(0.30),
                                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                                    ),
                                    child: Text(
                                      customerFiltered[index].strCustomerName!.substring(0,1).toUpperCase(),
                                      style: poppinsBlack.copyWith(fontSize: Dimensions.FONT_SIZE_19,color: ColorResources.BLACK),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: AppConstants.itemWidth*0.50,
                                            child: Text(capitalizedString,
                                              maxLines: 1,
                                              style: poppinsSemiBold.copyWith(
                                                  color: ColorResources.BLACK,
                                                  overflow: TextOverflow.ellipsis,
                                                  fontSize: Dimensions.FONT_SIZE_16),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            width: AppConstants.itemWidth*0.20,
                                            child: Text("\u20b9 ${customerFiltered[index].decDueAmount!.toStringAsFixed(0)}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: poppinsSemiBold.copyWith(
                                                  color: ColorResources.BLACK,
                                                  overflow: TextOverflow.ellipsis,
                                                  fontSize: Dimensions.FONT_SIZE_16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: AppConstants.itemHeight*0.005),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              makingPhoneCall(customerFiltered[index].strMobileNo);
                                            },
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              width: AppConstants.itemWidth*0.45,
                                              child: Text(customerFiltered[index].strMobileNo ?? "",
                                                maxLines: 1,
                                                style: poppinsSemiBold.copyWith(
                                                    color: ColorResources.BLACK,
                                                    overflow: TextOverflow.ellipsis,
                                                    fontSize: Dimensions.FONT_SIZE_14),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            width: AppConstants.itemWidth*0.25,
                                            child: Text(customerFiltered[index].dtLastpaymentdate ?? "",
                                              maxLines: 1,
                                              style: poppinsSemiBold.copyWith(
                                                  color: ColorResources.BLACK,
                                                  overflow: TextOverflow.ellipsis,
                                                  fontSize: Dimensions.FONT_SIZE_14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: AppConstants.itemHeight*0.01),
                              customerFiltered.last == customerFiltered[index]?const SizedBox():
                              const Divider(height: 0.05),
                            ],
                          ),
                        ),
                      );
                    },),
                  )
                  /*SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: DataTable(
                          dividerThickness: 1,
                          columnSpacing: 15,
                          showBottomBorder: true,
                          dataRowHeight: AppConstants.itemHeight*0.04,
                          headingRowHeight: AppConstants.itemHeight*0.04,
                          border: TableBorder.all(color: Colors.black12),
                          // decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                          columns: [
                            DataColumn(label: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(05),
                              child: Text('Name',
                                  style: montserratBold.copyWith(color: ColorResources.BLACK)),
                            )),
                            DataColumn(label: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(05),
                              child: Text('Mobile',
                                  style: montserratBold.copyWith(color: ColorResources.BLACK)),
                            )),
                            DataColumn(label: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(05),
                              child: Text('Due Amount',
                                  style: montserratBold.copyWith(color: ColorResources.BLACK)),
                            )),
                            DataColumn(label: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(05),
                              child: Text('Last Payment Date',
                                  style: montserratBold.copyWith(color: ColorResources.BLACK)),
                            )),
                            DataColumn(label: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(05),
                              child: Text('Due Date',
                                  style: montserratBold.copyWith(color: ColorResources.BLACK)),
                            )),
                          ],
                          rows: List.generate(customerFiltered.length, (index) {
                            final item = customerFiltered[index];
                            return DataRow(
                                cells: <DataCell>[
                                  DataCell(Container(alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.all(05),child: Text(item.strCustomerName.toString(),style: montserratBold.copyWith(color: ColorResources.BLACK),textAlign: TextAlign.center,))),
                                  DataCell(Container(alignment: Alignment.center,
                                      padding: const EdgeInsets.all(05),child: Text(item.strMobileNo.toString(),style: montserratBold.copyWith(color: ColorResources.BLACK),textAlign: TextAlign.center,))),
                                  DataCell(Container(alignment: Alignment.center,
                                      padding: const EdgeInsets.all(05),child: Text("\u20b9 ${item.decDueAmount!.round().toString()}",style: montserratBold.copyWith(color: ColorResources.BLACK),textAlign: TextAlign.center,))),
                                  DataCell(Container(alignment: Alignment.center,
                                      padding: const EdgeInsets.all(05),child: Text(item.dtLastpaymentdate == null ? "" : item.dtLastpaymentdate.toString(),style: montserratBold.copyWith(color: ColorResources.BLACK),textAlign: TextAlign.center,))),
                                  DataCell(Container(alignment: Alignment.center,
                                      padding: const EdgeInsets.all(05),child: Text(item.dtDuedate == null ? "" : item.dtDuedate.toString(),style: montserratBold.copyWith(color: ColorResources.BLACK),textAlign: TextAlign.center,))),
                                ],
                              );
                          }),
                      ),
                    ),
                  )*/
                      :
                  DataNotFoundScreen('No Data Found'),
                ],
              ),
            ],
          ),
        ),
      );
    },);
  }
}


extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}