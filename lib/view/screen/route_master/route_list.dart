import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gas_accounting/data/model/body/route.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/route_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/images.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/no_internet_screen.dart';
import 'package:gas_accounting/view/screen/dashboard/dashboard_screen.dart';
import 'package:gas_accounting/view/screen/route_master/add_route_mastre.dart';
import 'package:gas_accounting/view/screen/route_master/copy_route_master.dart';
import 'package:gas_accounting/view/screen/route_master/edit_route_master.dart';
import 'package:gas_accounting/view/screen/route_master/route_summary.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

class RouteList extends StatefulWidget {
  String? type;
  RouteList(this.type,{Key? key}) : super(key: key);

  @override
  State<RouteList> createState() => _RouteListState();
}

class _RouteListState extends State<RouteList> {
  bool is_loading = true;
  late String formattedMonth = '';
  late String formattedMonthNumber = '';
  late String formattedYear = '';
  late String month = '';
  late String monthNumber = '0';
  late String year = '0';
  late String formattedDate = '';
  late String date_shcedule = '';
  DateTime? selectedDate;
  List<InsertStock_Body> modelList = new List.empty(growable: true);
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
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<RouteProvider>(context, listen: false).getRouteUserList(context,PreferenceUtils.getString("${AppConstants.companyId}"),year,monthNumber).then((value) {
        setState(() {
          is_loading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.push(context,MaterialPageRoute(builder: (context) => Dashboard("Home"),));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorResources.LINE_BG,
          centerTitle: true,
          leading: IconButton(onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => Dashboard("Home"),));
          }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
          title: Text("Route Master",style: montserratSemiBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddRouteMaster("","","",0,0,"new")),);
          },
          backgroundColor: ColorResources.LINE_BG,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100)
          ),
          child: const Icon(Icons.add,size: 40,color: ColorResources.WHITE),
        ),
        body: Consumer<RouteProvider>(builder: (context, route, child) {
          return
           is_loading
              ?
           const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG,),)
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
                children: [
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
                          print("object:::$pickedDate:$month:::::$year::$monthNumber");
                          Provider.of<RouteProvider>(context, listen: false).getRouteUserList(context,PreferenceUtils.getString("${AppConstants.companyId}"),year,monthNumber).then((value) {
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
                  Provider.of<RouteProvider>(context, listen: false).isLoading
                      ?
                  Padding(
                    padding: EdgeInsets.only(top: AppConstants.itemHeight*0.35),
                    child: const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG,)),
                  )
                      :
                  Flexible(
                    child:
                    route.routeList.isNotEmpty
                        ?
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: route.routeList.length,
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.01,vertical: AppConstants.itemHeight*0.005),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: AppConstants.itemHeight*0.003),
                          padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.01,vertical: AppConstants.itemHeight*0.01),
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
                                  route.routeList[index].strDriverName!.substring(0,1).toUpperCase(),
                                  style: poppinsBlack.copyWith(fontSize: Dimensions.FONT_SIZE_18,color: ColorResources.BLACK),
                                ),
                              ),
                              SizedBox(width: AppConstants.itemWidth * 0.03),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: AppConstants.itemWidth*0.68,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text("${route.routeList[index].strDriverName}",style: poppinsSemiBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_17),),
                                        SizedBox(width: AppConstants.itemWidth*0.01),
                                        Container(alignment: Alignment.centerLeft,width: AppConstants.itemWidth*0.36,child: Text("${route.routeList[index].strRouteName}",maxLines: 1,overflow: TextOverflow.ellipsis,style: poppinsSemiBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_17),)),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Image(image: AssetImage(Images.truck),color: ColorResources.GREY,height: 12,width: 12),
                                        Text("  ${route.routeList[index].strVehicleno!.toUpperCase()}   ",style: poppinsSemiBold.copyWith(color: ColorResources.GREY,fontSize: Dimensions.FONT_SIZE_12)),
                                        const Icon(Icons.date_range,color: ColorResources.GREY,size: 12),
                                        Container(alignment: Alignment.centerLeft,width: AppConstants.itemWidth*0.30,child: Text("  ${AppConstants.changeDateMonth(route.routeList[index].strRoutedate.toString())}",style: poppinsSemiBold.copyWith(color: ColorResources.GREY,fontSize: Dimensions.FONT_SIZE_12),)),
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
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditRouteMaster(
                                        route.routeList[index].intId.toString(),
                                        route.routeList[index].strRoutedate.toString(),
                                        route.routeList[index].strVehicleno.toString(),
                                        route.routeList[index].strRouteName.toString(),
                                        route.routeList[index].intDriverid.toString(),
                                        route.routeList[index].intHelperId.toString(),
                                      "edit",
                                      modelList
                                    )));
                                    // Provider.of<RouteProvider>(context, listen: false).getRouteUserDetail(context,route.routeList[index].intId.toString()).then((value) {
                                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => EditRouteMaster(
                                    //       route.routeList[index].intId.toString(),
                                    //       route.routeList[index].strRoutedate.toString(),
                                    //       route.routeList[index].strVehicleno.toString(),
                                    //       route.routeList[index].strRouteName.toString(),
                                    //       route.routeList[index].intDriverid.toString(),
                                    //       route.routeList[index].intHelperId.toString()
                                    //   )),);
                                    // });
                                  }else if (result == 1){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RouteSummary(route.routeList[index].intId.toString())),);
                                  }else if (result == 2) {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => CopyRouteMaster(
                                        route.routeList[index].intId.toString(),
                                        route.routeList[index].strRoutedate.toString(),
                                        route.routeList[index].strVehicleno.toString(),
                                        route.routeList[index].strRouteName.toString(),
                                        route.routeList[index].intDriverid.toString(),
                                        route.routeList[index].intHelperId.toString()
                                    )),);
                                  }  else{
                                    showDialog<bool>(
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: const Text("Are You Sure You Want to Delete ?"),
                                            contentTextStyle: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_16),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Provider.of<RouteProvider>(context, listen: false).getDeleteRoute(context,"${route.routeList[index].intId}",routes).then((value) {
                                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => RouteList(""),));
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
                                        const Icon(Icons.summarize,color: ColorResources.BLACK,),
                                        Text('Summary',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
                                      ],
                                    )),
                                    PopupMenuItem(value: 2,child: Row(
                                      children: [
                                        const Icon(Icons.copy,color: ColorResources.BLACK,),
                                        Text('Copy',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
                                      ],
                                    )),
                                    PopupMenuItem(value: 3,child: Row(
                                      children: [
                                        const Icon(Icons.delete,color: ColorResources.BLACK,),
                                        Text('Delete',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
                                      ],
                                    )),
                                  ];
                                },
                                child: const Icon(Icons.more_vert,color: ColorResources.BLACK,),
                              ),
                          ],)
                          // ListTile(
                          //   horizontalTitleGap: AppConstants.itemHeight*0.01,
                          //   leading: Container(
                          //     alignment: Alignment.center,
                          //     width: AppConstants.itemWidth*0.12,
                          //     height: AppConstants.itemHeight*0.06,
                          //     decoration: BoxDecoration(
                          //       color: Color(Random().nextInt(0xffffffff)).withAlpha(0xff).withOpacity(0.30),
                          //       borderRadius: const BorderRadius.all(Radius.circular(10)),
                          //     ),
                          //     child: Text(
                          //       route.routeList[index].strDriverName!.substring(0,1).toUpperCase(),
                          //       style: poppinsBlack.copyWith(fontSize: Dimensions.FONT_SIZE_18,color: ColorResources.BLACK),
                          //     ),
                          //   ),
                          //   title: Row(
                          //     children: [
                          //       Text("${route.routeList[index].strDriverName}",style: poppinsSemiBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_17),),
                          //       SizedBox(width: AppConstants.itemWidth*0.01),
                          //       Container(alignment: Alignment.centerLeft,width: AppConstants.itemWidth*0.30,child: Text("${route.routeList[index].strRouteName}",maxLines: 1,overflow: TextOverflow.ellipsis,style: poppinsSemiBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_17),)),
                          //     ],
                          //   ),
                          //   subtitle: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: [
                          //       Text("${route.routeList[index].strVehicleno} ",style: poppinsSemiBold.copyWith(color: ColorResources.GREY,fontSize: Dimensions.FONT_SIZE_12),),
                          //       const Icon(Icons.date_range,color: ColorResources.GREY,size: 12),
                          //       Container(alignment: Alignment.centerLeft,width: AppConstants.itemWidth*0.30,child: Text(" ${route.routeList[index].strRoutedate.toString()}",style: poppinsSemiBold.copyWith(color: ColorResources.GREY,fontSize: Dimensions.FONT_SIZE_12),)),
                          //     ],
                          //   ),
                          //   trailing: Column(
                          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //     children: [
                          //       PopupMenuButton(
                          //         color: ColorResources.WHITE,
                          //         surfaceTintColor: ColorResources.WHITE,
                          //         elevation: 10,
                          //         shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          //         onSelected: (result) {
                          //           if (result == 0) {
                          //             Provider.of<RouteProvider>(context, listen: false).getRouteUserDetail(context,route.routeList[index].intId.toString()).then((value) {
                          //               Navigator.push(context, MaterialPageRoute(builder: (context) => EditRouteMaster(
                          //                   route.routeList[index].intId.toString(),
                          //                   route.routeList[index].strRoutedate.toString(),
                          //                   route.routeList[index].strVehicleno.toString(),
                          //                   route.routeList[index].strRouteName.toString(),
                          //                   route.routeList[index].intDriverid.toString(),
                          //                   route.routeList[index].intHelperId.toString()
                          //               )),);
                          //             });
                          //           }else if (result == 1){
                          //             Navigator.push(context, MaterialPageRoute(builder: (context) => RouteSummary(route.routeList[index].intId.toString())),);
                          //           }else{
                          //             showDialog<bool>(
                          //                 barrierDismissible: false,
                          //                 builder: (BuildContext context) {
                          //                   return AlertDialog(
                          //                     content: const Text("Are You Sure You Want to Delete ?"),
                          //                     contentTextStyle: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_16),
                          //                     actions: [
                          //                       TextButton(
                          //                         onPressed: () {
                          //                           Provider.of<RouteProvider>(context, listen: false).getDeleteRoute(context,"${route.routeList[index].intId}",routes).then((value) {
                          //                             // Navigator.push(context, MaterialPageRoute(builder: (context) => RouteList(""),));
                          //                           });
                          //                         },
                          //                         style: const ButtonStyle(
                          //                             backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                          //                             shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                          //                         ),
                          //                         child: Text('Yes',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
                          //                       ),
                          //                       TextButton(
                          //                         onPressed: () {
                          //                           Navigator.pop(context);
                          //                         },
                          //                         style: const ButtonStyle(
                          //                             backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                          //                             shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                          //                         ),
                          //                         child: Text('No',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
                          //                       ),
                          //                     ],
                          //                   );
                          //                 },context: context);
                          //           }
                          //         },
                          //         itemBuilder: (context) {
                          //           return [
                          //             PopupMenuItem(value: 0,child: Row(
                          //               children: [
                          //                 const Icon(Icons.edit,color: ColorResources.BLACK,),
                          //                 Text('Edit',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
                          //               ],
                          //             )),
                          //             PopupMenuItem(value: 1,child: Row(
                          //               children: [
                          //                 const Icon(Icons.summarize,color: ColorResources.BLACK,),
                          //                 Text('Summary',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
                          //               ],
                          //             )),
                          //             PopupMenuItem(value: 2,child: Row(
                          //               children: [
                          //                 const Icon(Icons.delete,color: ColorResources.BLACK,),
                          //                 Text('Delete',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
                          //               ],
                          //             )),
                          //           ];
                          //         },
                          //         child: const Icon(Icons.more_vert,color: ColorResources.BLACK,),
                          //       )
                          //     ],
                          //   ),
                          // ),
                        );
                      },)
                        :
                    DataNotFoundScreen("No Data Found"),
                  ),
                ],
              ),
            );
        },),
      ),
    );
  }

  routes(isRoute,String msg){
    if (isRoute) {
        msg=="0"?AppConstants.getToast("Route can not delete. \n It has use in invoice or payment."):AppConstants.getToast("Deleted Successfully");
        print("object::1$msg");
        Navigator.push(context, MaterialPageRoute(builder: (context) => RouteList(""),));
    }  else{
      print("object::2$msg");
      msg=="1"?AppConstants.getToast("Deleted Successfully"):AppConstants.getToast("Route can not delete. \n It has use in invoice or payment.");
      Navigator.push(context, MaterialPageRoute(builder: (context) => RouteList(""),));
    }
  }
}
