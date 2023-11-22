import 'package:gas_accounting/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepo {
  final SharedPreferences sharedPreferences;
  SplashRepo({required this.sharedPreferences});

  void disableIntro() {
    sharedPreferences.setBool(AppConstants.intro, true);
  }

  bool showIntro() {
    print('${sharedPreferences.getBool(AppConstants.intro)!}');
    return sharedPreferences.getBool(AppConstants.intro)!;
  }

  void initSharedData() async {
    if (!sharedPreferences.containsKey(AppConstants.intro)) {
      sharedPreferences.setBool(AppConstants.intro, false);
    }
  }
}
