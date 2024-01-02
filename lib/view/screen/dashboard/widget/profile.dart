import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/custom_button.dart';
import 'package:gas_accounting/view/basewidget/custom_textfield.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  FocusNode fNameCode = FocusNode();
  FocusNode lNameCode = FocusNode();
  FocusNode mobileCode = FocusNode();
  FocusNode emailCode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fNameController.text = PreferenceUtils.getString(AppConstants.fName);
    lNameController.text = PreferenceUtils.getString(AppConstants.lName);
    mobileController.text = PreferenceUtils.getString(AppConstants.mobile);
    emailController.text = PreferenceUtils.getString(AppConstants.email);
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
        title: Text("Profile",style: montserratBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: AppConstants.itemHeight*0.04),
            child: CachedNetworkImage(
              alignment: Alignment.center,
              fit: BoxFit.fill,
              imageUrl: "https://ps.w.org/user-avatar-reloaded/assets/icon-256x256.png?rev=2540745",
              imageBuilder: (context, imageProvider) =>
                  Container(
                    alignment: Alignment.center,
                    width: AppConstants.itemWidth * 0.5,
                    height: AppConstants.itemWidth * 0.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill),
                    ),
                  ),
              placeholder: (context, url) =>
                  Container(alignment: Alignment.center,child: const CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
              new Icon(Icons.image),
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
              child: Text("First Name",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
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
              child: Text("Last Name",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
            child: CustomTextField(
              controller: lNameController,
              focusNode: lNameCode,
              nextNode: emailCode,
              hintText: "Last Name",
              isPhoneNumber: false,
              textInputType: TextInputType.name,
              textInputAction: TextInputAction.next,
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
              child: Text("Email Id",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
            child: CustomTextField(
              controller: emailController,
              focusNode: emailCode,
              nextNode: mobileCode,
              hintText: "Email Id",
              isPhoneNumber: false,
              textInputType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
              child: Text("Mobile Number",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
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
          CustomButtonFuction(onTap: (){}, buttonText: "Update"),
        ],
      ),
    );
  }
}
