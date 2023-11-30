import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/images.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/confirm_dialog_view.dart';
import 'package:gas_accounting/view/screen/auth/login_screen.dart';
import 'package:gas_accounting/view/screen/dashboard/daily_update.dart';
import 'package:gas_accounting/view/screen/dashboard/dashboard_screen.dart';
import 'package:gas_accounting/view/screen/dashboard/due_balance.dart';
import 'package:gas_accounting/view/screen/dashboard/daily_report.dart';
import 'package:gas_accounting/view/screen/dashboard/profit_loss_report.dart';
import 'package:gas_accounting/view/screen/dashboard/widget/change_password.dart';
import 'package:gas_accounting/view/screen/dashboard/widget/profile.dart';
import 'package:gas_accounting/view/screen/expense/add_expense/expense_list.dart';
import 'package:gas_accounting/view/screen/expense/expense_type_manage/expense_type_manage.dart';
import 'package:gas_accounting/view/screen/manage_customer/customer_list.dart';
import 'package:gas_accounting/view/screen/manage_customer/search_customer.dart';
import 'package:gas_accounting/view/screen/manage_invoice/invoice_list.dart';
import 'package:gas_accounting/view/screen/manage_item/item_price/item_price_list.dart';
import 'package:gas_accounting/view/screen/manage_item/items/item_list.dart';
import 'package:gas_accounting/view/screen/manage_temp_payment/payment_list.dart';
import 'package:gas_accounting/view/screen/payment/payment_list.dart';
import 'package:gas_accounting/view/screen/route_master/route_list.dart';
import 'package:gas_accounting/view/screen/supplier/new_supplier/supplier_list.dart';
import 'package:gas_accounting/view/screen/supplier/supplier_invoice/supplier_invoice_list.dart';
import 'package:gas_accounting/view/screen/supplier/supplier_payment/supplier_payment_list.dart';
import 'package:gas_accounting/view/screen/temp_invoice/tempinvoice_list.dart';
import 'package:gas_accounting/view/screen/unit_management/unit_manage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Drawer_View extends StatefulWidget {
  const Drawer_View({Key? key}) : super(key: key);

  @override
  State<Drawer_View> createState() => _Drawer_ViewState();
}

class _Drawer_ViewState extends State<Drawer_View> with TickerProviderStateMixin{
  ExpansionTileController expansionTileController = ExpansionTileController();
  late final AnimationController _controller;
  // final GlobalKey<ScaffoldState> _key = GlobalKey();
  late final Animation<double> _animation;
  late final Tween<double> _sizeTween;
  bool _isExpanded = false;
  bool _isExpand = false;
  bool _isExpands = false;
  bool _isExpa = false;
  bool _isExpandReport = false;
  bool _isExpandSetting = false;

  @override
  void initState() {
    print("tax :: ${PreferenceUtils.getlogin(AppConstants.includeGst)}");
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    _sizeTween = Tween(begin: 0, end: 1);
    super.initState();
  }
  double _currentHeight = 0;

// expanded height of the expandable body
  final double _expandedHeight = AppConstants.itemHeight * 0.06;
  // toggle expandable without setState,
  // so that the widget does not rebuild itself.
  void _expandOnChanged() {
    var isExpanded = _currentHeight == _expandedHeight;
    _isExpanded = !_isExpanded;
    _isExpanded ? _controller.forward() : _controller.reverse();
    setState(() {
      _currentHeight = isExpanded ? 0 : _expandedHeight;
    });
  }

