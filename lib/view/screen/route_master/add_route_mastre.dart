import 'dart:convert';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
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
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

class AddRouteMaster extends StatefulWidget {
  String routeName,vehicleNumber,date,type;
  int driver,helper;
  AddRouteMaster(this.routeName,this.vehicleNumber,this.date,this.driver,this.helper,this.type,{Key? key}) : super(key: key);

  @override
  State<AddRouteMaster> createState() => _AddRouteMasterState();
}

class _AddRouteMasterState extends State<AddRouteMaster> {
  TextEditingController dateController =TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController routeNameController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  final SingleValueDropDownController _cnt = SingleValueDropDownController();
  FocusNode dateCode = FocusNode();
  FocusNode vehicleNumberCode = FocusNode();
  FocusNode routeNameCode = FocusNode();
  FocusNode itemCode = FocusNode();
  // FocusNode qtyCode = FocusNode();

  bool is_loading = true;
  bool _isLoading = false;
  DbManager dbManager = new DbManager();

  InsertStock_Body? model;
  InsertStock_Body? models;
  List<InsertStock_Body> modelList = [];
  late String formattedDate = '';
  late String date_shcedule = '';
  TimeOfDay selectedTime = TimeOfDay.now();
  int? driverDropdwon = 0;
  String? driverName = "";
  int? helperDropdwon = 0;
  String? helperName = "";
  dynamic itemsDropdownValue = "Select Item";
  String? itemsDropdownName = "";
  String? itemsUnitName = "";
  dynamic itemSame;
  String? itemsDropdownId ;

  void _date_pik_shcedule() {
    showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: ColorResources.LINE_BG, // header background color
                onPrimary: Colors.white, // header text color
                onSurface: ColorResources.BLACK,
                background: Colors.white
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
    DateTime today = DateTime.now();
    formattedDate = DateFormat('dd/MM/yyyy').format(today);
    dateController.text = widget.type!="item"?formattedDate:widget.date;
    routeNameController.text = widget.routeName;
    vehicleNumberController.text = widget.vehicleNumber;
    setState(() {
      dbManager = DbManager();
        dbManager.getModelList().then((value) {
          setState(() {
            modelList.addAll(value);
            modelList = value;
            print("object::::::4::$modelList$driverDropdwon:::$helperDropdwon");
          });
        });
    });
    print("object::::::4::$modelList::${widget.driver}:::$helperDropdwon");
    _loadData(context, true);
  }

