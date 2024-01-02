import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gas_accounting/data/model/response/supplier_response.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/supplier_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/no_internet_screen.dart';
import 'package:gas_accounting/view/screen/dashboard/dashboard_screen.dart';
import 'package:gas_accounting/view/screen/supplier/new_supplier/add_supplier.dart';
import 'package:provider/provider.dart';

class SupplierList extends StatefulWidget {
  const SupplierList({super.key});

  @override
  State<SupplierList> createState() => _SupplierListState();
}

class _SupplierListState extends State<SupplierList> {
  bool isLoading = true;
  SupplierData supplierData = SupplierData();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData(context, true);
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<SupplierProvider>(context, listen: false).getSupplierList(context,PreferenceUtils.getString("${AppConstants.companyId}")).then((value) {
        setState(() {
          isLoading = false;
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
            title: Text("Supplier",style: montserratSemiBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddSupplier(supplierData,"New")));
            },
            backgroundColor: ColorResources.LINE_BG,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)
            ),
            child: const Icon(Icons.add,size: 40,color: ColorResources.WHITE),
          ),
          body: isLoading
              ?
          const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
              :
          supplier.supplierList.isNotEmpty
              ?
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
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemCount: supplier.supplierList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: AppConstants.itemHeight*0.003),
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth * 0.01,vertical: AppConstants.itemHeight*0.01),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: AppConstants.itemWidth*0.12,
                        height: AppConstants.itemHeight*0.06,
                        decoration: BoxDecoration(
                          color: Color(Random().nextInt(0xffffffff)).withAlpha(0xff).withOpacity(0.30),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Text(
                          supplier.supplierList[index].strCompanyName!.substring(0,1).toUpperCase(),
                          style: poppinsBlack.copyWith(fontSize: Dimensions.FONT_SIZE_18,color: ColorResources.BLACK),
                        ),
                      ),
                      SizedBox(width: AppConstants.itemWidth * 0.03),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: AppConstants.itemWidth * 0.68,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: AppConstants.itemWidth*0.35,
                                  child: Text("${supplier.supplierList[index].strCompanyName}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: poppinsSemiBold.copyWith(
                                        color: ColorResources.BLACK,
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: Dimensions.FONT_SIZE_17),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: AppConstants.itemWidth*0.31,
                                  child: Text("${supplier.supplierList[index].strContactPersonName}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: poppinsSemiBold.copyWith(
                                        color: ColorResources.BLACK,
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: Dimensions.FONT_SIZE_17),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: AppConstants.itemWidth*0.45,
                                  child: Text("${supplier.supplierList[index].strContactMobilenumber}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: poppinsSemiBold.copyWith(
                                        color: ColorResources.BLACK,
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: Dimensions.FONT_SIZE_17),
                                  ),
                                ),
                              ],
                            ),
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddSupplier(
                                supplier.supplierList[index],
                                "Edit"),));
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
                                          Provider.of<SupplierProvider>(context, listen: false).getDeleteSupplier(context,"${supplier.supplierList[index].intid}").then((value) {
                                            AppConstants.getToast("Supplier Deleted Successfully");
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SupplierList(),));
                                          });
                                        },
                                        style: const ButtonStyle(
                                            backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                                        ),
                                        child: Text('Yes',style: poppinsRegular.copyWith(color: ColorResources.WHITE)),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: const ButtonStyle(
                                            backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                                        ),
                                        child: Text('No',style: poppinsRegular.copyWith(color: ColorResources.WHITE)),
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
                                const Icon(Icons.delete,color: ColorResources.BLACK),
                                Text('Delete',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
                              ],
                            )),
                          ];
                        },
                        child: const Icon(Icons.more_vert,color: ColorResources.BLACK,),
                      ),
                    ],
                  ),
                );
              },),
          )
              :
          DataNotFoundScreen("No Supplier Found"),
        ),
      );
    },);
  }
}