  // dispose the controller to release it from the memory
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClipRRect(
        // borderRadius: const BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
        child: Drawer(
          // key: _key,
          child: Scaffold(
            body: Column(
              children: [
                Container(
                  height: AppConstants.itemHeight*0.17,
                  padding: EdgeInsets.only(left: AppConstants.itemWidth*0.02),
                  color: Colors.blue,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile())),
                        child: const CircleAvatar(
                            radius: 30,
                            backgroundColor: ColorResources.WHITE,
                            child: Image(image: AssetImage(Images.shop),color: Colors.blue,height: 35,width: 35,)
                          /*CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: "https://ps.w.org/user-avatar-reloaded/assets/icon-256x256.png?rev=2540745",
                            imageBuilder: (context, imageProvider) =>
                                Container(
                                  width: AppConstants.itemWidth * 0.15,
                                  height: AppConstants.itemWidth * 0.15,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill),
                                  ),
                                ),
                            placeholder: (context, url) => Container(alignment: Alignment.center,child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(ColorResources.LINE_BG))),
                            errorWidget: (context, url, error) => const Image(image: AssetImage(Images.logo),),
                          )*/
                        ),
                      ),
                      SizedBox(width: AppConstants.itemWidth*0.02),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${PreferenceUtils.getString(AppConstants.fName)} ${PreferenceUtils.getString(AppConstants.lName)} (Owner)",
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: montserratSemiBold.copyWith(
                                  color: ColorResources.WHITE,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(height: AppConstants.itemHeight*0.005),
                          Text(PreferenceUtils.getString(AppConstants.mobile),
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: montserratSemiBold.copyWith(
                                  color: ColorResources.WHITE,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],),
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children: [
                      SizedBox(
                        height: AppConstants.itemHeight * 0.06,
                        child: ListTile(
                            onTap:() {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  Dashboard(""),));
                            },
                            leading: const Icon(Icons.dashboard,color: ColorResources.GREY,size: 25,),
                            title: Text("Dashboard",style: montserratSemiBold.copyWith(fontSize: 15))),
                      ),
                      PreferenceUtils.getlogin(AppConstants.includeGst) != true
                          ?
                      Column(
                        children: [
                          CustomExpansionTile(
                            title: 'Sale',
                            image: const Image(image: AssetImage(Images.shop),color: ColorResources.GREY,height: 25,width: 25),
                            content: Container(
                              decoration: BoxDecoration(
                                  color: ColorResources.WHITE,
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: ColorResources.GREY.withOpacity(0.10),
                                        spreadRadius: 0.1,
                                        blurRadius: 0.1
                                    )
                                  ]
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomerList(),));
                                        },
                                        leading: const Image(image: AssetImage(Images.party),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Manage Party",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => InvoiceList("", "", "", "Invoice"),));
                                        },
                                        leading: const Image(image: AssetImage(Images.supplier),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Sale Invoice",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentList("","","","Payment"),));
                                        },
                                        leading: const Image(image: AssetImage(Images.bill),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Payment In",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          CustomExpansionTile(
                            title: 'Purchase',
                            image: const Image(image: AssetImage(Images.purchasing),color: ColorResources.GREY,height: 25,width: 25),
                            content: Container(
                              decoration: BoxDecoration(
                                color: ColorResources.WHITE,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorResources.GREY.withOpacity(0.10),
                                      spreadRadius: 0.1,
                                      blurRadius: 0.1
                                    )
                                  ]
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SupplierList(),));
                                        },
                                        leading: const Image(image: AssetImage(Images.party),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Manage Party",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SupplierInvoiceList("","","","SupplierInvoice"),));
                                        },
                                        leading: const Image(image: AssetImage(Images.supplier),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Purchase Bill",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SupplierPaymentList("","Side"),));
                                        },
                                        leading: const Image(image: AssetImage(Images.bill),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Payment Out",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          CustomExpansionTile(
                            title: 'Report',
                            image: const Icon(Icons.report_gmailerrorred,color: ColorResources.GREY,size: 25),
                            content: Container(
                              decoration: BoxDecoration(
                                color: ColorResources.WHITE,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorResources.GREY.withOpacity(0.10),
                                      spreadRadius: 0.1,
                                      blurRadius: 0.1
                                    )
                                  ]
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DailyReport(),));
                                        },
                                        leading: const Icon(Icons.pending_outlined,color: ColorResources.GREY,size: 25),
                                        title: Text("Daily Report",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DueBalance(),));
                                        },
                                        leading: const Image(image: AssetImage(Images.duePayment),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Due Report",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DailyUpdate(),));
                                        },
                                        leading: const Image(image: AssetImage(Images.update),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Daily Summary",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          CustomExpansionTile(
                            title: 'Setup',
                            image: const Image(image: AssetImage(Images.setup),color: ColorResources.GREY,height: 25,width: 25),
                            content: Container(
                              decoration: BoxDecoration(
                                color: ColorResources.WHITE,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorResources.GREY.withOpacity(0.10),
                                      spreadRadius: 0.1,
                                      blurRadius: 0.1
                                    )
                                  ]
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ItemList(),));
                                        },
                                        leading: const Image(image: AssetImage(Images.item),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Item",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ItemPriceList(),));
                                        },
                                        leading: const Image(image: AssetImage(Images.priceList),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Item Price",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: AppConstants.itemHeight * 0.06,
                            child: ListTile(
                                onTap:() {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Expense_List("","","Expense"),));
                                },
                                leading: const Image(image: AssetImage(Images.expense),color: ColorResources.GREY,height: 25,width: 25),
                                title: Text("Expense",style: montserratSemiBold.copyWith(fontSize: 15))),
                          ),
                          CustomExpansionTile(
                            title: 'Setting',
                            image: const Icon(Icons.settings,color: ColorResources.GREY,size: 25),
                            content: Container(
                              decoration: BoxDecoration(
                                  color: ColorResources.WHITE,
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: ColorResources.GREY.withOpacity(0.10),
                                        spreadRadius: 0.1,
                                        blurRadius: 0.1
                                    )
                                  ]
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ExpenseTypeManage(),));
                                        },
                                        leading: const Image(image: AssetImage(Images.expense),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Expense Type",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UnitManage(),));
                                        },
                                        leading: const Image(image: AssetImage(Images.unit),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Unit Management",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                          :
                      Column(
                        children: [
                          SizedBox(
                            height: AppConstants.itemHeight * 0.06,
                            child: ListTile(
                                onTap:() {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RouteList(""),));
                                },
                                leading: const Image(image: AssetImage(Images.route),color: ColorResources.GREY,height: 25,width: 25),
                                title: Text("Route Master",style: montserratSemiBold.copyWith(fontSize: 15))),
                          ),
                          SizedBox(
                            height: AppConstants.itemHeight * 0.06,
                            child: ListTile(
                                onTap:() {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DailyUpdate(),));
                                },
                                leading: const Image(image: AssetImage(Images.update),color: ColorResources.GREY,height: 25,width: 25),
                                title: Text("Daily Update",style: montserratSemiBold.copyWith(fontSize: 15))),
                          ),
                          /*SizedBox(
                            height: AppConstants.itemHeight * 0.06,
                            child: ListTile(
                                onTap:() {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchCustomer(),));
                                },
                                leading: const Icon(Icons.search,color: ColorResources.GREY,size: 25),
                                title: Text("Search Customer",style: montserratSemiBold.copyWith(fontSize: 15))),
                          ),*/
                          CustomExpansionTile(
                            title: 'Sale',
                            image: const Image(image: AssetImage(Images.shop),color: ColorResources.GREY,height: 25,width: 25),
                            content: Container(
                              decoration: BoxDecoration(
                                color: ColorResources.WHITE,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                      color: ColorResources.GREY.withOpacity(0.10),
                                      spreadRadius: 0.1,
                                      blurRadius: 0.1
                                  )
                                ]
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomerList(),));
                                        },
                                        leading: const Image(image: AssetImage(Images.party),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Manage Party",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                  SizedBox(
                                    height: AppConstants.itemHeight * 0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => TempInvoiceList("","","Side"),));
                                        },
                                        leading: const Image(image: AssetImage(Images.bookkeeping),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Sale Invoice",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                  SizedBox(
                                    height: AppConstants.itemHeight * 0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => TempPaymentList("",""),));
                                        },
                                        leading: const Image(image: AssetImage(Images.payment),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Payment In",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          CustomExpansionTile(
                            title: 'Purchase',
                            image: const Image(image: AssetImage(Images.purchasing),color: ColorResources.GREY,height: 25,width: 25),
                            content: Container(
                              decoration: BoxDecoration(
                                color: ColorResources.WHITE,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorResources.GREY.withOpacity(0.10),
                                    spreadRadius: 0.1,
                                    blurRadius: 0.1
                                  )
                                ]
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SupplierList(),));
                                        },
                                        leading: const Image(image: AssetImage(Images.party),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Manage Party",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SupplierInvoiceList("","","","SupplierInvoice"),));
                                        },
                                        leading: const Image(image: AssetImage(Images.supplier),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Purchase Bill",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SupplierPaymentList("","Side"),));
                                        },
                                        leading: const Image(image: AssetImage(Images.bill),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Payment Out",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: AppConstants.itemHeight * 0.06,
                            child: ListTile(
                                onTap:() {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Expense_List("","","Expense"),));
                                },
                                leading: const Image(image: AssetImage(Images.expense),color: ColorResources.GREY,height: 25,width: 25),
                                title: Text("Expense",style: montserratSemiBold.copyWith(fontSize: 15))),
                          ),
                          CustomExpansionTile(
                            title: 'Report',
                            image: const Icon(Icons.report_gmailerrorred,color: ColorResources.GREY,size: 25),
                            content: Container(
                              decoration: BoxDecoration(
                                color: ColorResources.WHITE,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorResources.GREY.withOpacity(0.10),
                                    spreadRadius: 0.1,
                                    blurRadius: 0.1
                                  )
                                ]
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DailyReport(),));
                                        },
                                        leading: const Icon(Icons.pending_outlined,color: ColorResources.GREY,size: 25),
                                        title: Text("Daily Report",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DueBalance(),));
                                        },
                                        leading: const Image(image: AssetImage(Images.duePayment),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Due Balance",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfitLossReport("", "", "Side"),));
                                        },
                                        leading: const Image(image: AssetImage(Images.loss),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Profit Loss Report",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          CustomExpansionTile(
                            title: 'Item',
                            image: const Image(image: AssetImage(Images.setup),color: ColorResources.GREY,height: 25,width: 25),
                            content: Container(
                              decoration: BoxDecoration(
                                color: ColorResources.WHITE,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorResources.GREY.withOpacity(0.10),
                                    spreadRadius: 0.1,
                                    blurRadius: 0.1
                                  )
                                ]
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ItemList(),));
                                        },
                                        leading: const Image(image: AssetImage(Images.item),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Manage Item",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ItemPriceList(),));
                                        },
                                        leading: const Image(image: AssetImage(Images.priceList),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Item Price",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          CustomExpansionTile(
                            title: 'Setting',
                            image: const Icon(Icons.settings,color: ColorResources.GREY,size: 25),
                            content: Container(
                              decoration: BoxDecoration(
                                color: ColorResources.WHITE,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                      color: ColorResources.GREY.withOpacity(0.10),
                                      spreadRadius: 0.1,
                                      blurRadius: 0.1
                                  )
                                ]
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ExpenseTypeManage(),));
                                        },
                                        leading: const Image(image: AssetImage(Images.expense),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Expense Type",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                  SizedBox(
                                    height: AppConstants.itemHeight*0.06,
                                    child: ListTile(
                                        onTap:() {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UnitManage(),));
                                        },
                                        leading: const Image(image: AssetImage(Images.unit),color: ColorResources.GREY,height: 25,width: 25),
                                        title: Text("Unit Management",style: montserratSemiBold.copyWith(fontSize: 15))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AppConstants.itemHeight * 0.06,
                        child: ListTile(
                            onTap:() {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChangePassword(),));
                            },
                            leading: const Image(image: AssetImage(Images.forgotPassword),color: ColorResources.GREY,height: 25,width: 25),
                            title: Text("Change Password",style: montserratSemiBold.copyWith(fontSize: 15))),
                      ),
                      SizedBox(
                        height: AppConstants.itemHeight * 0.06,
                        child: ListTile(
                            onTap:() {
                              onLogoutPop(context);
                            },
                            leading: const Icon(Icons.logout,color: ColorResources.GREY,size: 25),
                            title: Text("Log Out",style: montserratSemiBold.copyWith(fontSize: 15))),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookSignIn = FacebookLogin();
  Future<bool> onLogoutPop(BuildContext context) {
    return showDialog<bool>(
        builder: (BuildContext context) {
          return ConfirmDialogView(
              description: "Are You Sure You Want To Log Out",
              leftButtonText: "No",
              rightButtonText: "Yes",
              onAgreeTap: () {
                PreferenceUtils.clear();
                googleSignIn.signOut();
                facebookSignIn.logOut();
                PreferenceUtils.setlogin(AppConstants.isLoggedIn, false);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Login(),));
              });
        }, context: context).then((value) => value ?? false);
  }
}


