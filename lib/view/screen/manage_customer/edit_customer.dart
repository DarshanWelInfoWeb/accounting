import 'package:flutter/material.dart';
import 'package:gas_accounting/data/model/body/add_customer.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/customer_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/custom_button.dart';
import 'package:gas_accounting/view/basewidget/custom_password_textfield.dart';
import 'package:gas_accounting/view/basewidget/custom_textfield.dart';
import 'package:gas_accounting/view/screen/manage_customer/customer_list.dart';
import 'package:provider/provider.dart';

class EditCustomer extends StatefulWidget {
  String id;
  EditCustomer(this.id,{Key? key}) : super(key: key);

  @override
  State<EditCustomer> createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  TextEditingController companyController = TextEditingController();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode companyCode = FocusNode();
  FocusNode fNameCode = FocusNode();
  FocusNode lNameCode = FocusNode();
  FocusNode accountNumberCode = FocusNode();
  FocusNode mobileCode = FocusNode();
  FocusNode emailCode = FocusNode();
  FocusNode passwordCode = FocusNode();

  bool is_loading = true;

  addCustomer(){
    if (companyController.text == null) {
      AppConstants.getToast("Please Enter Company Name");
    }  else if (fNameController.text == '') {
      AppConstants.getToast("Please Enter First Name");
    }  else if (lNameController.text == '') {
      AppConstants.getToast("Please Enter Last Name");
    }
    /*else if (emailController.text == '') {
      AppConstants.getToast("Please Enter Email Id");
    }  else if (AppConstants.isNotValid(emailController.text)) {
      AppConstants.getToast("Please Enter Valid Email Id");
    } */
    else if (passwordController.text == '') {
      AppConstants.getToast("Please Enter Password");
    }
    // else if (passwordController.text.length != 6) {
    //   AppConstants.getToast("Password Must be more than 6 characters");
    // }
    else if (mobileController.text == '') {
      AppConstants.getToast("Please Enter Mobile Number");
    }  else if (mobileController.text.length != 10) {
      AppConstants.getToast("Please Enter Valid Mobile Number");
    }  else {
      Update_Customer add_customer = Update_Customer(
        intId: int.parse(widget.id),
        intCompanyid: int.parse(PreferenceUtils.getString(AppConstants.companyId.toString())),
        strCompanyName: companyController.text,
        strFirstName: fNameController.text,
        strLastName: lNameController.text,
        strEmail: emailController.text,
        strPassword: passwordController.text,
        strMobileno: int.parse(mobileController.text),
      );
      Provider.of<CustomerProvider>(context,listen: false).getUpdateCustomer(context, add_customer, route);
      AppConstants.closeKeyboard();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("name::::${widget.id}::::${Provider.of<CustomerProvider>(context, listen: false).editCustomerList.length}");
    _loadData(context, true);
  }

  route(isRoute){
    if (isRoute) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerList(),));
      AppConstants.getToast("Customer Edited Successfully");
    }  else {
      AppConstants.getToast("Please Try After Some Time");
    }
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<CustomerProvider>(context, listen: false).getCustomerEdit(context,widget.id).then((value) {
        setState(() {
          is_loading = false;
          for(int i=0;i<Provider.of<CustomerProvider>(context, listen: false).editCustomerList.length;i++){
            companyController.text = Provider.of<CustomerProvider>(context, listen: false).editCustomerList[i].strCompanyName.toString();
            fNameController.text = Provider.of<CustomerProvider>(context, listen: false).editCustomerList[i].strFirstName.toString();
            lNameController.text = Provider.of<CustomerProvider>(context, listen: false).editCustomerList[i].strLastName.toString();
            emailController.text = Provider.of<CustomerProvider>(context, listen: false).editCustomerList[i].strEmail.toString();
            mobileController.text = Provider.of<CustomerProvider>(context, listen: false).editCustomerList[i].strMobileno.toString();
            passwordController.text = Provider.of<CustomerProvider>(context, listen: false).editCustomerList[i].strPassword.toString();
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.LINE_BG,
        centerTitle: true,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
        title: Text("Add Customer",style: montserratBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
      ),
      body:
          is_loading?Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG,)):
      ListView(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
        children: [
          Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: AppConstants.itemHeight*0.02),
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
              child: Row(
                children: [
                  Text("Company Name",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                  Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),),
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
            child: CustomTextField(
              controller: companyController,
              focusNode: companyCode,
              nextNode: fNameCode,
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
                  Text("First Name",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                  Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
            child: CustomTextField(
              controller: fNameController,
              focusNode: fNameCode,
              nextNode: lNameCode,
              hintText: "First Name",
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
                  Text("Last Name",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                  Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
            child: CustomTextField(
              controller: lNameController,
              focusNode: lNameCode,
              nextNode: accountNumberCode,
              hintText: "Last Name",
              isPhoneNumber: false,
              textInputType: TextInputType.name,
              textInputAction: TextInputAction.next,
            ),
          ),
          /*Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
              child: Row(
                children: [
                  Text("Account Number",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                  Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
            child: CustomTextField(
              controller: accountNumberController,
              focusNode: accountNumberCode,
              nextNode: emailCode,
              hintText: "Account Number",
              isPhoneNumber: false,
              textInputType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
          ),*/
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
              child: Row(
                children: [
                  Text("Email Id",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                  Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
            child: CustomTextFieldEnabled(
              enabled: false,
              controller: emailController,
              focusNode: emailCode,
              nextNode: passwordCode,
              hintText: "Email Id",
              isPhoneNumber: false,
              textInputType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
              child: Row(
                children: [
                  Text("Password",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                  Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
            child: CustomPasswordTextField(
              controller: passwordController,
              focusNode: passwordCode,
              nextNode: mobileCode,
              hintTxt: "Password",
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
              child: Row(
                children: [
                  Text("Mobile Number",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                  Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
            child: CustomTextField(
              controller: mobileController,
              focusNode: mobileCode,
              nextNode: null,
              hintText: "Mobile Number",
              isPhoneNumber: true,
              textInputType: TextInputType.phone,
              textInputAction: TextInputAction.done,
            ),
          ),
          Provider.of<CustomerProvider>(context).isLoading
              ?
          const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
              :
          CustomButtonFuction(onTap: () => addCustomer(), buttonText: "Add"),
        ],
      ),
    );
  }
}