  _routes(maps){
    maps = modelList;
    modelList = maps;
    itemsDropdownValue = "Select Item";
    itemsDropdownName = "";
    print("itemList::::::::$modelList");
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<RouteProvider>(context, listen: false).getDriverHelper(context,PreferenceUtils.getString("${AppConstants.companyId}"),"4").then((value) {
        setState(() {
          is_loading = false;
          for(int i=0;i<Provider.of<RouteProvider>(context, listen: false).driverList.length;i++){
            if (widget.driver == Provider.of<RouteProvider>(context, listen: false).driverList[i].intId) {
              driverDropdwon = widget.driver;
              driverName = Provider.of<RouteProvider>(context, listen: false).driverList[i].srtFullName;
            }
          }
          for(int i=0;i<Provider.of<RouteProvider>(context, listen: false).driverList.length;i++){
            if (widget.helper== Provider.of<RouteProvider>(context, listen: false).driverList[i].intId) {
              helperDropdwon = widget.helper;
              helperName = Provider.of<RouteProvider>(context, listen: false).driverList[i].srtFullName;
            }
          }
          print("object:::::s::::$driverDropdwon::::::$driverName:::::::$helperName:::$helperDropdwon");
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
    }else if(driverDropdwon == null || driverName == "" && driverDropdwon == 0){
      AppConstants.getToast("Please Select Driver");
    }else if(helperDropdwon == null || helperName == "" && helperDropdwon == 0){
      AppConstants.getToast("Please Select Helper");
    }else if(modelList.isEmpty) {
      AppConstants.getToast("Please Add Item");
    }else{
      setState(() {
        _isLoading = true;
      });
      print("model list:::::::::::${modelList.toList()}");
      var apiUrl = '${AppConstants.BASE_URL}${AppConstants.ADD_ROUTE_URI}'; // Replace with your API endpoint

      // Create the nested JSON SQL payload
      var payload = {
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
        // AppConstants.getToast('Route Master Added Successfully');
        print("response::::$responseData");
      } else {
        // Request failed, handle the error here
        AppConstants.getToast("Please Try After Sometime");
        print('Request failed with status: ${response.statusCode}');
      }
      AppConstants.closeKeyboard();
    }
  }
  int? routesId = 0;

  _route(){
    // if(isRoute) {
      driverDropdwon = null;
      helperDropdwon = null;
      itemsDropdownValue = "Select Item";
      itemsDropdownName = "";
      // _rout;
      dbManager.deleteAll();
      print("value::::::::${Provider.of<RouteProvider>(context, listen: false).routeId.toString()}");
      Navigator.push(context,MaterialPageRoute(builder: (context) =>  RouteList(""),));
      AppConstants.getToast('Route Master Added Successfully');
    // }else{
    //   AppConstants.getToast('Please Try After Sometime');
    // }
  }

  _rout(isRoute){
    if(isRoute) {
      driverDropdwon = null;
      helperDropdwon = null;
      dbManager.deleteAll();
      Navigator.push(context,MaterialPageRoute(builder: (context) =>  RouteList(""),));
      AppConstants.getToast('Route Master Added Successfully');
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
        Navigator.push(context,MaterialPageRoute(builder: (context) =>  RouteList(""),));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorResources.LINE_BG,
          centerTitle: true,
          leading: IconButton(onPressed: () {
            PreferenceUtils.remove('map');
            dbManager.deleteAll();
            AppConstants.closeKeyboard();
            Navigator.push(context,MaterialPageRoute(builder: (context) =>  RouteList(""),));
          }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
          title: Text("Add Route Master",style: montserratBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
        ),
        body: Consumer<RouteProvider>(
          builder: (context,route,child) {
            return
            is_loading?
                const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG),):
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
                  margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
                  decoration: BoxDecoration(
                    color: ColorResources.GREY.withOpacity(0.05),
                    borderRadius:BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: CustomSearchableDropDown(
                      menuPadding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.15),
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                      multiSelect: false,
                      dropDownMenuItems: route.driverList.map((areaList) {
                        return areaList.srtFullName;
                      }).toList(),
                      dropdownItemStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                      label: driverName==""?'Select Driver':driverName,
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
                    )
                  ),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                    child: Text("Helper Name",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
                  decoration: BoxDecoration(
                    color: ColorResources.GREY.withOpacity(0.05),
                    borderRadius:BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: CustomSearchableDropDown(
                      menuPadding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.15),
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                      multiSelect: false,
                      dropDownMenuItems: route.driverList.map((areaList) {
                        return areaList.srtFullName;
                      }).toList(),
                      dropdownItemStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                      label: helperName==""?'Select Helper':helperName,
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
                    )
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
                        child:
                        /*DropDownTextField(
                          controller: _cnt,
                          clearOption: true,
                          keyboardType: TextInputType.text,
                          textStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                          listTextStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                          searchKeyboardType: TextInputType.text,
                          searchDecoration: const InputDecoration(hintText: "Search Item"),
                          validator: (value) {
                            if (value == null) {
                              print("object");
                              return "Required field";
                            } else {
                              print("object1");
                              return null;
                            }
                          },
                          enableSearch: true,
                          dropDownItemCount: 6,
                          dropDownList: route.itemList.map((areaList) {
                            return DropDownValueModel(name: areaList.itemName.toString(), value: areaList.intId);
                          }).toList(),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (value) {
                            if(value!=null) {
                              itemsDropdownValue = value;
                              for (int i = 0; i < route.itemList.length; i++) {
                                if (route.itemList[i].intId == itemsDropdownValue) {
                                  itemsDropdownName = route.itemList[i].itemName;
                                  print("Card:::::$itemsDropdownName");
                                }
                              }
                              print("itemId:::$value");
                            }
                            else{
                              itemsDropdownValue = null;
                            }
                          },
                        )*/
                        CustomSearchableDropDown(
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
                                  for (int i = 0; i < route.itemList.length; i++) {
                                    if (route.itemList[i].intid == itemsDropdownValue) {
                                      itemsDropdownName = route.itemList[i].itemName;
                                      itemsUnitName = route.itemList[i].strName;
                                      print("Card:::::$itemsDropdownName");
                                    }
                                  }
                                print("itemId:::$value");
                              }
                              else{
                                itemsDropdownValue = "Select Item";
                                itemsDropdownName = '';
                              }
                          },
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: AppConstants.itemHeight*0.08,
                      width: AppConstants.itemWidth*0.40,
                      child: CustomTextField(
                        controller: qtyController,
                        // focusNode: qtyCode,
                        // nextNode: null,
                        hintText: "Qty",
                        isPhoneNumber: true,
                        textInputType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          for(int i=0;i<modelList.length;i++){
                            InsertStock_Body model = modelList[i];
                            model = modelList[i];
                            models = model;
                            itemSame = modelList.where((element) => element.intStockItemId == itemsDropdownValue);
                            print("itemName:::1::${modelList[i].itemName}");
                          }
                          print("itemName::$itemSame");
                          if (itemsDropdownValue == null) {
                            AppConstants.getToast("Please Select Item");
                          } else if (qtyController.text == '') {
                            AppConstants.getToast("Please Enter Qty");
                          }
                          // else if (itemsDropdownName == models?.itemName) {
                          //   // var item = modelList.firstWhere((i) => i.itemName == itemsDropdownName); // getting the item
                          //   // var index = modelList.indexOf(item); // Item index
                          //   // print("object::::${modelList[index]}:::$index");
                          //   // list[index] = {'a': 'brown', 'b': 'white'};
                          //   print("dropId:::$itemsDropdownName:::modelListId:::${models?.itemName}");
                          //   print("dropId:::${itemsDropdownName == models?.itemName}");
                          //   AppConstants.getToast("This Item is Already Added Please Add Different Item");
                          // }
                          else {
                            setState(() {
                              bool doesItemExit = modelList.any((element) => element.itemName == itemsDropdownName);
                              if (!doesItemExit) {
                                model = InsertStock_Body(
                                    intRouteId: null,
                                    intStockItemId: itemsDropdownValue,
                                    itemName: itemsDropdownName.toString(),
                                    strName: itemsUnitName.toString(),
                                    intQuantity: int.parse(qtyController.text));
                                dbManager.insertModel(model!).then((value) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddRouteMaster(routeNameController.text,vehicleNumberController.text.toUpperCase(),dateController.text,int.parse(driverDropdwon.toString()),int.parse(helperDropdwon.toString()),"item"),));
                                });
                                itemsDropdownValue = "Select Item";
                                itemsDropdownName = "";
                                qtyController.text = "";
                              } else {
                                itemsDropdownValue = "Select Item";
                                itemsDropdownName = "";
                                qtyController.text = "";
                                AppConstants.getToast("This Item is Already Added Please Add Different Item");
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddRouteMaster(routeNameController.text,vehicleNumberController.text.toUpperCase(),dateController.text,int.parse(driverDropdwon.toString()),int.parse(helperDropdwon.toString()),"item"),));
                              }
                            });
                            // if (modelList.containsObject((element) => element == itemsDropdownValue)) {
                            //   print("dropId:::$itemsDropdownValue:::modelListId:::$itemSame");
                            //   itemsDropdownValue = null;
                            //   itemsDropdownName = "";
                            //   qtyController.text = "";
                            //   AppConstants.getToast("This Item is Already Added Please Add Different Item");
                            // } else {
                              setState(() {
                                print("dropId:::$itemsDropdownName:::modelListId:::${models?.itemName}");
                                print("dropId:::${itemsDropdownName == models?.itemName}");
                                // model = InsertStock_Body(
                                //     intRouteId: null,
                                //     intStockItemId: itemsDropdownValue,
                                //     itemName: itemsDropdownName.toString(),
                                //     intQuantity: int.parse(qtyController.text));
                                // dbManager.insertModel(model!);
                                itemsDropdownValue = "Select Item";
                                itemsDropdownName = "";
                                qtyController.text = "";
                                _routes;
                                AppConstants.closeKeyboard();
                                print("list::::$itemsDropdownName:::::$itemsDropdownValue");
                              });
                            // }
                          }
                        },
                        icon: const Icon(
                          Icons.add,
                          size: 30,
                          color: ColorResources.GREEN,
                        )),
                  ],
                ),
                FutureBuilder(
                  future: dbManager.getModelList(),
                  builder: (context, snapshot) {
                    itemsDropdownValue = "Select Item";
                    itemsDropdownName = "";
                    if (snapshot.hasData) {
                      modelList = snapshot.data as List<InsertStock_Body>; // print("object::${snapshot.data}");
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
                              const DataColumn(label: SizedBox()),
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
                            rows: List.generate(modelList.length, (index) {
                              InsertStock_Body model = modelList[index];
                              model = modelList[index];
                              return DataRow(
                                  cells: <DataCell>[
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
                                                        dbManager.deleteModel(modelList[index]).then((value) {
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddRouteMaster(routeNameController.text,vehicleNumberController.text.toUpperCase(),dateController.text,int.parse(driverDropdwon.toString()),int.parse(helperDropdwon.toString()),"item"),));
                                                        });
                                                        itemsDropdownValue = "Select Item";
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
                                                      itemsDropdownValue = "Select Item";
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
                                ]
                              );
                            }),
                      ),
                        );
                        /*ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: modelList.length,
                        itemBuilder: (context, index) {
                          InsertStock_Body model = modelList[index];
                          model = modelList[index];
                          // itemSame = modelList[index].itemName;
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
                                          'Name: ${model.itemName}',
                                          overflow: TextOverflow.fade,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      Text(
                                        'Quantity: ${model.intQuantity}',
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
                                            setState(() {
                                              PreferenceUtils.remove('map');
                                              dbManager.deleteModel(modelList[index]);
                                            });
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
                      );*/
                    }
                    return const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG));
                  },
                ),
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



