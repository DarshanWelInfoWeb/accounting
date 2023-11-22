import 'package:flutter/material.dart';
import 'package:gas_accounting/data/model/body/addunitmaster_body.dart';
import 'package:gas_accounting/data/model/response/unitmaster_response.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/supplier_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/custom_textfield.dart';
import 'package:gas_accounting/view/basewidget/no_internet_screen.dart';
import 'package:gas_accounting/view/screen/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

class UnitManage extends StatefulWidget {
  const UnitManage({super.key});

  @override
  State<UnitManage> createState() => _UnitManageState();
}

class _UnitManageState extends State<UnitManage> {
  TextEditingController unitNameController = TextEditingController();
  TextEditingController unitSearchController = TextEditingController();
  FocusNode fieldFocusNode = FocusNode();
  List<UnitMasterData> unitFiltered = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData(context, true);
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<SupplierProvider>(context, listen: false).getUnitMasterList(context,PreferenceUtils.getString(AppConstants.companyId.toString())).then((value) {
        setState(() {
          isLoading = false;
          unitFiltered = isLoading
              ? Provider.of<SupplierProvider>(context, listen: false).unitMasterList
              : Provider.of<SupplierProvider>(context, listen: false).unitMasterList
              .where((item) => item.strname!.toUpperCase().contains("") ||
              item.strname!.toLowerCase().contains(""))
              .toList();
        });
      });
    });
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      print("search::$text");
      unitFiltered = text.isEmpty
          ? Provider.of<SupplierProvider>(context, listen: false).unitMasterList
          : Provider.of<SupplierProvider>(context, listen: false).unitMasterList
          .where((item) => item.strname!.toUpperCase().contains(text.toUpperCase()) ||
          item.strname!.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  addUnit(){
    if(unitNameController.text == ''){
      AppConstants.getToast("Please Enter Unit Name");
    }else{
      AddUnitBody addUnitBody = AddUnitBody(
        strname: unitNameController.text,
        intCompanyid: int.parse(PreferenceUtils.getString(AppConstants.companyId.toString())),
        createdBy: int.parse(PreferenceUtils.getString(AppConstants.companyId.toString())),
      );
      Provider.of<SupplierProvider>(context,listen: false).getAddUnitMaster(context, addUnitBody, route);
      AppConstants.closeKeyboard();
    }
  }

  route(isRoute){
    if(isRoute){
      Navigator.push(context, MaterialPageRoute(builder: (context) => const UnitManage(),));
      AppConstants.getToast("Unit Added Successfully");
    }else{
      AppConstants.getToast("Please Try After Some Time");
    }
  }

  _route(isRoute){
    if(isRoute){
      Navigator.push(context, MaterialPageRoute(builder: (context) => const UnitManage(),));
      AppConstants.getToast("Unit Updated Successfully");
    }else{
      AppConstants.getToast("Please Try After Some Time");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.push(context,MaterialPageRoute(builder: (context) => Dashboard("Home"),));
        return true;
      },
      child: Consumer<SupplierProvider>(builder: (context, unit, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorResources.LINE_BG,
            centerTitle: true,
            leading: IconButton(onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => Dashboard("Home"),));
            }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
            title: Text("Unit Management",style: montserratSemiBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              unitNameController.clear();
              showDialog<bool>(
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(top: AppConstants.itemHeight*0.005,right: AppConstants.itemWidth*0.05),
                                  child: const Icon(Icons.highlight_remove,size: 27,color: Colors.grey))),
                          Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(bottom: AppConstants.itemHeight*0.01),
                              child: Text("Add Unit",style: poppinsBold.copyWith(color: ColorResources.BLACK,fontSize: 16),)),
                          Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.04),
                              child: Row(
                                children: [
                                  Text("Unit Name",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                                  Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.04,vertical: AppConstants.itemHeight*0.01),
                            child: CustomTextField(
                              controller: unitNameController,
                              hintText: "Unit Name",
                              isPhoneNumber: false,
                              textInputType: TextInputType.name,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Provider.of<SupplierProvider>(context).isLoading
                                  ?
                              const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(color: ColorResources.LINE_BG),
                                ],
                              )
                                  :
                              TextButton(
                                onPressed: () {
                                  addUnit();
                                },
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                                ),
                                child: Text('Add',style: poppinsRegular.copyWith(color: ColorResources.WHITE)),
                              ),
                              TextButton(
                                onPressed: () {
                                  unitNameController.clear();
                                },
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                                ),
                                child: Text('Clear',style: poppinsRegular.copyWith(color: ColorResources.WHITE)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },context: context);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)
            ),
            backgroundColor: ColorResources.LINE_BG,
            child: const Icon(Icons.add,size: 40,color: ColorResources.WHITE),
          ),
          body: Column(
            children: [
              Container(
                // width: AppConstants.itemWidth*0.75,
                margin: EdgeInsets.symmetric(horizontal: AppConstants.itemHeight*0.01,vertical: AppConstants.itemHeight*0.01),
                decoration: BoxDecoration(
                  color: ColorResources.WHITE,
                  borderRadius:BorderRadius.circular(10),
                  border: Border.all(color: ColorResources.GREY),
                ),
                child: TextFormField(
                  controller: unitSearchController,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  style: montserratRegular.copyWith(fontWeight: FontWeight.w500,color: ColorResources.BLACK,fontSize: 17),
                  enableSuggestions: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search,color: ColorResources.GREY,size: 25),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.cancel,color: ColorResources.GREY,size: 25),
                      onPressed: () {
                        setState(() {
                          unitSearchController.clear();
                          unitFiltered = Provider.of<SupplierProvider>(context, listen: false).unitMasterList;
                          AppConstants.closeKeyboard();
                        });
                      },
                    ),
                    hintText: "Search Unit",
                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                    border: InputBorder.none,
                    fillColor: ColorResources.WHITE,
                    contentPadding: EdgeInsets.symmetric(vertical: AppConstants.itemHeight*0.02, horizontal: AppConstants.itemWidth*0.006),
                  ),
                  onChanged: _onSearchTextChanged,
                ),
              ),
              isLoading
                  ?
              Padding(
                padding: EdgeInsets.only(top: AppConstants.itemHeight * 0.35),
                child: const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG)),
              )
                  :
              Flexible(
                child: Container(
                  margin: EdgeInsets.all(AppConstants.itemHeight*0.01),
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
                  child:
                  unitFiltered.isNotEmpty
                      ?
                  ListView.builder( scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: unitFiltered.length,
                    padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth * 0.02,vertical: AppConstants.itemHeight*0.01),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: AppConstants.itemHeight*0.003),
                        padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth * 0.01,vertical: AppConstants.itemHeight*0.01),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: AppConstants.itemWidth*0.55,
                              margin: EdgeInsets.only(left: AppConstants.itemWidth*0.01),
                              child: Text("${index + 1}. ${unitFiltered[index].strname}",
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
                                width: AppConstants.itemWidth*0.27,
                                child:
                                unitFiltered[index].boolStatus == true
                                    ?
                                Row(
                                  children: [
                                    const Icon(Icons.radio_button_on_outlined,color: ColorResources.GREEN),
                                    SizedBox(width: AppConstants.itemWidth*0.01),
                                    Text("Active",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                                  ],
                                )
                                    :
                                Row(
                                  children: [
                                    const Icon(Icons.radio_button_on_outlined,color: ColorResources.RED),
                                    SizedBox(width: AppConstants.itemWidth*0.01),
                                    Text("In Active",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                                  ],
                                )),
                            PopupMenuButton(
                              color: ColorResources.WHITE,
                              surfaceTintColor: ColorResources.WHITE,
                              elevation: 10,
                              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              onSelected: (value) {
                                if(value == 0){
                                  showDialog<bool>(
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.only(bottom: AppConstants.itemHeight*0.01,top: AppConstants.itemHeight*0.01),
                                                  child: Text("Status Confirmation",style: poppinsBold.copyWith(color: ColorResources.BLACK,fontSize: 16),)),
                                              Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                                                  child: Text("Are you sure want to change status?",style: poppinsSemiBold.copyWith(color: ColorResources.BLACK),)),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Provider.of<SupplierProvider>(context).isLoading
                                                      ?
                                                  const Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      CircularProgressIndicator(color: ColorResources.LINE_BG),
                                                    ],
                                                  )
                                                      :
                                                  TextButton(
                                                    onPressed: () {
                                                      Provider.of<SupplierProvider>(context, listen: false).getStatusChangeUnitMaster(context, unitFiltered[index].intid.toString(),PreferenceUtils.getString(AppConstants.companyId.toString())).then((value) {
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => UnitManage(),));
                                                      });
                                                    },
                                                    style: const ButtonStyle(
                                                        backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                                                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))))
                                                    ),
                                                    child: Text('Change',style: poppinsRegular.copyWith(color: ColorResources.WHITE)),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    style: const ButtonStyle(
                                                        backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                                                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))))
                                                    ),
                                                    child: Text('Cancel',style: poppinsRegular.copyWith(color: ColorResources.WHITE)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },context: context);
                                }else if(value == 1){
                                  unitNameController.text = unitFiltered[index].strname.toString();
                                  showDialog<bool>(
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              GestureDetector(
                                                  onTap: () => Navigator.pop(context),
                                                  child: Container(
                                                      alignment: Alignment.centerRight,
                                                      padding: EdgeInsets.only(top: AppConstants.itemHeight*0.005,right: AppConstants.itemWidth*0.02),
                                                      child: const Icon(Icons.highlight_remove,size: 27,color: Colors.grey))),
                                              Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.only(bottom: AppConstants.itemHeight*0.01),
                                                  child: Text("Update Unit",style: poppinsBold.copyWith(color: ColorResources.BLACK,fontSize: 16),)),
                                              Container(
                                                  alignment: Alignment.centerLeft,
                                                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.04),
                                                  child: Row(
                                                    children: [
                                                      Text("Unit Name",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                                                      Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                                                    ],
                                                  )),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.04,vertical: AppConstants.itemHeight*0.01),
                                                child: CustomTextField(
                                                  controller: unitNameController,
                                                  hintText: "Unit Name",
                                                  isPhoneNumber: false,
                                                  textInputType: TextInputType.name,
                                                  textInputAction: TextInputAction.done,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Provider.of<SupplierProvider>(context).isLoading
                                                      ?
                                                  const Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      CircularProgressIndicator(color: ColorResources.LINE_BG),
                                                    ],
                                                  )
                                                      :
                                                  TextButton(
                                                    onPressed: () {
                                                      if(unitNameController.text == ''){
                                                        AppConstants.getToast("Please Enter Unit Name");
                                                      }else{
                                                        AddUnitBody addUnitBody = AddUnitBody(
                                                          intid: unitFiltered[index].intid,
                                                          strname: unitNameController.text,
                                                          intCompanyid: int.parse(PreferenceUtils.getString(AppConstants.companyId.toString())),
                                                          createdBy: int.parse(PreferenceUtils.getString(AppConstants.companyId.toString())),
                                                        );
                                                        Provider.of<SupplierProvider>(context,listen: false).getAddUnitMaster(context, addUnitBody, _route);
                                                        AppConstants.closeKeyboard();
                                                      }
                                                    },
                                                    style: const ButtonStyle(
                                                        backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                                                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                                                    ),
                                                    child: Text('Update',style: poppinsRegular.copyWith(color: ColorResources.WHITE)),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      unitNameController.clear();
                                                      // Navigator.pop(context);
                                                    },
                                                    style: const ButtonStyle(
                                                        backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                                                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                                                    ),
                                                    child: Text('Clear',style: poppinsRegular.copyWith(color: ColorResources.WHITE)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },context: context);
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
                                                Provider.of<SupplierProvider>(context, listen: false).getDeleteUnitMaster(context,"${unit.unitMasterList[index].intid}").then((value) {
                                                  AppConstants.getToast("Deleted Successfully");
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const UnitManage()));
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
                                      unitFiltered[index].boolStatus == true?
                                      const Icon(Icons.check,color: ColorResources.BLACK):
                                      const Icon(Icons.close,color: ColorResources.BLACK),
                                      Text('Status',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
                                    ],
                                  )),
                                  PopupMenuItem(value: 1,child: Row(
                                    children: [
                                      const Icon(Icons.edit,color: ColorResources.BLACK,),
                                      Text('Edit',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
                                    ],
                                  )),
                                  PopupMenuItem(value: 2,child: Row(
                                    children: [
                                      const Icon(Icons.delete,color: ColorResources.BLACK),
                                      Text('Delete',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
                                    ],
                                  )),
                                ];
                              },
                              child: const Icon(Icons.more_vert,color: ColorResources.BLACK,),)
                          ],
                        ),
                      );
                    },)
                      :
                  DataNotFoundScreen("No Data Found"),
                ),
              )
            ],
          ),
        );
      },),
    );
  }
}
