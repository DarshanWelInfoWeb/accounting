import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gas_accounting/provider/auth_provider.dart';
import 'package:gas_accounting/provider/customer_provider.dart';
import 'package:gas_accounting/provider/dashboard_provider.dart';
import 'package:gas_accounting/provider/expense_provider.dart';
import 'package:gas_accounting/provider/invoice_provider.dart';
import 'package:gas_accounting/provider/item_provider.dart';
import 'package:gas_accounting/provider/main_payment_provider.dart';
import 'package:gas_accounting/provider/otp_provider.dart';
import 'package:gas_accounting/provider/payment_provider.dart';
import 'package:gas_accounting/provider/route_provider.dart';
import 'package:gas_accounting/provider/splash_provider.dart';
import 'package:gas_accounting/provider/supplier_provider.dart';
import 'package:gas_accounting/provider/tempinvoice_provider.dart';
import 'package:gas_accounting/provider/theme_provider.dart';
import 'package:gas_accounting/theme/dark_theme.dart';
import 'package:gas_accounting/theme/light_theme.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:provider/provider.dart';
import 'di_container.dart' as di;
import 'view/screen/splash/splash_screen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OTPProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<DashboardProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CustomerProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<RouteProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<TempInvoiceProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<PaymentProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<MainPaymentProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ExpenseProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ItemProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<InvoiceProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SupplierProvider>()),
    ],
    child: const MyApp(),
    // builder: EasyLoading.init(),
  ));
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final navigatorKey = new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: ColorResources.LINE_BG,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark
    ));
    return MaterialApp(
      builder: EasyLoading.init(),
      title: "Accounting",
      // title: "Accounting for Plastic",
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).darkTheme ? dark : light,
      home: const SplashScreen(),
    );
  }
}
