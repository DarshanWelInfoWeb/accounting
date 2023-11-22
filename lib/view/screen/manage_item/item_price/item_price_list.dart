import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_accounting/data/model/response/items_response.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/item_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/no_internet_screen.dart';
import 'package:gas_accounting/view/screen/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

class ItemPriceList extends StatefulWidget {
  const ItemPriceList({super.key});

  @override
  State<ItemPriceList> createState() => _ItemPriceListState();
}

class _ItemPriceListState extends State<ItemPriceList> {
  TextEditingController controller = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  FocusNode fieldFocusNode = FocusNode();
  FocusNode salePriceFocusNode = FocusNode();
  FocusNode purchasePriceFocusNode = FocusNode();
  FocusNode qtyFocusNode = FocusNode();

  bool isLoading = true;
  bool isLoadings = true;
  List<ItemPriceData> customerFiltered = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoadings = false;
    _loadData(context, true);
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<ItemProvider>(context, listen: false).getItemPriceList(context,PreferenceUtils.getString("${AppConstants.companyId}")).then((value) {
        setState(() {
          isLoading = false;
          isLoadings = false;
          customerFiltered = isLoading
              ? Provider.of<ItemProvider>(context, listen: false).itemPriceList
              : Provider.of<ItemProvider>(context, listen: false).itemPriceList
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
          ? Provider.of<ItemProvider>(context, listen: false).itemPriceList
          : Provider.of<ItemProvider>(context, listen: false).itemPriceList
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
      child: Consumer<ItemProvider>(builder: (context, item, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorResources.LINE_BG,
            centerTitle: true,
            leading: IconButton(onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => Dashboard("Home")));
            }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
            title: Text("Item Price",style: montserratBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
          ),
          body: Column(
            children: [
              Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    width: AppConstants.itemWidth*0.70,
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
                              customerFiltered = Provider.of<ItemProvider>(context, listen: false).itemPriceList;
                              AppConstants.closeKeyboard();
                            });
                          },
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
                  TextButton(
                      onPressed: () {
                        controller.clear();
                        isLoadings = true;
                        AppConstants.closeKeyboard();
                        _loadData(context, true);
                      },
                      style: ButtonStyle(backgroundColor: const MaterialStatePropertyAll(ColorResources.LINE_BG),shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
                      child: Text("All Update",style: montserratBlack.copyWith(color: ColorResources.WHITE,fontSize: 14),)),
                ],
              ),
              isLoading
                  ?
              Padding(
                padding: EdgeInsets.only(top: AppConstants.itemHeight * 0.35),
                child: const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG)),
              )
                  :
              isLoadings
                  ?
              Padding(
                padding: EdgeInsets.only(top: AppConstants.itemHeight * 0.35),
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
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                  itemBuilder: (context, index) {
                    return Container(color: index.isEven ? ColorResources.WHITE : Colors.transparent,child: itemList(index));
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

  Widget itemList(int index){
    ItemPriceData item = customerFiltered[index];
    return InkWell(
      onTap: () {
        salePriceController.text = item.decSellPrice.toString();
        purchasePriceController.text = item.decPurcharePrice.toString();
        qtyController.text = item.decAvailablestock.toString();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: AppConstants.itemHeight*0.06,
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)), color: Theme.of(context).primaryColor),
                    child: Text('Item Price',style: poppinsBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_18)),
                  ),
                  SizedBox(height: AppConstants.itemHeight*0.01),
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03,vertical: AppConstants.itemHeight*0.005),
                      child: Text("Sale Price",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
                  Container(
                      height: AppConstants.itemHeight*0.06,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: ColorResources.GREY.withOpacity(0.05),
                        borderRadius:BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        controller: salePriceController,
                        focusNode: salePriceFocusNode,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        onChanged: (value) {
                          purchasePriceFocusNode;
                        },
                        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter,FilteringTextInputFormatter.allow(RegExp('[0-9.]')),],
                        style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                        decoration: InputDecoration(
                            counterText: '',
                            focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                            hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),
                            errorStyle: const TextStyle(height: 1.5),
                            hintText: 'Sale Price',
                            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
                            isDense: true,
                            border: InputBorder.none),
                      )),
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03,vertical: AppConstants.itemHeight*0.005),
                      child: Text("Purchase Price",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
                  Container(
                      height: AppConstants.itemHeight*0.06,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: ColorResources.GREY.withOpacity(0.05),
                        borderRadius:BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        controller: purchasePriceController,
                        focusNode: purchasePriceFocusNode,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        onChanged: (value) {
                          qtyFocusNode;
                        },
                        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter,FilteringTextInputFormatter.allow(RegExp('[0-9.]')),],
                        style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                        decoration: InputDecoration(
                            counterText: '',
                            focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                            hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),
                            errorStyle: const TextStyle(height: 1.5),
                            hintText: 'Purchase Price',
                            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
                            isDense: true,
                            border: InputBorder.none),
                      )),
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03,vertical: AppConstants.itemHeight*0.005),
                      child: Text("Available Stock",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
                  Container(
                      height: AppConstants.itemHeight*0.06,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: ColorResources.GREY.withOpacity(0.05),
                        borderRadius:BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        controller: qtyController,
                        focusNode: qtyFocusNode,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textInputAction: TextInputAction.done,
                        maxLines: 1,
                        enabled: qtyController.text=="0.0"?true:false,
                        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter,FilteringTextInputFormatter.allow(RegExp('[0-9.]')),],
                        style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                        decoration: InputDecoration(
                            counterText: '',
                            focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                            hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),
                            errorStyle: const TextStyle(height: 1.5),
                            hintText: 'Available Stock',
                            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
                            isDense: true,
                            border: InputBorder.none),
                      )),
                  SizedBox(height: AppConstants.itemHeight*0.01),
                  Divider(
                    color: Theme.of(context).iconTheme.color,
                    height: AppConstants.itemHeight*0.004,
                  ),
                  Row(children: <Widget>[
                    Provider.of<ItemProvider>(context).isLoading
                        ?
                    const Expanded(child: Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG)))
                        :
                    Expanded(
                        child: MaterialButton(height: AppConstants.itemHeight*0.05, minWidth: double.infinity,
                          onPressed: () {
                            setState(() {
                              AddItemPriceBody itemPrice = AddItemPriceBody(
                                intCompanyId: int.parse(PreferenceUtils.getString("${AppConstants.companyId}")),
                                intItemId: item.intItemId,
                                decSellPrice: double.parse(salePriceController.text),
                                decPurcharePrice: double.parse(purchasePriceController.text),
                                decAvailablestock: double.parse(qtyController.text),
                              );
                              Provider.of<ItemProvider>(context, listen: false).getAddItemPrice(context,itemPrice,_route);
                            });
                          },
                          child: Text("Save",
                              style: montserratBold.copyWith(color: ColorResources.BLACK)),
                        )),
                    Container(
                        height: AppConstants.itemHeight*0.05,
                        width: AppConstants.itemWidth*0.004,
                        color: Theme.of(context).iconTheme.color),
                    Expanded(
                        child: MaterialButton(height: AppConstants.itemHeight*0.05, minWidth: double.infinity,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Close", style: montserratBold.copyWith(color: Colors.black),),
                        )),
                  ])
                ],
              ),
            );
          },
        );
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: AppConstants.itemWidth * 0.60,
                child: Text(
                  "${item.itemName}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: poppinsSemiBold.copyWith(color: ColorResources.BLACK,
                      overflow: TextOverflow.fade,
                      fontSize: Dimensions.FONT_SIZE_17),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: AppConstants.itemWidth * 0.30,
                child: Text(
                  "${item.strItemCode}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: poppinsSemiBold.copyWith(color: ColorResources.BLACK,
                      overflow: TextOverflow.fade,
                      fontSize: Dimensions.FONT_SIZE_17),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: AppConstants.itemWidth*0.30,
                child: Text(
                  "Sale Price",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: poppinsSemiBold.copyWith(color: ColorResources.GREY,
                      overflow: TextOverflow.fade,
                      fontSize: Dimensions.FONT_SIZE_14),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: AppConstants.itemWidth*0.35,
                child: Text(
                  "Purchase Price",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: poppinsSemiBold.copyWith(color: ColorResources.GREY,
                      overflow: TextOverflow.fade,
                      fontSize: Dimensions.FONT_SIZE_14),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: AppConstants.itemWidth*0.30,
                child: Text(
                  "Available Stock",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: poppinsSemiBold.copyWith(color: ColorResources.GREY,
                      overflow: TextOverflow.fade,
                      fontSize: Dimensions.FONT_SIZE_14),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: AppConstants.itemWidth*0.20,
                padding: EdgeInsets.only(left: AppConstants.itemWidth*0.01),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(05),
                  border: Border.all(color: ColorResources.BLACK),
                ),
                child: Text(
                  "\u20b9 ${item.decSellPrice}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: poppinsSemiBold.copyWith(color: ColorResources.BLACK,
                      overflow: TextOverflow.fade,
                      fontSize: Dimensions.FONT_SIZE_15),
                ),
              ),
              SizedBox(
                width: AppConstants.itemWidth*0.45,
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: AppConstants.itemWidth*0.20,
                      padding: EdgeInsets.only(left: AppConstants.itemWidth*0.01),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(05),
                        border: Border.all(color: ColorResources.BLACK),
                      ),
                      child: Text(
                        "\u20b9 ${item.decPurcharePrice}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: poppinsSemiBold.copyWith(color: ColorResources.BLACK,
                            overflow: TextOverflow.fade,
                            fontSize: Dimensions.FONT_SIZE_15),
                      ),
                    ),
                    item.strName==null?const SizedBox():
                    Text(
                      " / ${item.strName}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: poppinsSemiBold.copyWith(color: ColorResources.BLACK,
                          overflow: TextOverflow.fade,
                          fontSize: Dimensions.FONT_SIZE_10),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: AppConstants.itemWidth*0.20,
                padding: EdgeInsets.only(right: AppConstants.itemWidth*0.01),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(05),
                  border: Border.all(color: item.decAvailablestock != 0.0 ? ColorResources.transparant : ColorResources.BLACK),
                ),
                child: Text(
                  "${item.decAvailablestock}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: poppinsSemiBold.copyWith(color: item.decAvailablestock == 0.0 ? ColorResources.BLACK : ColorResources.GREEN,
                      overflow: TextOverflow.fade,
                      fontSize: Dimensions.FONT_SIZE_15),
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstants.itemHeight*0.005),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              item.dtUpdatedDate == null ? const SizedBox():
              Container(
                alignment: Alignment.centerRight,
                width: AppConstants.itemWidth*0.65,
                child: Text(
                  "(Last Update On : ${item.dtUpdatedDate})",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: poppinsSemiBold.copyWith(color: ColorResources.GREY,
                      overflow: TextOverflow.fade,
                      fontSize: Dimensions.FONT_SIZE_10),
                ),
              ),
              item.strAvailablestockDate == "" ? const SizedBox() :
              Container(
                alignment: Alignment.centerRight,
                width: AppConstants.itemWidth*0.30,
                child: Text(
                  "(Date : ${AppConstants.changeDateToDMY(item.strAvailablestockDate.toString())})",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: poppinsSemiBold.copyWith(color: ColorResources.GREY,
                      overflow: TextOverflow.fade,
                      fontSize: Dimensions.FONT_SIZE_10),
                ),
              ),
            ],
          ),
          Divider(color: ColorResources.GREY,height: AppConstants.itemHeight*0.001),
        ],
      ),
    );
  }

  _route(isRoute){
    if(isRoute){
      salePriceController.clear();
      purchasePriceController.clear();
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ItemPriceList()));
      AppConstants.getToast("Item Price Updated Successfully");
    }else{
      AppConstants.getToast("Please Try After Sometime");
    }
  }
}