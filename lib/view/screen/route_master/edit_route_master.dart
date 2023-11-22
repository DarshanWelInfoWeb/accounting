import 'dart:convert';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:gas_accounting/data/model/response/stocklist_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gas_accounting/data/model/body/route.dart';
import 'package:gas_accounting/helper/dataBase.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/route_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/custom_button.dart';
import 'package:gas_accounting/view/basewidget/custom_password_textfield.dart';
import 'package:gas_accounting/view/basewidget/custom_textfield.dart';
import 'package:gas_accounting/view/screen/route_master/route_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditRouteMaster extends StatefulWidget {
  String id,date,number,name,driverId,helperId,type;
  List<InsertStock_Body> modelList;
  // int driverId,helperId;
  EditRouteMaster(this.id,this.date,this.number,this.name,this.driverId,this.helperId,this.type, this.modelList,{Key? key}) : super(key: key);

  @override
  State<EditRouteMaster> createState() => _EditRouteMasterState();
}

class _EditRouteMasterState extends State<EditRouteMaster> {
  TextEditingController dateController =TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController routeNameController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  TextEditingController qtyController = TextEditingController();

  FocusNode dateCode = FocusNode();
  FocusNode vehicleNumberCode = FocusNode();
  FocusNode routeNameCode = FocusNode();
  FocusNode itemCode = FocusNode();
  FocusNode qtyCode = FocusNode();

  bool is_loading = true;
  bool _isLoading = false;
  bool is_load = true;
  DbManager dbManager = new DbManager();

