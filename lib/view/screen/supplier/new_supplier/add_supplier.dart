import 'package:flutter/material.dart';
import 'package:gas_accounting/data/model/body/supplier_body.dart';
import 'package:gas_accounting/data/model/response/supplier_response.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/supplier_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/custom_button.dart';
import 'package:gas_accounting/view/basewidget/custom_textfield.dart';
import 'package:gas_accounting/view/screen/supplier/new_supplier/supplier_list.dart';
import 'package:provider/provider.dart';

class AddSupplier extends StatefulWidget {
  String type;
  SupplierData supplierData;
  AddSupplier(this.supplierData,this.type,{super.key});

  @override
  State<AddSupplier> createState() => _AddSupplierState();
}

class _AddSupplierState extends State<AddSupplier> {
  TextEditingController companyName = TextEditingController();
  TextEditingController personName = TextEditingController();
  TextEditingController personMobile = TextEditingController();
  TextEditingController address = TextEditingController();
  FocusNode companyNameCode = FocusNode();
  FocusNode personNameCode = FocusNode();
  FocusNode personMobileCode = FocusNode();
  FocusNode addressCode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("type::${widget.type}");
    companyName.text = widget.type=="New"?"":widget.supplierData.strCompanyName.toString();
    personName.text = widget.type=="New"?"":widget.supplierData.strContactPersonName.toString();
    personMobile.text = widget.type=="New"?"":widget.supplierData.strContactMobilenumber.toString();
    address.text = widget.type=="New"?"":widget.supplierData.strAddress.toString();
  }

  addSupplier(){
    if(companyName.text == ""){
      AppConstants.getToast("Please Enter Company Name");
    }else if(personName.text == ""){
      AppConstants.getToast("Please Enter Contact Person Name");
    }else if(personMobile.text == ""){
      AppConstants.getToast("Please Enter Contact Person Mobile No.");
    }else if(personMobile.text.length != 10){
      AppConstants.getToast("Please Enter Valid Contact Person Mobile No.");
    }else if(address.text == ""){
      AppConstants.getToast("Please Enter Address");
    }else{
      if(widget.type == "New"){
        AddSupplierBody addSupplierBody = AddSupplierBody(
          strCompanyName: companyName.text,
          strContactPersonName: personName.text,
          strContactMobilenumber: int.parse(personMobile.text),
          strAddress: address.text,
          intCreatedBy: int.parse(PreferenceUtils.getString(AppConstants.companyId.toString())),
          intCompanyId: int.parse(PreferenceUtils.getString(AppConstants.companyId.toString())),
        );
        Provider.of<SupplierProvider>(context,listen: false).getAddSupplier(context, addSupplierBody,route);
        AppConstants.closeKeyboard();
      }else{
        UpdateSupplierBody updateSupplierBody = UpdateSupplierBody(
          intid: widget.supplierData.intid,
          strCompanyName: companyName.text,
          strContactPersonName: personName.text,
          strContactMobilenumber: int.parse(personMobile.text),
          strAddress: address.text,
          intCreatedBy: int.parse(PreferenceUtils.getString(AppConstants.companyId.toString())),
          intCompanyId: int.parse(PreferenceUtils.getString(AppConstants.companyId.toString())),
        );
        Provider.of<SupplierProvider>(context,listen: false).getUpdateSupplier(context, updateSupplierBody,_route);
        AppConstants.closeKeyboard();
      }
    }
  }

  route(isRoute){
    if(isRoute){
      Navigator.push(context, MaterialPageRoute(builder: (context) => const SupplierList(),));
      AppConstants.getToast("Supplier Added Successfully");
    }else{
      AppConstants.getToast("Please Try After Some Time");
    }
  }

  _route(isRoute){
    if(isRoute){
      Navigator.push(context, MaterialPageRoute(builder: (context) => const SupplierList(),));
      AppConstants.getToast("Supplier Edited Successfully");
    }else{
      AppConstants.getToast("Please Try After Some Time");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.LINE_BG,
        centerTitle: true,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25)),
        title: Text(widget.type=="New"?"Add Supplier":"Edit Supplier",style: montserratSemiBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
      ),
      body: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
        children: [
          Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: AppConstants.itemHeight*0.02),
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
              child: Row(
                children: [
                  Text("Company Name",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                  Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
            child: CustomTextField(
              controller: companyName,
              focusNode: companyNameCode,
              nextNode: personNameCode,
              hintText: "Company Name",
              isPhoneNumber: false,
              textInputType: TextInputType.name,
              textInputAction: TextInputAction.next,
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
              child: Row(
                children: [
                  Text("Contact Person Name",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                  Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
            child: CustomTextField(
              controller: personName,
              focusNode: personNameCode,
              nextNode: personMobileCode,
              hintText: "Contact Person Name",
              isPhoneNumber: false,
              textInputType: TextInputType.name,
              textInputAction: TextInputAction.next,
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
              child: Row(
                children: [
                  Text("Contact Person Mobile No.",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                  Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
            child: CustomTextField(
              controller: personMobile,
              focusNode: personMobileCode,
              nextNode: addressCode,
              hintText: "Contact Person Mobile No.",
              isPhoneNumber: true,
              textInputType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
              child: Row(
                children: [
                  Text("Address",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                  Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
            child: CustomTextField(
              controller: address,
              focusNode: addressCode,
              nextNode: null,
              hintText: "Address",
              isPhoneNumber: false,
              maxLine: 3,
              textInputType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
            ),
          ),
          Provider.of<SupplierProvider>(context).isLoading
              ?
          const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
              :
          CustomButtonFuction(onTap: (){
            addSupplier();
          }, buttonText: widget.type=="New"?"Add":"Save"),
        ],
      ),
    );
  }
}
