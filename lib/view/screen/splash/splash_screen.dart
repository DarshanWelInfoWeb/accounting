import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_accounting/helper/dataBase.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/splash_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/images.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/no_internet_screen.dart';
import 'package:gas_accounting/view/screen/auth/login_screen.dart';
import 'package:gas_accounting/view/screen/dashboard/dashboard_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;
  bool? isNotConnected = true;
  DbManager dbManager = new DbManager();
  TempDb dbManagers = new TempDb();
  InvoiceStockDb invoiceStockDb = new InvoiceStockDb();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    permissionServiceCall();
    print("internetStatus:::::1:::$isNotConnected");
    AppConstants.closeKeyboard();
    dbManager.deleteAll();
    dbManagers.deleteAllStock();
    invoiceStockDb.deleteAllInvoiceStock();
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
      print("internetStatus::::::::$isNotConnected");
      isNotConnected ? const SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if(!isNotConnected) {
        _route();
      }else{
        showDialog<bool>(
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text("Internet Is Not Connected Please Connect To The Internet...."),
                actions: [
                  TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: Text('Ok',style: montserratRegular.copyWith(color: ColorResources.BLACK),),
                  ),
                ],
              );
            },context: context);
      }
    });
  }

  @override
    void dispose() {
      // TODO: implement dispose
      super.dispose();
      _onConnectivityChanged;
    }

  permissionServiceCall() async {
    await permissionServices().then((value) {
            print("permission:::1$value");
            if (value[Permission.storage]!.isGranted && value[Permission.camera]!.isGranted) {
              print("permission:::2$value");
              _route();
            }
        },
    );
  }

  /*Permission services*/
  Future<Map<Permission, PermissionStatus>> permissionServices() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
    ].request();

    if (statuses[Permission.storage]!.isPermanentlyDenied) {
      await openAppSettings().then(
            (value) async {
          if (value) {
            if (await Permission.storage.status.isPermanentlyDenied == true &&
                await Permission.storage.status.isGranted == false) {
              openAppSettings();
            }
          }
        },
      );
    } else {
      if (statuses[Permission.storage]!.isDenied) {
        permissionServiceCall();
      }
    }

    if (statuses[Permission.camera]!.isPermanentlyDenied) {
      await openAppSettings().then(
            (value) async {
          if (value) {
            if (await Permission.camera.status.isPermanentlyDenied == true &&
                await Permission.camera.status.isGranted == false) {
              openAppSettings();
            }
          }
        },
      );
    } else {
      if (statuses[Permission.camera]!.isDenied) {
        permissionServiceCall();
      }
    }
    return statuses;
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false).initSharedPrefData();
    Timer(const Duration(seconds: 2), () {
      if (PreferenceUtils.getlogin(AppConstants.isLoggedIn) == true) {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Dashboard("")));
      } else {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const Login()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppConstants.screenSize = MediaQuery.of(context).size;
    AppConstants.textScale = MediaQuery.of(context).textScaleFactor;
    AppConstants.itemHeight = MediaQuery.of(context).size.height;
    AppConstants.itemWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Provider.of<SplashProvider>(context).hasConnection
          ?
      Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(Images.logo),scale: 0.8)
        ),
        child: Container(margin: EdgeInsets.only(top: AppConstants.itemHeight*0.90),child: Text("Version 1.0.0.1",style: montserratSemiBold.copyWith(fontSize: 16))),
      )
          :
      NoInternetOrDataScreen(isNoInternet: true, child: const SplashScreen()),
    );
  }
}