  InsertStock_Body? model;
  List<InsertStock_Body>? driverStockModel;
  List<InsertStock_Body> modelList = new List.empty(growable: true);
  List<dynamic> modelLists = new List.empty(growable: true);
  late String formattedDate = '';
  late String date_shcedule = '';
  TimeOfDay selectedTime = TimeOfDay.now();
  String? driverDropdwon ;
  String? driverName;
  String? helperDropdwon ;
  String? helperName;
  dynamic itemsDropdownValue ;
  String? itemsDropdownName ;
  String? itemsUnitName ;
  String? sameItem ;

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
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("object::${widget.id}:::${widget.date}::::::::${widget.name}::::${widget.driverId}");
    DateTime today = DateTime.now();
    formattedDate = DateFormat('dd/MM/yyyy').format(today);
    widget.date==""?
    dateController.text = formattedDate:
    dateController.text = widget.date;
    vehicleNumberController.text = widget.number.toUpperCase();
    routeNameController.text = widget.name;
    driverDropdwon = widget.driverId;
    helperDropdwon = widget.helperId;
    print("Card:::::$itemsDropdownName");
    setState(() {
      dbManager = DbManager();
      dbManager.getModelList().then((value) {
        setState(() {
          modelList.addAll(value);
          modelList = value;
          print("object::::::4::${modelList.length}");
        });
      });
    });
    _loadData(context, true);
  }
  List<StockListData> items = [];

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<RouteProvider>(context, listen: false).getRouteUserDetail(context,widget.id).then((value) {
        itemsDropdownName = Provider.of<RouteProvider>(context, listen: false).routeDetail!.data.driverStockModel[0].StrItemName;
        driverName = Provider.of<RouteProvider>(context, listen: false).routeDetail!.data.strDriverName;
        helperName = Provider.of<RouteProvider>(context, listen: false).routeDetail!.data.strHelperName;
        print("Card:::1::$itemsDropdownName");
        setState(() {
          is_loading = false;
        });
      });
      Provider.of<RouteProvider>(context, listen: false).getStockList(context,widget.id).then((value) {
        for(int i=0;i<Provider.of<RouteProvider>(context, listen: false).stockList.length;i++){
          sameItem = Provider.of<RouteProvider>(context, listen: false).stockList[i].itemName;
          print("name::::$sameItem");
        }
      });
      Provider.of<RouteProvider>(context, listen: false).getDriverHelper(context,PreferenceUtils.getString("${AppConstants.companyId}"),"4").then((value) {
        setState(() {
          is_loading = false;
        });
      });
      Provider.of<RouteProvider>(context, listen: false).getItemList(context,PreferenceUtils.getString("${AppConstants.companyId}"),'0','0');
    });
  }

  addRoute() async {
    if (vehicleNumberController.text == '') {
      AppConstants.getToast("Please Enter Vehicle Number");
    }else if(routeNameController.text == ''){
      AppConstants.getToast("Please Enter Route Name");
    }else if(driverDropdwon == 0){
      AppConstants.getToast("Please Select Driver");
    }else if(helperDropdwon == 0) {
      AppConstants.getToast("Please Select Helper");
    }else if(modelList.isEmpty && Provider.of<RouteProvider>(context, listen: false).stockList.isEmpty) {
      AppConstants.getToast("Please Add Item");
    }else{
      /*UpdateRoute_Body routes = UpdateRoute_Body(
        intId: int.parse(widget.id),
        dtRouteDate: dateController.text,
        strvehicleno: vehicleNumberController.text,
        strRouteName: routeNameController.text,
        intDriverid: int.parse(driverDropdwon.toString()),
        intHelperid: int.parse(helperDropdwon.toString()),
        intCompanyId: int.parse(PreferenceUtils.getString("${AppConstants.companyId}")),
      );
      Provider.of<RouteProvider>(context, listen: false).getUpdateRoute(context,routes,_route).then((value) {
        for(int i=0; i< modelList.length; i++){
          print("list::length:::${modelList.length}::${modelList[i].intStockItemId}");
          InsertStock_Body item = InsertStock_Body(
            intRouteId: int.parse(widget.id),
            intStockItemId: modelList[i].intStockItemId,
            intQuantity: modelList[i].intQuantity,
          );
          print("value::for::routeId:${Provider.of<RouteProvider>(context, listen: false).routeId}:::::stockId:${modelList[i].intStockItemId}:::stockQTY:${modelList[i].intQuantity}");
          // modelList.length != null?
          // Provider.of<RouteProvider>(context, listen: false).getAddItem(context,item,_route):
          Provider.of<RouteProvider>(context, listen: false).getAddItem(context,item);
          AppConstants.closeKeyboard();
        }
      });*/
      setState(() {
        _isLoading = true;
      });
      print("model list:::::::::::${modelList.toList()}");
      var apiUrl = '${AppConstants.BASE_URL}${AppConstants.ADD_ROUTE_URI}';

      // Create the nested JSON SQL payload
      var payload = {
        "intId": int.parse(widget.id),
        "dtRouteDate": dateController.text,
        "strvehicleno": vehicleNumberController.text.toUpperCase(),
        "strRouteName": routeNameController.text,
        "intDriverid": driverDropdwon,
        "intHelperid": helperDropdwon,
        "intCompanyId": int.parse(PreferenceUtils.getString("${AppConstants.companyId}")),
        "driverStockModel": [
          for(int i=0; i< modelList.length; i++){
            "intStockItemId": modelList[i].intStockItemId,
            "intQuantity": modelList[i].intQuantity,
          }
        ]
      };
      // Convert the nested payload to JSON
      var payloadJson = json.encode(payload);

      // Send the POST request
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: payloadJson,
      );
      setState(() {
        _isLoading = false;
        for(int i=0;i<items.length;i++){
          print("itemId::${items[i].intId}");
          Provider.of<RouteProvider>(context, listen: false).getDeleteStock(context,items[i].intId.toString());
        }
      });
      // Check the response
      if (response.statusCode == 200) {
        // Request successful, handle the response here
        var responseData = json.decode(response.body);
        setState(() {
          _isLoading = false;
        });
        dbManager.deleteAll();
        _route();
        // AppConstants.getToast('Route Master Edited Successfully');
        print("response::::$responseData");
      } else {
        // Request failed, handle the error here
        AppConstants.getToast("Please Try After Sometime");
        print('Request failed with status: ${response.statusCode}');
      }
      AppConstants.closeKeyboard();
    }
  }

  _route(){
    // if(isRoute) {
      driverDropdwon = null;
      helperDropdwon = null;
      dbManager.deleteAll();
      print("object::1:");
      Navigator.push(context,MaterialPageRoute(builder: (context) => RouteList(""),));
      AppConstants.getToast('Route Master Edited Successfully');
    // }else{
    //   AppConstants.getToast('Please Try After Sometime');
    // }
  }

  _rout(isRoute){
    if(isRoute) {
      driverDropdwon = null;
      helperDropdwon = null;
      dbManager.deleteAll();
      print("object::2:");
      Navigator.push(context,MaterialPageRoute(builder: (context) => RouteList("edit"),)).then((value) {
        Provider.of<RouteProvider>(context, listen: false).getRouteUserList(context,PreferenceUtils.getString("${AppConstants.companyId}"),"0","0");
      });
      AppConstants.getToast('Route Master Edited Successfully');
    }else{
      AppConstants.getToast('Please Try After Sometime');
    }
  }

  final Widget _verticalDivider = const VerticalDivider(
    color: Colors.black12,
    thickness: 1,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        dbManager.deleteAll();
        AppConstants.closeKeyboard();
        Navigator.push(context,MaterialPageRoute(builder: (context) => RouteList(""),));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorResources.LINE_BG,
          centerTitle: true,
          leading: IconButton(onPressed: () {
            dbManager.deleteAll();
            AppConstants.closeKeyboard();
            Navigator.push(context,MaterialPageRoute(builder: (context) => RouteList(""),));
          }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
          title: Text("Add Route Master",style: montserratBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
        ),
        body: Consumer<RouteProvider>(
            builder: (context,route,child) {
              return
                is_loading
                    ?
                const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG),)
                    :
                ListView(
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                  children: [
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
                          nextNode: vehicleNumberCode,
                        ),
                      ),
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                        child: Text("Vehicle Number",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                      child: CustomTextField(
                        controller: vehicleNumberController,
                        focusNode: vehicleNumberCode,
                        nextNode: routeNameCode,
                        hintText: "Vehicle Number",
                        isPhoneNumber: false,
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                        child: Text("Route Name",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                      child: CustomTextField(
                        controller: routeNameController,
                        focusNode: routeNameCode,
                        nextNode: null,
                        hintText: "Route Name",
                        isPhoneNumber: false,
                        textInputType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                        child: Text("Driver Name",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
                    Container(
                      width: double.infinity,
                      height: AppConstants.itemHeight*0.06,
                      margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
                      decoration: BoxDecoration(
                        color: ColorResources.GREY.withOpacity(0.05),
                        borderRadius:BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                          child:
                         /* CustomSearchableDropDown(
                            menuPadding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.15),
                            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                            multiSelect: false,
                            dropDownMenuItems: route.driverList.map((areaList) {
                              return areaList.srtFullName;
                            }).toList(),
                            dropdownItemStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                            label: driverName ?? 'Select Driver',
                            labelStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                            items : route.driverList.map((areaList) {
                              return  areaList.intId;
                            }).toList(),
                            onChanged: (value){
                              if(value!=null)
                              {
                                driverDropdwon = value;
                                print("object:::$value");
                              }
                              else{
                                driverDropdwon = null;
                                print("object:::$value");
                              }
                            },
                          )*/
                        DropdownButton<String>(
                          hint: Text('Select Driver',style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),),
                          value: driverDropdwon,
                          dropdownColor: Colors.white,
                          menuMaxHeight: 200,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 15,
                          style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                          underline: Container(
                            height: 0,
                            color: Colors.white,
                          ),
                          onChanged: null,
                          //     (String? newValue) {
                          //   setState(() {
                          //     driverDropdwon = newValue!;
                          //   });
                          // },
                          items: route.driverList.map((areaList) {
                            return DropdownMenuItem<String>(
                              value: areaList.intId.toString(),
                              child: Text(areaList.srtFullName.toString()),
                            );
                          }).toList(),
                          itemHeight: AppConstants.itemHeight*0.07,
                      ),
                      ),
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                        child: Text("Helper Name",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
                    Container(
                      width: double.infinity,
                      height: AppConstants.itemHeight*0.06,
                      margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
                      decoration: BoxDecoration(
                        color: ColorResources.GREY.withOpacity(0.05),
                        borderRadius:BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                          child:
                          /*CustomSearchableDropDown(
                            menuPadding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.15),
                            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                            multiSelect: false,
                            dropDownMenuItems: route.driverList.map((areaList) {
                              return areaList.srtFullName;
                            }).toList(),
                            dropdownItemStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                            label: helperName ?? 'Select Helper',
                            labelStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                            items : route.driverList.map((areaList) {
                              return  areaList.intId;
                            }).toList(),
                            onChanged: (value){
                              if(value!=null)
                              {
                                helperDropdwon = value;
                                print("object:::$value");
                              }
                              else{
                                helperDropdwon = null;
                                print("object:::$value");
                              }
                            },
                          )*/
                        DropdownButton<String>(
                        hint: Text('Select Helper',style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),),
                        value: helperDropdwon,
                        dropdownColor: Colors.white,
                        menuMaxHeight: 200,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 15,
                        style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                        underline: Container(
                          height: 0,
                          color: Colors.white,
                        ),
                        onChanged: null,
                        //     (String? newValue) {
                        //   setState(() {
                        //     helperDropdwon = newValue!;
                        //   });
                        // },
                        items: route.driverList.map((areaList) {
                          return DropdownMenuItem<String>(
                            value: areaList.intId.toString(),
                            child: Row(
                              children: [
                                Text(areaList.srtFullName.toString()),
                              ],
                            ),
                          );
                        }).toList(),
                        itemHeight: AppConstants.itemHeight*0.07,
                    ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                      child: Text("Stock Summary",style: montserratBold.copyWith(color: ColorResources.BLACK)),
                    ),
                    Row(
                      children: [
                        Container(
                          // height: AppConstants.itemHeight*0.06,
                          width: AppConstants.itemWidth*0.40,
                          margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.01,vertical: AppConstants.itemHeight*0.01),
                          // padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                          decoration: BoxDecoration(
                            color: ColorResources.GREY.withOpacity(0.05),
                            borderRadius:BorderRadius.circular(10),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: CustomSearchableDropDown(
                              menuPadding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.15),
                              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.00),
                              multiSelect: false,
                              dropDownMenuItems: route.itemList.map((areaList) {
                                return areaList.itemName;
                              }).toList(),
                              dropdownItemStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                              label: 'Select Item',
                              labelStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                              items : route.itemList.map((areaList) {
                                return areaList.intid;
                              }).toList(),
                              onChanged: (value){
                                if(value!=null) {
                                  itemsDropdownValue = value;
                                  for(int i=0;i<route.itemList.length;i++){
                                    if(route.itemList[i].intid==itemsDropdownValue){
                                      itemsDropdownName = route.itemList[i].itemName;
                                      itemsUnitName = route.itemList[i].strName;
                                      print("Card:::::$itemsDropdownName");
                                    }
                                  }
                                  print("itemId:::$value");
                                }
                                else{
                                  itemsDropdownValue = null;
                                  print("object:::$value");
                                }

                              },
                            ),
                            // DropdownButton<String>(
                            //   hint: Text('Select Item',style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),),
                            //   value: itemsDropdownValue,
                            //   dropdownColor: Colors.white,
                            //   menuMaxHeight: 200,
                            //   icon: const Icon(Icons.arrow_drop_down),
                            //   elevation: 15,
                            //   style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                            //   underline: Container(
                            //     height: 0,
                            //     color: Colors.white,
                            //   ),
                            //   onChanged: (String? newValue) {
                            //     setState(() {
                            //       itemsDropdownValue = newValue!;
                            //       for(int i=0;i<route.itemList.length;i++){
                            //         if(route.itemList[i].intId.toString()==itemsDropdownValue){
                            //           itemsDropdownName = route.itemList[i].itemName;
                            //           print("Card:::::$itemsDropdownName");
                            //         }
                            //       }
                            //     });
                            //   },
                            //   items: route.itemList.map((areaList) {
                            //     return DropdownMenuItem<String>(
                            //       value: areaList.intId.toString(),
                            //       child: Text(areaList.itemName.toString(),maxLines: 1),
                            //     );
                            //   }).toList(),
                            //   itemHeight: AppConstants.itemHeight*0.07,
                            //   isExpanded: true,
                            // ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: AppConstants.itemHeight*0.06,
                          width: AppConstants.itemWidth*0.40,
                          child: CustomTextField(
                            controller: qtyController,
                            focusNode: qtyCode,
                            nextNode: null,
                            hintText: "Qty",
                            isPhoneNumber: true,
                            textInputType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              if (itemsDropdownValue == null) {
                                AppConstants.getToast("Please Select Item");
                              }
                              else if (qtyController.text == '') {
                                AppConstants.getToast("Please Enter Qty");
                              } else {
                                bool doesItemExit = modelList.any((element) => element.itemName == itemsDropdownName);
                                bool doesItemExits = route.stockList.any((element) => element.itemName == itemsDropdownName);
                                for(int i=0;i<route.routeDetail!.data.driverStockModel.length;i++){
                                  if(route.routeDetail!.data.driverStockModel[i].intId==itemsDropdownValue){
                                    itemsDropdownName = route.routeDetail!.data.driverStockModel[i].StrItemName;
                                    print("Card:::::$itemsDropdownName");
                                  }
                                }
                                setState(() {
                                  if (!doesItemExit && !doesItemExits) {
                                    model = InsertStock_Body(
                                        intRouteId: int.parse(widget.id),
                                        intStockItemId: itemsDropdownValue,
                                        itemName: itemsDropdownName.toString(),
                                        strName: itemsUnitName.toString(),
                                        intQuantity: int.parse(qtyController.text));
                                    dbManager.insertModel(model!).then((value){
                                      return Navigator.push(context, MaterialPageRoute(builder: (context) => EditRouteMaster(widget.id, dateController.text, widget.number, widget.name, widget.driverId, widget.helperId,"table",modelList),));
                                    });
                                    itemsDropdownValue = null;
                                    qtyController.text = "";
                                  }  else {
                                    itemsDropdownValue = null;
                                    itemsDropdownName = "";
                                    qtyController.text = "";
                                    AppConstants.getToast("This Item is Already Added Please Add Different Item");
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditRouteMaster(widget.id, dateController.text, widget.number, widget.name, widget.driverId, widget.helperId,"table",modelList),));
                                  }
                                });
                                print("Card:::::$itemsDropdownName");
                              }
                            },
                            icon: const Icon(
                              Icons.add,
                              size: 30,
                              color: ColorResources.GREEN,
                            )),
                      ],
                    ),
                    /*Visibility(
                        visible: route.stockList.length !=null ?true:false,
                        child:
                        route.stockList.isEmpty
                            ?
                        const SizedBox()
                            :
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: DataTable(
                            dividerThickness: 1,
                            columnSpacing: AppConstants.itemWidth*0.085,
                            dataRowHeight: AppConstants.itemHeight*0.04,
                            headingRowHeight: AppConstants.itemHeight*0.04,
                            decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                            columns: [
                              DataColumn(label: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(05),
                                child: Text('Name',
                                    style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                              )),
                              DataColumn(label: _verticalDivider),
                              DataColumn(label: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(05),
                                child: Text('QTY',
                                    style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                              )),
                              DataColumn(label: _verticalDivider),
                              DataColumn(label: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(05),
                                child: Text('Delete',
                                    style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                              )),
                            ],
                            rows: List.generate( route.stockList.length, (index) {
                              return DataRow(
                                  cells: <DataCell>[
                                    DataCell(Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.all(05),
                                        child: Text(
                                          "${ route.stockList[index].itemName}",
                                          style: poppinsBold.copyWith(
                                              color: ColorResources.BLACK),
                                          textAlign: TextAlign.center,
                                        ))),
                                    DataCell(Container(child: _verticalDivider)),
                                    DataCell(Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.all(05),
                                        child: Text(
                                          "${ route.stockList[index].intQuantity}",
                                          style: poppinsBold.copyWith(
                                              color: ColorResources.BLACK),
                                          textAlign: TextAlign.center,
                                        ))),
                                    DataCell(Container(child: _verticalDivider)),
                                    DataCell(GestureDetector(
                                      onTap: (){
                                        showDialog<bool>(
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: const Text("Are You Sure You Want to Delete ?"),
                                                contentTextStyle: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_16),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        Provider.of<RouteProvider>(context, listen: false).getDeleteStock(context,route.stockList[index].intId.toString()).then((value) {
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => EditRouteMaster(widget.id, widget.date, widget.number, widget.name, widget.driverId, widget.helperId,"",modelList),));
                                                        });
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
                                                      itemsDropdownValue = null;
                                                      itemsDropdownName = "";
                                                      qtyController.text = "";
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
                                      },
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.all(05),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          )),
                                    )),
                                  ]
                              );
                            }),
                          ),
                        )
                    // ListView.builder(
                    //       shrinkWrap: true,
                    //       physics: const NeverScrollableScrollPhysics(),
                    //       itemCount: route.stockList.length,
                    //       itemBuilder: (context, index) {
                    //         sameItem = route.stockList[index].itemName;
                    //         return Card(
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //               children: <Widget>[
                    //                 Column(
                    //                   crossAxisAlignment: CrossAxisAlignment.start,
                    //                   children: <Widget>[
                    //                     Container(
                    //                       alignment: Alignment.centerLeft,
                    //                       width: AppConstants.itemWidth*0.75,
                    //                       child: Text(
                    //                         'Name: ${route.stockList[index].itemName}',
                    //                         style: const TextStyle(fontSize: 15),
                    //                       ),
                    //                     ),
                    //                     Text(
                    //                       'Quantity: ${route.stockList[index].intQuantity}',
                    //                       style: const TextStyle(
                    //                         fontSize: 15,
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //                 Row(
                    //                   children: [
                    //                     CircleAvatar(
                    //                       backgroundColor: Colors.white,
                    //                       child: IconButton(
                    //                         onPressed: (){
                    //                           showDialog<bool>(
                    //                               barrierDismissible: false,
                    //                               builder: (BuildContext context) {
                    //                                 return AlertDialog(
                    //                                   content: const Text("Are You Sure You Want to Delete ?"),
                    //                                   contentTextStyle: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_16),
                    //                                   actions: [
                    //                                     TextButton(
                    //                                       onPressed: () {
                    //                                         setState(() {
                    //                                           Provider.of<RouteProvider>(context, listen: false).getDeleteStock(context,route.stockList[index].intId.toString()).then((value) {
                    //                                             Navigator.push(context, MaterialPageRoute(builder: (context) => EditRouteMaster(widget.id, widget.date, widget.number, widget.name, widget.driverId, widget.helperId),));
                    //                                           });
                    //                                         });
                    //                                       },
                    //                                       style: const ButtonStyle(
                    //                                           backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                    //                                           shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                    //                                       ),
                    //                                       child: Text('Yes',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
                    //                                     ),
                    //                                     TextButton(
                    //                                       onPressed: () {
                    //                                         itemsDropdownValue = null;
                    //                                         itemsDropdownName = "";
                    //                                         qtyController.text = "";
                    //                                         Navigator.pop(context);
                    //                                       },
                    //                                       style: const ButtonStyle(
                    //                                           backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                    //                                           shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                    //                                       ),
                    //                                       child: Text('No',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
                    //                                     ),
                    //                                   ],
                    //                                 );
                    //                               },context: context);
                    //                         },
                    //                         icon: const Icon(
                    //                           Icons.delete,
                    //                           color: Colors.red,
                    //                         ),
                    //                       ),
                    //                     )
                    //                   ],
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         );
                    //       },
                    //     )
                    ),*/
                    /*FutureBuilder(
                      future: dbManager.getModelList(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          modelList = snapshot.data as List<InsertStock_Body>;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: modelList.length,
                            itemBuilder: (context, index) {
                              InsertStock_Body _model = modelList[index];
                              model = modelList[index];
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: AppConstants.itemWidth*0.75,
                                            child: Text(
                                              'Name: ${_model.itemName}',
                                              style: const TextStyle(fontSize: 15),
                                            ),
                                          ),
                                          Text(
                                            'Quantity: ${_model.intQuantity}',
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: IconButton(
                                              onPressed: (){
                                                showDialog<bool>(
                                                    barrierDismissible: false,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        content: const Text("Are You Sure You Want to Delete ?"),
                                                        contentTextStyle: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_16),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                PreferenceUtils.remove('map');
                                                                dbManager.deleteModel(_model);
                                                                itemsDropdownValue = null;
                                                                itemsDropdownName = "";
                                                                qtyController.text = "";
                                                                Navigator.pop(context);
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
                                                              itemsDropdownValue = null;
                                                              itemsDropdownName = "";
                                                              qtyController.text = "";
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
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG));
                      },
                    ),*/
                    /*FutureBuilder(
                      future: dbManager.getModelList(),
                      builder: (context, snapshot) {
                        itemsDropdownValue = null;
                        itemsDropdownName = "";
                        if (snapshot.hasData) {
                          modelList = snapshot.data as List<InsertStock_Body>;
                          return
                            modelList.isEmpty
                                ?
                            const SizedBox()
                                :
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: DataTable(
                                dividerThickness: 1,
                                columnSpacing: AppConstants.itemWidth*0.085,
                                dataRowHeight: AppConstants.itemHeight*0.04,
                                headingRowHeight: AppConstants.itemHeight*0.04,
                                decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                                columns: [
                                  DataColumn(label: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(05),
                                    child: Text('Name',
                                        style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                                  )),
                                  DataColumn(label: _verticalDivider),
                                  DataColumn(label: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(05),
                                    child: Text('QTY',
                                        style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                                  )),
                                  DataColumn(label: _verticalDivider),
                                  DataColumn(label: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(05),
                                    child: Text('Delete',
                                        style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                                  )),
                                ],
                                rows: List.generate(modelList.length, (index) {
                                  InsertStock_Body model = modelList[index];
                                  model = modelList[index];
                                  return DataRow(
                                      cells: <DataCell>[
                                        DataCell(Container(
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.all(05),
                                            child: Text(
                                              "${model.itemName}",
                                              style: poppinsBold.copyWith(
                                                  color: ColorResources.BLACK),
                                              textAlign: TextAlign.center,
                                            ))),
                                        DataCell(Container(child: _verticalDivider)),
                                        DataCell(Container(
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.all(05),
                                            child: Text(
                                              "${model.intQuantity}",
                                              style: poppinsBold.copyWith(
                                                  color: ColorResources.BLACK),
                                              textAlign: TextAlign.center,
                                            ))),
                                        DataCell(Container(child: _verticalDivider)),
                                        DataCell(GestureDetector(
                                          onTap: (){
                                            showDialog<bool>(
                                                barrierDismissible: false,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    content: const Text("Are You Sure You Want to Delete ?"),
                                                    contentTextStyle: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_16),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            PreferenceUtils.remove('map');
                                                            dbManager.deleteModel(model);
                                                            itemsDropdownValue = null;
                                                            itemsDropdownName = "";
                                                            qtyController.text = "";
                                                            Navigator.pop(context);
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
                                                          itemsDropdownValue = null;
                                                          itemsDropdownName = "";
                                                          qtyController.text = "";
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
                                          },
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              padding: const EdgeInsets.all(05),
                                              child: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              )),
                                        )),
                                      ]
                                  );
                                }),
                              ),
                            );
                        }
                        return const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG));
                      },
                    ),*/
                    MyDataTableMerge(widget.id, dateController.text, widget.number, widget.name, widget.driverId, widget.helperId,modelList,route.stockList),
                    SizedBox(height: AppConstants.itemHeight*0.05),
                    _isLoading
                    // Provider.of<RouteProvider>(context).isLoading
                        ?
                    const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG,))
                        :
                    CustomButtonFuction(onTap: () => addRoute(), buttonText: "Submit"),
                  ],
                );
            }
        ),
      ),
    );
  }
}



