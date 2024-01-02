import 'package:flutter/cupertino.dart';
import 'package:gas_accounting/data/model/body/login_body.dart';
import 'package:gas_accounting/data/model/response/base/api_response.dart';
import 'package:gas_accounting/data/model/response/base/error_response.dart';
import 'package:gas_accounting/data/repository/auth_repo.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/utill/app_constants.dart';

class AuthenticationProvider with ChangeNotifier {
  final AuthRepo? authRepo;
  AuthenticationProvider({@required this.authRepo});
  String? _sucess="true";
  bool? _Vendor_status;
  bool _isLoading = false;
  static bool _isRemember = false;
  int _selectedIndex = 0;
  int get selectedIndex =>_selectedIndex;
  String? get sucess => _sucess;
  bool? get Vendor_status => _Vendor_status;

  updateSelectedIndex(int index){
    _selectedIndex = index;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  bool get isRemember => _isRemember;

  void updateRemember(bool? value) {
    _isRemember = value!;
    notifyListeners();
  }



  Future authToken(String authToken ) async{
    authRepo?.saveAuthToken(authToken);
    notifyListeners();
  }


  Future login(LoginBody loginBody, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await authRepo?.login(loginBody);
    _isLoading = false;
    if (apiResponse?.response != null && apiResponse!.response.statusCode == 200) {
      Map map = apiResponse.response.data;
      dynamic token = '';
      String msg = '';
      msg = map['strMsg'];
      token = map['data'];

      print("Data::::::$token:::::${map['strMsg']}:");
      token==null?"":PreferenceUtils.setString("${AppConstants.userId}",map['data'][0]['intId'].toString());
      token==null?"":PreferenceUtils.setString(AppConstants.fName,map['data'][0]['FirstName']);
      token==null?"":PreferenceUtils.setString(AppConstants.lName,map['data'][0]['LastName']);
      token==null?"":PreferenceUtils.setString(AppConstants.mobile,map['data'][0]['MobileNo']);
      token==null?"":PreferenceUtils.setString(AppConstants.email,map['data'][0]['Email']);
      token==null?"":PreferenceUtils.setString(AppConstants.companyName,map['data'][0]['CompanyName']).toString();
      token==null?"":PreferenceUtils.setString("${AppConstants.companyId}",map['data'][0]['CompanyId'].toString());
      token==null?"":PreferenceUtils.setbool(AppConstants.includeGst,map['data'][0]['bisIncludeGST']);
      callback(true, msg,token);
      _isLoading = false;
      notifyListeners();
    }
    else if(apiResponse?.response.statusCode == 403){
      _isLoading = false;
      callback(false, "token","Connection timeout with API server");
      notifyListeners();
    }
    else {
      _isLoading = false;
      Map map = apiResponse!.response.data;
      String? errorMessage;
      errorMessage = map['strMsg'];
      print("error:::::$errorMessage");
      callback(false, errorMessage, errorMessage);
      notifyListeners();
    }
    notifyListeners();
  }

  // for phone verification
  bool _isPhoneNumberVerificationButtonLoading = false;

  bool get isPhoneNumberVerificationButtonLoading => _isPhoneNumberVerificationButtonLoading;
  String? _verificationMsg = '';

  String? get verificationMessage => _verificationMsg;
  String _email = '';
  String _phone = '';

  String get email => _email;
  String get phone => _phone;

  updateEmail(String email) {
    _email = email;
    notifyListeners();
  }
  updatePhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  void clearVerificationMessage() {
    _verificationMsg = '';
  }


  // for verification Code
  String _verificationCode = '';

  String get verificationCode => _verificationCode;
  bool _isEnableVerificationCode = false;

  bool get isEnableVerificationCode => _isEnableVerificationCode;

  updateVerificationCode(String query) {
    if (query.length == 4) {
      _isEnableVerificationCode = true;
    } else {
      _isEnableVerificationCode = false;
    }
    _verificationCode = query;
    notifyListeners();
  }

  // for user Section
  String? getUserToken() {
    return authRepo?.getUserToken();
  }

  // for user Section
  String? getAuthToken() {
    return authRepo?.getAuthToken();
  }

  bool? isLoggedIn() {
    return authRepo?.isLoggedIn();
  }

  Future<bool?> clearSharedData() async {
    return await authRepo?.clearSharedData();
  }

}