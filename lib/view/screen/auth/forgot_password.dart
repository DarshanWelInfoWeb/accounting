import 'package:flutter/material.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/bezierContainer.dart';
import 'package:gas_accounting/view/basewidget/custom_button.dart';
import 'package:gas_accounting/view/basewidget/custom_password_textfield.dart';
import 'package:gas_accounting/view/basewidget/custom_textfield.dart';
import 'package:gas_accounting/view/screen/auth/login_screen.dart';
import 'package:gas_accounting/view/screen/otp/otp_screen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController passwordController = TextEditingController();
  FocusNode passwordCode = FocusNode();


  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black,size: 35),
            ),
            Text('Back',
                style: montserratSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_17, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        height: AppConstants.itemHeight,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: -AppConstants.itemHeight * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: const BezierContainer()),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: AppConstants.itemHeight * .3),
                    Text("Forgot Password",style: montserratBold.copyWith(color: ColorResources.RED, fontSize: 30,fontWeight: FontWeight.w700),),
                    SizedBox(height: AppConstants.itemHeight*0.10),
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                        child: Text("Email Id",style: montserratSemiBold.copyWith(color: ColorResources.BLACK),)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                      child: CustomTextField(
                        controller: passwordController,
                        focusNode: passwordCode,
                        nextNode: null,
                        hintText: "Email Id",
                        textInputType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButtonFuction(onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OTPScreen(passwordController.text),));
                    }, buttonText: "Submit"),
                    Padding(
                      padding: EdgeInsets.only(top: AppConstants.itemHeight*0.03),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Login(),));
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: 'You have an password',
                              style: montserratBold.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: ColorResources.BLACK
                              ),
                              children: [
                                TextSpan(text: '  '),
                                TextSpan(
                                  text: 'Login',
                                  style: montserratBold.copyWith(color: ColorResources.RED,fontWeight: FontWeight.w600, fontSize: 14),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
