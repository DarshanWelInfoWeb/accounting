import 'package:data_table_plus/data_table_plus.dart';
import 'package:gas_accounting/provider/route_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteSummary extends StatefulWidget {
  String id;
  RouteSummary(this.id,{Key? key}) : super(key: key);

  @override
  State<RouteSummary> createState() => _RouteSummaryState();
}

class _RouteSummaryState extends State<RouteSummary> {
  bool is_loading = true;
  double saleTotal = 0;
  double saleTotalQty = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("id::::${widget.id}");
    _loadData(context, true);
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<RouteProvider>(context, listen: false).getRouteUserDetail(context,widget.id);
      Provider.of<RouteProvider>(context, listen: false).getStockList(context,widget.id).then((value) {
        for(int i=0;i<Provider.of<RouteProvider>(context, listen: false).stockList.length;i++){
          saleTotal += Provider.of<RouteProvider>(context, listen: false).stockList[i].invoiceAmt!;
          saleTotalQty += Provider.of<RouteProvider>(context, listen: false).stockList[i].invoiceQty!;
          print("object::::${Provider.of<RouteProvider>(context, listen: false).stockList[i].invoiceAmt}");
          print("re::::$saleTotal");
        }
        print("object::::$saleTotal");
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
    return Consumer<RouteProvider>(builder: (context, route, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorResources.LINE_BG,
          centerTitle: true,
          leading: IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
          title: Text("Summary",style: montserratBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
        ),
        body:
            is_loading
                ?
            const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
                :
            ListView(
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: AppConstants.itemWidth*0.02,top: AppConstants.itemHeight*0.02,),
                    child: Row(
                      children: [
                        const Icon(Icons.circle,size: 10,color: ColorResources.LINE_BG),
                        SizedBox(width: AppConstants.itemWidth*0.01),
                        Text("Route Detail",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_17)),
                      ],
                    )),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03,vertical: AppConstants.itemHeight*0.01),
                  margin: EdgeInsets.only(top: AppConstants.itemHeight*0.005,left: AppConstants.itemWidth*0.02,right: AppConstants.itemWidth*0.02),
                  decoration: BoxDecoration(
                    color: ColorResources.WHITE,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Rote Name",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                          Text("${route.routeDetail?.data.strRouteName}",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Vehicle Number",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                          Text("${route.routeDetail?.data.strvehicleno}",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Driver Name",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                          Text("${route.routeDetail?.data.strDriverName}",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Helper Name",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                          Text("${route.routeDetail?.data.strHelperName}",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: route.stockList.isNotEmpty ? true :false,
                  child: Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: AppConstants.itemWidth*0.02,top: AppConstants.itemHeight*0.02),
                      child: Row(
                        children: [
                          const Icon(Icons.circle,size: 10,color: ColorResources.LINE_BG),
                          SizedBox(width: AppConstants.itemWidth*0.01),
                          Text("Stock Summary",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_17)),
                        ],
                      )),
                ),
                Visibility(
                  visible: route.stockList.isNotEmpty ? true :false,
                  child: SingleChildScrollView(
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
                              child: Text('Qty',
                                  style: montserratBold.copyWith(color: ColorResources.BLACK)),
                            )),
                            DataColumn(label: _verticalDivider),
                            DataColumn(label: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(05),
                              child: Text('SaleQty',
                                  style: montserratBold.copyWith(color: ColorResources.BLACK)),
                            )),
                            DataColumn(label: _verticalDivider),
                            DataColumn(label: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(05),
                              child: Text('SaleAmt',
                                  style: montserratBold.copyWith(color: ColorResources.BLACK)),
                            )),
                          ],
                          customRows: [
                            CustomRow(
                              index: route.stockList.length + 1,
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
                                  child: Text(saleTotalQty.round().toString(),
                                      style: montserratBold.copyWith(color: ColorResources.BLACK)),
                                ),
                                SizedBox(height: AppConstants.itemHeight*0.04,child: _verticalDivider),
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(top: 05,bottom: 05,right: 20),
                                  child: Text("\u20b9 ${saleTotal.round().toString()}",
                                      style: montserratBold.copyWith(color: ColorResources.BLACK)),
                                ),
                              ],
                            ),
                          ],
                          rows: route.stockList.map(((element) => DataRow(
                            cells: <DataCell>[
                              DataCell(Container(alignment: Alignment.center,
                                  padding: const EdgeInsets.all(05),child: Text(element.itemName ?? "",style: montserratBold.copyWith(color: ColorResources.BLACK),textAlign: TextAlign.center,))),
                              DataCell(Container(child: _verticalDivider)),
                              DataCell(Container(alignment: Alignment.center,
                                  padding: const EdgeInsets.all(05),child: Text(element.intQuantity.toString(),style: montserratBold.copyWith(color: ColorResources.BLACK),textAlign: TextAlign.center,))),
                              DataCell(Container(child: _verticalDivider)),
                              DataCell(Container(alignment: Alignment.center,
                                  padding: const EdgeInsets.all(05),child: Text(element.invoiceQty!.round().toString(),style: montserratBold.copyWith(color: ColorResources.BLACK),))),
                              DataCell(Container(child: _verticalDivider)),
                              DataCell(Container(alignment: Alignment.center,
                                  padding: const EdgeInsets.all(05),child: Text("\u20b9 ${element.invoiceAmt!.round().toString()}",style: montserratBold.copyWith(color: ColorResources.BLACK),)),),
                            ],
                          )),
                          ).toList()),
                    ),
                  ),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: AppConstants.itemWidth*0.02,top: AppConstants.itemHeight*0.00),
                    child: Row(
                      children: [
                        const Icon(Icons.circle,size: 10,color: ColorResources.LINE_BG),
                        SizedBox(width: AppConstants.itemWidth*0.01),
                        Text("Payment Detail",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_17)),
                      ],
                    )),
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
                          Text("\u20b9 ${route.routeDetail?.data.decOnlinePayment}",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Cash",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                          Text("\u20b9 ${route.routeDetail?.data.decCashPayment}",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                        ],
                      ),
                      const Divider(thickness: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                          Text("\u20b9 ${route.routeDetail?.data.decTotalAmount}",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                        ],
                      ),
                    ],
                  ),
                ),
                route.routeDetail?.data.ExpenseTotalAmount == 0.0?SizedBox():
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: AppConstants.itemWidth*0.02,top: AppConstants.itemHeight*0.02),
                    child: Row(
                      children: [
                        const Icon(Icons.circle,size: 10,color: ColorResources.LINE_BG),
                        SizedBox(width: AppConstants.itemWidth*0.01),
                        Text("Expense Payment Detail",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_17)),
                      ],
                    )),
                route.routeDetail?.data.ExpenseTotalAmount == 0.0?SizedBox():
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
                          Text("\u20b9 ${route.routeDetail?.data.ExpensedecOnlinepayment}",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Cash",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                          Text("\u20b9 ${route.routeDetail?.data.ExpensedecCashpayment}",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                        ],
                      ),
                      const Divider(thickness: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                          Text("\u20b9 ${route.routeDetail?.data.ExpenseTotalAmount}",style: montserratBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
        ),
      );
    },);
  }
}
