import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_accounting/data/model/body/login_body.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/auth_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/images.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/bezierContainer.dart';
import 'package:gas_accounting/view/basewidget/custom_button.dart';
import 'package:gas_accounting/view/basewidget/custom_textfield.dart';
import 'package:gas_accounting/view/screen/auth/forgot_password.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:gas_accounting/view/screen/dashboard/dashboard_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../basewidget/custom_password_textfield.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode nameCode = FocusNode();
  FocusNode passwordCode = FocusNode();
  LoginBody loginBody = LoginBody();

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
          text: 'Lo',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: ColorResources.RED
          ),
          children: [
            TextSpan(
              text: 'g',
              style: TextStyle(color: ColorResources.RED, fontSize: 30),
            ),
            TextSpan(
              text: 'in',
              style: TextStyle(color: ColorResources.RED, fontSize: 30),
            ),
          ]),
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 20,
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 01),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text('Or',style: montserratSemiBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 01),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  _login(){
    if (nameController.text == '') {
      AppConstants.getToast("Please Enter Email Id");
    }else if(AppConstants.isNotValid(nameController.text)){
      AppConstants.getToast("Please Enter Valid Email Id");
    }else if(passwordController.text == ''){
      AppConstants.getToast("Please Enter Password");
    }else{
      loginBody.email = nameController.text;
      loginBody.password = passwordController.text;
      Provider.of<AuthenticationProvider>(context, listen: false).login(loginBody,route);
      AppConstants.closeKeyboard();
    }
  }

  route(isRoute,String msg, dynamic errorMessage){
    if (isRoute) {
      if (errorMessage == null) {
        print("object:::1:::");
        AppConstants.getToast("This Email Id is not Found");
        nameController.clear();
        passwordController.clear();
      } else {
        print("object:::1:0: $msg::::$errorMessage");
        errorMessage == null?print("object:::Home::"):print("object::Dash::");
        PreferenceUtils.setlogin(AppConstants.isLoggedIn, true);
        errorMessage == null?AppConstants.getToast("This Email Id is not Found"):AppConstants.getToast("Login Successfull");
        Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(""),));
      }
    } else{
      print("object:::2:::");
      AppConstants.getToast("This Email Id is not Found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => AppConstants.onWillPop(context),
      child: SafeArea(
        child: Scaffold(
          body: SizedBox(
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
                        SizedBox(height: AppConstants.itemHeight * .27),
                        _title(),
                        const SizedBox(height: 50),
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                            child: Text("Email Id",style: montserratSemiBold.copyWith(color: ColorResources.BLACK),)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                          child: CustomTextField(
                            controller: nameController,
                            focusNode: nameCode,
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
                            child: Text("Password",style: montserratSemiBold.copyWith(color: ColorResources.BLACK),)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                          child: CustomPasswordTextField(
                            controller: passwordController,
                            focusNode: passwordCode,
                            nextNode: null,
                            hintTxt: "Password",
                            textInputType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPassword(),));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerRight,
                            child: const Text('Forgot Password ?',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Provider.of<AuthenticationProvider>(context).isLoading
                            ? const Center(
                          child: CircularProgressIndicator(
                            color: ColorResources.LINE_BG,
                          ),
                        )
                            :
                        CustomButtonFuction(
                            onTap: () => _login(),
                            buttonText: "Login"),
                        _divider(),
                        isLoggedIn
                            ?
                        const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG,))
                            :
                        Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                          decoration: BoxDecoration(
                            color: const Color(0xff3A5897),
                            borderRadius: BorderRadius.circular(50),),
                          child: TextButton(
                            onPressed: _facebookLogin,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(Images.facebook,width: 24,height: 24),
                                Text("Continue with Facebook", style: montserratSemiBold.copyWith(fontWeight: FontWeight.w600,color: Colors.white, fontSize: Dimensions.FONT_SIZE_14))
                              ],
                            ),
                          ),
                        ),
                        isLogin
                            ?
                        const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG,))
                            :
                        Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                          decoration: BoxDecoration(
                              color: Colors.white30,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: ColorResources.COLORPRIMERY,width: 1)
                          ),
                          child: TextButton(
                            onPressed: signInWithGoogle,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(Images.gmail,width: 24,height: 24,),
                                Text("Continue with Gmail", style: montserratSemiBold.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK, fontSize: Dimensions.FONT_SIZE_14))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  /* Gmail Login */
  bool isLogin = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<void> signInWithGoogle() async {
    setState(() {
      isLogin = true;
    });
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      print("log :: ${user!.email}");
      print("log :: ${user.displayName}");
      // Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(""),));
      // route;
      // Use the user object for further operations or navigate to a new screen.
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isLogin = false;
    });
  }

  /* Facebook Login */

  bool isLoggedIn = false;

  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
    });
  }

  static final FacebookLogin facebookSignIn = FacebookLogin();
  String _message = 'Log in/out by pressing the buttons below.';
  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
  }
  Future<void> _facebookLogin() async {
    print("object :: 0 ::");
    setState(() {
      isLoggedIn = true;
    });
    final FacebookLoginResult result = await facebookSignIn.logIn();
    print("object :: 1 ::");
    switch (result.status) {
      case FacebookLoginStatus.success:
        final FacebookAccessToken? accessToken = result.accessToken;
        AppConstants.getToast("Logged in!");
        Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(""),));
        // _showMessage('''
        //  Logged in!
        //  Token: ${accessToken?.token}
        //  User id: ${accessToken?.userId}
        //  Expires: ${accessToken?.expires}
        //  Permissions: ${accessToken?.permissions}
        //  Declined permissions: ${accessToken?.declinedPermissions}
        //  ''');
        break;
      case FacebookLoginStatus.cancel:
        AppConstants.getToast("Login cancelled by the user.");
        // _showMessage('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        AppConstants.getToast("Something went wrong with the login process.\nHere's the error Facebook gave us: ${result.error}");
        // _showMessage('Something went wrong with the login process.\n'
        //     'Here\'s the error Facebook gave us: ${result.error}');
        break;
    }
    setState(() {
      isLoggedIn = false;
    });
  }

}
