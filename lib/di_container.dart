import 'package:dio/dio.dart';
import 'package:gas_accounting/data/datasource/remote/dio/dio_client.dart';
import 'package:gas_accounting/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:gas_accounting/data/repository/auth_repo.dart';
import 'package:gas_accounting/data/repository/customer_repo.dart';
import 'package:gas_accounting/data/repository/dashboard_repo.dart';
import 'package:gas_accounting/data/repository/expense_repo.dart';
import 'package:gas_accounting/data/repository/invoice_repo.dart';
import 'package:gas_accounting/data/repository/item_repo.dart';
import 'package:gas_accounting/data/repository/main_payment_repo.dart';
import 'package:gas_accounting/data/repository/payment_repo.dart';
import 'package:gas_accounting/data/repository/route_repo.dart';
import 'package:gas_accounting/data/repository/splash_repo.dart';
import 'package:gas_accounting/data/repository/supplier_repo.dart';
import 'package:gas_accounting/data/repository/tempinvoice_repo.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
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
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.BASE_URL, sl(), loggingInterceptor: sl()));
  sl.registerLazySingleton(() => SplashRepo(sharedPreferences: sl()));
  sl.registerLazySingleton(() => AuthRepo(dioClient: sl(),sharedPreferences: sl()));
  sl.registerLazySingleton(() => DashboardRepo(dioClient: sl(),sharedPreferences: sl()));
  sl.registerLazySingleton(() => CustomerRepo(dioClient: sl(),sharedPreferences: sl()));
  sl.registerLazySingleton(() => RouteRepo(dioClient: sl(),sharedPreferences: sl()));
  sl.registerLazySingleton(() => TempInvoiceRepo(dioClient: sl(),sharedPreferences: sl()));
  sl.registerLazySingleton(() => PaymentRepo(dioClient: sl(),sharedPreferences: sl()));
  sl.registerLazySingleton(() => MainPaymentRepo(dioClient: sl(),sharedPreferences: sl()));
  sl.registerLazySingleton(() => ExpenseRepo(dioClient: sl(),sharedPreferences: sl()));
  sl.registerLazySingleton(() => ItemRepo(dioClient: sl(),sharedPreferences: sl()));
  sl.registerLazySingleton(() => InvoiceRepo(dioClient: sl(),sharedPreferences: sl()));
  sl.registerLazySingleton(() => SupplierRepo(dioClient: sl(),sharedPreferences: sl()));

  // Provider
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerFactory(() => SplashProvider(splashRepo: sl()));
  sl.registerFactory(() => OTPProvider());
  sl.registerFactory(() => AuthenticationProvider(authRepo: sl()));
  sl.registerFactory(() => DashboardProvider(dashboardRepo: sl()));
  sl.registerFactory(() => CustomerProvider(customerRepo: sl()));
  sl.registerFactory(() => RouteProvider(routeRepo: sl()));
  sl.registerFactory(() => TempInvoiceProvider(tempInvoiceRepo: sl()));
  sl.registerFactory(() => PaymentProvider(paymentRepo: sl()));
  sl.registerFactory(() => MainPaymentProvider(mainPaymentRepo: sl()));
  sl.registerFactory(() => ExpenseProvider(expenseRepo: sl()));
  sl.registerFactory(() => ItemProvider(itemRepo: sl()));
  sl.registerFactory(() => InvoiceProvider(invoiceRepo: sl()));
  sl.registerFactory(() => SupplierProvider(supplierRepo: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  PreferenceUtils.init();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}