class CustomExpansionTile extends StatefulWidget {
  final String title;
  final Widget content;
  final Widget image;
  final bool initiallyExpanded;

  CustomExpansionTile({
    required this.title,
    required this.content,
    required this.image,
    this.initiallyExpanded = false,
  });

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: AppConstants.itemHeight*0.001,
          decoration: BoxDecoration(
            color: _isExpanded?Colors.black12:ColorResources.transparant,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          )
        ),
        Container(
          height: AppConstants.itemHeight*0.06,
          decoration: BoxDecoration(
            color: _isExpanded?ColorResources.WHITE:ColorResources.transparant,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            // border: Border.all(color: _isExpanded?Colors.black12:ColorResources.transparant),
              boxShadow: [
                BoxShadow(
                    color: _isExpanded?ColorResources.WHITE:ColorResources.transparant,
                    spreadRadius: 0.1,
                    blurRadius: 0.1
                )
              ]
          ),
          child: ListTile(
            title: Text(widget.title,style: montserratSemiBold.copyWith(fontSize: 15)),
            leading: widget.image,
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            trailing: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more,color: _isExpanded ? ColorResources.BLACK : ColorResources.GREY),
          ),
        ),
        if (_isExpanded) widget.content,
        Container(
            height: AppConstants.itemHeight*0.001,
            decoration: BoxDecoration(
              color: _isExpanded?Colors.black12:ColorResources.transparant,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
            )
        ),
      ],
    );
  }
}