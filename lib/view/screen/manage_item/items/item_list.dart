import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gas_accounting/data/model/response/items_response.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/item_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/images.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/no_internet_screen.dart';
import 'package:gas_accounting/view/screen/dashboard/dashboard_screen.dart';
import 'package:gas_accounting/view/screen/manage_item/items/add_new_item.dart';
import 'package:gas_accounting/view/screen/manage_item/items/edit_item.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  TextEditingController controller = TextEditingController();
  FocusNode fieldFocusNode = FocusNode();
  bool is_loading = true;
  List<ItemsListData> customerFiltered = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData(context, true);
  }

  void _onShare(BuildContext context,String itemName,String price,String fName,String lName) async {
    await Share.share("Item Name : $itemName \n Sale Price : $price \n\n Thank You \n $fName $lName");
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<ItemProvider>(context, listen: false).getItemsList(context,PreferenceUtils.getString("${AppConstants.companyId}")).then((value) {
        setState(() {
          is_loading = false;
          customerFiltered = is_loading
              ? Provider.of<ItemProvider>(context, listen: false).itemsList
              : Provider.of<ItemProvider>(context, listen: false).itemsList
              .where((item) => item.itemName!.toUpperCase().contains("") ||
              item.itemName!.toLowerCase().contains("") ||
              item.strItemCode!.toUpperCase().contains("") ||
              item.strItemCode!.toLowerCase().contains(""))
              .toList();
        });
      });
    });
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      print("search::$text");
      customerFiltered = text.isEmpty
          ? Provider.of<ItemProvider>(context, listen: false).itemsList
          : Provider.of<ItemProvider>(context, listen: false).itemsList
          .where((item) => item.itemName!.toUpperCase().contains(text.toUpperCase()) ||
          item.itemName!.toLowerCase().contains(text.toLowerCase()) ||
          item.strItemCode!.toUpperCase().contains(text) ||
          item.strItemCode!.toLowerCase().contains(text))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.push(context,MaterialPageRoute(builder: (context) => Dashboard("Home")));
        return true;
      },
      child: Consumer<ItemProvider>(builder: (context, items, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorResources.LINE_BG,
            centerTitle: true,
            leading: IconButton(onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) =>  Dashboard("Home")));
            }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
            title: Text("Items",style: montserratBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewItem("")));
            },
            backgroundColor: ColorResources.LINE_BG,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)
            ),
            child: const Icon(Icons.add,size: 40,color: ColorResources.WHITE),
          ),
          body:
          Column(
            children: [
              /*Autocomplete(
                optionsMaxHeight: AppConstants.itemHeight * 0.25,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  return customerFiltered.where((ItemsListData item) => item.itemName!.startsWith(textEditingValue.text)).toList();
                },
                displayStringForOption: (ItemsListData option) => option.itemName.toString(),
                fieldViewBuilder: (
                    BuildContext context,
                    controller,
                    fieldFocusNode,
                    VoidCallback onFieldSubmitted
                    ) {
                  return TextField(
                    controller: controller,
                    focusNode: fieldFocusNode,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    onChanged: _onSearchTextChanged,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search,color: ColorResources.GREY,size: 25),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.cancel,color: ColorResources.GREY,size: 25),
                        onPressed: () {
                          setState(() {
                            controller.clear();
                            customerFiltered = Provider.of<ItemProvider>(context, listen: false).itemsList;
                            AppConstants.closeKeyboard();
                          });
                        },
                      ),
                      border: InputBorder.none,
                      hintText: "Search Item",
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                      fillColor: ColorResources.WHITE,
                      contentPadding: EdgeInsets.symmetric(vertical: AppConstants.itemHeight*0.02, horizontal: AppConstants.itemWidth*0.006),
                    ),
                  );
                },
                onSelected: (ItemsListData selection) {
                  print('Selected: ${selection.itemName}::${selection.intId}');
                },
                optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<ItemsListData> onSelected, Iterable<ItemsListData> options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      child: Container(
                        width: AppConstants.itemWidth * 0.60,
                        height: AppConstants.itemHeight * 0.25,
                        color: Colors.white,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(10.0),
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final ItemsListData option = options.elementAt(index);
                            return GestureDetector(
                              onTap: () {
                                onSelected(option);
                              },
                              child: ListTile(
                                title: Text(option.itemName.toString(), style: const TextStyle(color: Colors.black)),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),*/
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
                          controller.clear();
                          customerFiltered = Provider.of<ItemProvider>(context, listen: false).itemsList;
                          AppConstants.closeKeyboard();
                        });
                      },
                    ),
                    suffix:
                    customerFiltered.isNotEmpty
                        ?
                    const SizedBox()
                        :
                    InkWell(
                        onTap: () {
                          setState(() {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewItem(controller.text),)).then((value) {                            AppConstants.closeKeyboard();
                            setState(() {
                              controller.clear();
                              customerFiltered = Provider.of<ItemProvider>(context, listen: false).itemsList;
                              AppConstants.closeKeyboard();
                            });
                            });
                          });
                        },
                        child: Text(
                          "Add New Item",
                          style: montserratRegular.copyWith(
                              fontWeight: FontWeight.w500,
                              color: ColorResources.BLACK,
                              fontSize: 17),
                        ),
                      ),
                    hintText: "Search Item by Name or Code",
                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                    border: InputBorder.none,
                    fillColor: ColorResources.WHITE,
                    contentPadding: EdgeInsets.symmetric(vertical: AppConstants.itemHeight*0.02, horizontal: AppConstants.itemWidth*0.006),
                  ),
                  onChanged: _onSearchTextChanged,
                ),
              ),
              is_loading
                  ?
              Padding(
                padding: EdgeInsets.only(top: AppConstants.itemHeight * 0.30),
                child: const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG)),
              )
                  :
              Flexible(
                child:
                customerFiltered.isNotEmpty
                    ?
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: customerFiltered.length,
                    padding: EdgeInsets.only(top: AppConstants.itemHeight*0.02),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => EditItem(customerFiltered[index].intId.toString()),));
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: AppConstants.itemWidth * 0.80,
                                    child: Text(
                                      "${customerFiltered[index].itemName}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: poppinsSemiBold.copyWith(color: ColorResources.BLACK,
                                          overflow: TextOverflow.fade,
                                          fontSize: Dimensions.FONT_SIZE_17),
                                    ),
                                  ),
                                  GestureDetector(onTap: () {
                                    _onShare(context,customerFiltered[index].itemName.toString(),customerFiltered[index].decSellPrice.toString(),PreferenceUtils.getString(AppConstants.fName),PreferenceUtils.getString(AppConstants.lName));
                                  },child: const Image(image: AssetImage(Images.share),height: 25,width: 25,color: ColorResources.GREY)),
                                  /*PopupMenuButton(
                                    color: ColorResources.WHITE,
                                    surfaceTintColor: ColorResources.WHITE,
                                    elevation: 10,
                                    shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    onSelected: (result) {
                                      if (result == 0) {
                                        print("object::${customerFiltered[index].intId.toString()}");
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditItem(customerFiltered[index].intId.toString()),));
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
                                                      print("object::${customerFiltered[index].intId.toString()}");
                                                      Provider.of<ItemProvider>(context, listen: false).getDeleteItems(context,customerFiltered[index].intId.toString()).then((value) {
                                                        AppConstants.getToast("Item Deleted successfully.");
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ItemList(),));
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
                                            Text('Edit',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
                                          ],
                                        )),
                                        PopupMenuItem(value: 1,child: Row(
                                          children: [
                                            const Icon(Icons.delete,color: ColorResources.BLACK,),
                                            Text('Delete',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
                                          ],
                                        )),
                                      ];
                                    },
                                    child: const Icon(Icons.more_vert,color: ColorResources.BLACK,),
                                  ),*/
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Sale Price",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: poppinsSemiBold.copyWith(color: ColorResources.GREY,
                                            overflow: TextOverflow.fade,
                                            fontSize: Dimensions.FONT_SIZE_14),
                                      ),
                                      Text(
                                        "\u20b9 ${customerFiltered[index].decSellPrice}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: poppinsSemiBold.copyWith(color: ColorResources.BLACK,
                                            overflow: TextOverflow.fade,
                                            fontSize: Dimensions.FONT_SIZE_16),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Purchase Price",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: poppinsSemiBold.copyWith(color: ColorResources.GREY,
                                            overflow: TextOverflow.fade,
                                            fontSize: Dimensions.FONT_SIZE_14),
                                      ),
                                      Text(
                                        "\u20b9 ${customerFiltered[index].decPurchaseprice}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: poppinsSemiBold.copyWith(color: ColorResources.BLACK,
                                            overflow: TextOverflow.fade,
                                            fontSize: Dimensions.FONT_SIZE_16),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Opening Stock",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: poppinsSemiBold.copyWith(color: ColorResources.GREY,
                                            overflow: TextOverflow.fade,
                                            fontSize: Dimensions.FONT_SIZE_14),
                                      ),
                                      Text(
                                        "${customerFiltered[index].decAvailablestock}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: poppinsSemiBold.copyWith(color: ColorResources.GREEN,
                                            overflow: TextOverflow.fade,
                                            fontSize: Dimensions.FONT_SIZE_16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(color: ColorResources.GREY),
                          ],
                        ),
                      );
                        /*Container(
                        margin: EdgeInsets.symmetric(vertical: AppConstants.itemHeight*0.003),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: ListTile(
                          horizontalTitleGap: AppConstants.itemHeight*0.01,
                          leading: Container(
                            alignment: Alignment.center,
                            width: AppConstants.itemWidth*0.12,
                            height: AppConstants.itemHeight*0.06,
                            decoration: BoxDecoration(
                              color: Color(Random().nextInt(0xffffffff)).withAlpha(0xff).withOpacity(0.30),
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Text(
                              customerFiltered[index].itemName!.substring(0,1).toUpperCase(),
                              style: poppinsBlack.copyWith(fontSize: Dimensions.FONT_SIZE_18,color: ColorResources.BLACK),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Item Code:- ${customerFiltered[index].strItemCode}",
                                  // maxLines: 1,
                                  style: poppinsSemiBold.copyWith(color: ColorResources.BLACK,
                                      overflow: TextOverflow.fade,
                                      fontSize: Dimensions.FONT_SIZE_17),
                                ),
                              ),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Item Name :- ${customerFiltered[index].itemName}",
                                    style: poppinsSemiBold.copyWith(
                                        color: ColorResources.BLACK,
                                        fontSize: Dimensions.FONT_SIZE_15),
                                  ),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton(
                            color: ColorResources.WHITE,
                            surfaceTintColor: ColorResources.WHITE,
                            elevation: 10,
                            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            onSelected: (result) {
                              if (result == 0) {
                                print("object::${customerFiltered[index].intId.toString()}");
                                Navigator.push(context, MaterialPageRoute(builder: (context) => EditItem(customerFiltered[index].intId.toString()),));
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
                                              print("object::${customerFiltered[index].intId.toString()}");
                                              Provider.of<ItemProvider>(context, listen: false).getDeleteItems(context,customerFiltered[index].intId.toString()).then((value) {
                                                AppConstants.getToast("Item Deleted successfully.");
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => const ItemList(),));
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
                                    Text('Edit',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
                                  ],
                                )),
                                PopupMenuItem(value: 1,child: Row(
                                  children: [
                                    const Icon(Icons.delete,color: ColorResources.BLACK,),
                                    Text('Delete',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
                                  ],
                                )),
                              ];
                            },
                            child: const Icon(Icons.more_vert,color: ColorResources.BLACK,),
                          ),
                        ),
                      );*/
                    },)
                    :
                DataNotFoundScreen("No Data Found"),
              ),
            ],
          ),
        );
      },),
    );
  }
}