class MyDataTableMerge extends StatefulWidget {
  String id,date,number,name,driverId,helperId;
  List<InsertStock_Body> modelList;
  List<StockListData> stockList;
  MyDataTableMerge(this.id,this.date,this.number,this.name,this.driverId,this.helperId,this.modelList, this.stockList,{super.key});

  @override
  State<MyDataTableMerge> createState() => _MyDataTableMergeState();
}

class _MyDataTableMergeState extends State<MyDataTableMerge> {
  DbManager dbManager = new DbManager();
  InsertStock_Body? model;
  List<InsertStock_Body>? driverStockModel;
  List<InsertStock_Body> modelList = new List.empty(growable: true);
  List<dynamic> modelLists = new List.empty(growable: true);
  String? sameItem ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbManager.getModelList();
    setState(() {
      dbManager = DbManager();
      dbManager.getModelList().then((value) {
        setState(() {
          modelList.addAll(value);
          modelList = value;
          print("object::::::4::${modelList}");
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
    return Center(
      child: FutureBuilder(
        future: Future(() {
          dbManager.getModelList();
        }),
        builder: (context,snapshot) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: DataTable(
              dividerThickness: 1,
              columnSpacing: AppConstants.itemWidth*0.085,
              dataRowHeight: AppConstants.itemHeight*0.04,
              headingRowHeight: AppConstants.itemHeight*0.04,
              decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
              columns: [
                DataColumn(label: SizedBox()),
                DataColumn(label: _verticalDivider),
                DataColumn(label: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(05),
                  child: Text('Name',
                      style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                )),
                DataColumn(label: _verticalDivider),
                DataColumn(label: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(05),
                  child: Text('QTY',
                      style: poppinsBold.copyWith(color: ColorResources.BLACK)),
                )),
              ],
              rows: _buildRows(),
            ),
          );
        }
      ),
    );
  }

  List<DataRow> _buildRows() {
    List<DataRow> rows = [];

    // Replace these with your actual data
    List<Map<String, String>> data1 = [
      {'col1': 'Data A1', 'col2': 'Data A2'},
      {'col1': 'Data B1', 'col2': 'Data B2'},
    ];

    List<Map<String, String>> data2 = [
      {'col1': 'Data X1', 'col2': 'Data X2'},
      {'col1': 'Data Y1', 'col2': 'Data Y2'},
    ];
    InsertStock_Body model;
    for(int i=0;i<modelList.length;i++) {
      model = modelList[i];
    }
    // Add rows from data1
    rows.addAll(modelList.map((item) => DataRow(
      cells: [
        DataCell(GestureDetector(
          onTap: (){
            showDialog<bool>(
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text("Are You Sure You Want to Delete ?"),
                    contentTextStyle: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_16),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            PreferenceUtils.remove('map');
                            dbManager.deleteModel(item).then((value) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditRouteMaster(widget.id, widget.date, widget.number, widget.name, widget.driverId, widget.helperId,"table",modelList),));
                            });
                            Navigator.pop(context);
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
          },
          child: Container(
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.delete,
                color: Colors.red,
              )),
        )),
        DataCell(Container(child: _verticalDivider)),
        DataCell(Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(05),
            child: Text(
              "${item.itemName}",
              style: poppinsBold.copyWith(
                  color: ColorResources.BLACK),
              textAlign: TextAlign.center,
            ))),
        DataCell(Container(child: _verticalDivider)),
        DataCell(Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(05),
            child: Text(
              "${item.intQuantity}",
              style: poppinsBold.copyWith(
                  color: ColorResources.BLACK),
              textAlign: TextAlign.center,
            ))),
      ],
    )));

    // Add rows from data2
    rows.addAll(Provider.of<RouteProvider>(context).stockList.map((item) => DataRow(
      cells: [
        DataCell(GestureDetector(
          onTap: (){
            showDialog<bool>(
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text("Are You Sure You Want to Delete ?"),
                    contentTextStyle: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_16),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            Provider.of<RouteProvider>(context, listen: false).getDeleteStock(context,item.intId.toString()).then((value) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditRouteMaster(widget.id, widget.date, widget.number, widget.name, widget.driverId, widget.helperId,"table",modelList),));
                            });
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
          },
          child: Container(
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.delete,
                color: Colors.red,
              )),
        )),
        DataCell(Container(child: _verticalDivider)),
        DataCell(Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(05),
            child: Text(
              "${item.itemName}",
              style: poppinsBold.copyWith(
                  color: ColorResources.BLACK),
              textAlign: TextAlign.center,
            ))),
        DataCell(Container(child: _verticalDivider)),
        DataCell(Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(05),
            child: Text(
              "${item.intQuantity}",
              style: poppinsBold.copyWith(
                  color: ColorResources.BLACK),
              textAlign: TextAlign.center,
            ))),
      ],
    )));

    return rows;
  }
}
